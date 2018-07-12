//
//  FortMapViewController.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/10/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import Firebase
import ARKit


class FortMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currUserLocation = CLLocation()
    var initialUserLocation = CLLocation()
    let regionRadius: CLLocationDistance = 1000
    var oneTimeCenter = true
    var ref: DatabaseReference!
    var closestForts = [Any]()
    var selectedFort: FortMapMarker?
    var headingImageView: UIImageView?
    var userHeading: CLLocationDirection?
    var selectedFortOb : Fort?
    var distanceToSelectedFort : Double?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigateToFortButton: UIButton!
    @IBOutlet weak var seeFortButton: UIButton!
    
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
        mapView.delegate = self
        mapView.showsUserLocation = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        }
        ref = Database.database().reference()
        markAllFortLocations()
        navigateToFortButton.isEnabled = false
        seeFortButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnLocation(location: currUserLocation.coordinate)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue : CLLocation = manager.location!
        currUserLocation = locValue
        if oneTimeCenter {
            centerMapOnLocation(location: currUserLocation.coordinate)
            initialUserLocation = locValue
            oneTimeCenter = false
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        let heading = newHeading.trueHeading > 0 ? newHeading.trueHeading : newHeading.magneticHeading
        userHeading = heading
        updateHeadingRotation()
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currUserLocation.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func markAllFortLocations() {
        let currentUserEmail = Auth.auth().currentUser?.email
        ref.child("forts").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            for case let (id, fort) as (String, NSDictionary) in (value)! {
                let privacy = fort["privacy"] as? String
                let creatorEmail = fort["creator_email"] as? String
                if (privacy == "Public" || creatorEmail == currentUserEmail) {
                    let fortName = fort["fort_name"] as? String
                    let fortCreator = fort["creator_username"] as? String
                    let fortLocation = fort["location"] as? String
                    let fortEditedBy = fort["last_edited_by"] as? String
                    let fortLatLong = fortLocation?.split(separator: ",")
                    let fortClLocation = CLLocation(latitude: Double(fortLatLong![0])!, longitude: Double(fortLatLong![1])!)
                    let fortArtwork = FortMapMarker(fortId: id, title: fortName!, creator: fortCreator!, editedBy: fortEditedBy ?? "", coordinate: fortClLocation.coordinate)
                    self.mapView.addAnnotation(fortArtwork)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        self.selectedFort = view.annotation as? FortMapMarker
        if self.selectedFort != nil {
            let fortLocation = CLLocation(latitude: (self.selectedFort?.coordinate.latitude)!, longitude: (self.selectedFort?.coordinate.longitude)!)
            if fortLocation != currUserLocation {
                navigateToFortButton.isEnabled = true
                distanceToSelectedFort = fortLocation.distance(from: self.currUserLocation)
                if distanceToSelectedFort! < 15 {
                    navigateToFortButton.isEnabled = false
                    seeFortButton.isEnabled = true
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        navigateToFortButton.isEnabled = false
        seeFortButton.isEnabled = false
        self.selectedFort = nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.alpha = 0.5
        return renderer
    }
    
    @IBAction func navigateToFort(_ sender: UITapGestureRecognizer) {
        if navigateToFortButton.titleLabel?.text != "Cancel Route" {
            let request: MKDirectionsRequest = createDirectionsRequest()
            let directions = MKDirections(request: request)
            calculateAndAddDirections(directions)
            navigateToFortButton.setTitle("Cancel Route", for: .normal)
        } else {
            let mapOverlays = self.mapView.overlays
            self.mapView.removeOverlays(mapOverlays)
            navigateToFortButton.setTitle("Navigate to Fort", for: .normal)
        }
    }
    
    private func createDirectionsRequest() -> MKDirectionsRequest {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        let sourcePlacemark = MKPlacemark.init(coordinate: self.currUserLocation.coordinate)
        let destinationPlacemark = MKPlacemark.init(coordinate: (self.selectedFort?.coordinate)!)
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = MKMapItem(placemark: destinationPlacemark)
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        return request
    }
    
    private func calculateAndAddDirections(_ directions: MKDirections) {
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            for route in unwrappedResponse.routes {
                self.mapView.add(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
    @IBAction func renderAndEditFort(_ sender: UITapGestureRecognizer) {
        createFortFromFortId(fortId: (self.selectedFort?.fortId)!)
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        if views.last?.annotation is MKUserLocation {
            addHeadingView(toAnnotationView: views.last!)
        }
    }
    
    func addHeadingView(toAnnotationView annotationView: MKAnnotationView) {
        if headingImageView == nil {
            let image = UIImage(named: "art.scnassets/location_arrow_2_resized.png")
            headingImageView = UIImageView(image: image)
            headingImageView!.frame = CGRect(x: (annotationView.frame.size.width - (image?.size.width)!)/2, y: (annotationView.frame.size.height - (image?.size.height)!)/2, width: (image?.size.width)!, height: (image?.size.height)!)
            annotationView.insertSubview(headingImageView!, at: 0)
            headingImageView!.isHidden = true
        }
    }
    
    func updateHeadingRotation() {
        if let headingImageView = self.headingImageView {
            headingImageView.isHidden = false
            let rotation = CGFloat(self.userHeading!/180 * Double.pi)
            headingImageView.transform = CGAffineTransform(rotationAngle: rotation)
        }
    }
    
    func createFortFromFortId(fortId: String) {
        ref.child("forts").child(fortId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let dbFort = Fort()
            let value = snapshot.value as? NSDictionary
            let creatorUsername = value!["creator_username"] as? String
            let fortName = value!["fort_name"] as? String
            let fortPrivacy = value!["privacy"] as? String
            let blocks = value!["blocks"] as? NSArray
            for case let blockInfo as NSDictionary in (blocks!) {
                let blockType = blockInfo["block_type"] as? String
                let fortBlock = self.getFortBlockObject(blockType: blockType)
                let newBlockPos = blockInfo["position"] as? String
                let newBlockPosList = newBlockPos?.split(separator: ",")
                let newBlockVect = SCNVector3(x: Float(newBlockPosList![0])!, y: Float(newBlockPosList![1])!, z: Float(newBlockPosList![2])!)
                fortBlock.position = newBlockVect
                dbFort.addBlock(block: fortBlock)
            }
            dbFort.setCreatorUsername(username: creatorUsername!)
            dbFort.setFortId(uid: fortId)
            dbFort.setFortName(name: fortName!)
            dbFort.setFortPrivacy(privacy: fortPrivacy!)
            self.passFortToFortBuilder(fortForPass: dbFort)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func getFortBlockObject(blockType: String?) -> Block {
        var newBlock = Block()
        switch blockType! {
        case "X" :
            newBlock = XBlock() as XBlock
        case "Y":
            newBlock = YBlock() as YBlock
        case "Z" :
            newBlock = ZBlock() as ZBlock
        default:
            break
        }
        return newBlock
    }
    
    private func passFortToFortBuilder(fortForPass: Fort) {
        self.selectedFortOb = fortForPass
        self.performSegue(withIdentifier: "editSelectedFortSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let buildFortViewController = segue.destination as? BuildFortViewController {
            buildFortViewController.preExistingFort = self.selectedFortOb!
            buildFortViewController.distanceToFort = self.distanceToSelectedFort!
        }
    }
    
    
}

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
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigateToFortButton: UIButton!
    @IBOutlet weak var seeFortButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            mapView.delegate = self
            mapView.showsUserLocation = true
        }
        ref = Database.database().reference()
        renderAllFortLocations()
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
    
    private func renderAllFortLocations() {
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
                    let fortLatLong = fortLocation?.split(separator: ",")
                    let fortClLocation = CLLocation(latitude: Double(fortLatLong![0])!, longitude: Double(fortLatLong![1])!)
                    let fortArtwork = FortMapMarker(fortId: id, title: fortName!, creator: fortCreator!, coordinate: fortClLocation.coordinate)
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
                let distanceToFort = fortLocation.distance(from: self.currUserLocation)
                if distanceToFort < 10 {
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
            let request: MKDirectionsRequest = MKDirectionsRequest()
            let sourcePlacemark = MKPlacemark.init(coordinate: self.currUserLocation.coordinate)
            let destinationPlacemark = MKPlacemark.init(coordinate: (self.selectedFort?.coordinate)!)
            request.source = MKMapItem(placemark: sourcePlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            request.requestsAlternateRoutes = true
            request.transportType = .walking
            let directions = MKDirections(request: request)
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                for route in unwrappedResponse.routes {
                    self.mapView.add(route.polyline)
                    self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                }
            }
            navigateToFortButton.setTitle("Cancel Route", for: .normal)
        } else {
            let mapOverlays = self.mapView.overlays
            self.mapView.removeOverlays(mapOverlays)
            navigateToFortButton.setTitle("Navigate to Fort", for: .normal)
        }
    }
    
    @IBAction func renderAndEditFort(_ sender: UITapGestureRecognizer) {
    }
    
    private func degreesToRadians(degrees: Double) -> Double { return degrees * .pi / 180.0 }
    private func radiansToDegrees(radians: Double) -> Double { return radians * 180.0 / .pi }
    
    private func getBearingBetweenTwoPoints(point1 : CLLocation, point2 : CLLocation) -> Double {
        
        let lat1 = degreesToRadians(degrees: point1.coordinate.latitude)
        let lon1 = degreesToRadians(degrees: point1.coordinate.longitude)
        
        let lat2 = degreesToRadians(degrees: point2.coordinate.latitude)
        let lon2 = degreesToRadians(degrees: point2.coordinate.longitude)
        
        let dLon = lon2 - lon1
        
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return radiansToDegrees(radians: radiansBearing)
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
    
    
}

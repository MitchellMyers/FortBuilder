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



class FortMapViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var currUserLocation = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 1000
    var oneTimeCenter = true
    var ref: DatabaseReference!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            mapView.showsUserLocation = true
        }
        ref = Database.database().reference()
        renderAllFortLocations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        centerMapOnLocation(location: currUserLocation)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        currUserLocation = locValue
        if oneTimeCenter {
            centerMapOnLocation(location: currUserLocation)
            oneTimeCenter = false
        }
    }
    
    func centerMapOnLocation(location: CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(currUserLocation,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func renderAllFortLocations() {
        let currentUserEmail = Auth.auth().currentUser?.email
        ref.child("forts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
//            print(value)
            for case let fort as NSDictionary in (value?.allValues)! {
                let privacy = fort["privacy"] as? String
                let creatorEmail = fort["creator_email"] as? String
                if (privacy == "Public" || creatorEmail == currentUserEmail) {
                    let fortName = fort["fort_name"] as? String
                    let fortCreator = fort["creator_username"] as? String
                    let fortLocation = fort["location"] as? String
                    let fortLatLong = fortLocation?.split(separator: ",")
                    let fortCoordinate = CLLocationCoordinate2D(latitude: Double(fortLatLong![0])!, longitude: Double(fortLatLong![1])!)
                    let fortArtwork = FortMapMarker(title: fortName!, creator: fortCreator!, coordinate: fortCoordinate)
                    self.mapView.addAnnotation(fortArtwork)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
}

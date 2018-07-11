//
//  FortMapMarker.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/11/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import MapKit

class FortMapMarker: NSObject, MKAnnotation {
    let title: String?
    let creator: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, creator: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.creator = creator
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        return "Created By: \(creator!)"
    }
    
    
}

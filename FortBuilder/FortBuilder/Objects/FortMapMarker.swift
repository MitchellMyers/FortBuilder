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
    let fortId: String?
    let editedBy: String?
    let coordinate: CLLocationCoordinate2D
    
    init(fortId: String, title: String, creator: String, editedBy: String, coordinate: CLLocationCoordinate2D) {
        self.fortId = fortId
        self.title = title
        self.creator = creator
        self.editedBy = editedBy
        self.coordinate = coordinate
        super.init()
    }
    
    var subtitle: String? {
        let subtitle = self.editedBy != "" ? "Created By: \(creator!) \nLast Edited By: \(editedBy!)" : "Created By: \(creator!)"
        return subtitle
    }
    
    
}

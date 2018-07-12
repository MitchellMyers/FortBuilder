//
//  UserLocationAnnotation.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 7/11/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class UserLocationAnnotation: MKPointAnnotation {
    public init(withCoordinate coordinate: CLLocationCoordinate2D, heading: CLLocationDirection) {
        self.heading = heading
        
        super.init()
        self.coordinate = coordinate
    }
    
    @objc dynamic public var heading: CLLocationDirection
}

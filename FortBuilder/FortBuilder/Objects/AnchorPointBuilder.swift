//
//  AnchorPoint.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/19/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class AnchorPointBuilder : SCNNode {
    
    func getNewAnchorPoint() -> SCNNode {
        let apBox = SCNBox(width: 0.05, height: 0.05, length: 0.05, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        apBox.materials = [material]
        let wrapperNode = SCNNode(geometry: apBox)
        return wrapperNode
    }
    
}

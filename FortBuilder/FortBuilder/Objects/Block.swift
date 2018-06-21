//
//  Block.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/18/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class Block: SCNNode {
    
    // TODO: create a struct for anchorpoints. It will be used to determine which anchorpoints are available for building and which are used
    
    func loadBlock() {
        
        let box = SCNBox(width: 1.0, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "../art.scnassets/wooden_texture.png")
        box.materials = [material]
        
//        // get Anchor Point locations
//        let anchorPointLocations = getAnchorPointVectors(block: box)
//        // create anchor point for each location
//        let anchorPointBuilder = AnchorPointBuilder()
//        for anchor in anchorPointLocations {
//            let ap = anchorPointBuilder.getNewAnchorPoint()
//            ap.position = anchor
//            addChildNode(ap)
//        }
        
        let wrapperNode = SCNNode(geometry: box)
        
        addChildNode(wrapperNode)
    }
    
    func getAnchorPoints() -> Array<SCNVector3> {
        let anchors = [SCNVector3]()
        return anchors
    }
    
    /*
     Function that finds the anchor points for a block
     Params: block: SCNBox
     Returns: anchorPointsArray: Array<SCNVector3> - array of SCNVectors representing the anchor points
     */
    func getAnchorPointVectors(block: SCNBox) -> Array<SCNVector3> {
        // Instantiate Return Array
        let anchorPointsArray: Array<SCNVector3> = Array()
        
        // Get anchor points
//        anchorPointsArray.append(SCNVector3Make(Float(kStartingPosition.x) + Float(block.width / 2),  Float(kStartingPosition.y), Float(kStartingPosition.z)))
//        anchorPointsArray.append(SCNVector3Make(Float(kStartingPosition.x) - Float(block.width / 2), Float(kStartingPosition.y), Float(kStartingPosition.z)))
        
        // Return array
        return anchorPointsArray
    }
    
}

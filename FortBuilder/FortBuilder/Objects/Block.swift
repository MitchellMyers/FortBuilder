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
        
  
        
        let wrapperNode = SCNNode(geometry: box)
        
        addChildNode(wrapperNode)
    }
    
    /*
     Function that finds the anchor points for a block
     Params: None
     Returns: anchorPointsArray: Array<SCNVector3> - array of SCNVectors representing the anchor points
     */
    func getAnchorPoints() -> Array<SCNVector3> {
        let anchors = [SCNVector3]()
        return anchors
    }
    
    
    
}

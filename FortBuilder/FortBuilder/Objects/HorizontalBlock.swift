//
//  HorizontalBlock.swift
//  FortBuilder
//
//  Created by Samuel Alexander Bretz on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class HorizontalBlock: SCNNode {
    
    /* Loads in a HorizontalBlock
     Parameters: None
     Returns: None
    */
    func loadHorizontalBlock() {
        let box = SCNBox(width: 1.0, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "../art.scnassets/wooden_texture.png")
        box.materials = [material]
        
    }
    
}

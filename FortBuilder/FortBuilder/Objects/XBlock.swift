//
//  HorizontalBlock.swift
//  FortBuilder
//
//  Created by Samuel Alexander Bretz on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class XBlock: Block {
    
    /* Loads in a HorizontalBlock
     Parameters: None
     Returns: None
    */
    func loadXBlock() {
        let box = SCNBox(width: 1.0, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "../art.scnassets/wooden_texture.png")
        box.materials = [material]
        let wrapperNode = SCNNode(geometry: box)
        addChildNode(wrapperNode)
    }
    
    override func getAnchorPoints() -> Array<SCNVector3> {
        var anchors = [SCNVector3]()
        anchors.append(SCNVector3Make(self.position.x - 0.49, self.position.y, self.position.z))
        anchors.append(SCNVector3Make(self.position.x + 0.49, self.position.y, self.position.z))
        return anchors
    }
    
}

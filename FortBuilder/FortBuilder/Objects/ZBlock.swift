//
//  ZBlock.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class ZBlock: Block {
    
    var myBox = SCNBox()
    
    /* Loads in a HorizontalBlock
     Parameters: None
     Returns: None
     */
    override func loadBlock() {
        let box = SCNBox(width: 0.2, height: 0.2, length: 1.0, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/wooden_texture.jpg")
        box.materials = [material]
        myBox = box
        let wrapperNode = SCNNode(geometry: box)
        addChildNode(wrapperNode)
    }
    
    override func getAnchorPoints() -> Array<SCNVector3> {
        var anchors = [SCNVector3]()
        anchors.append(SCNVector3Make(self.position.x, self.position.y, self.position.z - 0.40))
        anchors.append(SCNVector3Make(self.position.x, self.position.y, self.position.z + 0.40))
        return anchors
    }
    
    override func getBox() -> SCNBox {
        return myBox
    }
    
    override func getType() -> String {
        return "Z"
    }
    
}

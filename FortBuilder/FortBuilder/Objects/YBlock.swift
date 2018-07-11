//
//  YBlock.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class YBlock: Block {
    
    var myBox = SCNBox()
    
    /* Loads in a HorizontalBlock
     Parameters: None
     Returns: None
     */
    func loadYBlock() {
        let box = SCNBox(width: 0.2, height: 1.0, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/wooden_texture.jpg")
        box.materials = [material]
        myBox = box
        let wrapperNode = SCNNode(geometry: box)
        addChildNode(wrapperNode)
    }
    
    override func getAnchorPoints() -> Array<SCNVector3> {
        var anchors = [SCNVector3]()
        anchors.append(SCNVector3Make(self.position.x, self.position.y - 0.40, self.position.z))
        anchors.append(SCNVector3Make(self.position.x, self.position.y + 0.40, self.position.z))
        return anchors
    }
    
    override func getBox() -> SCNBox {
        return myBox
    }
    
    override func getType() -> String {
        return "Y"
    }
    
}

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
    
    func loadBlock() {
        guard let virtualObjectScene = SCNScene(named: "Block.scn") else { return }
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            wrapperNode.addChildNode(child)
        }
        addChildNode(wrapperNode)
    }
    
}

//
//  Fort.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class Fort {
    
    private var fortBlocks = [Block]()
    
    func addBlock(block: Block) {
        fortBlocks.append(block)
    }
    
    func checkProximity(selectedBlock: Block) -> (Block, SCNVector3, SCNVector3) {
        for fortBlock in fortBlocks {
            for fbAnchor in fortBlock.getAnchorPoints() {
                for sbAnchor in selectedBlock.getAnchorPoints() {
                    if (getDistance(blockOnePos: fbAnchor, blockTwoPos: sbAnchor) < 0.4) {
                        return (fortBlock, fbAnchor, sbAnchor)
                    }
                }
            }
        }
        return (selectedBlock, SCNVector3Make(0.0, 0.0, 0.0), SCNVector3Make(0.0, 0.0, 0.0))
    }
    
    func getFortBlocks() -> [Block] {
        return self.fortBlocks
    }
    
    func getDistance(blockOnePos: SCNVector3, blockTwoPos: SCNVector3) -> Float {
        return sqrtf(pow((blockTwoPos.x - blockOnePos.x), 2.0) + pow((blockTwoPos.y - blockOnePos.y), 2.0) + pow((blockTwoPos.z - blockOnePos.z), 2.0))
    }
    
}

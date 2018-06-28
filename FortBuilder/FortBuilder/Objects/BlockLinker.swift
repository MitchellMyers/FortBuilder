//
//  Mover.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/19/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class BlockLinker {

    /* Move block to anchor point location
     Params: blockTuple(fortBlock, selectedBlock), anchorTuple(fortBlockAnchor, selectedBlockAnchor)
     Returns: undetermined
     */
    func linkBlocks(blockTuple: (Block, Block), anchorTuple: (SCNVector3, SCNVector3)) -> SCNVector3 {
        
        let fortBlockX = blockTuple.0.position.x
        let fortBlockY = blockTuple.0.position.y
        let fortBlockZ = blockTuple.0.position.z
        let selectBlockX = blockTuple.1.position.x
        let selectBlockY = blockTuple.1.position.y
        let selectBlockZ = blockTuple.1.position.z
        
        let fortBlockAnchorX = anchorTuple.0.x
        let fortBlockAnchorY = anchorTuple.0.y
        let fortBlockAnchorZ = anchorTuple.0.z
        
        var selectBlockPos = SCNVector3()
        
        switch blockTuple {
        // X and X
        case (blockTuple.0 as? XBlock, blockTuple.1 as? XBlock):
            if (fortBlockX > selectBlockX) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.6, fortBlockAnchorY, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.6, fortBlockAnchorY, fortBlockAnchorZ)
            }
        // Y and Y
        case (blockTuple.0 as? YBlock, blockTuple.1 as? YBlock):
            if (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.6, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.6, fortBlockAnchorZ)
            }
        // Z and Z
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? ZBlock):
            if (fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY, fortBlockAnchorZ - 0.6)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY, fortBlockAnchorZ + 0.6)
            }
        // X and Y
        case (blockTuple.0 as? XBlock, blockTuple.1 as? YBlock):
            if (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX,fortBlockAnchorY - 0.6, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.6, fortBlockAnchorZ)
            }
        // X and Z
        case (blockTuple.0 as? XBlock, blockTuple.1 as? ZBlock):
            if (fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY, fortBlockAnchorZ - 0.6)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY, fortBlockAnchorZ + 0.6)
            }
        // Y and X
        case (blockTuple.0 as? YBlock, blockTuple.1 as? XBlock):
            if (fortBlockX > selectBlockX) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.4, fortBlockAnchorY - 0.2, fortBlockAnchorZ)
            } else if (fortBlockX > selectBlockX) && (fortBlockY < selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.4, fortBlockAnchorY + 0.2, fortBlockAnchorZ)
            } else if (fortBlockX < selectBlockX) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.4, fortBlockAnchorY - 0.2, fortBlockAnchorZ)
            } else if (fortBlockX < selectBlockX) && (fortBlockY < selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.4, fortBlockAnchorY + 0.2, fortBlockAnchorZ)
            }
        // Y and Z
        case (blockTuple.0 as? YBlock, blockTuple.1 as? ZBlock):
            if (fortBlockZ > selectBlockZ) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.2, fortBlockAnchorZ - 0.4)
            } else if (fortBlockZ > selectBlockZ) && (fortBlockY <= selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.2, fortBlockAnchorZ - 0.4)
            } else if (fortBlockZ <= selectBlockZ) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.2, fortBlockAnchorZ + 0.4)
            } else if (fortBlockZ <= selectBlockZ) && (fortBlockY <= selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.2, fortBlockAnchorZ + 0.4)
            }
        // Z and X
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? XBlock):
            if (fortBlockX > selectBlockX && fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.4, fortBlockAnchorY, fortBlockAnchorZ - 0.2)
            } else if (fortBlockX > selectBlockX && fortBlockZ <= selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.4, fortBlockAnchorY, fortBlockAnchorZ + 0.2)
            } else if (fortBlockX <= selectBlockX && fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.4, fortBlockAnchorY, fortBlockAnchorZ - 0.2)
            } else if (fortBlockX <= selectBlockX && fortBlockZ <= selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.4, fortBlockAnchorY, fortBlockAnchorZ + 0.2)
            }
        // Z and Y
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? YBlock):
            if (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.6, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.6, fortBlockAnchorZ)
            }
        // For exhaustion condition
        default: break
        
        }
        return selectBlockPos
    }
    
}

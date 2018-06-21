//
//  Mover.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/19/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class Mover {
    
    func moveLeft(sender: UILongPressGestureRecognizer, block: Block) {
        let x = -deltas(block: block).cos
        let z = deltas(block: block).sin
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveRight(sender: UILongPressGestureRecognizer, block: Block) {
        let x = deltas(block: block).cos
        let z = -deltas(block: block).sin
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveUp(sender: UILongPressGestureRecognizer, block: Block) {
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
    func moveDown(sender: UILongPressGestureRecognizer, block: Block) {
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
    func moveForward(sender: UILongPressGestureRecognizer, block: Block) {
        let x = -deltas(block: block).sin
        let z = -deltas(block: block).cos
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveBackward(sender: UILongPressGestureRecognizer, block: Block) {
        let x = deltas(block: block).sin
        let z = deltas(block: block).cos
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    private func deltas(block: Block) -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(block.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(block.eulerAngles.y)))
    }
    
    private func moveBlock(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer, block: Block) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
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
            if (fortBlockX > selectBlockX) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.6, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.6, fortBlockAnchorZ)
            }
        // Z and Z
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? ZBlock):
            if (fortBlockX > selectBlockX) {
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
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.4, fortBlockAnchorY - 0.2, fortBlockAnchorZ)
            }
        // Y and Z
        case (blockTuple.0 as? YBlock, blockTuple.1 as? ZBlock):
            if (fortBlockZ > selectBlockZ) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.2, fortBlockAnchorZ - 0.4)
            } else if (fortBlockZ > selectBlockZ) && (fortBlockY < selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.2, fortBlockAnchorZ - 0.4)
            } else if (fortBlockZ < selectBlockZ) && (fortBlockY > selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.2, fortBlockAnchorZ - 0.4)
            } else if (fortBlockZ < selectBlockZ) && (fortBlockY < selectBlockY) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.2, fortBlockAnchorZ + 0.4)
            }
        // Z and X
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? XBlock):
            if (fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX - 0.6, fortBlockAnchorY, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX + 0.6, fortBlockAnchorY, fortBlockAnchorZ)
            }
        // Z and Y
        case (blockTuple.0 as? ZBlock, blockTuple.1 as? YBlock):
            if (fortBlockZ > selectBlockZ) {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY - 0.6, fortBlockAnchorZ)
            } else {
                selectBlockPos = SCNVector3Make(fortBlockAnchorX, fortBlockAnchorY + 0.6, fortBlockAnchorZ)
            }
        // For exhaustion condition
        default: break
        
        }
        return selectBlockPos
    }
            
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer, block: Block) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            block.runAction(loopAction)
        } else if sender.state == .ended {
            block.removeAllActions()
        }
    }
}

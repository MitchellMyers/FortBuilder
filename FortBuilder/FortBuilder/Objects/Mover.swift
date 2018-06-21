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
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer, block: Block) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            block.runAction(loopAction)
        } else if sender.state == .ended {
            block.removeAllActions()
        }
    }
    
}

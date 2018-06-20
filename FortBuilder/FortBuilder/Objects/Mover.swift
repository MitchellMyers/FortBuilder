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
    
    func moveLeft(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let x = -deltas(block: block).cos
        let z = deltas(block: block).sin
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveRight(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let x = deltas(block: block).cos
        let z = -deltas(block: block).sin
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveUp(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
    func moveDown(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
    func moveForward(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let x = -deltas(block: block).sin
        let z = -deltas(block: block).cos
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
    func moveBackward(sender: UILongPressGestureRecognizer, block: SCNNode) {
        let x = deltas(block: block).sin
        let z = deltas(block: block).cos
        moveBlock(x: x, z: z, sender: sender, block: block)
    }
    
//    func rotateLeft(sender: UITapGestureRecognizer) {
//        let action = SCNAction.rotateBy(x: 0, y: kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
//        self.runAction(action)
//    }
//
//    func rotateRight(sender: UITapGestureRecognizer) {
//        let action = SCNAction.rotateBy(x: 0, y: -kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
//        self.runAction(action)
//    }
//
//    func rotateUp(sender: UITapGestureRecognizer) {
//        let action = SCNAction.rotateBy(x: 0, y: 0, z: kRotationRadianHalfPi, duration: kAnimationDurationMoving)
//        print(self.position)
//        self.runAction(action)
//    }
    
    private func deltas(block: SCNNode) -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(block.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(block.eulerAngles.y)))
    }
    
    private func moveBlock(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer, block: SCNNode) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender, block: block)
    }
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer, block: SCNNode) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            block.runAction(loopAction)
        } else if sender.state == .ended {
            block.removeAllActions()
        }
    }
    
}

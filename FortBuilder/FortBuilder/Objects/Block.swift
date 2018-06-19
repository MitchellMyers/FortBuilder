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
        
        let box = SCNBox(width: 1.0, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "../art.scnassets/wooden_texture.png")
        box.materials = [material]
        let wrapperNode = SCNNode(geometry: box)
        
        addChildNode(wrapperNode)
    }
    
    func getCorners() {
        var corners = [SCNVector3]()
        let rotation = self.rotation.w
        let cornerOne = SCNVector3(self.position.x - (4.9 * cos(rotation)), self.position.y - (4.9 * sin(rotation)), self.position.z)
        let cornerTwo = SCNVector3(self.position.x + 4.9, self.position.y, self.position.z)
        corners.append(cornerOne)
        corners.append(cornerTwo)
    }
    
    func moveLeft(sender: UILongPressGestureRecognizer) {
        let x = -deltas().cos
        let z = deltas().sin
        moveBlock(x: x, z: z, sender: sender)
    }
    
    func moveRight(sender: UILongPressGestureRecognizer) {
        let x = deltas().cos
        let z = -deltas().sin
        moveBlock(x: x, z: z, sender: sender)
    }
    
    func moveUp(sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    func moveDown(sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    func moveForward(sender: UILongPressGestureRecognizer) {
        let x = -deltas().sin
        let z = -deltas().cos
        moveBlock(x: x, z: z, sender: sender)
    }
    
    func moveBackward(sender: UILongPressGestureRecognizer) {
        let x = deltas().sin
        let z = deltas().cos
        moveBlock(x: x, z: z, sender: sender)
    }
    
    func rotateLeft(sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
        self.runAction(action)
    }
    
    func rotateRight(sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: -kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
        self.runAction(action)
    }
    
    func rotateUp(sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: 0, z: kRotationRadianHalfPi, duration: kAnimationDurationMoving)
        print(self.position)
        self.runAction(action)
    }
    
    private func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(self.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(self.eulerAngles.y)))
    }
    
    private func moveBlock(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            self.runAction(loopAction)
        } else if sender.state == .ended {
            self.removeAllActions()
        }
    }
    
}

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
    
    // TODO: create a struct for anchorpoints. It will be used to determine which anchorpoints are available for building and which are used
    
    func loadBlock() {
        
        let box = SCNBox(width: 1.0, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "../art.scnassets/wooden_texture.png")
        box.materials = [material]
        
        // get Anchor Point locations
        let anchorPointLocations = getAnchorPointVectors(block: box)
        // create anchor point for each location
        let anchorPointBuilder = AnchorPointBuilder()
        for anchor in anchorPointLocations {
            let ap = anchorPointBuilder.getNewAnchorPoint()
            ap.position = anchor
            addChildNode(ap)
        }
        
        let wrapperNode = SCNNode(geometry: box)
        
        addChildNode(wrapperNode)
    }
    
    /*
     Function that finds the anchor points for a block
     Params: block: SCNBox
     Returns: anchorPointsArray: Array<SCNVector3> - array of SCNVectors representing the anchor points
     */
    func getAnchorPointVectors(block: SCNBox) -> Array<SCNVector3> {
        // Instantiate Return Array
        var anchorPointsArray: Array<SCNVector3> = Array()
        
        // Get anchor points
        anchorPointsArray.append(SCNVector3Make(Float(kStartingPosition.x) + Float(block.width / 2),  Float(kStartingPosition.y), Float(kStartingPosition.z)))
        anchorPointsArray.append(SCNVector3Make(Float(kStartingPosition.x) - Float(block.width / 2), Float(kStartingPosition.y), Float(kStartingPosition.z)))
        
        
        
        
        
        
        
        // Return array
        return anchorPointsArray
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

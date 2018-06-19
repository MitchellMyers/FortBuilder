//
//  ViewController.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/18/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

let kStartingPosition = SCNVector3(0, -0.8, -0.8)
let kAnimationDurationMoving: TimeInterval = 0.2
let kMovingLengthPerLoop: CGFloat = 0.05
let kRotationRadianPerLoop: CGFloat = 0.2
let kRotationRadianHalfPi: CGFloat = CGFloat.pi / 2

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    
    let selectedBlock = Block();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        configuration.planeDetection = [.horizontal]
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.automaticallyUpdatesLighting = true
        sceneView.session.run(configuration)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func addInitialBlock(vec : SCNVector3) {
        selectedBlock.loadBlock()
        selectedBlock.position = kStartingPosition
        selectedBlock.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(selectedBlock)
    }
    
    
    
    @IBAction func moveBlockLeft(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().cos
        let z = deltas().sin
        moveBlock(x: x, z: z, sender: sender)
    }
    
    
    @IBAction func moveBlockRight(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().cos
        let z = -deltas().sin
        moveBlock(x: x, z: z, sender: sender)
    }
    
    
    @IBAction func moveBlockUp(_ sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    @IBAction func moveBlockDown(_ sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: 0, y: -kMovingLengthPerLoop, z: 0, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    @IBAction func moveBlockForward(_ sender: UILongPressGestureRecognizer) {
        let x = -deltas().sin
        let z = -deltas().cos
        moveBlock(x: x, z: z, sender: sender)
    }
    
    
    @IBAction func moveBlockBack(_ sender: UILongPressGestureRecognizer) {
        let x = deltas().sin
        let z = deltas().cos
        moveBlock(x: x, z: z, sender: sender)
    }
    
    @IBAction func rotateBlockRight(_ sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: -kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
        selectedBlock.runAction(action)
    }
    
    
    @IBAction func rotateBlockLeft(_ sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: kRotationRadianHalfPi, z: 0, duration: kAnimationDurationMoving)
        selectedBlock.runAction(action)
    }
    
    
    @IBAction func rotateBlockUp(_ sender: UITapGestureRecognizer) {
        let action = SCNAction.rotateBy(x: 0, y: 0, z: kRotationRadianHalfPi, duration: kAnimationDurationMoving)
        print(selectedBlock.position)
        selectedBlock.runAction(action)
    }
    
    private func deltas() -> (sin: CGFloat, cos: CGFloat) {
        return (sin: kMovingLengthPerLoop * CGFloat(sin(selectedBlock.eulerAngles.y)), cos: kMovingLengthPerLoop * CGFloat(cos(selectedBlock.eulerAngles.y)))
    }
    
    private func moveBlock(x: CGFloat, z: CGFloat, sender: UILongPressGestureRecognizer) {
        let action = SCNAction.moveBy(x: x, y: 0, z: z, duration: kAnimationDurationMoving)
        execute(action: action, sender: sender)
    }
    
    private func execute(action: SCNAction, sender: UILongPressGestureRecognizer) {
        let loopAction = SCNAction.repeatForever(action)
        if sender.state == .began {
            selectedBlock.runAction(loopAction)
        } else if sender.state == .ended {
            selectedBlock.removeAllActions()
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // Place content only for anchors found by plane detection.
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        
        // Create a SceneKit plane to visualize the plane anchor using its position and extent.
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // `SCNPlane` is vertically oriented in its local coordinate space, so
        // rotate the plane to match the horizontal orientation of `ARPlaneAnchor`.
        planeNode.eulerAngles.x = -.pi / 2
        
        // Make the plane visualization semitransparent to clearly show real-world placement.
        planeNode.opacity = 0.25
    
        
        // Add the plane visualization to the ARKit-managed node so that it tracks
        // changes in the plane anchor as plane estimation continues.
        node.addChildNode(planeNode)
        addInitialBlock(vec: planeNode.position)
    }
    
}

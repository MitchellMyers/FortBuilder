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

let kStartingPosition = SCNVector3(x: 0.187596142, y: -1.2002033, z: -1.2585659)
//let kStartingPosition = SCNVector3(x: 0, y: 0, z: 0)
let kAnimationDurationMoving: TimeInterval = 0.2
let kMovingLengthPerLoop: CGFloat = 0.05
let kRotationRadianPerLoop: CGFloat = 0.2
let kRotationRadianHalfPi: CGFloat = CGFloat.pi / 2

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    
    let selectedBlock = Block()
    let blockMover = Mover()
    
    
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
        print(selectedBlock.boundingBox)
    }
    
    
    
    @IBAction func moveBlockLeft(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveLeft(sender: sender, block: selectedBlock)
    }
    
    
    @IBAction func moveBlockRight(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveRight(sender: sender, block: selectedBlock)
    }
    
    
    @IBAction func moveBlockUp(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveUp(sender: sender, block: selectedBlock)
    }
    
    @IBAction func moveBlockDown(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveDown(sender: sender, block: selectedBlock)
    }
    
    @IBAction func moveBlockForward(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveForward(sender: sender, block: selectedBlock)
    }
    
    
    @IBAction func moveBlockBack(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveBackward(sender: sender, block: selectedBlock)
    }
    
    @IBAction func rotateBlockRight(_ sender: UITapGestureRecognizer) {
        selectedBlock.rotateRight(sender: sender)
    }
    
    
    @IBAction func rotateBlockLeft(_ sender: UITapGestureRecognizer) {
        selectedBlock.rotateLeft(sender: sender)
    }
    
    
    @IBAction func rotateBlockUp(_ sender: UITapGestureRecognizer) {
        selectedBlock.rotateUp(sender: sender)
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

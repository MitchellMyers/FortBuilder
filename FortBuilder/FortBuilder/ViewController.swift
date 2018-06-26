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

let kStartingPositionXBlock = SCNVector3(x: 0.0, y: -1.2002033, z: -1.0)
let kStartingPositionYBlock = SCNVector3(x: 0.0, y: -0.3, z: -1.0)
let kStartingPositionZBlock = SCNVector3(x: 0.0, y: -1.2002033, z: -1.0)
//let kStartingPosition = SCNVector3(x: 0, y: 0, z: 0)
let kAnimationDurationMoving: TimeInterval = 0.2
let kMovingLengthPerLoop: CGFloat = 0.05
let kRotationRadianPerLoop: CGFloat = 0.2
let kRotationRadianHalfPi: CGFloat = CGFloat.pi / 2

class ViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    
    var selectedBlock = Block()
    var temporaryBlock : SCNNode? = nil
    let blockMover = Mover()
    var currentFort = Fort()
    
    
    
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
        
        // Allow user interaction
        sceneView.isUserInteractionEnabled = true
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
    
    @IBAction func moveBlockLeft(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveLeft(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    
    @IBAction func moveBlockRight(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveRight(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    
    @IBAction func moveBlockUp(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveUp(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    @IBAction func moveBlockDown(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveDown(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    @IBAction func moveBlockForward(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveForward(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    
    @IBAction func moveBlockBack(_ sender: UILongPressGestureRecognizer) {
        blockMover.moveBackward(sender: sender, block: selectedBlock)
        checkPoximities()
    }
    
    
    @IBAction func addYBlockToScene(_ sender: UITapGestureRecognizer) {
        let newYBlock = YBlock()
        newYBlock.loadYBlock()
        newYBlock.position = kStartingPositionYBlock
        newYBlock.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(newYBlock)
        newYBlock.opacity = 0.75
        self.selectedBlock = newYBlock
    }
    
    
    @IBAction func addXBlockToScene(_ sender: UITapGestureRecognizer) {
        let newXBlock = XBlock()
        newXBlock.loadXBlock()
        newXBlock.position = kStartingPositionXBlock
        newXBlock.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(newXBlock)
        newXBlock.opacity = 0.75
        self.selectedBlock = newXBlock
    }
    
    
    @IBAction func addZBlockToScene(_ sender: UITapGestureRecognizer) {
        let newZBlock = ZBlock()
        newZBlock.loadZBlock()
        newZBlock.position = kStartingPositionZBlock
        newZBlock.rotation = SCNVector4Zero
        sceneView.scene.rootNode.addChildNode(newZBlock)
        newZBlock.opacity = 0.75
        self.selectedBlock = newZBlock
    }
    
    @IBAction func addBlockToFort(_ sender: UITapGestureRecognizer) {
        if temporaryBlock != nil {
            selectedBlock.position = (temporaryBlock?.position)!
            temporaryBlock?.removeFromParentNode()
            temporaryBlock = nil
        }
        selectedBlock.opacity = 1.0
        currentFort.addBlock(block: selectedBlock)
    }
    
    private func checkPoximities() {
        if temporaryBlock != nil {
            let tempDist = currentFort.getDistance(blockOnePos: (temporaryBlock?.position)!, blockTwoPos: selectedBlock.position)
            if tempDist > 0.4 {
                temporaryBlock?.removeFromParentNode()
                temporaryBlock = nil
            }
        }
        let proxTuple = currentFort.checkProximity(selectedBlock: selectedBlock)
        if proxTuple.0 != selectedBlock {
            let newBlockPos = blockMover.linkBlocks(blockTuple: (proxTuple.0, selectedBlock), anchorTuple: (proxTuple.1, proxTuple.2))
            let tempBox = selectedBlock.getBox()
            let newBox = SCNBox(width: tempBox.width, height: tempBox.height, length: tempBox.length, chamferRadius: 0.0)
            let material = SCNMaterial()
            material.diffuse.contents = UIColor.blue
            newBox.materials = [material]
            let tempBlockNode = SCNNode(geometry: newBox)
            tempBlockNode.opacity = 0.50
            tempBlockNode.position = newBlockPos
            temporaryBlock = tempBlockNode
            sceneView.scene.rootNode.addChildNode(tempBlockNode)
        }
    }
    
    @IBAction func didReceiveScreenTap(_ sender: UITapGestureRecognizer) {
        
        if sender.state == .ended {
            let location: CGPoint = sender.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: nil)
            if let tappednode = hits.first?.node {
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.red
                tappednode.geometry?.materials=[material]
                for node in sceneView.scene.rootNode.childNodes {
                    if (tappednode.name == node.name) && (((node as? Block) != nil)) {
                        selectedBlock = node as! Block
                    }
                }
            }
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
    }
    
}

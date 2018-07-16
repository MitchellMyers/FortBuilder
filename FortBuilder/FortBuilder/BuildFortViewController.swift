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
import Firebase

class BuildFortViewController: UIViewController, ARSCNViewDelegate {

    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var sliderView: UIView!
    
    let sliderContainer0: Int = 0
    let sliderContainer1: Int = 1
    let sliderContainer2: Int = 2
    let sliderContainer3: Int = 3
    let sliderContainer4: Int = 4
    
    let kStartingPositionXBlock = SCNVector3(x: 0.0, y: -1.2002033, z: -1.0)
    let kStartingPositionYBlock = SCNVector3(x: 0.0, y: -0.3, z: -1.0)
    let kStartingPositionZBlock = SCNVector3(x: 0.0, y: -1.2002033, z: -1.0)
    
    var ref: DatabaseReference!
    
    @IBOutlet var sliderBlockZ: UIView!
    @IBOutlet var sliderBlockX: UIView!
    @IBOutlet var sliderBlockY: UIView!
    
    var currSlideBlockTag : Int = 1
    
    var sliderBlocks = [UIView]()
    
    var sliderBlockToContainerDict = [Int : Int]()
    var sliderIndexToContainerDict = [Int : Int]()
    
    var selectedBlock : Block?
    var temporaryBlock : SCNNode? = nil
    let blockLinker = BlockLinker()
    var currentFort = Fort()
    var preExistingFort : Fort?
    var distanceToFort : Double?
    var sceneBlocks = [SCNNode]()
    
    var currentUserUsername : String?
    var currentCenter = SCNVector3()
    
    @IBOutlet weak var deleteBlockButton: UIButton!
    @IBOutlet var addToFortButton: UIButton!
    @IBOutlet weak var saveFortButton: UIButton!
    
    
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
        
        addToFortButton.isEnabled = false
        deleteBlockButton.isEnabled = false
        saveFortButton.isEnabled = false
        
        ref = Database.database().reference()
        
        setupSlider()
        
        ref.child("users").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let username = value?["username"] as? String ?? ""
            self.currentUserUsername = username
            self.setupUserAndPreexistingFort()
        }) { (error) in
            print(error.localizedDescription)
        }
        
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
    
    private func setupUserAndPreexistingFort() {
        if preExistingFort != nil {
            renderPreexistingFort()
            self.currentFort = preExistingFort!
        } else {
            self.currentFort.setCreatorUsername(username: self.currentUserUsername!)
            self.currentFort.setFortId(uid: UUID().uuidString)
        }
    }
    
    private func setupSlider() {
        sliderBlockToContainerDict[sliderBlockZ.tag] = sliderContainer1
        sliderBlockToContainerDict[sliderBlockX.tag] = sliderContainer2
        sliderBlockToContainerDict[sliderBlockY.tag] = sliderContainer3
        
        sliderIndexToContainerDict[0] = sliderContainer0
        sliderIndexToContainerDict[1] = sliderContainer1
        sliderIndexToContainerDict[2] = sliderContainer2
        sliderIndexToContainerDict[3] = sliderContainer3
        sliderIndexToContainerDict[4] = sliderContainer4
        
        sliderBlocks.append(sliderBlockZ)
        sliderBlocks.append(sliderBlockX)
        sliderBlocks.append(sliderBlockY)
        
        sliderBlockZ.alpha = 0.5
        sliderBlockX.alpha = 1.0
        sliderBlockY.alpha = 0.5
    }
    
    
    @IBAction func addYBlockToScene(_ sender: UITapGestureRecognizer) {
        if currSlideBlockTag == 2 && selectedBlock == nil {
            saveFortButton.isEnabled = false
            print("Adding Y block...")
            let enabledButton = sceneBlocks.count > 0 ? false : true
            addToFortButton.isEnabled = enabledButton
            deleteBlockButton.isEnabled = true
            let newYBlock = YBlock()
            newYBlock.loadBlock()
            newYBlock.position = kStartingPositionYBlock
            newYBlock.rotation = SCNVector4Zero
            sceneView.scene.rootNode.addChildNode(newYBlock)
            newYBlock.opacity = 0.75
            self.selectedBlock = newYBlock
            sceneBlocks.append(newYBlock)
        }
    }
    
    
    @IBAction func addXBlockToScene(_ sender: UITapGestureRecognizer) {
        if currSlideBlockTag == 1 && selectedBlock == nil {
            saveFortButton.isEnabled = false
            print("Adding X block...")
            let enabledButton = sceneBlocks.count > 0 ? false : true
            addToFortButton.isEnabled = enabledButton
            deleteBlockButton.isEnabled = true
            let newXBlock = XBlock()
            newXBlock.loadBlock()
            newXBlock.position = kStartingPositionXBlock
            newXBlock.rotation = SCNVector4Zero
            sceneView.scene.rootNode.addChildNode(newXBlock)
            newXBlock.opacity = 0.75
            self.selectedBlock = newXBlock
            sceneBlocks.append(newXBlock)
        }
    }
    
    
    @IBAction func addZBlockToScene(_ sender: UITapGestureRecognizer) {
        if currSlideBlockTag == 0 && selectedBlock == nil {
            saveFortButton.isEnabled = false
            print("Adding Z block...")
            let enabledButton = sceneBlocks.count > 0 ? false : true
            addToFortButton.isEnabled = enabledButton
            deleteBlockButton.isEnabled = true
            let newZBlock = ZBlock()
            newZBlock.loadBlock()
            newZBlock.position = kStartingPositionZBlock
            newZBlock.rotation = SCNVector4Zero
            sceneView.scene.rootNode.addChildNode(newZBlock)
            newZBlock.opacity = 0.75
            self.selectedBlock = newZBlock
            sceneBlocks.append(newZBlock)
        }
    }
    
    @IBAction func addBlockToFort(_ sender: UITapGestureRecognizer) {
        if temporaryBlock != nil {
            selectedBlock!.position = (temporaryBlock?.position)!
            temporaryBlock?.removeFromParentNode()
            temporaryBlock = nil
        }
        selectedBlock!.opacity = 1.0
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/wooden_texture.jpg")
        selectedBlock!.getBox().materials = [material]
        currentFort.addBlock(block: selectedBlock!)
        selectedBlock = nil
        addToFortButton.isEnabled = false
        deleteBlockButton.isEnabled = false
        saveFortButton.isEnabled = true
    }
    
    @IBAction func deleteBlock(_ sender: UITapGestureRecognizer) {
        selectedBlock!.removeFromParentNode()
        for i in 0...sceneBlocks.count - 1 {
            if selectedBlock!.isEqual(sceneBlocks[i]) {
                sceneBlocks.remove(at: i)
                break
            }
        }
        selectedBlock = nil
        deleteBlockButton.isEnabled = false
        addToFortButton.isEnabled = false
        saveFortButton.isEnabled = true
    }
    
    @IBAction func rightSliderSwipe(_ sender: UISwipeGestureRecognizer) {
        let currYContainer = sliderBlockToContainerDict[sliderBlockY.tag]
        if !(currYContainer == sliderContainer4) {
            for slideBlock in sliderBlocks {
                let fromView = sliderBlockToContainerDict[slideBlock.tag]
                sliderBlockToContainerDict[slideBlock.tag] = sliderIndexToContainerDict[fromView! + 1]
                UIView.animate(withDuration: 0.5, animations: {
                    slideBlock.frame = CGRect(x: slideBlock.frame.minX + (self.sliderView?.frame.width)! / 5.0, y: slideBlock.frame.minY, width: slideBlock.frame.width, height: slideBlock.frame.height)
                })
                if (fromView! + 1) != 2 {
                    slideBlock.alpha = 0.5
                } else {
                    currSlideBlockTag = slideBlock.tag
                    slideBlock.alpha = 1.0
                }
            }
        }
    }
    
    
    @IBAction func leftSliderSwipe(_ sender: UISwipeGestureRecognizer) {
        let currZContainer = sliderBlockToContainerDict[sliderBlockZ.tag]
        if !(currZContainer == sliderContainer0) {
            for slideBlock in sliderBlocks {
                let fromView = sliderBlockToContainerDict[slideBlock.tag]
                sliderBlockToContainerDict[slideBlock.tag] = sliderIndexToContainerDict[fromView! - 1]
                UIView.animate(withDuration: 0.5, animations: {
                    slideBlock.frame = CGRect(x: slideBlock.frame.minX - (self.sliderView?.frame.width)! / 5.0, y: slideBlock.frame.minY, width: slideBlock.frame.width, height: slideBlock.frame.height)
                })
                if (fromView! - 1) != 2 {
                    slideBlock.alpha = 0.5
                } else {
                    currSlideBlockTag = slideBlock.tag
                    slideBlock.alpha = 1.0
                }
            }
        }
    }
    
    @IBAction func moveSelectedBlock(_ sender: UIPanGestureRecognizer) {
        sender.maximumNumberOfTouches = 1
        let translation = sender.translation(in: sceneView.superview)
        let cameraRot = sceneView.session.currentFrame!.camera.eulerAngles.y
        if sender.state == .began {
            // Save the view's original position.
            currentCenter.x = selectedBlock!.position.x
            currentCenter.y = selectedBlock!.position.y
            currentCenter.z = selectedBlock!.position.z
        }
        // Update the position for the .began, .changed, and .ended states
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            let newCenter = CGPoint(x: CGFloat(currentCenter.x) + (CGFloat(cos(cameraRot)) * (translation.x / 300)), y: CGFloat(currentCenter.y) - (translation.y / 300))
            let newZ = CGFloat(currentCenter.z) + (CGFloat(-sin(cameraRot)) * (translation.x / 300))
            selectedBlock!.position = SCNVector3Make(Float(newCenter.x), Float(newCenter.y), Float(newZ))
            checkPoximities()
        }
        
    }
    
    
    @IBAction func moveSelectedBlockZDir(_ sender: UIPanGestureRecognizer) {
        sender.minimumNumberOfTouches = 2
        let translation = sender.translation(in: sceneView.superview)
        let cameraRot = sceneView.session.currentFrame!.camera.eulerAngles.y
        if sender.state == .began {
            // Save the view's original position.
            currentCenter.x = selectedBlock!.position.x
            currentCenter.y = selectedBlock!.position.y
            currentCenter.z = selectedBlock!.position.z
        }
        // Update the position for the .began, .changed, and .ended states
        if sender.state != .cancelled {
            // Add the X and Y translation to the view's original position.
            
            let newCenter = CGPoint(x: CGFloat(currentCenter.x) + (CGFloat(sin(cameraRot)) * (translation.y / 300)) + (CGFloat(-sin(cameraRot)) * (translation.x / 300)), y: CGFloat(currentCenter.y))
            let newZ = CGFloat(currentCenter.z) + (CGFloat(cos(cameraRot)) * (translation.y / 300)) + (CGFloat(-cos(cameraRot)) * (translation.x / 300))
            
            selectedBlock!.position = SCNVector3Make(Float(newCenter.x), Float(newCenter.y), Float(newZ))
            checkPoximities()
        }
    }
    
    private func checkPoximities() {
        if temporaryBlock != nil {
            let tempDist = currentFort.getDistance(blockOnePos: (temporaryBlock?.position)!, blockTwoPos: selectedBlock!.position)
            if tempDist > 0.4 {
                temporaryBlock?.removeFromParentNode()
                temporaryBlock = nil
                addToFortButton.isEnabled = false
            }
        } else {
            let proxTuple = currentFort.checkProximity(selectedBlock: selectedBlock!)
            if proxTuple.0 != selectedBlock {
                addToFortButton.isEnabled = true
                let newBlockPos = blockLinker.linkBlocks(blockTuple: (proxTuple.0, selectedBlock!), anchorTuple: (proxTuple.1, proxTuple.2))
                if !fortBlockPositionExists(blockPos: newBlockPos) {
                    let tempBox = selectedBlock!.getBox()
                    let newBox = SCNBox(width: tempBox.width, height: tempBox.height, length: tempBox.length, chamferRadius: 0.0)
                    let material = SCNMaterial()
                    material.diffuse.contents = UIColor.red
                    newBox.materials = [material]
                    temporaryBlock = SCNNode(geometry: newBox)
                    temporaryBlock?.opacity = 0.50
                    temporaryBlock?.position = newBlockPos
                    sceneView.scene.rootNode.addChildNode(temporaryBlock!)
                }
            } else if (sceneBlocks.count > 1) {
                addToFortButton.isEnabled = false
            } else {
                addToFortButton.isEnabled = true
            }
        }
    }
    
    private func fortBlockPositionExists(blockPos: SCNVector3) -> Bool {
        var blockExists = false
        for block in currentFort.getFortBlocks() {
            if SCNVector3EqualToVector3(block.position, blockPos) {
                blockExists = true
            }
        }
        return blockExists
    }
            
    @IBAction func didReceiveScreenTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let location: CGPoint = sender.location(in: sceneView)
            let hits = self.sceneView.hitTest(location, options: [:])
            if let tappednode = hits.first?.node {
                let parentBlock = tappednode.parent as? Block
                let material = SCNMaterial()
                material.diffuse.contents = UIColor.blue
                parentBlock?.geometry?.materials=[material]
                parentBlock?.opacity = 0.50
                parentBlock?.childNodes[0].geometry?.materials = [material]
                currentFort.removeBlock(block: parentBlock ?? Block())
                selectedBlock = parentBlock ?? selectedBlock
                let enabledButton = sceneBlocks.count > 1 ? false : true
                addToFortButton.isEnabled = enabledButton
                deleteBlockButton.isEnabled = true
                saveFortButton.isEnabled = false
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
    
    @IBAction func saveCurrentFort(_ sender: UITapGestureRecognizer) {
        self.performSegue(withIdentifier: "saveFortSegue", sender: self)
    }
    
    @IBAction func returnToHomeScreen(_ sender: UITapGestureRecognizer) {
        let alertController = UIAlertController(title: "Are you sure?", message: "If you go home now, then your current fort work will be lost.", preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "Go Anyways", style: .default) { (action) -> Void in
            self.performSegue(withIdentifier: "buildFortViewToHome", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let saveFortViewController = segue.destination as? SaveFortViewController {
            saveFortViewController.currentFort = self.currentFort
            if preExistingFort != nil {
                saveFortViewController.editedByUsername = currentUserUsername
            }
        }
    }
    
    private func renderPreexistingFort() {
        for block in self.preExistingFort!.getFortBlocks() {
            block.loadBlock()
            block.position.z = block.position.z - Float(distanceToFort!)
            block.rotation = SCNVector4Zero
            sceneView.scene.rootNode.addChildNode(block)
            sceneBlocks.append(block)
            block.opacity = 1.0
        }
    }
    
}

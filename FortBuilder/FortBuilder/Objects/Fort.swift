//
//  Fort.swift
//  FortBuilder
//
//  Created by Mitchell Myers on 6/20/18.
//  Copyright © 2018 BreMy Software. All rights reserved.
//

import Foundation
import ARKit

class Fort {
    
    private var fortBlocks = [Block]()
    private var creatorUsername : String?
    private var fortUid : String?
    private var fortName : String?
    private var fortPrivacy : String?
    
    func addBlock(block: Block) {
        fortBlocks.append(block)
    }
    
    func removeBlock(block: Block) {
        if fortBlocks.count > 0 {
            for i in 0...fortBlocks.count - 1 {
                if block.isEqual(fortBlocks[i]) {
                    fortBlocks.remove(at: i)
                    break
                }
            }
        }
    }
    
    func checkProximity(selectedBlock: Block) -> (Block, SCNVector3, SCNVector3) {
        for fortBlock in fortBlocks {
            for fbAnchor in fortBlock.getAnchorPoints() {
                for sbAnchor in selectedBlock.getAnchorPoints() {
                    if (getDistance(blockOnePos: fbAnchor, blockTwoPos: sbAnchor) < 0.4) {
                        return (fortBlock, fbAnchor, sbAnchor)
                    }
                }
            }
        }
        return (selectedBlock, SCNVector3Make(0.0, 0.0, 0.0), SCNVector3Make(0.0, 0.0, 0.0))
    }
    
    func getFortBlocks() -> [Block] {
        return self.fortBlocks
    }
    
    func getDistance(blockOnePos: SCNVector3, blockTwoPos: SCNVector3) -> Float {
        return sqrtf(pow((blockTwoPos.x - blockOnePos.x), 2.0) + pow((blockTwoPos.y - blockOnePos.y), 2.0) + pow((blockTwoPos.z - blockOnePos.z), 2.0))
    }
    
    func getFortBlockDict() -> [String: [String: String]] {
        var blocksDict = [String: [String: String]]()
        let fortBlocks = self.getFortBlocks()
        if fortBlocks.count > 1 {
            for i in 0...fortBlocks.count - 1 {
                let block = fortBlocks[i]
                var blockDict = [String:String]()
                blockDict["block_type"] = block.getType()
                blockDict["position"] = "\(block.position.x),\(block.position.y),\(block.position.z)"
                blocksDict[String(i)] = blockDict
            }
        }
        return blocksDict
    }
    
    func setCreatorUsername(username: String) {
        self.creatorUsername = username
    }
    
    func getCreatorUsername() -> String? {
        return self.creatorUsername
    }
    
    func setFortId(uid: String) {
        self.fortUid = uid
    }
    
    func getFortId() -> String? {
        return self.fortUid
    }
    
    func setFortName(name: String) {
        self.fortName = name
    }
    
    func getFortName() -> String? {
        return self.fortName
    }
    
    func setFortPrivacy(privacy: String) {
        self.fortPrivacy = privacy
    }
    
    func getFortPrivacy() -> String? {
        return self.fortPrivacy
    }
    
}

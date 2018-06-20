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
    
    private var fortBlocks = [SCNNode]()
    
    func addBlock(block: SCNNode) {
        fortBlocks.append(block)
    }
    
}

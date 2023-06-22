//
//  InventoryNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 22/06/23.
//

import Foundation
import SpriteKit
import GameplayKit

class InventoryNode: SKSpriteNode {
    init(position: CGPoint) {
        let inventorySlot1: InventorySlotNode = InventorySlotNode(imageName: "diamond_block")
        let inventorySlot2: InventorySlotNode = InventorySlotNode(imageName: "diamond_block")
        
        let size = CGSize(width: Constants.INVENTORY_WIDTH, height: Constants.INVENTORY_HEIGHT)
        
        super.init(texture: nil, color: .blue, size: size)
        
        self.position = position
        
        inventorySlot1.position = CGPoint(x: frame.midX-100, y: frame.midY)
        inventorySlot2.position = CGPoint(x: frame.midX+100, y: frame.midY)

        self.addChild(inventorySlot1)
        
        self.addChild(inventorySlot2)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

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
    var inventorySlots: [InventorySlotNode] = []

    init(position: CGPoint) {
        
        let size = CGSize(width: Constants.INVENTORY_WIDTH, height: Constants.INVENTORY_HEIGHT)
        
        super.init(texture: nil, color: .blue, size: size)
        
        self.position = position
        
//        self.addChild(inventorySlot1)
//        self.addChild(inventorySlot2)
//        self.addChild(inventorySlot3)
//        self.addChild(inventorySlot4)
//        self.addChild(inventorySlot5)
//        self.addChild(inventorySlot6)
//        self.addChild(inventorySlot7)
//        self.addChild(inventorySlot8)
        self.initInventorySlots()
        
        for inventorySlotNode in self.inventorySlots {
            self.addChild(inventorySlotNode)
        }
        
       
    }
    
    private func initInventorySlots() {
        let startCoordinate = 0.0

        let inventorySlot1: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 0)
        let inventorySlot2: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 1)
        let inventorySlot3: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 2)
        let inventorySlot4: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 3)
        let inventorySlot5: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 4)
        let inventorySlot6: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 5)
        let inventorySlot7: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 6)
        let inventorySlot8: InventorySlotNode = InventorySlotNode(imageName: "diamond_block", index: 7)
        
        inventorySlot1.position = CGPoint(x:  -(inventorySlot4.size.width * 3) - 90, y: startCoordinate)
        inventorySlot2.position = CGPoint(x:  -(inventorySlot4.size.width * 2) - 70, y: startCoordinate)
        inventorySlot3.position = CGPoint(x:  -(inventorySlot4.size.width * 1) - 50, y: startCoordinate)
        inventorySlot4.position = CGPoint(x:  -30, y: startCoordinate)
        
        inventorySlot5.position = CGPoint(x: startCoordinate + 30, y: startCoordinate)
        inventorySlot6.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 1) + 50, y: startCoordinate)
        inventorySlot7.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 2) + 70, y: startCoordinate)
        inventorySlot8.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 3) + 90, y: startCoordinate)
        
        self.inventorySlots.append(inventorySlot1)
        self.inventorySlots.append(inventorySlot2)
        self.inventorySlots.append(inventorySlot3)
        self.inventorySlots.append(inventorySlot4)
        self.inventorySlots.append(inventorySlot5)
        self.inventorySlots.append(inventorySlot6)
        self.inventorySlots.append(inventorySlot7)
        self.inventorySlots.append(inventorySlot8)

    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

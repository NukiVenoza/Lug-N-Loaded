//
//  InventoryNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 22/06/23.
//

import Foundation
import GameplayKit
import SpriteKit

class InventoryNode: SKSpriteNode {
  var inventorySlots: [InventorySlotNode] = []

  init(position: CGPoint) {
    let size = CGSize(width: Constants.INVENTORY_WIDTH, height: Constants.INVENTORY_HEIGHT)
    super.init(
      texture: SKTexture(imageNamed: Constants.INVENTORY_BACKGROUND_IMAGENAME),
      color: .blue,
      size: size)
    self.position = position
    
    self.initInventorySlots()
        
    for inventorySlotNode in self.inventorySlots {
      self.addChild(inventorySlotNode)
    }
  }
    
  private func initInventorySlots() {
    let startCoordinate = 0.0
    let startCoordinateY = 5.0
    let inventorySlot1 = InventorySlotNode(index: 0)
    let inventorySlot2 = InventorySlotNode(index: 1)
    let inventorySlot3 = InventorySlotNode(index: 2)
    let inventorySlot4 = InventorySlotNode(index: 3)
    let inventorySlot5 = InventorySlotNode(index: 4)
    let inventorySlot6 = InventorySlotNode(index: 5)
    let inventorySlot7 = InventorySlotNode(index: 6)
    let inventorySlot8 = InventorySlotNode(index: 7)
        
    inventorySlot1.position = CGPoint(x: -(inventorySlot4.size.width * 3) - 130, y: startCoordinateY)
    inventorySlot2.position = CGPoint(x: -(inventorySlot4.size.width * 2) - 100, y: startCoordinateY)
    inventorySlot3.position = CGPoint(x: -(inventorySlot4.size.width * 1) - 70, y: startCoordinateY)
    inventorySlot4.position = CGPoint(x: -40, y: startCoordinateY)
        
    inventorySlot5.position = CGPoint(x: startCoordinate + 40, y: startCoordinateY)
    inventorySlot6.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 1) + 70, y: startCoordinateY)
    inventorySlot7.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 2) + 100, y: startCoordinateY)
    inventorySlot8.position = CGPoint(x: startCoordinate + (inventorySlot5.size.width * 3) + 130, y: startCoordinateY)
        
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

//
//  GameSceneFunctions.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 25/06/23.
//

import Foundation
import SpriteKit

class GameSceneFunctions {
  public static func checkWin(gameScene: GameScene) {
    // loop over itemnode, check that all is not in inventory and is in luggage
    for itemNode in gameScene.itemNodes {
      if itemNode.isPlaced == false {
        return
      }
    }
    
    for itemNode in gameScene.itemNodes {
      if itemNode.inInventory {
        return
      }
    }
    
    for itemNode in gameScene.itemNodes {
      if itemNode.inLuggage == false {
        return
      }
    }
    
    // all ItemNodes are in LuggageNode therefore:
    print("YOU WIN!")
    gameScene.gameWon = true
  }
  
  public static func handleCollision(gameScene: GameScene) {
    for itemNode in gameScene.itemNodes {
      if gameScene.luggage.contains(itemNode.position) {
        if itemNode.inInventory {
          itemNode.inLuggage = true
          itemNode.inInventory = false
          itemNode.updateItemScale()
        }
        if itemNode.isInsideLuggage(luggage: gameScene.luggageHitBox) == false, itemNode.isPlaced {
          itemNode.inLuggage = false
          itemNode.inInventory = true
          itemNode.updateItemScale()
          self.moveItemToInventorySlot(
            gameScene: gameScene, item: itemNode)
        }
      } else {
        if itemNode.inLuggage {
          itemNode.inLuggage = false
          self.moveItemToInventorySlot(gameScene: gameScene, item: itemNode)
          itemNode.updateItemScale()
        }
      }
    }
  }

  public static func updateInventorySlotStatus(gameScene: GameScene) {
    for inventorySlot in gameScene.inventory.inventorySlots {
      var isSlotFilled = false
          
      for itemNode in gameScene.itemNodes {
        if inventorySlot.intersects(itemNode) {
          isSlotFilled = true
          break
        }
      }
          
      inventorySlot.isFilled = isSlotFilled
      inventorySlot.updateTexture()
    }
  }
  
  public static func findEmptySlot(gameScene: GameScene) -> InventorySlotNode? {
    for inventorySlot in gameScene.inventory.inventorySlots {
      if !inventorySlot.isFilled {
        return inventorySlot
      }
    }
    return nil
  }
  
  public static func moveItemToInventorySlot(gameScene: GameScene, item: ItemNode) {
    self.updateInventorySlotStatus(gameScene: gameScene)
    
    if let slot = self.findEmptySlot(gameScene: gameScene) {
      var finalSlotPosition = slot.convert(slot.position, to: gameScene)
      
      if slot == gameScene.inventory.inventorySlots[0] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_1
        gameScene.emptySlotPositionLeft = finalSlotPosition
        
      } else if slot == gameScene.inventory.inventorySlots[1] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_2
          
      } else if slot == gameScene.inventory.inventorySlots[2] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_3
          
      } else if slot == gameScene.inventory.inventorySlots[3] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_4
          
      } else if slot == gameScene.inventory.inventorySlots[4] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_5
          
      } else if slot == gameScene.inventory.inventorySlots[5] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_6
          
      } else if slot == gameScene.inventory.inventorySlots[6] {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_7
          
      } else {
        finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_8
      }
      
      // move item to finalSlotPosition
      item.position = finalSlotPosition
      item.inInventory = true
      item.inLuggage = false
      slot.isFilled = true
      
      slot.updateTexture()
    }
  }
  
  public static func getSlotPosition(
    gameScene: GameScene,
    slotIndex: Int) -> CGPoint
  {
    var finalPoint = gameScene.inventory.inventorySlots[0].convert(gameScene.inventory.inventorySlots[0].position, to: gameScene)
    
    if slotIndex == 0 {
      finalPoint.x = finalPoint.x + Constants.INVENTORY_SLOP_GAP_FIRST
      gameScene.emptySlotPositionLeft = finalPoint

    } else if slotIndex == 1 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_2
        
    } else if slotIndex == 2 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_3
        
    } else if slotIndex == 3 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_4

    } else if slotIndex == 4 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_5

    } else if slotIndex == 5 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_6

    } else if slotIndex == 6 {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_7

    } else {
      finalPoint.x = Constants.INVENTORY_SLOT_POSITION_8
    }
      
    return finalPoint
  }
  
  public static func createLuggageHitBox(gameScene: GameScene, luggage: LuggageNode) -> SKSpriteNode {
    let luggageHitBox = SKSpriteNode(color: .gray, size: luggage.calculateAccumulatedFrame().size)
    luggageHitBox.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 40)
    luggageHitBox.zPosition = 1
    luggageHitBox.texture = SKTexture(imageNamed: Constants.LUGGAGE_BACKGROUND_IMAGENAME)
    
    luggageHitBox.size.height = luggageHitBox.size.height + 32
    luggageHitBox.size.width = luggageHitBox.size.width + 30
    
    luggageHitBox.position.x = luggageHitBox.position.x + 1.0
    luggageHitBox.position.y = luggageHitBox.position.y - 0.5

    return luggageHitBox
  }
  
//  public static func initItemNodes(gameScene: GameScene) {
//    let slotPosition1 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[0])
//    let slotPosition2 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[1])
//    let slotPosition3 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[2])
//    let slotPosition4 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[3])
//    let slotPosition5 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[4])
//    let slotPosition6 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[5])
//    let slotPosition7 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[6])
//    let slotPosition8 = self.convertInventorySlotNodePositionToScene(gameScene: gameScene, inventorySlotNode: gameScene.inventory.inventorySlots[7])
//  }
  
  public static func initLevel1(gameScene: GameScene) {
    // Init Background:
    let backgroundNode = SKSpriteNode(imageNamed: Constants.BACKGROUND_IMAGE)
    backgroundNode.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
    backgroundNode.zPosition = -1
    gameScene.addChild(backgroundNode)
    
    // Init Luggage:
    gameScene.luggage = LuggageNode(row: 4, column: 8, position: CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 20))
    gameScene.addChild(gameScene.luggage)
    gameScene.luggageHitBox = self.createLuggageHitBox(gameScene: gameScene, luggage: gameScene.luggage)
    gameScene.addChild(gameScene.luggageHitBox)
    
    // Init Items:
    let item1 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: getSlotPosition(gameScene: gameScene, slotIndex: 0))
    let item2 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                         position: getSlotPosition(gameScene: gameScene, slotIndex: 1))
    let item3 = ItemNode(imageName: "medal", itemShape: "l_right",
                         position: getSlotPosition(gameScene: gameScene, slotIndex: 2))
    let item4 = ItemNode(imageName: "clothes", itemShape: "square_2",
                         position: getSlotPosition(gameScene: gameScene, slotIndex: 3))
    let item5 = ItemNode(imageName: "wallet", itemShape: "rect_horizontal_2",
                         position: getSlotPosition(gameScene: gameScene, slotIndex: 4))
    gameScene.itemNodes.append(item1)
    gameScene.itemNodes.append(item2)
    gameScene.itemNodes.append(item3)
    gameScene.itemNodes.append(item4)
    gameScene.itemNodes.append(item5)
    
    for itemNode in gameScene.itemNodes {
      gameScene.addChild(itemNode)
    }
  }
}

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
        finalSlotPosition.x = finalSlotPosition.x + 200.0
        gameScene.emptySlotPositionLeft = finalSlotPosition
      } else {
        let neededSpace = 45 * (slot.index + 1)
        finalSlotPosition.x = gameScene.emptySlotPositionLeft.x + CGFloat(neededSpace)
      }
      
      // move item to finalSlotPosition
      item.position = finalSlotPosition
      item.inInventory = true
      item.inLuggage = false
      slot.isFilled = true
      
      slot.updateTexture()
    }
  }
  
  public static func convertInventorySlotNodePositionToScene(
    gameScene: GameScene,
    inventorySlotNode: InventorySlotNode) -> CGPoint
  {
    var finalPoint = inventorySlotNode.convert(
      inventorySlotNode.position, to: gameScene)
      
    if inventorySlotNode.index == 0 {
      finalPoint.x = finalPoint.x + 200.0
      gameScene.emptySlotPositionLeft = finalPoint

    } else {
      let neededSpace = 32 * (inventorySlotNode.index + 1)
      finalPoint.x = gameScene.emptySlotPositionLeft.x + CGFloat(neededSpace)
    }
      
    return finalPoint
  }
  
  public static func createLuggageHitBox(gameScene: GameScene, luggage: LuggageNode) -> SKSpriteNode {
    var luggageHitBox = SKSpriteNode(color: .gray, size: luggage.calculateAccumulatedFrame().size)
    luggageHitBox.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 40)
    luggageHitBox.zPosition = 1
    
    let scaleAction = SKAction.scale(by: 1.08, duration: 0.1)
    luggageHitBox.run(scaleAction)
    
    return luggageHitBox
  }
  
  public static func initItemNodes(gameScene: GameScene) {
    let item1 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY))

    let item2 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                         position: CGPoint(x: gameScene.frame.midX + 100, y: gameScene.frame.midY + 100))
    let item3 = ItemNode(imageName: "medal", itemShape: "l_right",
                         position: CGPoint(x: gameScene.frame.midX + 200, y: gameScene.frame.midY + 100))
    let item4 = ItemNode(imageName: "clothes", itemShape: "square_2",
                         position: CGPoint(x: gameScene.frame.midX + -100, y: gameScene.frame.midY + 100))
    let item5 = ItemNode(imageName: "wallet", itemShape: "rect_horizontal_2",
                         position: CGPoint(x: gameScene.frame.midX + -200, y: gameScene.frame.midY + 100))
    let item6 = ItemNode(imageName: "gold", itemShape: "square",
                         position: CGPoint(x: gameScene.frame.midX + 300, y: gameScene.frame.midY + 100))
    
    gameScene.itemNodes.append(item1)
    gameScene.itemNodes.append(item2)
    gameScene.itemNodes.append(item3)
    gameScene.itemNodes.append(item4)
    gameScene.itemNodes.append(item5)
    gameScene.itemNodes.append(item6)
  }
}

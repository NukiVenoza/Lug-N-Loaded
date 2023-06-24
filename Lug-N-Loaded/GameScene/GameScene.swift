//
//  GameScene.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 17/06/23.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
  private var gameWon: Bool = false
  private var currentNode: SKNode?
  private var currentItemNode: ItemNode?
  
  private var luggage: LuggageNode!
  private var inventory: InventoryNode!
  // nanti append semua itemNodes kesini
  private var itemNodes: [ItemNode] = []
  
  var emptySlotPositionLeft: CGPoint = .init(x: 0, y: 0)
  
  override func didMove(to view: SKView) {
    // MARK: Enables gestures
    
    isUserInteractionEnabled = true
    
    // Add double tap gesture recognizer
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapGesture)
    
    // MARK: Node Placement
    
    self.luggage = LuggageNode(row: 4, column: 8,
                               position: CGPoint(x: frame.midX, y: frame.midY + 20))
    
    self.inventory = InventoryNode(position: CGPoint(x: frame.midX, y: frame.midY - 120))
    
    self.addChild(self.luggage)
    self.addChild(self.inventory)
    
    self.initItemNodes()
    
    for itemNode in self.itemNodes {
      self.addChild(itemNode)
    }
  }
  
  @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
    // Get the location of the double tap gesture
    let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
    
    // Convert the touch location to the scene's coordinate system
    let convertedLocation = convertPoint(fromView: touchLocation)
    
    // MARK: Rotate Node
    
    if let tappedNode = atPoint(convertedLocation) as? SKSpriteNode {
      // Rotate the node by 90 degrees
      if tappedNode.name == "item" {
        // Rotate the node by 90 degrees
        let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
        tappedNode.run(rotateAction)
      }
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    // MARK: For Drag n Drop Functionality
    
    if let touch = touches.first {
      let location = touch.location(in: self)
      
      let touchedNodes = self.nodes(at: location)
      for node in touchedNodes.reversed() {
        if node.name == "item" {
          self.currentNode = node
          
          self.currentItemNode = SKNodeToItemNode(node: self.currentNode!)
          self.currentItemNode?.isPlaced = false

          if let currentNode = currentNode, luggage.contains(currentNode.position) {
            self.currentItemNode?.updateItemPhysics()
            
          } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
            self.currentItemNode?.updateItemPhysics()
          }
        }
      }
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = self.currentNode {
      let touchLocation = touch.location(in: self)
      node.position = touchLocation
      
      if self.luggage.contains(node.position) {
        // Di Dalem LUGGAGE
        self.currentItemNode?.inLuggage = true
        self.currentItemNode?.inInventory = false
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
        
      } else if self.inventory.contains(node.position) {
        // Di Dalem INVENTORY
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = true
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
      } else {
        // Di Luar
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = false
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // MARK: check if item is inside of luggage or not
    
    for touch in touches {
      _ = touch.location(in: self)
      
      // check if item node is in luggagenode
      if let currentNode = currentNode, luggage.contains(currentNode.position) {
        self.updateInventorySlotStatus()

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = true
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
      } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
        self.updateInventorySlotStatus()

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        self.moveItemToInventorySlot(item: self.currentItemNode ?? ItemNode())
        
      } else if let currentNode = currentNode {
        self.updateInventorySlotStatus()

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        self.moveItemToInventorySlot(item: self.currentItemNode ?? ItemNode())
      }

      self.currentNode = nil
      self.currentItemNode = nil
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.currentNode = nil
    self.currentItemNode = nil
  }
  
  override func update(_ currentTime: TimeInterval) {
    super.update(currentTime)
    
    // check if game won
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      if !self.gameWon {
        self.checkWin()
      }
    }
    self.handleCollision()
  }
  
  //  function to check win condition
  private func checkWin() {
    // loop over itemnode, check that all is not in inventory and is in luggage
    for itemNode in self.itemNodes {
      if itemNode.isPlaced == false {
        return
      }
    }
    
    for itemNode in self.itemNodes {
      if itemNode.inInventory {
        return
      }
    }
    
    for itemNode in self.itemNodes {
      if itemNode.inLuggage == false {
        return
      }
    }
    
    // all ItemNodes are in LuggageNode therefore:
    print("YOU WIN!")
    self.gameWon = true
  }
  
  private func handleCollision() {
    for itemNode in self.itemNodes {
      if self.luggage.contains(itemNode.position) {
        if itemNode.inInventory {
          itemNode.inLuggage = true
          itemNode.inInventory = false
          itemNode.updateItemScale()
        }
      } else {
        if itemNode.inLuggage {
          itemNode.inLuggage = false
          self.moveItemToInventorySlot(item: itemNode)
          itemNode.updateItemScale()
        }
      }
    }
  }

  private func updateInventorySlotStatus() {
    for inventorySlot in self.inventory.inventorySlots {
      var isSlotFilled = false
          
      for itemNode in self.itemNodes {
        if inventorySlot.intersects(itemNode) {
          isSlotFilled = true
          break
        }
      }
          
      inventorySlot.isFilled = isSlotFilled
      inventorySlot.updateTexture()
    }
  }
  
  private func findEmptySlot() -> InventorySlotNode? {
    for inventorySlot in self.inventory.inventorySlots {
      if !inventorySlot.isFilled {
        return inventorySlot
      }
    }
    return nil
  }
  
  private func moveItemToInventorySlot(item: ItemNode) {
    self.updateInventorySlotStatus()
    
    if let slot = self.findEmptySlot() {
      print("BEFORE SELF: \(self.inventory.inventorySlots[slot.index].isFilled)")
      print("BEFORE SLOT: \(slot.isFilled)")
      var finalSlotPosition = slot.convert(slot.position, to: self)
      print("empty slot ke-\(slot.index)")
      
      if slot == self.inventory.inventorySlots[0] {
        finalSlotPosition.x = finalSlotPosition.x + 200.0
        self.emptySlotPositionLeft = finalSlotPosition
      } else {
        let neededSpace = 45 * (slot.index + 1)
        finalSlotPosition.x = self.emptySlotPositionLeft.x + CGFloat(neededSpace)
      }
      
      // move item to finalSlotPosition
      item.position = finalSlotPosition
      item.inInventory = true
      item.inLuggage = false
      slot.isFilled = true
      
      print("SELF: \(self.inventory.inventorySlots[slot.index].isFilled)")
      print("SLOT: \(slot.isFilled)")
      
      slot.updateTexture()
    }
  }
  
  private func convertInventorySlotNodePositionToScene(inventorySlotNode: InventorySlotNode) -> CGPoint {
    var finalPoint = inventorySlotNode.convert(inventorySlotNode.position, to: self)
      
    if inventorySlotNode.index == 0 {
      finalPoint.x = finalPoint.x + 200.0
      self.emptySlotPositionLeft = finalPoint

    } else {
      let neededSpace = 32 * (inventorySlotNode.index + 1)
      finalPoint.x = self.emptySlotPositionLeft.x + CGFloat(neededSpace)
    }
      
    print("returned slot of index \(inventorySlotNode.index)")
    return finalPoint
  }
  
  private func initItemNodes() {
    let item1 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: frame.midX, y: frame.midY))

    let item2 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                         position: CGPoint(x: frame.midX + 100, y: frame.midY + 100))
    let item3 = ItemNode(imageName: "medal", itemShape: "l_right",
                         position: CGPoint(x: frame.midX + 200, y: frame.midY + 100))
    let item4 = ItemNode(imageName: "clothes", itemShape: "square_2",
                         position: CGPoint(x: frame.midX + -100, y: frame.midY + 100))
    let item5 = ItemNode(imageName: "wallet", itemShape: "rect_horizontal_2",
                         position: CGPoint(x: frame.midX + -200, y: frame.midY + 100))
    let item6 = ItemNode(imageName: "gold", itemShape: "square",
                         position: CGPoint(x: frame.midX + 300, y: frame.midY + 100))
    
    self.itemNodes.append(item1)
    self.itemNodes.append(item2)
    self.itemNodes.append(item3)
    self.itemNodes.append(item4)
    self.itemNodes.append(item5)
    self.itemNodes.append(item6)
  }
}

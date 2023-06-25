//
//  GameScene.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 17/06/23.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
  public var gameWon: Bool = false
  public var currentNode: SKNode?
  public var currentItemNode: ItemNode?
  
  public var luggage: LuggageNode!
  public var luggageHitBox: SKSpriteNode!
  public var inventory: InventoryNode!
  public var itemNodes: [ItemNode] = []
  
  var emptySlotPositionLeft: CGPoint = .init(x: 0, y: 0)
  
  override func didMove(to view: SKView) {
    // MARK: Enables gestures
    
    isUserInteractionEnabled = true
    
    // Add double tap gesture recognizer
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapGesture)
    
    // MARK: Background

    let backgroundNode = SKSpriteNode(imageNamed: Constants.BACKGROUND_IMAGE)
    backgroundNode.position = CGPoint(x: size.width / 2, y: size.height / 2)
    backgroundNode.zPosition = -1
    addChild(backgroundNode)
    
    // MARK: Node Placement
    
    self.luggage = LuggageNode(row: 3, column: 5,
                               position: CGPoint(x: frame.midX, y: frame.midY + 20))

    self.inventory = InventoryNode(position: CGPoint(x: frame.midX, y: frame.midY - 120))
    
    self.addChild(self.luggage)
    
    self.luggageHitBox = GameSceneFunctions.createLuggageHitBox(gameScene: self, luggage: self.luggage)
  
    self.addChild(self.luggageHitBox)
    self.addChild(self.inventory)
    GameSceneFunctions.initItemNodes(gameScene: self)
    
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
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = true
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        
        if self.currentItemNode?.isInsideLuggage(luggage: self.luggageHitBox) == false {
          self.currentItemNode?.inLuggage = false
          self.currentItemNode?.inInventory = true
          self.currentItemNode?.updateItemScale()
          self.currentItemNode?.updateItemPhysics()
          GameSceneFunctions.moveItemToInventorySlot(
            gameScene: self, item: self.currentItemNode ?? ItemNode())
        }
        
      } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        GameSceneFunctions.moveItemToInventorySlot(
          gameScene: self, item: self.currentItemNode ?? ItemNode())
        
      } else if let currentNode = currentNode {
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        GameSceneFunctions.moveItemToInventorySlot(
          gameScene: self, item: self.currentItemNode ?? ItemNode())
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
    
    GameSceneFunctions.handleCollision(gameScene: self)
    // check if game won
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      if !self.gameWon {
        GameSceneFunctions.checkWin(gameScene: self)
      }
    }
  }
}

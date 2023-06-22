//
//  GameScene.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 17/06/23.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
  private var currentNode: SKNode?
  private var currentItemNode: ItemNode?

  private var luggage: LuggageNode!
  private var inventory: LuggageNode!
  // nanti append semua itemNodes kesini
  private var itemNodes: [ItemNode] = []

  override func didMove(to view: SKView) {
    // MARK: Enables gestures

    isUserInteractionEnabled = true

    // Add double tap gesture recognizer
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapGesture)

    // MARK: Node Placement

    self.luggage = LuggageNode(row: 3, column: 8,
                               position: CGPoint(x: frame.midX, y: frame.midY))
    let item1 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: frame.midX, y: frame.midY))
    let item2 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: frame.midX + 100, y: frame.midY + 100))
    self.itemNodes.append(item1)
    self.itemNodes.append(item2)

    self.addChild(self.luggage)
    self.addChild(item1)
    self.addChild(item2)
  }

  @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
    // Get the location of the double tap gesture
    let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)

    // Convert the touch location to the scene's coordinate system
    let convertedLocation = convertPoint(fromView: touchLocation)

    // MARK: Rotate Node

    if let tappedNode = atPoint(convertedLocation) as? SKSpriteNode {
      // Rotate the node by 90 degrees
      let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
      tappedNode.run(rotateAction)
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
        }
      }

      // MARK: check if item is inside of luggage or not

      let touchLocation = touch.location(in: self)

      if self.luggage.contains(touchLocation) {
        print("node is inside")
      } else {
        print("node is outside")
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = self.currentNode {
      let touchLocation = touch.location(in: self)
      node.position = touchLocation

      if self.luggage.contains(node.position) {
        print("You are MOVING ITEM INSIDE THE LUGGAGE!")
        if self.currentItemNode?.inInventory == true {
          // scale up the item back to actual size
          let scaleAction = SKAction.scale(by: 2, duration: 0.2)
          self.currentItemNode?.run(scaleAction)
          // set inInventory to false
          self.currentItemNode?.inInventory = false
        }
      } else {}
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // MARK: check if item is inside of luggage or not

    for touch in touches {
      _ = touch.location(in: self)

      // check if item node is in luggagenode
      if let currentNode = currentNode, luggage.contains(currentNode.position) {
        print("item was released INSIDE the luggage.")
        // set inLuggage to true
        self.currentItemNode?.inLuggage = true

        // buat jaga" aja kalo pas moving g ke detect!
        if self.currentItemNode?.inInventory == true {
          let scaleAction = SKAction.scale(by: 2, duration: 0.2)
          self.currentItemNode?.run(scaleAction)
          self.currentItemNode?.inInventory = false
        }

      } else {
        print("item  was released OUTSIDE the luggage.")

        // MARK: Pseudo for putting item in inventory

        // 0. Get the Current ItemNode ✅ --> done by using currentItemNode
        // 1. Set item.inLuggage to false✅
        self.currentItemNode?.inLuggage = false

        // 2. Scale down item Size by 0.5✅
        if self.currentItemNode?.inInventory == false {
          let scaleAction = SKAction.scale(by: 0.5, duration: 0.2)
          self.currentItemNode?.run(scaleAction)
          // 3. Set item.inInventory to true✅
          self.currentItemNode?.inInventory = true
          // 4. Change Item position to one of the empty inventory slot 📝
        }

        // Set all current Node to nil
        self.currentNode = nil
        self.currentItemNode = nil
      }

      // Remove the small node from the scene
//      smallNode?.removeFromParent()
//      self.smallNode = nil
      self.currentNode = nil
    }
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.currentNode = nil
  }
}

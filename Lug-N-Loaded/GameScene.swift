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

  override func didMove(to view: SKView) {
    // MARK: Enables gestures

    isUserInteractionEnabled = true

    // Add double tap gesture recognizer
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapGesture)

    // MARK: Node Placement

    let luggage = LuggageNode(row: 3, column: 8,
                              position: CGPoint(x: frame.midX, y: frame.midY))
    let item1 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: frame.midX, y: frame.midY))
    let item2 = ItemNode(imageName: "camera", itemShape: "t_reversed",
                         position: CGPoint(x: frame.midX + 100, y: frame.midY + 100))

    item1.name = "draggable"
    item2.name = "draggable"
    self.addChild(luggage)
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

    // MARK: For scaling up/down node

//    // Check if a node was double-tapped
//    if let tappedNode = atPoint(convertedLocation) as? SKSpriteNode {
//      // Scale up the node by 1.5 times
//      let scaleAction = SKAction.scale(by: 1.5, duration: 0.2)
//      tappedNode.run(scaleAction)
//    }
  }

  // MARK: For Drag n Drop Functionality

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first {
      let location = touch.location(in: self)

      let touchedNodes = self.nodes(at: location)
      for node in touchedNodes.reversed() {
        if node.name == "draggable" {
          self.currentNode = node
        }
      }
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let touch = touches.first, let node = self.currentNode {
      let touchLocation = touch.location(in: self)
      node.position = touchLocation
    }
  }

  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.currentNode = nil
  }

  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.currentNode = nil
  }
}

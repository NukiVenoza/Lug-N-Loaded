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
    let luggage = LuggageEntity(row: 3, column: 8, position: CGPoint(x: frame.midX, y: frame.midY))

    let item = ItemEntity(name: "preset1", position: CGPoint(x: frame.midX-50, y: frame.midY-50))
    let item2 = ItemEntity(name: "preset3", position: CGPoint(x: frame.midX, y: frame.midY))

    item.itemVisualComponent.itemNode.name = "draggable"
    item2.itemVisualComponent.itemNode.name = "draggable"

    self.addChild(luggage.luggageVisualComponent.luggageNode)
    self.addChild(item.itemVisualComponent.itemNode)
    self.addChild(item2.itemVisualComponent.itemNode)
  }

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

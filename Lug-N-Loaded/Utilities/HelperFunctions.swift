//
//  NodeBuilder.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 20/06/23.
//

import Foundation
import SpriteKit

// STICKING FUNCTIONS:
public func stickNodeToLeft(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x - toNode.frame.size.width / 2 - nodeToStick.frame.size.width / 2 - margin
  let yPosition = toNode.position.y

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

public func stickNodeToTop(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x
  let yPosition = toNode.position.y + toNode.frame.size.height / 2 + nodeToStick.frame.size.height / 2 + margin

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

public func stickNodeToRight(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x + toNode.frame.size.width / 2 + nodeToStick.frame.size.width / 2 + margin
  let yPosition = toNode.position.y

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

public func stickNodeToBottom(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x
  let yPosition = toNode.position.y - toNode.frame.size.height / 2 - nodeToStick.frame.size.height / 2 - margin

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

func SKNodeToItemNode(node: SKNode) -> ItemNode? {
  let currSKSpriteNode = (node as? SKSpriteNode)
  let currItemNode = (currSKSpriteNode as? ItemNode)
  return currItemNode
}

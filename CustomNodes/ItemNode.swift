//
//  ItemNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit
import GameplayKit

class ItemNode: SKNode {
  override init() {
    // ITEM CREATION
    let parentNode = SquareNode(color: .green, image: "")
    let childNode1 = SquareNode(color: .red, image: "")

    super.init()

    addChild(parentNode)

    stickNodeToLeft(nodeToStick: childNode1, toNode: parentNode)
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// STICKING FUNCTIONS:

func stickNodeToLeft(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x - toNode.frame.size.width / 2 - nodeToStick.frame.size.width / 2 - margin
  let yPosition = toNode.position.y

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

func stickNodeToTop(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x
  let yPosition = toNode.position.y + toNode.frame.size.height / 2 + nodeToStick.frame.size.height / 2 + margin

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

func stickNodeToRight(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x + toNode.frame.size.width / 2 + nodeToStick.frame.size.width / 2 + margin
  let yPosition = toNode.position.y

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}

func stickNodeToBottom(nodeToStick: SKNode, toNode: SKNode, margin: CGFloat = 0) {
  guard let parentNode = toNode.parent else {
    return
  }

  let xPosition = toNode.position.x
  let yPosition = toNode.position.y - toNode.frame.size.height / 2 - nodeToStick.frame.size.height / 2 - margin

  nodeToStick.position = CGPoint(x: xPosition, y: yPosition)
  parentNode.addChild(nodeToStick)
}


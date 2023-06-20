//
//  ItemNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import GameplayKit
import SpriteKit

class ItemNode: SKNode {
  init(itemName: String) {
    // MARK: TEM CREATION

    super.init()

    if itemName == "preset1" {
      // T Shape
      let parentNode = SquareNode(image: "diamond_block")
      let leftNode = SquareNode(image: "diamond_block")
      let rightNode = SquareNode(image: "diamond_block")
      let bottomNode = SquareNode(image: "diamond_block")

      addChild(parentNode)

      stickNodeToLeft(nodeToStick: leftNode, toNode: parentNode)
      stickNodeToRight(nodeToStick: rightNode, toNode: parentNode)
      stickNodeToBottom(nodeToStick: bottomNode, toNode: parentNode)
    }

    else if itemName == "preset2" {
      // L Shape
      let parentNode = SquareNode(image: "diamond_block")
      let bottomNode1 = SquareNode(image: "diamond_block")
      let bottomNode2 = SquareNode(image: "diamond_block")
      let rightNode1 = SquareNode(image: "diamond_block")
      let rightNode2 = SquareNode(image: "diamond_block")

      addChild(parentNode)

      stickNodeToLeft(nodeToStick: bottomNode1, toNode: parentNode)
      stickNodeToRight(nodeToStick: bottomNode2, toNode: bottomNode1)
      stickNodeToBottom(nodeToStick: rightNode1, toNode: bottomNode2)
      stickNodeToBottom(nodeToStick: rightNode2, toNode: rightNode1)
    }

    else if itemName == "preset3" {
      // SQUARE
      let parentNode = SquareNode(image: "diamond_block")

      let right = SquareNode(image: "diamond_block")
      let bottomLeft = SquareNode(image: "diamond_block")
      let bottomRight = SquareNode(image: "diamond_block")

      addChild(parentNode)
      stickNodeToRight(nodeToStick: right, toNode: parentNode)
      stickNodeToBottom(nodeToStick: bottomLeft, toNode: parentNode)
      stickNodeToBottom(nodeToStick: bottomRight, toNode: right)
    }

    else if itemName == "preset4" {
      // Rectangle
      let parentNode = SquareNode(image: "diamond_block")
      parentNode.zPosition = 1
      let right = SquareNode(image: "diamond_block")

      addChild(parentNode)
      stickNodeToRight(nodeToStick: right, toNode: parentNode)
    }
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

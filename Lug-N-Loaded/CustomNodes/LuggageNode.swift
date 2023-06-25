//
//  LuggageNode.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 20/06/23.
//

import Foundation
import SpriteKit

import Foundation
import GameplayKit
import SpriteKit

class LuggageNode: SKNode {
  init(row: Int, column: Int, position: CGPoint) {
    super.init()

    let luggageWidth = Constants.SQUARESIZE * column - 1
    let luggageHeight = Constants.SQUARESIZE * row - 1

    var luggagePosition = position
    luggagePosition.x = position.x - CGFloat(luggageWidth / 2) + CGFloat(Constants.SQUARESIZE / 2)
    luggagePosition.y = position.y + CGFloat(luggageHeight / 2)
    zPosition = 2
    self.position = luggagePosition

    // To store the most left tile for each row
    var verticalTiles: [SquareNode] = []

    // Loop for creating grid
    for i in 1...row {
      let tile = SquareNode(image: Constants.LUGGAGE_IMAGENAME)

      if i == 1 {
        addChild(tile)
      } else if i > 1 {
//        print("sticking bottom node")
        stickNodeToBottom(nodeToStick: tile,
                          toNode: verticalTiles.last!)
      }
      verticalTiles.append(tile)

      // To store the most last inserted right tile
      var horizontalTiles: [SquareNode] = [tile]

      for _ in 1...column - 1 {
        let rightTile = SquareNode(image: Constants.LUGGAGE_IMAGENAME)
//        print("sticking right node")
        stickNodeToRight(nodeToStick: rightTile,
                         toNode: horizontalTiles.last ?? tile)
        horizontalTiles.append(rightTile)
      }
    }
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

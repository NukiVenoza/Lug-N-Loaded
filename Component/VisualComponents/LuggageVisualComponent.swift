//
//  LuggageVisualComponent.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 20/06/23.
//

import Foundation
import GameplayKit
import SpriteKit

class LuggageVisualComponent: GKComponent {
  let luggageNode: SKNode

  var position: CGPoint

  init(row: Int, column: Int, position: CGPoint) {
    self.position = position

    let luggageWidth = Constants.SQUARESIZE * column - 1
    let luggageHeight = Constants.SQUARESIZE * row - 1

    self.position.x = position.x - CGFloat(luggageWidth / 2) + CGFloat(Constants.SQUARESIZE / 2)
    self.position.y = position.y + CGFloat(luggageHeight / 2)

    luggageNode = LuggageNode(row: row, column: column)
    luggageNode.position = self.position

    super.init()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

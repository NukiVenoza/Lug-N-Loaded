//
//  LuggageEntity.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 20/06/23.
//

import GameplayKit
import SpriteKit

class LuggageEntity: GKEntity {
  let position: CGPoint
  var luggageVisualComponent: LuggageVisualComponent

  init(row: Int, column: Int, position: CGPoint) {
    self.position = position

    self.luggageVisualComponent = LuggageVisualComponent(row: row, column: column, position: position)

    super.init()

    addComponent(luggageVisualComponent)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

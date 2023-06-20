//
//  SquareNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit

class SquareNode: SKSpriteNode {
  init(image: String) {
    let size = CGSize(width: Constants.SQUARESIZE, height: Constants.SQUARESIZE)
    let texture = SKTexture(imageNamed: image)

    super.init(texture: texture, color: .blue, size: size)

    // Additional customizations if needed
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

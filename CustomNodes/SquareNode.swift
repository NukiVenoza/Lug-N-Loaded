//
//  SquareNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit

class SquareNode: SKSpriteNode {
  init(color: UIColor = .blue, image: String) {
    let size = CGSize(width: 50, height: 50)
    let texture = SKTexture(imageNamed: image)

    super.init(texture: texture, color: .white, size: size)

    // Additional customizations if needed
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

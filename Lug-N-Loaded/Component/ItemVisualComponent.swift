//
//  ItemVisualComponent.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import GameplayKit
import SpriteKit

class ItemVisualComponent: GKComponent {
  let itemNode: SKNode

  init(position: CGPoint) {
    itemNode = ItemNode()
    itemNode.position = position

    super.init()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

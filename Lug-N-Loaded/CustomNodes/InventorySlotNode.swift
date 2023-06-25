//
//  InventorySlotNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 22/06/23.
//

import Foundation
import SpriteKit

class InventorySlotNode: SKSpriteNode {
  var isFilled: Bool = false
  var index: Int = 0

  // TODO: bikin image name g perlu di passing

  init(index: Int) {
    let slotSize = CGSize(width: Constants.INVENTORY_SLOT, height: Constants.INVENTORY_SLOT)
    super.init(texture: nil, color: .white, size: slotSize)
    self.zPosition = 2
    self.index = index
    self.updateTexture()
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func updateTexture() {
    if self.isFilled {
      self.texture = SKTexture(imageNamed: Constants.INVENTORY_SLOT_IMAGENAME_FILLED)
    } else {
      self.texture = SKTexture(imageNamed: Constants.INVENTORY_SLOT_IMAGENAME)
    }
  }
}

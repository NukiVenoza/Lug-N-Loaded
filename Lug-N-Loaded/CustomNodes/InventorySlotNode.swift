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
    init(imageName: String, index: Int) {
        let slotSize = CGSize(width: Constants.INVENTORY_SLOT, height: Constants.INVENTORY_SLOT)
        super.init(texture: SKTexture(imageNamed: imageName), color: .white, size: slotSize)
        self.index = index

        
//        self.texture = SKTexture(imageNamed: imageName)
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
}

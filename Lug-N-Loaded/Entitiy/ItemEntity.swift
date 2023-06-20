//
//  ItemEntity.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import GameplayKit
import SpriteKit

class ItemEntity: GKEntity {
    let position: CGPoint
    var itemVisualComponent: ItemVisualComponent
    var movementComponenet: MovementComponent
    
    init(position: CGPoint) {
        self.position = position
        self.itemVisualComponent = ItemVisualComponent(position: position)
        self.movementComponenet = MovementComponent()
        super.init()
        
        addComponent(itemVisualComponent)
        addComponent(movementComponenet)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



//
//  MovementComponent.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit
import GameplayKit

class MovementComponent: GKComponent {
    var itemVisualComponent: ItemVisualComponent? {
        return entity?.component(ofType: ItemVisualComponent.self)
    }
    
    var isDraggingActive = false
    
    public func setupDrag(at point: CGPoint){
        //entities current node
        let nodes = self.itemVisualComponent?.itemNode.scene?.nodes(at: point)

//        if nodes?.first?.name == NodesName.mainCharacter{
        isDraggingActive = true
//        }
        if isDraggingActive {
            print("true")
        } else {
            print("false")
        }
    }

    public func move(to point: CGPoint){
        if isDraggingActive{
            itemVisualComponent?.itemNode.position = point
        }
    }
    
    public func stop(){
        isDraggingActive = false
    }
}

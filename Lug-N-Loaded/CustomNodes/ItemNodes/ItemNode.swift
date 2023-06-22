//
//  ItemNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit

class ItemNode: SKSpriteNode {
  var inLuggage: Bool = false
  var inInventory: Bool = false

  init(imageName: String, itemShape: String, position: CGPoint) {
    // Identify the image and shape of the node
    let textureShape = SKTexture(imageNamed: itemShape)
    let textureImage = SKTexture(imageNamed: imageName)
    let size = textureShape.size()

    super.init(texture: textureImage, color: .white, size: size)
    zPosition = 10
    self.position = position
    self.name = "item"

    // Give node collision and physics
    physicsBody = SKPhysicsBody(texture: textureShape, alphaThreshold: 0.5, size: size)
    physicsBody?.isDynamic = true
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = 0x1
    physicsBody?.collisionBitMask = 0xFFFFFFFF
    physicsBody?.contactTestBitMask = 0xFFFFFFFF
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

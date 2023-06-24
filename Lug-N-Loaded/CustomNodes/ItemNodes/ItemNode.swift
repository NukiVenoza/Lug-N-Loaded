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
  var inInventory: Bool = true

  init(imageName: String, itemShape: String, position: CGPoint) {
    // Identify the image and shape of the node
    let textureShape = SKTexture(imageNamed: itemShape)
    let textureImage = SKTexture(imageNamed: imageName)
    let size = textureShape.size()

    super.init(texture: textureImage, color: .white, size: size)
    zPosition = 10
    self.position = position
    self.name = "item"

    updateItemScale()

    // Give node collision and physics
    physicsBody = SKPhysicsBody(texture: textureShape, alphaThreshold: 0.5, size: size)
    physicsBody?.isDynamic = true
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = 0x1
    physicsBody?.collisionBitMask = 0xFFFFFFFF
    physicsBody?.contactTestBitMask = 0xFFFFFFFF
    physicsBody?.affectedByGravity = false
  }

  init() {
    let size = CGSize(width: 50, height: 50)
    super.init(texture: nil, color: .red, size: size)
  }

  public func updateItemScale() {
    if inInventory {
      let scaleAction = SKAction.scale(by: 0.5, duration: 0.2)
      run(scaleAction)
    } else {
      let scaleAction = SKAction.scale(by: 2, duration: 0.2)
      run(scaleAction)
    }
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

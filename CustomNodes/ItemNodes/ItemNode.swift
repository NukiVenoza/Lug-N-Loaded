//
//  ItemNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import GameplayKit
import SpriteKit

class ItemNode: SKSpriteNode {
  init(imageName: String, itemShape: String, position: CGPoint) {
    let textureShape = SKTexture(imageNamed: itemShape)
    let textureImage = SKTexture(imageNamed: imageName)
    let size = textureShape.size()

    super.init(texture: textureImage, color: .white, size: size)

    physicsBody = SKPhysicsBody(texture: textureShape, alphaThreshold: 0.5, size: size)
    physicsBody?.isDynamic = true
    physicsBody?.allowsRotation = false
    physicsBody?.categoryBitMask = 0x1
    physicsBody?.collisionBitMask = 0xFFFFFFFF
    physicsBody?.contactTestBitMask = 0xFFFFFFFF

    self.position = position
  }

  private var lastTapTime: TimeInterval = 0

  // MARK: Double tap to rotate

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else { return }
    let currentTime = touch.timestamp

    // Calculate the time difference between the current touch and the previous one
    let tapDuration = currentTime - lastTapTime

    // Check if it's a double-tap
    if tapDuration < 0.3 {
      // Rotate the node by 90 degrees
      let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.3)
      run(rotateAction)
    }

    lastTapTime = currentTime
  }

  @available(*, unavailable)
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

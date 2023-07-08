//
//  ItemNode.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 19/06/23.
//

import Foundation
import SpriteKit

class ItemNode: SKSpriteNode {
    var itemId: Int = 0
    var lastTouchedBy: String = ""
    var inLuggage: Bool = false
    var inInventory: Bool = true
    var isPlaced: Bool = true
    var currentScale: Double = Constants.ITEM_SCALE_BIG
    var currentRotation: Double = 0
    var hide: Bool = false

    // TODO: coba pakai isHidden, kalo g bekerja baru pakai hide

    init(id: Int, imageName: String, itemShape: String, position: CGPoint) {
        // Identify the image and shape of the node
        self.itemId = id
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
        updateItemPhysics()
        physicsBody?.allowsRotation = true
        physicsBody?.affectedByGravity = false
    }

    init() {
        let size = CGSize(width: 50, height: 50)
        super.init(texture: nil, color: .red, size: size)
    }

    public func updateItemScale() {
        if inInventory && currentScale == Constants.ITEM_SCALE_BIG {
            let scaleAction = SKAction.scale(by: Constants.ITEM_SCALE_SMALL, duration: 0.2)
            run(scaleAction)
            currentScale = Constants.ITEM_SCALE_SMALL
        }
        else if inLuggage && currentScale == Constants.ITEM_SCALE_SMALL {
            let scaleAction = SKAction.scale(by: Constants.ITEM_SCALE_BIG, duration: 0.2)
            run(scaleAction)
            currentScale = Constants.ITEM_SCALE_BIG
        }
        else if !inLuggage && !inInventory && currentScale == Constants.ITEM_SCALE_SMALL {
            let scaleAction = SKAction.scale(by: Constants.ITEM_SCALE_BIG, duration: 0.2)
            run(scaleAction)
            currentScale = Constants.ITEM_SCALE_BIG
        }
    }

    public func updateItemPhysics() {
        if inInventory || isPlaced == false {
            physicsBody?.isDynamic = false
            physicsBody?.categoryBitMask = 0
            physicsBody?.collisionBitMask = 0
            physicsBody?.contactTestBitMask = 0
            zPosition = zPosition + 1
        }
        else {
            physicsBody?.isDynamic = true
            physicsBody?.categoryBitMask = 0x1
            physicsBody?.collisionBitMask = 0xFFFFFFFF
            physicsBody?.contactTestBitMask = 0xFFFFFFFF
            zPosition = zPosition - 1
        }
    }

    public func unhideItem() {
        hide = false
        zPosition = 10
    }

    public func hideItem() {
        zPosition = -10
        position = CGPoint(x: 10000, y: 10000)
        hide = true
    }

    func isInsideLuggage(luggage: SKSpriteNode) -> Bool {
        let smallerNodeFrame = calculateAccumulatedFrame()
        let largerNodeFrame = luggage.calculateAccumulatedFrame()
        let isFullyContained = smallerNodeFrame.minX >= largerNodeFrame.minX &&
            smallerNodeFrame.maxX <= largerNodeFrame.maxX &&
            smallerNodeFrame.minY >= largerNodeFrame.minY &&
            smallerNodeFrame.maxY <= largerNodeFrame.maxY

        return isFullyContained
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

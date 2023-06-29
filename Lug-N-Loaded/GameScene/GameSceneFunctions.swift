//
//  GameSceneFunctions.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 25/06/23.
//

import Foundation
import SpriteKit

class GameSceneFunctions {
    public static func checkWin(gameScene: GameScene) {
        // loop over itemnode, check that all is not in inventory and is in luggage
        GameSceneFunctions.handleCollision(gameScene: gameScene)
        
        for itemNode in gameScene.itemNodes {
            if itemNode.isPlaced == false {
                return
            }
        }
        
        for itemNode in gameScene.itemNodes {
            if itemNode.inInventory {
                return
            }
        }
        
        for itemNode in gameScene.itemNodes {
            if itemNode.inLuggage == false {
                return
            }
        }
        
        // all ItemNodes are in LuggageNode therefore:
        print("YOU WIN!")
        gameScene.gameWon = true
    }
    
    public static func showTimesUpScreen(gameScene: GameScene) {
        print("KAMU KALAH WAKTU HABIS!")
        
        // Scaling animation
        let scaleAction = SKAction.sequence([
            SKAction.scale(to: 0.1, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.2)
        ])
        
        // Opacity animation
        let opacityAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.0, duration: 0.2),
            SKAction.fadeAlpha(to: 0.8, duration: 0.5)
        ])
        
        // Combined animation
        let combinedAction = SKAction.group([
            scaleAction,
            opacityAction
        ])
        
        let fullScreenNode = SKSpriteNode(color: .black, size: gameScene.size)
        fullScreenNode.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        fullScreenNode.alpha = 0.0 // Start with 0 opacity
        fullScreenNode.zPosition = 1000
        
        gameScene.addChild(fullScreenNode)
        fullScreenNode.run(combinedAction)
        
        let timesUpNode = SKSpriteNode(imageNamed: "times_up_text.png")
        
        let originalSize = timesUpNode.size
        let aspectRatio = originalSize.width / originalSize.height
        let desiredWidth: CGFloat = 120.0 // Specify your desired width
        let desiredHeight = desiredWidth / aspectRatio
        
        timesUpNode.size = CGSize(width: desiredWidth, height: desiredHeight)
        timesUpNode.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        timesUpNode.alpha = 0.0
        timesUpNode.zPosition = 1000
        gameScene.addChild(timesUpNode)
        timesUpNode.run(opacityAction)
    }
    
    public static func showWinScreen(gameScene: GameScene) {
        print("KAMU MENANG HEBAT MANTEP!")
        
        // Scaling animation
        let scaleAction = SKAction.sequence([
            SKAction.scale(to: 0.1, duration: 0.2),
            SKAction.scale(to: 1.0, duration: 0.2)
        ])
        
        // Opacity animation
        let opacityAction = SKAction.sequence([
            SKAction.fadeAlpha(to: 0.0, duration: 0.2),
            SKAction.fadeAlpha(to: 0.8, duration: 0.5)
        ])
        
        // Combined animation
        let combinedAction = SKAction.group([
            scaleAction,
            opacityAction
        ])
        
        let fullScreenNode = SKSpriteNode(color: .black, size: gameScene.size)
        fullScreenNode.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        fullScreenNode.alpha = 0.0 // Start with 0 opacity
        fullScreenNode.zPosition = 1000
        
        gameScene.addChild(fullScreenNode)
        fullScreenNode.run(combinedAction)
        
        let missionSuccessNode = SKSpriteNode(imageNamed: "mission_success_Text")
        
        let originalSize = missionSuccessNode.size
        let aspectRatio = originalSize.width / originalSize.height
        let desiredWidth: CGFloat = 200.0 // Specify your desired width
        let desiredHeight = desiredWidth / aspectRatio
        
        missionSuccessNode.size = CGSize(width: desiredWidth, height: desiredHeight)
        missionSuccessNode.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2)
        missionSuccessNode.alpha = 0.0
        missionSuccessNode.zPosition = 1000
        gameScene.addChild(missionSuccessNode)
        missionSuccessNode.run(opacityAction)
    }
    
    public static func handleCollision(gameScene: GameScene) {
        for itemNode in gameScene.itemNodes {
            if gameScene.luggage.contains(itemNode.position) {
                if itemNode.inInventory {
                    itemNode.inLuggage = true
                    itemNode.inInventory = false
                    itemNode.updateItemScale()
                }
                if itemNode.isInsideLuggage(luggage: gameScene.luggageHitBox) == false, itemNode.isPlaced {
                    itemNode.inLuggage = false
                    itemNode.inInventory = true
                    itemNode.updateItemScale()
                    self.moveItemToInventorySlot(
                        gameScene: gameScene, item: itemNode)
                }
            } else {
                if itemNode.inLuggage {
                    itemNode.inLuggage = false
                    self.moveItemToInventorySlot(gameScene: gameScene, item: itemNode)
                    itemNode.updateItemScale()
                }
            }
        }
    }
    
    public static func updateInventorySlotStatus(gameScene: GameScene) {
        for inventorySlot in gameScene.inventory.inventorySlots {
            var isSlotFilled = false
            
            for itemNode in gameScene.itemNodes {
                if inventorySlot.intersects(itemNode) {
                    isSlotFilled = true
                    break
                }
            }
            
            inventorySlot.isFilled = isSlotFilled
            inventorySlot.updateTexture()
        }
    }
    
    public static func findEmptySlot(gameScene: GameScene) -> InventorySlotNode? {
        for inventorySlot in gameScene.inventory.inventorySlots {
            if !inventorySlot.isFilled {
                return inventorySlot
            }
        }
        return nil
    }
    
    public static func moveItemToInventorySlot(gameScene: GameScene, item: ItemNode) {
        self.updateInventorySlotStatus(gameScene: gameScene)
        
        if let slot = self.findEmptySlot(gameScene: gameScene) {
            var finalSlotPosition = slot.convert(slot.position, to: gameScene)
            finalSlotPosition.y = finalSlotPosition.y - 5
            
            if slot == gameScene.inventory.inventorySlots[0] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_1
                gameScene.emptySlotPositionLeft = finalSlotPosition
                
            } else if slot == gameScene.inventory.inventorySlots[1] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_2
                
            } else if slot == gameScene.inventory.inventorySlots[2] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_3
                
            } else if slot == gameScene.inventory.inventorySlots[3] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_4
                
            } else if slot == gameScene.inventory.inventorySlots[4] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_5
                
            } else if slot == gameScene.inventory.inventorySlots[5] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_6
                
            } else if slot == gameScene.inventory.inventorySlots[6] {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_7
                
            } else {
                finalSlotPosition.x = Constants.INVENTORY_SLOT_POSITION_8
            }
            
            // move item to finalSlotPosition
            item.position = finalSlotPosition
            item.inInventory = true
            item.inLuggage = false
            slot.isFilled = true
            
            slot.updateTexture()
        }
    }
    
    public static func getSlotPosition(
        gameScene: GameScene,
        slotIndex: Int) -> CGPoint
    {
        var finalPoint = gameScene.inventory.inventorySlots[0].convert(gameScene.inventory.inventorySlots[0].position, to: gameScene)
        finalPoint.y = finalPoint.y - 5
        
        if slotIndex == 0 {
            finalPoint.x = finalPoint.x + Constants.INVENTORY_SLOP_GAP_FIRST
            gameScene.emptySlotPositionLeft = finalPoint
            
        } else if slotIndex == 1 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_2
            
        } else if slotIndex == 2 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_3
            
        } else if slotIndex == 3 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_4
            
        } else if slotIndex == 4 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_5
            
        } else if slotIndex == 5 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_6
            
        } else if slotIndex == 6 {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_7
            
        } else {
            finalPoint.x = Constants.INVENTORY_SLOT_POSITION_8
        }
        
        return finalPoint
    }
    
    public static func createLuggageHitBox(gameScene: GameScene, luggage: LuggageNode, isTutorial: Bool = false) -> SKSpriteNode {
        let luggageHitBox = SKSpriteNode(color: .gray, size: luggage.calculateAccumulatedFrame().size)
        luggageHitBox.position = CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY + 20)
        luggageHitBox.zPosition = 1
        
        if isTutorial {
            luggageHitBox.texture = SKTexture(imageNamed: Constants.LUGGAGE_BACKGROUND_TUTORIAL)
            luggageHitBox.position = CGPoint(x: gameScene.frame.midX - 3, y: gameScene.frame.midY + 38)
        } else {
            luggageHitBox.texture = SKTexture(imageNamed: Constants.LUGGAGE_BACKGROUND_IMAGENAME)
        }
        
        luggageHitBox.size.height = luggageHitBox.size.height + 34
        luggageHitBox.size.width = luggageHitBox.size.width + 32
        
        luggageHitBox.position.x = luggageHitBox.position.x + 1.0
        luggageHitBox.position.y = luggageHitBox.position.y - 0.5
        
        return luggageHitBox
    }
    
    public static func initTutorial(gameScene: GameScene) {
        gameScene.duration = 999
        
        // Init Background:
        
        let backgroundImage = SKSpriteNode(imageNamed: "background_tutorial") // MARK: Change Background Image Here
        
        backgroundImage.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 30)
        let scaleX = gameScene.size.width / backgroundImage.size.width
        let scaleY = gameScene.size.height / backgroundImage.size.height
        let scale = max(scaleX, scaleY)
        backgroundImage.zPosition = -100
        backgroundImage.setScale(scale * 0.96)
        gameScene.addChild(backgroundImage)
        
        // Init Luggage:
        
        gameScene.luggage = LuggageNode(row: 3, column: 3,
                                        position: CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY - 10)) // MARK: Change Background Image Here
        
        gameScene.addChild(gameScene.luggage)
        gameScene.luggageHitBox = self.createLuggageHitBox(gameScene: gameScene, luggage: gameScene.luggage, isTutorial: true)
        gameScene.luggageHitBox.position.y = gameScene.luggageHitBox.position.y - 28
        gameScene.addChild(gameScene.luggageHitBox)
        
        // Init Items:
        let item1 = ItemNode(imageName: "camera", itemShape: "shape_t_upsidedown",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 0))
        let item2 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 1))
        let item3 = ItemNode(imageName: "router", itemShape: "l_right",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 2))
        
        gameScene.itemNodes.append(item1)
        gameScene.itemNodes.append(item2)
        gameScene.itemNodes.append(item3)
        
        for itemNode in gameScene.itemNodes {
            gameScene.addChild(itemNode)
        }
    }
    
    public static func initLevel1(gameScene: GameScene) {
        // Init Background:
        gameScene.duration = 61
        let backgroundImage = SKSpriteNode(imageNamed: "background_level1") // MARK: Change Background Image Here
        
        backgroundImage.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 25)
        let scaleX = gameScene.size.width / backgroundImage.size.width
        let scaleY = gameScene.size.height / backgroundImage.size.height
        let scale = max(scaleX, scaleY)
        backgroundImage.zPosition = -100
        backgroundImage.setScale(scale * 0.95)
        gameScene.addChild(backgroundImage)
        
        // Init Highlight:
        
        let highlightImage = SKSpriteNode(imageNamed: "background_highlight")
        
        let initialPosition = CGPoint(x: gameScene.size.width / 2 - 80, y: gameScene.size.height / 2 + 20)
        
        highlightImage.position = initialPosition
        let scaleXHighlight = gameScene.size.width / highlightImage.size.width
        let scaleYHighlight = gameScene.size.height / highlightImage.size.height
        let scaleHighlight = max(scaleXHighlight, scaleYHighlight)
        highlightImage.zPosition = 10
        highlightImage.setScale(scaleHighlight * 0.3)
        gameScene.addChild(highlightImage)
        
        // Define the destination position where you want the sprite to move
        let destination1 = CGPoint(x: gameScene.size.width / 2 - 50, y: gameScene.size.height / 2 + 50)
        let destination2 = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 + 20)
        
        let destination3 = CGPoint(x: gameScene.size.width / 2 + 50, y: gameScene.size.height / 2 - 10)
        let destination4 = CGPoint(x: gameScene.size.width / 2 + 80, y: gameScene.size.height / 2 + 20)
        let destination5 = CGPoint(x: gameScene.size.width / 2 + 50, y: gameScene.size.height / 2 + 50)
        
        let destination6 = CGPoint(x: gameScene.size.width / 2 - 50, y: gameScene.size.height / 2 - 10)
        
        // Define the duration for the movement
        let duration: TimeInterval = 1.0
        
        // Create the move action
        let highlightAction = SKAction.sequence([
            SKAction.move(to: destination1, duration: duration),
            SKAction.move(to: destination2, duration: 1.2),
            SKAction.move(to: destination3, duration: 1.2),
            SKAction.move(to: destination4, duration: duration),
            SKAction.move(to: destination5, duration: duration),
            SKAction.move(to: destination2, duration: 1.2),
            SKAction.move(to: destination6, duration: 1.2),
            SKAction.move(to: initialPosition, duration: duration)
            
        ])
        
        // loop animation
        let repeatAction = SKAction.repeatForever(highlightAction)
        
        // Run the move action on the sprite
        highlightImage.run(repeatAction)
        
        // Init Luggage:
        
        gameScene.luggage = LuggageNode(row: 3, column: 7,
                                        position: CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)) // MARK: Change Background Image Here
        
        gameScene.addChild(gameScene.luggage)
        gameScene.luggageHitBox = self.createLuggageHitBox(gameScene: gameScene, luggage: gameScene.luggage)
        gameScene.addChild(gameScene.luggageHitBox)
        
        // Init Items:
        let item1 = ItemNode(imageName: "camera", itemShape: "shape_t_upsidedown",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 0))
        let item2 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 1))
        let item3 = ItemNode(imageName: "router", itemShape: "l_right",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 2))
        let item4 = ItemNode(imageName: "CCTV", itemShape: "shape_s",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 3))
        let item5 = ItemNode(imageName: "lamp", itemShape: "rect_vertical_4",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 4))
        let item6 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 5))
        let item7 = ItemNode(imageName: "bottle", itemShape: "rect_vertical_2",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 6))
        
        gameScene.itemNodes.append(item1)
        gameScene.itemNodes.append(item2)
        gameScene.itemNodes.append(item3)
        gameScene.itemNodes.append(item4)
        gameScene.itemNodes.append(item5)
        gameScene.itemNodes.append(item6)
        gameScene.itemNodes.append(item7)
        
        for itemNode in gameScene.itemNodes {
            gameScene.addChild(itemNode)
        }
    }
    
    public static func initLevel2(gameScene: GameScene) {
        gameScene.duration = 91
        
        // Init Background:
        
        let backgroundImage = SKSpriteNode(imageNamed: "background_level2") // MARK: Change Background Image Here
        
        backgroundImage.position = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 - 25)
        let scaleX = gameScene.size.width / backgroundImage.size.width
        let scaleY = gameScene.size.height / backgroundImage.size.height
        let scale = max(scaleX, scaleY)
        backgroundImage.zPosition = -100
        backgroundImage.setScale(scale * 0.95)
        gameScene.addChild(backgroundImage)
        
        // Init Highlight:
        
        let highlightImage = SKSpriteNode(imageNamed: "background_highlight")
        
        let initialPosition = CGPoint(x: gameScene.size.width / 2 - 80, y: gameScene.size.height / 2 + 25)
        
        highlightImage.position = initialPosition
        let scaleXHighlight = gameScene.size.width / highlightImage.size.width
        let scaleYHighlight = gameScene.size.height / highlightImage.size.height
        let scaleHighlight = max(scaleXHighlight, scaleYHighlight)
        highlightImage.zPosition = 10
        highlightImage.setScale(scaleHighlight * 0.3)
        gameScene.addChild(highlightImage)
        
        // Define the destination position where you want the sprite to move
        let destination1 = CGPoint(x: gameScene.size.width / 2 - 50, y: gameScene.size.height / 2 + 50)
        let destination2 = CGPoint(x: gameScene.size.width / 2, y: gameScene.size.height / 2 + 20)
        
        let destination3 = CGPoint(x: gameScene.size.width / 2 + 50, y: gameScene.size.height / 2 - 10)
        let destination4 = CGPoint(x: gameScene.size.width / 2 + 80, y: gameScene.size.height / 2 + 20)
        let destination5 = CGPoint(x: gameScene.size.width / 2 + 50, y: gameScene.size.height / 2 + 50)
        
        let destination6 = CGPoint(x: gameScene.size.width / 2 - 50, y: gameScene.size.height / 2 - 10)
        
        // Define the duration for the movement
        let duration: TimeInterval = 1.0
        
        // Create the move action
        let highlightAction = SKAction.sequence([
            SKAction.move(to: destination1, duration: duration),
            SKAction.move(to: destination2, duration: 1.2),
            SKAction.move(to: destination3, duration: 1.2),
            SKAction.move(to: destination4, duration: duration),
            SKAction.move(to: destination5, duration: duration),
            SKAction.move(to: destination2, duration: 1.2),
            SKAction.move(to: destination6, duration: 1.2),
            SKAction.move(to: initialPosition, duration: duration)
            
        ])
        
        // loop animation
        let repeatAction = SKAction.repeatForever(highlightAction)
        
        // Run the move action on the sprite
        highlightImage.run(repeatAction)
        
        // Init Luggage:
        
        gameScene.luggage = LuggageNode(row: 4, column: 8,
                                        position: CGPoint(x: gameScene.frame.midX, y: gameScene.frame.midY)) // MARK: Change Background Image Here
        
        gameScene.addChild(gameScene.luggage)
        gameScene.luggageHitBox = self.createLuggageHitBox(gameScene: gameScene, luggage: gameScene.luggage)
        gameScene.addChild(gameScene.luggageHitBox)
        
        // Init Items:
        let item1 = ItemNode(imageName: "controller", itemShape: "l_right",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 0))
        let item2 = ItemNode(imageName: "battery", itemShape: "l_right_long",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 1))
        let item3 = ItemNode(imageName: "pistols", itemShape: "shape_s",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 2))
        let item4 = ItemNode(imageName: "scope", itemShape: "rect_horizontal_4",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 3))
        let item5 = ItemNode(imageName: "handycam", itemShape: "shape_t_right",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 4))
        let item6 = ItemNode(imageName: "drive", itemShape: "rect_vertical_2",
                             position: getSlotPosition(gameScene: gameScene, slotIndex: 5))
        
        gameScene.itemNodes.append(item1)
        gameScene.itemNodes.append(item2)
        gameScene.itemNodes.append(item3)
        gameScene.itemNodes.append(item4)
        gameScene.itemNodes.append(item5)
        gameScene.itemNodes.append(item6)
        
        for itemNode in gameScene.itemNodes {
            gameScene.addChild(itemNode)
        }
    }
}

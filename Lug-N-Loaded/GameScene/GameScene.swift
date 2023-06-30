//
//  GameScene.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 17/06/23.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
    var matchManager = MatchManager.shared
    var level: Int
    
    public var isPlayer1 = false
    public var isPlayer2 = false
    public var scenePlayerId: String = ""

    init(level: Int) {
        self.level = level
        super.init(size: UIScreen.main.bounds.size)
        
        // MARK: Code for MatchMaker (MUTLIPLAYER)

        // check which player is current player
        self.scenePlayerId = self.matchManager.currentPlayer

        if self.matchManager.player1 == self.matchManager.currentPlayer {
            self.isPlayer1 = true
        } else if self.matchManager.player2 == self.matchManager.currentPlayer {
            self.isPlayer2 = true
        }
    }
  
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    public var gameWon: Bool = false
    public var currentNode: SKNode?
    public var currentItemNode: ItemNode?
  
    public var luggage: LuggageNode!
    public var luggageHitBox: SKSpriteNode!
    public var inventory: InventoryNode!
    public var itemNodes: [ItemNode] = []
  
    var emptySlotPositionLeft: CGPoint = .init(x: 0, y: 0)
    
    // TIMER & AUDIO VARIABLES
    let timer = CountdownLabel()
    let obsTimer = CountdownLabel()
    var timerProgressBar: SKShapeNode!
    var progressBarBackground: SKShapeNode!
    
    var obstructionNode: ObstructionNode!
    var duration: TimeInterval = 61 // reality -1
    let obsDuration: TimeInterval = 13 // reality -3
    
    var isShowingObstruction = false
    var hasShownObstruction = false
    var plusMinus: SKLabelNode!
    var isGameFinished: Bool = false
    
    // SOUND MP3
    var backgroundMusic: String!
    var obstructionAlarm: String = "OBSTRUCTION.mp3"
    var winMusic: String = "GameWin.mp3"
    var loseMusic: String = "GameLose.mp3"
    
    // OBSTRUCTION CODE
    var correctCode: String!
    
    var gameInitialized = false
  
    override func didMove(to view: SKView) {
        
        if self.gameInitialized == false {
            self.matchManager.scene = self
            self.gameInitialized = true
        }
        
        
        isUserInteractionEnabled = true

        // Add double tap gesture recognizer
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        view.addGestureRecognizer(doubleTapGesture)
    
        self.inventory = InventoryNode(position: CGPoint(x: frame.midX, y: frame.midY - 150))
        self.addChild(self.inventory)
    
        // Init Game Background, Luggage, Items:
        switch self.level {
        case 0:
            self.correctCode = "1111"
            self.backgroundMusic = "Tutorial.mp3"
            GameSceneFunctions.initTutorial(gameScene: self)

        case 1:
            self.correctCode = "3214"
            self.backgroundMusic = "Level1.mp3"
            GameSceneFunctions.initLevel1(gameScene: self)

        case 2:
            self.correctCode = "3214"
            self.backgroundMusic = "Level2.mp3"
            GameSceneFunctions.initLevel2(gameScene: self)

        default:
            self.correctCode = "3214"
            self.backgroundMusic = "Level1.mp3"
            GameSceneFunctions.initTutorial(gameScene: self)
        }
        // TIMER & AUDIO SECTION
        self.setupTimerAudio()
    }
  
    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
        let convertedLocation = convertPoint(fromView: touchLocation)
    
        // MARK: Rotate Node
    
        if let tappedNode = atPoint(convertedLocation) as? SKSpriteNode {
            // Rotate the node by 90 degrees
            if tappedNode.name == "item" {
                // Rotate the node by 90 degrees
                print("mencoba merotate item")
                let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
                let currItemNode = SKSpriteNodeToItemNode(node: tappedNode)
                currItemNode?.currentRotation = (currItemNode?.currentRotation ?? 0) + .pi / 2
            }
        }
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // MARK: For Drag n Drop Functionality
    
        if let touch = touches.first {
            let location = touch.location(in: self)
      
            let touchedNodes = self.nodes(at: location)
            for node in touchedNodes.reversed() {
                if node.name == "item" {
                    self.currentNode = node
          
                    self.currentItemNode = SKNodeToItemNode(node: self.currentNode!)
                    self.currentItemNode?.isPlaced = false
          
                    if let currentNode = currentNode, luggage.contains(currentNode.position) {
                        self.currentItemNode?.isPlaced = true
                        self.currentItemNode?.updateItemPhysics()
            
                    } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
                        self.currentItemNode?.updateItemPhysics()
                    }
                }
            }
        }
    }
  
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let node = self.currentNode {
            let touchLocation = touch.location(in: self)
            node.position = touchLocation
      
            self.currentItemNode?.isPlaced = false
            self.currentItemNode?.updateItemPhysics()

            if self.luggage.contains(node.position) {
                // Di Dalem LUGGAGE
                self.currentItemNode?.inLuggage = true
                self.currentItemNode?.inInventory = false
                self.currentItemNode?.updateItemScale()
        
            } else if self.inventory.contains(node.position) {
                // Di Dalem INVENTORY
                self.currentItemNode?.inLuggage = false
                self.currentItemNode?.inInventory = true
                self.currentItemNode?.updateItemScale()
            } else {
                // Di Luar
                self.currentItemNode?.inLuggage = false
                self.currentItemNode?.inInventory = false
                self.currentItemNode?.updateItemScale()
            }
        }
    }
  
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            _ = touch.location(in: self)
      
            // check if item node is in luggagenode
            self.currentItemNode?.isPlaced = true
            
            if let itemNode = currentItemNode {
                GameSceneFunctions.prepareImpact(gameScene: self, item: itemNode, newLocation: touch.location(in: self))
                
                // Send Data to Other Player:
                self.matchManager.sendItemData(item: itemNode, player: self.scenePlayerId)
            }
            
//            if let currentNode = currentNode, luggage.contains(currentNode.position) {
//                GameSceneFunctions.updateInventorySlotStatus(gameScene: self)
//                // Dalem Luggage
//                self.currentItemNode?.inLuggage = true
//                self.currentItemNode?.inInventory = false
//                self.currentItemNode?.updateItemScale()
//                self.currentItemNode?.updateItemPhysics()
//
//                if self.currentItemNode?.isInsideLuggage(luggage: self.luggageHitBox) == false {
//                    // Di Luar Hitbox Lugguage
//                    self.currentItemNode?.inLuggage = false
//                    self.currentItemNode?.inInventory = true
//                    self.currentItemNode?.updateItemScale()
//                    self.currentItemNode?.updateItemPhysics()
//                    GameSceneFunctions.moveItemToInventorySlot(
//                        gameScene: self, item: self.currentItemNode ?? ItemNode())
//                }
//
//            } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
//                GameSceneFunctions.updateInventorySlotStatus(gameScene: self)
//                // Dalem Inventory
//                self.currentItemNode?.inLuggage = false
//                self.currentItemNode?.inInventory = true
//                self.currentItemNode?.updateItemScale()
//                self.currentItemNode?.updateItemPhysics()
//                GameSceneFunctions.moveItemToInventorySlot(
//                    gameScene: self, item: self.currentItemNode ?? ItemNode())
//
//            } else if let currentNode = currentNode {
//                GameSceneFunctions.updateInventorySlotStatus(gameScene: self)
//                // Di Luar!
//                self.currentItemNode?.inLuggage = false
//                self.currentItemNode?.inInventory = false
//                self.currentItemNode?.inInventory = true
//                self.currentItemNode?.updateItemScale()
//                self.currentItemNode?.updateItemPhysics()
//                GameSceneFunctions.moveItemToInventorySlot(
//                    gameScene: self, item: self.currentItemNode ?? ItemNode())
//            }

            self.currentNode = nil
            self.currentItemNode = nil
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.currentNode = nil
        self.currentItemNode = nil
    }
  
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
    
        GameSceneFunctions.handleCollision(gameScene: self)
        // check if game won
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if !self.gameWon {
                GameSceneFunctions.checkWin(gameScene: self)
                if self.gameWon {
                    self.isGameFinished = true
                    GameSceneFunctions.showWinScreen(gameScene: self)
                    AudioManager.shared.playWinMusic(filename: self.winMusic)
                }
            }
        }
    
        // show game win screen

        // TIMER & AUDIO SECTION
      
        if !self.isGameFinished {
            self.timer.update()
            self.decreaseTimeBar()
        }
   
        if self.timer.text == "30" && !self.isShowingObstruction && !self.hasShownObstruction {
            print("SHOW")
            self.showObstruction()
            if self.obstructionNode.player == "Player2" {
                self.obsTimer.alpha = 1
                self.obsTimer.zPosition = 5000
            }
            AudioManager.shared.playObstructionMusic(filename: self.obstructionAlarm)
            AudioManager.shared.pauseBackgroundMusic()
        }
      
//    if self.timer.text == "10" {
//      AudioManager.shared.stopBackgroundMusic()
//      AudioManager.shared.playRushMusic(filename: "COUNTDOWN")
//    }
      
        if self.isShowingObstruction {
            self.obsTimer.update()
            if self.obstructionNode.inputText.count == 4 && self.obstructionNode.isCorrect {
                self.hideObstruction()
                AudioManager.shared.stopObstructionMusic()
                AudioManager.shared.resumeBackgroundMusic()
            }
        }
      
        if self.obsTimer.hasFinished() && self.isShowingObstruction {
            self.hideObstruction()
            AudioManager.shared.stopObstructionMusic()
            AudioManager.shared.resumeBackgroundMusic()
        }
      
        if self.timer.hasFinished() && !self.isGameFinished {
            self.isGameFinished = true
            GameSceneFunctions.showTimesUpScreen(gameScene: self)
            AudioManager.shared.stopBackgroundMusic()
            AudioManager.shared.playLoseMusic(filename: self.loseMusic)
        }
    }
    
    func showObstruction() {
        self.timer.pause()
        self.obsTimer.resume()
        
        if isPlayer1 {
            self.obstructionNode = ObstructionNode(player: "Player1", size: size, parentView: view!, correctCode: self.correctCode)
        } else {
            self.obstructionNode = ObstructionNode(player: "Player2", size: size, parentView: view!, correctCode: self.correctCode)
        } 
        self.obstructionNode.position = CGPoint(x: frame.midX, y: frame.midY)
        self.obstructionNode.zPosition = 1999
//        self.obstructionNode.isUserInteractionEnabled = true
        addChild(self.obstructionNode)
        
        self.isShowingObstruction = true
    }
    
    func hideObstruction() {
        self.isShowingObstruction = false
        let isCorrect = self.obstructionNode.removeTextField()
        print(isCorrect)
        if isCorrect {
            self.timer.addTime(amount: 6)
            self.timer.update()
            self.plusMinus.fontColor = UIColor(named: "Blue")
            self.plusMinus.alpha = 1
        } else {
            self.timer.addTime(amount: -5)
            self.timer.update()
            self.plusMinus.fontColor = .red
            self.plusMinus.text = "-5"
            self.plusMinus.alpha = 1
        }
        let fadeOutAction = SKAction.fadeOut(withDuration: 0.7)
        let waitAction = SKAction.wait(forDuration: 1)
        let hideAction = SKAction.run { [weak self] in
            self?.plusMinus.alpha = 0
        }
        let sequenceAction = SKAction.sequence([fadeOutAction, waitAction, hideAction])
        self.plusMinus.run(sequenceAction)
        self.obsTimer.alpha = 0
        self.obstructionNode.removeFromParent()
        self.hasShownObstruction = true
        self.timer.resume()
    }
    
    // Helper method to create a progress bar shape node
    func createProgressBar(size: CGSize, color: UIColor, progressBarCornerRadius: CGFloat) -> SKShapeNode {
        let progressBar = SKShapeNode(rectOf: size, cornerRadius: progressBarCornerRadius)
        progressBar.fillColor = color
        progressBar.lineWidth = 0
        return progressBar
    }
    
    func decreaseTimeBar() {
        // Update the timer progress bar
        let progress = CGFloat(timer.timeLeft() / self.duration)
        let progressBarWidth = 400.0 // Width of the progress bar
        let progressBarHeight = 30.0 // Height of the progress bar
        
        let scaledWidth = progressBarWidth * progress
        let offsetX = (progressBarWidth - scaledWidth) / 2
        
        self.timerProgressBar.xScale = scaledWidth / progressBarWidth
        self.timerProgressBar.position.x = frame.midX - CGFloat(offsetX)
    }
    
    func setupTimerAudio() {
        let center = CGPoint(x: frame.midX, y: frame.midY)
        self.timer.position = CGPoint(x: frame.midX, y: frame.midY + 140)
        self.timer.zPosition = 500
        self.timer.fontName = "Fredoka"
        self.timer.fontSize = 25
      
        addChild(self.timer)
        self.timer.startWithDuration(duration: self.duration)
        
        // Create and add the timer progress bar
        let progressBarSize = CGSize(width: 400, height: 30)
        let progressBarCornerRadius: CGFloat = 10.0
        let progressBarPosition = CGPoint(x: center.x, y: center.y + 150)
        self.timerProgressBar = self.createProgressBar(size: progressBarSize, color: UIColor(named: "Blue") ?? .blue, progressBarCornerRadius: progressBarCornerRadius)
        self.timerProgressBar.position = progressBarPosition
        self.timerProgressBar.zPosition = 124
        self.progressBarBackground = self.createProgressBar(size: progressBarSize, color: UIColor(named: "Brown") ?? .brown, progressBarCornerRadius: progressBarCornerRadius)
        self.progressBarBackground.position = progressBarPosition
        self.progressBarBackground.zPosition = 123
        addChild(self.timerProgressBar)
        addChild(self.progressBarBackground)
      
        let outlineSize = CGSize(width: progressBarSize.width + 3, height: progressBarSize.height + 3) // Adjust the size as needed
        let outlineColor = UIColor.black // Adjust the color as needed
        let outlineLineWidth: CGFloat = 2.0 // Adjust the line width as needed
        let outlineShape = SKShapeNode(rectOf: outlineSize, cornerRadius: progressBarCornerRadius)
        outlineShape.fillColor = UIColor.clear
        outlineShape.strokeColor = outlineColor
        outlineShape.lineWidth = outlineLineWidth
        outlineShape.position = progressBarPosition
        outlineShape.zPosition = 122
        addChild(outlineShape)
        
        self.obsTimer.position = CGPoint(x: frame.midX, y: frame.midY + 60)
        self.obsTimer.fontSize = 25
        self.obsTimer.alpha = 0
        self.obsTimer.fontSize = 40
        addChild(self.obsTimer)
        self.obsTimer.startWithDuration(duration: self.obsDuration)
        self.obsTimer.pause()
      
        self.plusMinus = SKLabelNode()
        self.plusMinus.fontSize = 25
        self.plusMinus.fontName = "YourName-Bold"
        self.plusMinus.text = "+5"
        self.plusMinus.zPosition = 7000
        self.plusMinus.position = CGPoint(x: frame.midX + 50, y: frame.midY + 140)
        self.plusMinus.alpha = 0
        addChild(self.plusMinus)
        
        AudioManager.shared.playBackgroundMusic(filename: self.backgroundMusic)
    }
}

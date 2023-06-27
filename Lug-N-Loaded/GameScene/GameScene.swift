//
//  GameScene.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 17/06/23.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene {
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
  let duration: TimeInterval = 36
    
  var isShowingObstruction = false
  var hasShownObstruction = false
  
  override func didMove(to view: SKView) {
    isUserInteractionEnabled = true

    // TIMER & AUDIO SECTION
    self.setupTimerAudio()
      
    // Add double tap gesture recognizer
    let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleDoubleTap(_:)))
    doubleTapGesture.numberOfTapsRequired = 2
    view.addGestureRecognizer(doubleTapGesture)
    
    self.inventory = InventoryNode(position: CGPoint(x: frame.midX, y: frame.midY - 120))
    self.addChild(self.inventory)
    
    // Init Game Background, Luggage, Items:
    GameSceneFunctions.initLevel1(gameScene: self)
  }
  
  @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
    // Get the location of the double tap gesture
    let touchLocation = gestureRecognizer.location(in: gestureRecognizer.view)
    
    // Convert the touch location to the scene's coordinate system
    let convertedLocation = convertPoint(fromView: touchLocation)
    
    // MARK: Rotate Node
    
    if let tappedNode = atPoint(convertedLocation) as? SKSpriteNode {
      // Rotate the node by 90 degrees
      if tappedNode.name == "item" {
        // Rotate the node by 90 degrees
          
        let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
        tappedNode.run(rotateAction)
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
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
        
      } else if self.inventory.contains(node.position) {
        // Di Dalem INVENTORY
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = true
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
      } else {
        // Di Luar
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = false
//        self.currentItemNode?.updateItemPhysics()
        self.currentItemNode?.updateItemScale()
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    // MARK: check if item is inside of luggage or not
    
    for touch in touches {
      _ = touch.location(in: self)
      
      // check if item node is in luggagenode
      if let currentNode = currentNode, luggage.contains(currentNode.position) {
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = true
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        
        if self.currentItemNode?.isInsideLuggage(luggage: self.luggageHitBox) == false {
          self.currentItemNode?.inLuggage = false
          self.currentItemNode?.inInventory = true
          self.currentItemNode?.updateItemScale()
          self.currentItemNode?.updateItemPhysics()
          GameSceneFunctions.moveItemToInventorySlot(
            gameScene: self, item: self.currentItemNode ?? ItemNode())
        }
        
      } else if let currentNode = currentNode, inventory.contains(currentNode.position) {
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        GameSceneFunctions.moveItemToInventorySlot(
          gameScene: self, item: self.currentItemNode ?? ItemNode())
        
      } else if let currentNode = currentNode {
        GameSceneFunctions.updateInventorySlotStatus(gameScene: self)

        self.currentItemNode?.isPlaced = true
        self.currentItemNode?.inLuggage = false
        self.currentItemNode?.inInventory = false
        self.currentItemNode?.inInventory = true
        self.currentItemNode?.updateItemScale()
        self.currentItemNode?.updateItemPhysics()
        GameSceneFunctions.moveItemToInventorySlot(
          gameScene: self, item: self.currentItemNode ?? ItemNode())
      }

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
      }
    }
      
    // TIMER & AUDIO SECTION
    self.timer.update()
      
    self.decreaseTimeBar()
      
    if self.timer.text == "30" && !self.isShowingObstruction && !self.hasShownObstruction {
      print("SHOW")
      self.showObstruction()
      AudioManager.shared.playObstructionMusic(filename: "OBSTRUCTION.mp3")
      AudioManager.shared.pauseBackgroundMusic()
    }
      
    if self.timer.text == "10" {
      AudioManager.shared.stopBackgroundMusic()
      AudioManager.shared.playRushMusic(filename: "COUNTDOWN.mp3")
    }
      
    if self.isShowingObstruction {
      self.obsTimer.update()
    }
      
    if self.obsTimer.hasFinished() && self.isShowingObstruction {
      self.hideObstruction()
      self.hasShownObstruction = true
      AudioManager.shared.stopObstructionMusic()
      AudioManager.shared.resumeBackgroundMusic()
    }
      
    if self.timer.hasFinished() {
      AudioManager.shared.stopRushMusic()
    }
  }
    
  func showObstruction() {
    self.timer.pause()
    self.obsTimer.resume()
        
    self.obstructionNode = ObstructionNode(size: size, parentView: view!)
    self.obstructionNode.position = CGPoint(x: frame.midX, y: frame.midY)
    self.obstructionNode.zPosition = 1000
    self.obstructionNode.isUserInteractionEnabled = true
    addChild(self.obstructionNode)
        
    self.isShowingObstruction = true
    self.obsTimer.alpha = 1
  }
    
  func hideObstruction() {
    self.isShowingObstruction = false
    let isCorrect = self.obstructionNode.removeTextField()
    print(isCorrect)
    if isCorrect {
      self.timer.addTime(amount: 6)
      self.timer.update()
    } else {
      self.timer.addTime(amount: -5)
      self.timer.update()
    }
    self.obsTimer.alpha = 0
    self.obstructionNode.removeFromParent()
    self.timer.resume()
  }
    
  // Helper method to create a progress bar shape node
  func createProgressBar(size: CGSize, color: UIColor) -> SKShapeNode {
    let progressBar = SKShapeNode(rectOf: size)
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
    self.timer.fontName = "YourName-Bold"
    self.timer.fontSize = 30
    addChild(self.timer)
    self.timer.startWithDuration(duration: self.duration)
        
    // Create and add the timer progress bar
    let progressBarSize = CGSize(width: 400, height: 30)
    let progressBarPosition = CGPoint(x: center.x, y: center.y + 150)
    self.timerProgressBar = self.createProgressBar(size: progressBarSize, color: .green)
    self.timerProgressBar.position = progressBarPosition
    self.timerProgressBar.zPosition = 124
    self.progressBarBackground = self.createProgressBar(size: progressBarSize, color: .white)
    self.progressBarBackground.position = progressBarPosition
    self.progressBarBackground.zPosition = 123
    addChild(self.timerProgressBar)
    addChild(self.progressBarBackground)
        
    self.obsTimer.position = CGPoint(x: frame.midX, y: frame.midY + 70)
    self.obsTimer.zPosition = 1001
    self.obsTimer.fontSize = 25
    self.obsTimer.alpha = 0
    addChild(self.obsTimer)
    self.obsTimer.startWithDuration(duration: 7)
    self.obsTimer.pause()
        
    AudioManager.shared.playBackgroundMusic(filename: "BGM.mp3")
  }
}

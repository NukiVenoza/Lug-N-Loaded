//
//  MatchManager.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import Foundation
import GameKit
import SpriteKit
import SwiftUI

enum PlayerRole: String {
    case player1 = "Player 1"
    case player2 = "Player 2"
}

/// - Tag:RealTimeGame
@MainActor
class MatchManager: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    public static var shared = MatchManager()

    // The game interface state.
    @Published var matchAvailable = false
    @Published var playingGame = false
    @Published var myMatch: GKMatch? = nil
    @Published var automatch = false

    // The match information.
    @Published var myAvatar = Image(systemName: "person.crop.circle")
    @Published var opponentAvatar = Image(systemName: "person.crop.circle")
    @Published var opponent: GKPlayer? = nil

    var scene: GameScene?
    @Published var currentLevel: Int = 1
    @Published var remainingTime: Int = 0

    // Testing roles buat players // check role P1 P2 --> pake alias
    @Published var localPlayer: GKPlayer?
    @Published var connectedPlayer: GKPlayer?
    var playerRole: PlayerRole?

    var rootViewController: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }

    // MARK: CORE MULTIPLAYER FUNCTIONALITY

    func sendItemData(item: ItemNode) {
        let positionX = Double(item.position.x)
        let positionY = Double(item.position.y)

        var inPlayer1 = false
        var inPlayer2 = false

        if localPlayer?.alias == "Player 1" {
            print("player 1 sending to player 2")
            inPlayer1 = true
        } else {
            print("player 2 sending to player 1")
            inPlayer2 = true
        }

        do {
            let sharedItem = SharedItem(
                itemId: item.itemId,
                positionX: positionX,
                positionY: positionY,
                inLuggage: item.inLuggage,
                itemRotation: item.currentRotation,
                inPlayer1: inPlayer1,
                inPlayer2: inPlayer2
            )
            let encodedSharedItem = encode(sharedItem: sharedItem)
            try myMatch?.sendData(toAllPlayers: encodedSharedItem!, with: GKMatch.SendDataMode.unreliable)
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }

    func receiveData(gameScene: GameScene, sharedItem: SharedItem) {
        print("dapet data:")
        print("\(sharedItem)")

        let item = GameSceneFunctions.findNode(gameScene: gameScene, itemId: sharedItem.itemId)
        let newPosition = CGPoint(x: sharedItem.positionX, y: sharedItem.positionY)

        // check if rotation in sharedItem is same with item's rotation

        if sharedItem.itemRotation != item.currentRotation {
            item.currentRotation = sharedItem.itemRotation
            let rotateAction = SKAction.rotate(byAngle: .pi / 2, duration: 0.2)
            item.run(rotateAction)
        }

        // set siapa yang terakhir sentuh item tersebut

        if sharedItem.inPlayer1 {
            if localPlayer?.alias == "Player 1" {
                item.lastTouchedBy = localPlayer?.gamePlayerID ?? ""
            } else {
                item.lastTouchedBy = connectedPlayer?.gamePlayerID ?? ""
            }
        } else {
            if localPlayer?.alias == "Player 2" {
                item.lastTouchedBy = localPlayer?.gamePlayerID ?? ""
            } else {
                item.lastTouchedBy = connectedPlayer?.gamePlayerID ?? ""
            }
        }

        if sharedItem.inLuggage {
            GameSceneFunctions.prepareImpact(
                gameScene: gameScene,
                item: item,
                newLocation: newPosition
            )

        } else {
            returnToLastToucher(gameScene: gameScene, item: item)
        }
    }

    func returnToLastToucher(gameScene: GameScene, item: ItemNode) {
        // TODO: maybe harus dirombak
        print("Returning to last toucher")

        if item.lastTouchedBy == localPlayer?.gamePlayerID {
            if gameScene.isPlayer1 == true {
                let dummyPosition = CGPoint(x: -1000, y: -1000)
                GameSceneFunctions.prepareImpact(gameScene: gameScene, item: item, newLocation: dummyPosition)
            } else {
                print("hide item from player 2")
                item.hideItem()
                item.isHidden = true
            }
        } else {
            if gameScene.isPlayer2 == true {
                let dummyPosition = CGPoint(x: -1000, y: -1000)
                GameSceneFunctions.prepareImpact(gameScene: gameScene, item: item, newLocation: dummyPosition)
            } else {
                print("hide item from player 1")
                item.hideItem()
                item.isHidden = true
            }
        }
    }

    // MARK: GK TEMPLATES FUNCTIONS

    func authenticatePlayer() {
        GKLocalPlayer.local.authenticateHandler = { viewController, error in
            if let viewController = viewController {
                self.rootViewController?.present(viewController, animated: true) {}
                return
            }
            if let error {
                print("Error: \(error.localizedDescription).")
                return
            }

            GKLocalPlayer.local.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
                if let image {
                    self.myAvatar = Image(uiImage: image)
                }
                if let error {
                    print("Error: \(error.localizedDescription).")
                }
            }

            GKLocalPlayer.local.register(self)
            GKAccessPoint.shared.location = .topLeading
            GKAccessPoint.shared.showHighlights = true
            GKAccessPoint.shared.isActive = true
            self.matchAvailable = true
        }
    }

    func findPlayer() async {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        let match: GKMatch
        do {
            match = try await GKMatchmaker.shared().findMatch(for: request)
        } catch {
            print("Error: \(error.localizedDescription).")
            return
        }
        if !playingGame {
            startMyMatchWith(match: match)
        }
        GKMatchmaker.shared().finishMatchmaking(for: match)
        automatch = false
    }

    func choosePlayer() {
        let request = GKMatchRequest()
        request.minPlayers = 2
        request.maxPlayers = 2
        if let viewController = GKMatchmakerViewController(matchRequest: request) {
            viewController.matchmakerDelegate = self
            rootViewController?.present(viewController, animated: true) {}
        }
    }

//    func startMyMatchWith(match: GKMatch) {
    ////        GKAccessPoint.shared.isActive = false
    ////        playingGame = true
    ////        myMatch = match
    ////        myMatch?.delegate = self
    ////
    ////        if myMatch?.expectedPlayerCount == 0 {
    ////            localPlayer = GKLocalPlayer.local
    ////            localPlayer?.alias = "Player 1"
    ////            connectedPlayer = myMatch?.players[0]
    ////            connectedPlayer?.alias = "Player 2"
    ////
    ////            opponent = myMatch?.players[0]
    ////            opponent?.loadPhoto(for: GKPlayer.PhotoSize.small) { image, error in
    ////                if let image {
    ////                    self.opponentAvatar = Image(uiImage: image)
    ////                }
    ////                if let error {
    ////                    print("Error: \(error.localizedDescription).")
    ////                }
    ////            }
    ////        }
//
//        reportProgress()
//    }

    func startMyMatchWith(match: GKMatch) {
        GKAccessPoint.shared.isActive = false
        playingGame = true
        myMatch = match
        myMatch?.delegate = self

        if myMatch?.expectedPlayerCount == 0 {
            localPlayer = GKLocalPlayer.local
            connectedPlayer = myMatch?.players[0]

            playerRole = Bool.random() ? .player1 : .player2

            // Send a message to the connected player with the player role
            let message = "\(playerRole!)"
            do {
                try myMatch?.sendData(toAllPlayers: message.data(using: .utf8)!, with: .reliable)
            } catch {
                print("error!")
            }

            reportProgress()
        }
    }

    func endMatch() {}

    func forfeitMatch() {}

    func saveScore() {
        GKLeaderboard.submitScore(remainingTime, context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: ["123"])
        { error in
            if let error {
                print("Error: \(error.localizedDescription).")
            }
        }
    }

    func resetMatch() {
        playingGame = false
        myMatch?.disconnect()
        myMatch?.delegate = nil
        myMatch = nil
        opponent = nil
        opponentAvatar = Image(systemName: "person.crop.circle")
        GKAccessPoint.shared.isActive = true
    }

    // Rewarding players with achievements.
    func reportProgress() {
        GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
            let achievementID = "1234"
            var achievement: GKAchievement?
            achievement = achievements?.first(where: { $0.identifier == achievementID })
            if achievement == nil {
                achievement = GKAchievement(identifier: achievementID)
            }
            let achievementsToReport: [GKAchievement] = [achievement!]
            achievement?.percentComplete = achievement!.percentComplete + 10.0
            GKAchievement.report(achievementsToReport, withCompletionHandler: { (error: Error?) in
                if let error {
                    print("Error: \(error.localizedDescription).")
                }
            })

            if let error {
                print("Error: \(error.localizedDescription).")
            }
        })
    }
}

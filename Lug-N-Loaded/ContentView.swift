//
//  ContentView.swift
//  Lug-N-Loaded
//
//  Created by Abraham Putra Lukas on 22/06/23.
//

import SwiftUI
import SpriteKit
import GameKit

struct ContentView: View {
    @StateObject private var game = RealTimeGame()
    var scene = Game()
    init(scene: Game) {
        self.scene = scene
        scene.size = CGSize(width: 852, height: 415)
        scene.scaleMode = .fill
//        return scene
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor(red: 0.2196078431372549, green: 0.20392156862745098, blue: 0.20392156862745098, alpha: 1))
                    .ignoresSafeArea()
                Circle()
                    .frame(width: 300, height: 300)
                    .foregroundColor(Color(red: 0.03529411764705882, green: 0.2901960784313726, blue: 0.4823529411764706))

                VStack {
                    Text("Lug-N-Loaded")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.941, green: 0.7725490196078432, blue: 0.09019607843137255))
                        .fontWeight(.semibold)
                        
//                    NavigationLink(destination: GameScene()) {
//                        Image("startBtn")
//                            .resizable()
//                            .frame(width: 61, height: 65)
//
//                    }
                    // Navigate matching with friend
                    Button {
                        if game.automatch {
                            // Turn automatch off.
                            GKMatchmaker.shared().cancel()
                            game.automatch = false
                        }
                        game.choosePlayer()
                    }label: {
                        Image("startBtn")
                            .resizable()
                            .frame(width: 61, height: 65)
                    }
                   
                }
//                VStack {
//                    Rectangle()
//                        .frame(maxWidth: .infinity, maxHeight: 90)
////                        .position(x: 0, y: 200)
//                        .padding(.top, 300)
//                        .foregroundColor(Color(red: 0.9019607843137255, green: 0.9019607843137255, blue: 0.9019607843137255))
//
//                        .ignoresSafeArea()
//                }
                
            }
            .onAppear {
                if !game.playingGame {
                    game.authenticatePlayer()
                }
            }
            .fullScreenCover(isPresented: $game.playingGame) {
                GameScene(game: game)
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(scene: Game())
    }
}

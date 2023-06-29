//
//  ContentView.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import SpriteKit
import SwiftUI

// TODO: Fix bug di obstruction -> kecilin text dikit + angka ke-4 g muncul!

struct ContentView: View {
//  @ObservedObject private var game : RealTimeGame

  @State var isPlayingGame = false

  var body: some View {
    NavigationView {
      ZStack {
        Image("bgTitle")
          .resizable()
          .aspectRatio(contentMode: .fill)
          .ignoresSafeArea()
        VStack {
          // Navigate matching with friend
          Button {
            //          if game.automatch {
            //            // Turn automatch off.
            //            GKMatchmaker.shared().cancel()
            //            game.automatch = false
            //          }
            //          game.choosePlayer()
            isPlayingGame = true
          } label: {
            Image("btnStart")
              .resizable()
              .frame(width: 61, height: 65)
              .padding(.top, 68)
          }
        }
      }
      .onAppear {
        //      if !game.playingGame {
        //        game.authenticatePlayer()
        //      }
      }
      .fullScreenCover(isPresented: $isPlayingGame) {
        GameView()
      }
      //    .fullScreenCover(isPresented: $game.playingGame) {
      //      GameView()
      //    }
    }
  }
}

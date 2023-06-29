//
//  GameView.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import SpriteKit
import SwiftUI

struct GameView: View {
    @EnvironmentObject var matchManager: MatchManager
    @Binding var level: Int
    // 0 = tutorial, 1 = level 1, and so on...

    var scene: SKScene {
        @EnvironmentObject var matchManager: MatchManager
        let scene = GameScene(level: level)
        scene.size = UIScreen.main.bounds.size
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: scene)
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 22)
            .ignoresSafeArea()
            .environmentObject(matchManager)
    }
}

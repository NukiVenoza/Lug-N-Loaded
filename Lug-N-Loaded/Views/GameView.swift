//
//  GameView.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import SpriteKit
import SwiftUI

struct GameView: View {
  var scene: SKScene {
    let scene = GameScene()
    scene.size = UIScreen.main.bounds.size
    scene.scaleMode = .fill
    return scene
  }

  var body: some View {
    SpriteView(scene: scene)
      .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height + 22)
      .ignoresSafeArea()
  }
}

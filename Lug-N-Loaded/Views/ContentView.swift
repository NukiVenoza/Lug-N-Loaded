//
//  ContentView.swift
//  Lug-N-Loaded
//
//  Created by Kevin Bryan on 29/06/23.
//

import SpriteKit
import SwiftUI


//TODO: Fix bug di obstruction -> kecilin text dikit + angka ke-4 g muncul!

struct ContentView: View {
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

//
// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
// }

//
//  ChooseLevelView.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 29/06/23.
//

import SwiftUI

struct ChooseLevelView: View {
    @EnvironmentObject var matchManager: MatchManager
    @State var currentIndex: Int = 0
    @State var levels: [Level] = []
    @State var isPlayingGame = false
    
    var body: some View {
        ZStack {
            Color("background_grey")
                .ignoresSafeArea()
            
            Image("background_chooselevel")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                LevelCarousel(index: $currentIndex, items: levels) { level in
                    
                    GeometryReader { proxy in
                        let size = proxy.size
                        
                        Image(level.levelImage)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: size.width)
                    }
                }
                .mask {
                    Image("levelScope")
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(0.85)
                }
            }
            .onAppear {
                for index in 0 ... 1 {
                    levels.append(Level(levelImage: "level\(index + 1)-rbg"))
                }
            }
            
            VStack {
                HStack(alignment: .top) {
                    Button {
                        print("")
                    } label: {
                        Image("backArrow")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                    
                    Spacer()
                    
                    Image("select_level_text")
                        .resizable()
                        .scaledToFit()
                        .edgesIgnoringSafeArea(.all)
                        .frame(width: 250)
                        .padding(.top, -7)
                    
                    Spacer()
                    
                    Button {
                        print("")
                        
                    } label: {
                        Image("")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.top, 32)
                Spacer()
            }
            
            Button {
                isPlayingGame = true
                currentIndex = currentIndex + 1
            } label: {
                Image("btnStart")
                    .resizable()
                    .frame(width: 72, height: 72)
            }.position(CGPoint(x: UIScreen.main.bounds.midX - 20,
                               y: UIScreen.main.bounds.midY + 150))
        }
        .fullScreenCover(isPresented: $isPlayingGame) {
            GameView(level: $currentIndex)
                .environmentObject(matchManager)
        }
    }
}

struct ChooseLevelView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLevelView()
    }
}

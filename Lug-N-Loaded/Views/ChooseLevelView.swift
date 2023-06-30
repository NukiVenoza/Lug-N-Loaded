//
//  ChooseLevelView.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 29/06/23.
//

import SwiftUI

struct ChooseLevelView: View {
    @State var currentIndex: Int = 0
    @State var levels: [Level] = []
    @State var isPlayingGame = false
    @State var gameLevel: Int = 0
//    @State var moonPositionX = 520
     let moonPosition1 = CGPoint(x: 520, y: 130)
     let moonPosition2 = CGPoint(x: 200, y: 130)
    var body: some View {
        
        ZStack {
            Color("background_grey")
                .ignoresSafeArea()
            
            Image("background_chooselevel")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            
//            Button {
//                currentIndex = currentIndex + 1
//            } label: {
//                Image("btn_back_level")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 70)
//                    .position(x: 90, y: 190)
//            }
            
            VStack(alignment: .leading){
                
                HStack{

                    LevelCarousel(index: $currentIndex, items: levels) { level in
                        
                        GeometryReader{ proxy in
                            let size = proxy.size
                            
                            
                       
                                Image("moon")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
//                                    .offset(x: 480, y: 100)
                                    .position(
                                        currentIndex == 0 ? moonPosition1 : moonPosition2)
                                    .animation(.easeInOut(duration: 2.0), value: currentIndex)
                            
                            
//                            Button {
//                                isPlayingGame = true
//                                currentIndex =  currentIndex + 1
//                            } label: {
                                Image(level.levelImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: size.width)
                                    .padding(.leading, 10)
//                            }

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
                
                
                
            }
            .onAppear {
                for index in 0...1{
                    levels.append(Level(levelImage: "level\(index + 1)-rbg"))
                    
                }
            }
            
//            Button{
//                currentIndex = currentIndex + 1
//            } label: {
//                Image("btn_next_level")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 70)
//                    .position(x: 710, y: 190)
//            }
           
            HStack(alignment: .center){
                Spacer()
                
                if currentIndex == 0 {
                    Image("levelIndicatorLeft")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .position(x: 520, y: 330)
                }
                else if currentIndex == 1 {
                    Image("levelIndicatorRight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                        .position(x: 270, y: 330)
                }
                
                Spacer()
                    
            }
            
            VStack{
                HStack(alignment: .top) {
                    
                    Button{
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
                    
                    Button{
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
            
            if currentIndex == 0 {
                NavigationLink {
                    StoryLevel1View()
                } label: {
                    Image("btnStart")
                        .resizable()
                        .frame(width: 72, height: 72)
                        .padding(.top, 300)
                }
            }else{
                Button {
                    gameLevel =  currentIndex + 1
                    isPlayingGame = true
                } label: {
                    Image("btnStart")
                        .resizable()
                        .frame(width: 72, height: 72)
                }.position(CGPoint(x: UIScreen.main.bounds.midX - 12,
                                   y: UIScreen.main.bounds.midY + 135))
            }
        }
        .fullScreenCover(isPresented: $isPlayingGame) {
            GameView(level: $gameLevel)
        }
    }
}

struct ChooseLevelView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLevelView()
    }
}

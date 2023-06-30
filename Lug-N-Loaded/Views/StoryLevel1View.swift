import SwiftUI

struct StoryLevel1View: View {
    @State private var isShowingImage1 = false
    @State private var isShowingImage2 = false
    @State private var isShowingImage3 = false
    @State private var isShowingImage4 = false
    @State private var isShowingStory = true
    @State private var isStoryDone = false
    
    @State var isPlayingGame: Bool = false
    @State var gameLevel: Int = 1
    
    var timer : Double = 6
    
    var body: some View {
        ZStack {
            Color("background_black")
                .ignoresSafeArea()
            if isShowingStory {
                VStack(alignment: .leading) {
                    HStack {
                        Image("LV1P1")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 315)
                            .opacity(isShowingImage1 ? 1 : 0)
                            .animation(.easeInOut(duration: 1))
                            .onAppear {
                                isShowingImage1 = true
                            }
                        Image("LV1P2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 415)
                            .opacity(isShowingImage2 ? 1 : 0)
                            .animation(.easeInOut(duration: 1).delay(timer*(1/3)))
                            .onAppear {
                                isShowingImage2 = true
                            }
                    }
                    HStack {
                        Image("LV1P3")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 415)
                            .opacity(isShowingImage3 ? 1 : 0)
                            .animation(.easeInOut(duration: 1).delay(timer*(2/3)))
                            .onAppear {
                                isShowingImage3 = true
                            }
                        Image("LV1P4")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 315)
                            .opacity(isShowingImage4 ? 1 : 0)
                            .animation(.easeInOut(duration: 1).delay(timer))
                            .onAppear {
                                isShowingImage4 = true
                            }
                    }
                }
                .onAppear {
                    Timer.scheduledTimer(withTimeInterval: timer, repeats: false) { _ in
                        isStoryDone = true
                    }
                }
            } else {
                
            }
            
        }
        .onTapGesture {
            if isStoryDone {
                isShowingStory = false
                isPlayingGame = true
            }
        }
        .onAppear{}
        .navigationBarBackButtonHidden()
        .fullScreenCover(isPresented: $isPlayingGame) {
            GameView(level: $gameLevel)
        }
    }
}

struct StoryLevel1View_Previews: PreviewProvider {
    static var previews: some View {
        StoryLevel1View()
    }
}

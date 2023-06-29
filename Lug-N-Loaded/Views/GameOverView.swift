//
//  GameOverView.swift
//  Lug-N-Loaded
//
//  Created by Jonathan Axel Benaya on 28/06/23.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        ZStack (alignment: .leading) {
            Color("background_black")
                .ignoresSafeArea()
            HStack {
                VStack (alignment: .leading){
                    Image("GameOver")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200)
                    Image("Divider")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                        .padding(.bottom)
                    HStack {
                        Button {
                            //to menu
                        } label: {
                            Image("btnMenu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        Button {
                            //to retry
                        } label: {
                            Image("btnRetry")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        Spacer()
                    }
                }
                Image("Fin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
        }
        
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}

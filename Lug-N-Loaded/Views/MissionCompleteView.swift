//
//  MissionCompleteView.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 28/06/23.
//

import SwiftUI

struct MissionCompleteView: View {
    var body: some View {
        ZStack (alignment: .leading){
            Color("background_black")
                .ignoresSafeArea()
            HStack{
                VStack (alignment: .leading){
                    Image("mission_completed_text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330)
                        .padding(.bottom, 7)
                    
                    HStack {
                        Image("timeCompleted")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 170)
                            .padding(.leading, -5)
                        
                        Spacer()
                        
                        Image("time_textfield")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 60)
                            .overlay(
                                Text("3:00")
                                    .font(.custom("Fredoka", size: 15))
                                    .fontWeight(.semibold)
                                    .offset(x : 3,y : -3)
                                
                            )
                        Spacer()
                        Spacer()
                        
                    }
                    .padding(.bottom, 6)
                    
                    Image("Divider")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 310)
                        .padding(.bottom, 6)
                    
                    HStack{
                        Button{
                            
                        } label: {
                            Image("btnMenu")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        
                        Button{
                            
                        } label: {
                            Image("btnRetry")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                        
                        Button{
                            
                        } label: {
                            Image("btnNext")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100)
                        }
                    }
                    
                }
                                
                Image("win_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                
            }
        }
        
    }
    
}

struct MissionCompleteView_Previews: PreviewProvider {
    static var previews: some View {
        MissionCompleteView()
    }
}

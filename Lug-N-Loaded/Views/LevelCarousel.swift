//
//  LevelCarousel.swift
//  Lug-N-Loaded
//
//  Created by Nuki Venoza on 29/06/23.
//

import SwiftUI

struct LevelCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 120, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    //offset
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View{
        GeometryReader{proxy in
            //            let width = (650 + spacing)
            let width = proxy.size.width - (trailingSpace - spacing)
            
            HStack(spacing: spacing) {
                ForEach(list) {
                    item in
                    content(item)
                        .frame(width: width)
                }
            }
            .padding(.horizontal, spacing)
            .padding(.leading, 20)
            .offset(x: (CGFloat(currentIndex) * -width) + offset)
            
            .gesture(
                DragGesture()
                    .updating($offset,
                              body: {
                                  value, out,
                                  _ in
                                  out = value.translation.width
                              })
                    .onEnded({ value in
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        index = currentIndex
                        
                    })
                    .onChanged({ value in
                        let offsetX = value.translation.width
                        
                        let progress = -offsetX / width
                        
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
            )
        }
        .animation(.easeInOut(duration: 1.0), value: offset == 0)
        
    }
}

struct LevelCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLevelView()
    }
}

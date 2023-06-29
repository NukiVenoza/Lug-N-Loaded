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
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T)->Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    var body: some View{
        
        GeometryReader{proxy in
            
        }
    }
    
}

struct LevelCarousel_Previews: PreviewProvider {
    static var previews: some View {
        ChooseLevelView()
    }
}

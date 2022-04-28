//
//  CarouselView.swift
//  DemoPager
//
//  Created by gannha on 20/04/2022.
//

import SwiftUI

struct CarouselView<Content: View,T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    
    init(spacing: CGFloat = 15,trailingSpace: CGFloat = 60,index: Binding<Int>,items: [T],@ViewBuilder content: @escaping (T)->Content){
        
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View{
        
        GeometryReader{proxy in
            
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing){
                ForEach(list){item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace, height: 100)
                }
            }
            .padding(.horizontal,spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(
                DragGesture()
                    .updating($offset) { value, out, _ in
                        out = value.translation.width
                    }
                    .onChanged { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    }
                    .onEnded { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        currentIndex = index
                        
                        if currentIndex == 0 {
                            currentIndex = 1
                        } else if currentIndex == list.count - 1 {
                            currentIndex = list.count - 2
                        }
                    }
            )
        }
        .animation(.easeInOut, value: offset == 0)
        .onAppear {
            if currentIndex == 0 {
                currentIndex = 1
            } else if currentIndex == list.count - 1 {
                currentIndex = list.count - 2
            }
        }
    }
}

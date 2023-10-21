//
//  ContentView.swift
//  sound
//
//  Created by oiu on 21.10.2023.
//

import SwiftUI

struct ContentView: View {
    
    private enum Constants {
        static let width: CGFloat = 100
        static let height: CGFloat = 230
        static let cornerRadius: CGFloat = 30
    }
    
    @State
    private var height: CGFloat = 50
    
    @State
    private var translation: CGFloat = .zero
    
    @State
    private var proposedXScale: CGFloat = 1
    
    @State
    private var proposedYScale: CGFloat = 1

    
    private var background: some View {
        Rectangle()
            .fill(
                Gradient(colors: [.yellow, .red, .blue])
            )
    }
    
    private var slider: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .foregroundColor(.clear)
                .background(Color.clear.background(.ultraThinMaterial))
            Rectangle()
                .foregroundColor(.white)
                .frame(height: max(0, height + translation))
                .layoutPriority(-1)
        }
        .mask {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
        }
        .gesture(gesture)
        .scaleEffect(
            x: proposedXScale,
            y: proposedYScale
        )
    }
    
    private var gesture: some Gesture {
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                translation = -value.translation.height

                var currentOverflow = height + translation - Constants.height
                
                guard currentOverflow > 0 || currentOverflow < -Constants.height else {
                    return
                }
                
                if currentOverflow < 0 {
                    currentOverflow = (currentOverflow + Constants.height) * -1
                }
                
                let root = sqrt(currentOverflow)
                let dimension = Constants.height + root
                
                proposedXScale = Constants.height / dimension
                proposedYScale = dimension / Constants.height
            }
            .onEnded { _ in
                height = min(max(height + translation, 0), Constants.height)
                translation = .zero
                withAnimation {
                    proposedXScale = 1
                    proposedYScale = 1
                }
            }
    }
    
    var body: some View {
        ZStack {
            background
            slider
                .frame(width: Constants.width, height: Constants.height)
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

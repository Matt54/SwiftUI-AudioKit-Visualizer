//
//  VerticalBar.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import SwiftUI

/// Single bar of Amplitude Visualizer
struct VerticalBar: View {
    
    @Binding var amplitude: Double
    
    var body: some View {
        GeometryReader
            { geometry in
            ZStack(alignment: .bottom){
                
                // Colored rectangle in back of ZStack
                Rectangle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.red, .yellow, .green]), startPoint: .top, endPoint: .center))
                
                    // blue/purple bar style
                    //.fill(LinearGradient(gradient: Gradient(colors: [Color.init(red: 0.0, green: 1.0, blue: 1.0), .blue, .purple]), startPoint: .top, endPoint: .bottom))
                
                // Dynamic black mask padded from bottom in relation to the amplitude
                Rectangle()
                    .mask(Rectangle().padding(.bottom, geometry.size.height * CGFloat(self.amplitude)))
                    .animation(.easeOut(duration: 0.15))
                
                // White bar with slower animation for floating effect
                Rectangle()
                    .fill(Color.white)
                    .frame(height: geometry.size.height * 0.005)
                    .offset(x: 0.0, y: -geometry.size.height * CGFloat(self.amplitude) - geometry.size.height * 0.02)
                    .animation(.easeOut(duration: 0.6))
                
            }
            .padding(geometry.size.width * 0.1)
            .border(Color.black, width: geometry.size.width * 0.1)
        }
    }
    
}

struct VerticalBar_Previews: PreviewProvider {
    static var previews: some View {
        VerticalBar(amplitude: .constant(0.8))
        .previewLayout(.fixed(width: 40, height: 500))
    }
}

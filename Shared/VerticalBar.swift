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

  var amplitude: Double

  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .bottom) {

        // Colored rectangle in back of ZStack
        Rectangle()
          .fill(
            LinearGradient(
              gradient: Gradient(colors: [
                .cyan, .blue,
              ]), startPoint: .top, endPoint: .bottom))

        // Dynamic black mask padded from bottom in relation to the amplitude
        Rectangle()
          .fill(Color.black)
          .mask(Rectangle().padding(.bottom, geometry.size.height * CGFloat(self.amplitude)))
        //          .animation(.easeOut(duration: 0.15), value: amplitude)
      }
      .padding(geometry.size.width * 0.1)
      .border(Color.black, width: geometry.size.width * 0.1)
    }
  }

}

struct VerticalBar_Previews: PreviewProvider {
  static var previews: some View {
    VerticalBar(amplitude: 0.8)
      .previewLayout(.fixed(width: 40, height: 500))
  }
}

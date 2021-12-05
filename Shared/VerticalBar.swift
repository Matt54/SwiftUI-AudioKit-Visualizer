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
            .blue
            )
          .border(Color.black, width: 0.5)
          .frame(width: geometry.size.width * 1, height: geometry.size.height * amplitude)
          .offset(x: 0, y: geometry.size.height * (1 - amplitude))
      }
    }
  }

}

struct VerticalBar_Previews: PreviewProvider {
  static var previews: some View {
    VerticalBar(amplitude: 0.8)
      .previewLayout(.fixed(width: 40, height: 500))
  }
}

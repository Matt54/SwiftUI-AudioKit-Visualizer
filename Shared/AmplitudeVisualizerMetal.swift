//
//  AmplitudeVisualizer.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import SwiftUI

struct AmplitudeVisualizerMetal: AmplitudeVisualizer {

var amplitudes: [Double]


  var body: some View {
      
    HStack(spacing: 0.0) {
        MetalView(amplitudes:self.amplitudes)
    }
    .background(Color.black)
  }
}

//struct AmplitudeVisualizer_Previews: PreviewProvider {
//  static var previews: some View {
//    AmplitudeVisualizerForEach(amplitudes: [0.2, 0.3, 0.1])
//  }
//}

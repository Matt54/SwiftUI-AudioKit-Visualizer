//
//  AmplitudeVisualizer.swift
//  Visualizer
//
//  Created by Macbook on 7/30/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import SwiftUI

struct AmplitudeVisualizer: View {
    
    @Binding var amplitudes: [Double]
    
    var body: some View {
        HStack(spacing: 0.0){
            ForEach(0 ..< self.amplitudes.count) { number in
                VerticalBar(amplitude: self.$amplitudes[number])
            }
        }
        .background(Color.black)
    }
}

struct AmplitudeVisualizer_Previews: PreviewProvider {
    static var previews: some View {
        AmplitudeVisualizer(amplitudes: .constant(Array(repeating: 1.0, count: 50)))
    }
}

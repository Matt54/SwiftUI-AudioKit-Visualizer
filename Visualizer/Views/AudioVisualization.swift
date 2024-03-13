//
//  AudioVisualization.swift
//  Visualizer
//
//  Created by Treata Norouzi on 3/13/24.
//

import SwiftUI
import AudioKitUI

struct InputAudioVisualization: View {
    @Environment(InputConductor.self) var conductor
    
    var body: some View {
        FFTView(conductor.outputMixer)
    }
}

#Preview("InputAudioVisualization") {
    InputAudioVisualization()
        .environment(InputConductor.shared)
}

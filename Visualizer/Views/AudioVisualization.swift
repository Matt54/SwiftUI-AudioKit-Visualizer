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
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        FFTView(conductor.outputMixer)
            .onChange(of: scenePhase) {
                if scenePhase == .inactive { conductor.stop() }
            }
            .onAppear {
                conductor.start()
            }
            .onDisappear {
                conductor.stop()
            }
    }
}

//#Preview("InputAudioVisualization") {
//    InputAudioVisualization()
//        .environment(InputConductor.shared)
//}

// MARK: - Music Visualizer

struct MusicVisualizer: View {
    // TODO: Create an option to choose a music file
    @Environment(MusicPlayerConductor.self) var conductor
    
    var body: some View {
        FFTView(conductor.outputMixer)
            .onAppear {
                conductor.start()
                conductor.player.play()
            }
            .onDisappear {
//                conductor.stop()
                conductor.player.stop()
            }
    }
}

#Preview("InputAudioVisualization") {
    @Bindable var conductor = MusicPlayerConductor()
    
    return InputAudioVisualization()
        .environment(conductor)
}

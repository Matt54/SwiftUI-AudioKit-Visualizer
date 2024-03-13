//
//  VisualizerApp.swift
//  Visualizer
//
//  Created by Treata Norouzi on 3/13/24.
//

import SwiftUI

@main
struct VisualizerApp: App {
    @Bindable var inputConductor = InputConductor()
    
    var body: some Scene {
        WindowGroup {
            Group {
                InputAudioVisualization()
            }
            .ignoresSafeArea()
            // Injecting the ViewModel(s)
            .environment(inputConductor)
        }
    }
}

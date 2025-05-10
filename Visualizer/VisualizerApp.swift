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
    @Bindable var musicConductor = MusicPlayerConductor()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MusicVisualizer()
                    .toolbar {
                        ToolbarItem {
                            Menu(content: {
//                                NavigationLink(destination: MusicVisualizer(), label: {
//                                    Label("Input from File", systemImage: "music.note")
//                                })
                
                                NavigationLink(destination: InputAudioVisualization(), label: {
                                    Label("Input from Mic", systemImage: "mic.fill")
                                })
                            }, label: {
                                Image(systemName: "line.3.horizontal.decrease.circle")
                            })
                        }
                    }
            }
            .ignoresSafeArea()
            // Injecting the ViewModel(s)
            .environment(inputConductor)
            .environment(musicConductor)
        }
    }
}

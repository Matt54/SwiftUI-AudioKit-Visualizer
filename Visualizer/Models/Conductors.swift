//
//  Conductors.swift
//  Visualizer
//
//  Created by Treata Norouzi on 3/13/24.
//

import AudioKit
import AudioKitUI
import Observation

@Observable
class InputConductor: HasAudioEngine {
    
    /// Single shared data model
    static let shared = InputConductor()
    
    /// Single shared data model
    let engine = AudioEngine()
    
    /// default microphone
    let mic: AudioEngine.InputNode?
    /// mixing node for microphone input - routes to plotting and recording paths
    let outputMixer: Mixer
    
    init() {
        mic = engine.input
        outputMixer = Mixer(mic!)
        engine.output = outputMixer

        // start the AudioKit engine
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
}

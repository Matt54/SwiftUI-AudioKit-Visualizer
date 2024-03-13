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

// MARK: - Music Player

// To have the `URL` struct available in the scope
import UniformTypeIdentifiers

@Observable
class MusicPlayerConductor: HasAudioEngine, ProcessesPlayerInput {
    let engine = AudioEngine()
    
    let player: AudioPlayer
    let outputMixer: Mixer
    
    init(musicUrl: URL = Bundle.main.url(forResource: "Guitar", withExtension: "mp3")!) {
        player = AudioPlayer(url: musicUrl)!
        
        engine.output = player
        player.isLooping = true
        outputMixer = Mixer(player)
        
        engine.output = outputMixer
        
        do {
            try engine.start()
        } catch {
            print(error)
        }
    }
}

//
//  Conductor.swift
//  Visualizer
//
//  Created by Macbook on 6/27/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import AudioKit

/// Persistent data object
final class Conductor : ObservableObject{

    /// Single shared data model
    static let shared = Conductor()
    
    /// default microphone
    var mic = AKMicrophone()
    
    /// mixing node for microphone input - routes to plotting and recording paths
    var micMixer = AKMixer()
    
    /// time interval in seconds for repeating timer callback
    static var refreshTimeInterval : Double = 0.02
    
    /// tap for the fft data
    let fft : AKFFTTap
    
    /// size of fft
    let FFT_SIZE = 512
    
    /// audio sample rate
    let sampleRate : double_t = 44100
    
    /// limiter to prevent excessive volume at the output - just in case, it's the music producer in me :)
    let outputLimiter = AKPeakLimiter()
    
    /// amplitude bar values from (values range from 0.0 to 1.0)
    @Published var amplitudes : [Double] = Array(repeating: 0.5, count: 50)
    
    init(){
        
        fft = AKFFTTap.init(micMixer)
        
        setupMic()
        
        setAudioKitSettings()
        
        AudioKit.output = outputLimiter

        //START AUDIOKIT
        do{
            try AudioKit.start()
        }
        catch{
            assert(false, error.localizedDescription)
        }
        
        Timer.scheduledTimer(withTimeInterval: Conductor.refreshTimeInterval, repeats: true) { timer in
            self.checkAudioLevel()
        }

    }
    
    /// Sets AudioKit to appropriate settings
    func setAudioKitSettings(){

        do {
            try AKSettings.setSession(category: .ambient, with: [.mixWithOthers])
        } catch {
            AKLog("Could not set session category.")
        }
        
    }
    
    /// Does all the setup required for microphone input
    func setupMic(){
        
        // route mic to the micMixer which is tapped by our fft
        mic?.setOutput(to: micMixer)
        
        // route mixMixer to a mixer with no volume so that we don't output audio
        let silentMixer = AKMixer(micMixer)
        silentMixer.volume = 0.0
        
        // route the silent Mixer to the limiter (you must always route the audio chain to AudioKit.output)
        silentMixer.setOutput(to: outputLimiter)
    }
    
    /// Analyze fft data and write to our amplitudes array
    @objc func checkAudioLevel(){
        
        // loop through all the fft bins (by two - we will need to calculate level from real and imaginary parts)
        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {

            let re = fft.fftData[i]
            let im = fft.fftData[i + 1]
            
            let normBinMag = 2.0 * sqrt(re * re + im * im) / self.FFT_SIZE
            let amplitude = (20.0 * log10(normBinMag))
            
            var revisedAmplitude = (amplitude + 250) / 229.80
            if (revisedAmplitude < 0) {
                revisedAmplitude = 0
            }
            if (revisedAmplitude > 1.0) {
                revisedAmplitude = 1.0
            }
            
            DispatchQueue.main.async {
                if(i/2 < self.amplitudes.count){
                    self.amplitudes[i/2] = self.mapy(n: revisedAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                }
            }
        }
        
    }
    
    func mapy(n:Double, start1:Double, stop1:Double, start2:Double, stop2:Double) -> Double {
        return ((n-start1)/(stop1-start1))*(stop2-start2)+start2;
    };
}

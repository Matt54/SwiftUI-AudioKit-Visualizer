//
//  Conductor.swift
//  Visualizer
//
//  Created by Macbook on 6/27/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import AudioKit

/// The persistent data object of the application (it does the audio processing and publishes changes to the UI)
final class Conductor : ObservableObject{

    /// Single shared data model
    static let shared = Conductor()
    
    /// default microphone
    let mic = AKMicrophone()
    
    /// mixing node for microphone input - routes to plotting and recording paths
    let micMixer = AKMixer()
    
    /// time interval in seconds for repeating timer callback
    let refreshTimeInterval : Double = 0.02
    
    /// tap for the fft data
    let fft : AKFFTTap
    
    /// size of fft
    let FFT_SIZE = 512
    
    /// audio sample rate
    let sampleRate : double_t = 44100
    
    /// limiter to prevent excessive volume at the output - just in case, it's the music producer in me :)
    let outputLimiter = AKPeakLimiter()
    
    /// bin amplitude values (range from 0.0 to 1.0)
    @Published var amplitudes : [Double] = Array(repeating: 0.5, count: 50)
    
    /// constructor - runs during initialization of the object
    init(){
        
        // connect the fft tap to the mic mixer (this allows us to analyze the audio at the micMixer node)
        fft = AKFFTTap.init(micMixer)
        
        // route the audio from the microphone to the limiter
        setupMic()
        
        // set the limiter as the last node in our audio chain
        AudioKit.output = outputLimiter
        
        // do any AudioKit setting changes before starting the AudioKit engine
        setAudioKitSettings()

        // start the AudioKit engine
        do{
            try AudioKit.start()
        }
        catch{
            assert(false, error.localizedDescription)
        }
        
        // create a repeating timer at the rate of our chosen time interval - this updates the amplitudes each timer callback
        Timer.scheduledTimer(withTimeInterval: refreshTimeInterval, repeats: true) { timer in
            self.updateAmplitudes()
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
    @objc func updateAmplitudes(){
        //If you are interested in knowing more about this calculation, I have provided a couple recommended links at the bottom of this file.
        
        // loop by two through all the fft data
        for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {

            // get the real and imaginary parts of the complex number
            let real = fft.fftData[i]
            let imaginary = fft.fftData[i + 1]
            
            let normalizedBinMagnitude = 2.0 * sqrt(real * real + imaginary * imaginary) / self.FFT_SIZE
            let amplitude = (20.0 * log10(normalizedBinMagnitude))
            
            // scale the resulting data
            var scaledAmplitude = (amplitude + 250) / 229.80
            
            // restrict the range to 0.0 - 1.0
            if (scaledAmplitude < 0) {
                scaledAmplitude = 0
            }
            if (scaledAmplitude > 1.0) {
                scaledAmplitude = 1.0
            }
            
            // add the amplitude to our array (further scaling array to look good in visualizer)
            DispatchQueue.main.async {
                if(i/2 < self.amplitudes.count){
                    self.amplitudes[i/2] = self.mapy(n: scaledAmplitude, start1: 0.3, stop1: 0.9, start2: 0.0, stop2: 1.0)
                }
            }
        }
        
    }
    
    /// simple mapping function to scale a value to a different range
    func mapy(n:Double, start1:Double, stop1:Double, start2:Double, stop2:Double) -> Double {
        return ((n-start1)/(stop1-start1))*(stop2-start2)+start2;
    };
}

/*
 Visual introduction to the fourier transform:
 https://www.youtube.com/watch?v=spUNpyF58BY
 Shoutout to Grant Sanderson - thank you for your videos!
 
 Discrete fourier transform:
 https://www.youtube.com/watch?v=nl9TZanwbBk
 
 Fast fourier transform:
 https://www.youtube.com/watch?v=E8HeD-MUrjY
 Shoutout to Steve Brunton - thank you for your videos!
 
 Google groups conversation explaining how to use the fft data to calculate bin decibel levels:
 https://groups.google.com/g/comp.dsp/c/cZsS1ftN5oI?pli=1
 Shoutout to Stephan M. Sprenger - thank you for sharing!
 */

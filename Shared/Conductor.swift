import AudioKit
//
//  Conductor.swift
//  Visualizer
//
//  Created by Macbook on 6/27/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//
import SwiftUI

/// The persistent data object of the application (it does the audio processing and publishes changes to the UI)
final class Conductor: ObservableObject {

  let engine = AudioEngine()

  /// default microphone
  let mic: AudioEngine.InputNode?

  /// mixing node for microphone input - routes to plotting and recording paths
  var micMixer: Mixer?

  /// time interval in seconds for repeating timer callback
  let refreshTimeInterval: Double = 0.02

  /// tap for the fft data
  var fft: FFTTap?

  /// size of fft
  let FFT_SIZE = 512

  /// audio sample rate
  let sampleRate: double_t = 44100

  /// limiter to prevent excessive volume at the output - just in case, it's the music producer in me :)
  var outputLimiter: PeakLimiter?

  /// bin amplitude values (range from 0.0 to 1.0)
  @Published var amplitudes: [Double] = Array(repeating: 0.5, count: 150)

  /// constructor - runs during initialization of the object
  init() {
    // set the limiter as the last node in our audio chain
    if let input = engine.input {
      mic = input
      if let inputAudio = mic {
        micMixer = Mixer(inputAudio)
        fft = FFTTap(inputAudio, handler: updateAmplitudes)
        fft?.isNormalized = false

        // route the silent Mixer to the limiter (you must always route the audio chain to AudioKit.output)
        outputLimiter = PeakLimiter(micMixer!)
        engine.output = outputLimiter

      }
    } else {
      mic = nil
      micMixer = nil
      fft = nil
      outputLimiter = nil
    }

    do {
      try engine.start()
      fft?.start()
    } catch {
      assert(false, error.localizedDescription)
    }
  }

  /// Analyze fft data and write to our amplitudes array
  func updateAmplitudes(fftData: [Float]) {
    //If you are interested in knowing more about this calculation, I have provided a couple recommended links at the bottom of this file.

    // loop by two through all the fft data
    for i in stride(from: 0, to: self.FFT_SIZE - 1, by: 2) {

      // get the real and imaginary parts of the complex number
      let real = fftData[i]
      let imaginary = fftData[i + 1]

      let normalizedBinMagnitude =
        2.0 * sqrt(real * real + imaginary * imaginary) / Float(self.FFT_SIZE)
      let amplitude = (20.0 * log10(normalizedBinMagnitude))

      // scale the resulting data
      var scaledAmplitude = (amplitude + 250) / 229.80

      // restrict the range to 0.0 - 1.0
      if scaledAmplitude < 0 {
        scaledAmplitude = 0
      }
      if scaledAmplitude > 1.0 {
        scaledAmplitude = 1.0
      }

      // add the amplitude to our array (further scaling array to look good in visualizer)
      DispatchQueue.main.async {
        if i / 2 < self.amplitudes.count {
          self.amplitudes[i / 2] = Double(scaledAmplitude)
        }
      }
    }

  }

  /// simple mapping function to scale a value to a different range
  func mapy(n: Double, start1: Double, stop1: Double, start2: Double, stop2: Double) -> Double {
    return ((n - start1) / (stop1 - start1)) * (stop2 - start2) + start2
  }
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

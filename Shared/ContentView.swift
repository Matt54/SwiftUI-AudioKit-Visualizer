//
//  ContentView.swift
//  Visualizer
//
//  Created by Macbook on 6/27/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  @EnvironmentObject var conductor: Conductor

  var body: some View {
    //    AmplitudeVisualizer(amplitudes: conductor.amplitudes)
    //      .edgesIgnoringSafeArea(.all)
    AmplitudeVisualizerCanvas(amplitudes: conductor.amplitudes)
      .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environmentObject(Conductor())
  }
}

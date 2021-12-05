//
//  ContentView.swift
//  Visualizer
//
//  Created by Macbook on 6/27/20.
//  Copyright © 2020 Matt Pfeiffer. All rights reserved.
//

import SwiftUI

struct ContentView: View {

  var conductor: Conductor

  var body: some View {
    withObservedConductor<AmplitudeVisualizerForEach>(conductor: conductor)
      .edgesIgnoringSafeArea(.all)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(conductor: Conductor())
  }
}

import SwiftUI

protocol AmplitudeVisualizer: View {
  init(amplitudes: [Double])
}

struct withObservedConductor<C: AmplitudeVisualizer>: View {
  @ObservedObject var conductor: Conductor
  init(conductor: Conductor) {
    self.conductor = conductor
  }
  var body: some View {
    C.init(amplitudes: conductor.amplitudes)
  }
}

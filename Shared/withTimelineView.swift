import SwiftUI

struct withTimelineView<C: AmplitudeVisualizer>: View {
  var conductor: Conductor

  var body: some View {
    TimelineView(.animation(minimumInterval: 1 / 15)) { context in
      C.init(amplitudes: conductor.amplitudes)
    }
  }
}

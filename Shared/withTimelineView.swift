import SwiftUI

struct withTimelineView<C: AmplitudeVisualizer>: View {
  var conductor: Conductor

  var body: some View {
    TimelineView(.animation(minimumInterval: 1 / 30)) { context in
      C.init(amplitudes: conductor.amplitudes)
        .animation(
          .linear(duration: 0.2),
          value: conductor.amplitudes
        )
    }
  }
}

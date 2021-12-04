import SwiftUI

struct AmplitudeVisualizerCanvas: View {

  @Binding var amplitudes: [Double]

  var body: some View {
      Canvas(opaque: true, colorMode: .linear, rendersAsynchronously: true) { context, size in
          
          
      }
    .background(Color.black)
  }
}

struct AmplitudeVisualizerCanvas_Previews: PreviewProvider {
  static var previews: some View {
    AmplitudeVisualizer(amplitudes: Array(repeating: 1.0, count: 50))
  }
}

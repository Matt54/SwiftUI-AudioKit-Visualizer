import SwiftUI

struct AmplitudeVisualizerCanvas: AmplitudeVisualizer {

  var amplitudes: [Double]

  var body: some View {
    Canvas { context, size in
      for (i, amplitude) in amplitudes.enumerated() {
        // make a bar path
        let widthIncludingGap = (size.width / CGFloat(amplitudes.count))
        let gapWidth: CGFloat = 1
        let barWidth = widthIncludingGap - gapWidth
        let barHeight = amplitude * size.height
        let barRect = CGRect(
          x: CGFloat(i) * widthIncludingGap, y: size.height - barHeight, width: barWidth,
          height: barHeight)
        let barPath = Rectangle().path(in: barRect)

        // make a gradient shading
        let shading = GraphicsContext.Shading.color(.blue)

        context.fill(
          barPath, with: shading)
      }
    }
    .background(Color.black)
  }
}

struct AmplitudeVisualizerCanvas_Previews: PreviewProvider {
  static var previews: some View {
    AmplitudeVisualizerCanvas(amplitudes: [0.0, 0.1, 1.1, 0.5])
  }
}

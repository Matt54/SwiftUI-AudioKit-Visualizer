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
          let gradient = Gradient(colors: [.cyan, .blue])
          let startPoint = barRect.origin
          let endPoint = CGPoint(x: barRect.width + startPoint.x, y: barRect.height + startPoint.y)
          let gradientShading = GraphicsContext.Shading.linearGradient(
            gradient, startPoint: startPoint, endPoint: endPoint)

          context.fill(
            barPath, with: gradientShading)

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

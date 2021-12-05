import SwiftUI

struct AmplitudeVisualizerCanvas: View {

  @ObservedObject var conductor: Conductor
  var amplitudes: [Double] {
    conductor.amplitudes
  }

  var body: some View {
    Canvas(opaque: true, colorMode: .linear, rendersAsynchronously: true) { context, size in
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
        let gradient = Gradient(colors: [.green, .blue])
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
    AmplitudeVisualizer(conductor: Conductor())
  }
}
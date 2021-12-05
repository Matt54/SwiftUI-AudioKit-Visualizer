import SwiftUI

@main
struct VisualizerApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(conductor: Conductor())
    }
  }
}

import SwiftUI

struct ContentView: View {
    var viewModel: MenuBarViewModel

    var body: some View {
        VStack {
            Text("発電量: \(self.viewModel.generatedPower) W")
            Text("消費量: \(self.viewModel.consumedPower) W")
            Text("差引: \(self.viewModel.generatedPower - self.viewModel.consumedPower) W")
            Button("Quit") {
                NSApp.terminate(self)
            }
        }
        .frame(width: 200, height: 110)
    }
}

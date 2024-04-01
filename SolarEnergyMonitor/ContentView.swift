import SwiftUI

struct ContentView: View {
    @State private var generatedPower: String = "発電量"
    @State private var consumedPower: String = "消費量"
    var viewModel: MenuBarViewModel

    var body: some View {
        VStack {
            Text(generatedPower).onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UpdateContentView"))) { _ in
                updateGeneratedPower()
            }
            Text(consumedPower).onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("UpdateContentView"))) { _ in
                updateConsumedPower()
            }

            Button("Quit") {
                NSApp.terminate(self)
            }
        }
        .frame(width: 200, height: 110)
    }
    
    func updateGeneratedPower() {
        self.generatedPower = "発電量: \(self.viewModel.generatedPower) W"
    }

    func updateConsumedPower() {
        self.consumedPower = "消費量: \(self.viewModel.consumedPower) W"
    }
}

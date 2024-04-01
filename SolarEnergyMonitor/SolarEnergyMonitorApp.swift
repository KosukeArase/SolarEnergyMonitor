//
//  SolarEnergyMonitorApp.swift
//  SolarEnergyMonitor
//
//  Created by Kosuke Arase on 2024/04/01.
//

import SwiftUI
import Combine

@main
struct MyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            Text("Settings or Configuration View")
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var viewModel = MenuBarViewModel()
    var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        viewModel.$consumedPower.merge(with: viewModel.$generatedPower)
            .sink { [weak self] _ in
                self?.updateMenuBarIcon()
            }
            .store(in: &cancellables)
        
        updateMenuBarIcon()
    }
    
    func updateMenuBarIcon() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, let button = self.statusItem?.button else { return }
            let style = NSMutableParagraphStyle()
            style.maximumLineHeight = 10
            style.alignment = NSTextAlignment.left
            let attributes = [NSAttributedString.Key.paragraphStyle: style, NSAttributedString.Key.font: NSFont.systemFont(ofSize: 9.0), NSAttributedString.Key.baselineOffset: -5] as [NSAttributedString.Key : Any]
            var textString = ""
            if self.viewModel.consumedPower > 0 {
                textString = "☀️\(self.viewModel.generatedPower) W\n💡\(self.viewModel.consumedPower) W"
            }
            let attributedTitle = NSAttributedString(string: textString, attributes: attributes)
            button.attributedTitle = attributedTitle
        }
    }
}

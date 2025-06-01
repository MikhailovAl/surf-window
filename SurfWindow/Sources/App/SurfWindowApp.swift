import SwiftUI
import AppKit
import AVKit

@main
struct SurfWindowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var videoManager = VideoManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView(initialWidth: 150)
                .environmentObject(videoManager)
        }
        .windowStyle(.hiddenTitleBar)
    }
}



import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Скрываем Dock-иконку, но оставляем Status Bar
        NSApp.setActivationPolicy(.accessory)
        
        statusBarController = StatusBarController()
    }
}

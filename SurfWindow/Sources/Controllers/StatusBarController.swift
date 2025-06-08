import AppKit

class StatusBarController {
    private let statusItem: NSStatusItem
    private let playImage = NSImage(systemSymbolName: "play.circle.fill", accessibilityDescription: "Play")
    private let stopImage = NSImage(systemSymbolName: "stop.circle.fill", accessibilityDescription: "Stop")
    private let videoManager = VideoManager.shared
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        statusItem.menu = menu
        
        if let button = statusItem.button {
            button.image = playImage
        }
    }
    
    private var menu: NSMenu {
        let menu = NSMenu()
        
        let showHideItem = NSMenuItem(
            title: showHideTitle,
            action: #selector(toggleVideo),
            keyEquivalent: ""
        )
        showHideItem.target = self
        menu.addItem(showHideItem)
        
        menu.addItem(.separator())
        
        let quitItem = NSMenuItem(
            title: "Quit",
            action: #selector(quitApp),
            keyEquivalent: "q"
        )
        quitItem.target = self
        menu.addItem(quitItem)
        return menu
    }
    
    private var showHideTitle: String {
        guard let window = NSApp.windows.first else { return "Show window" }
        if window.isVisible {
            return "Hide window"
        } else {
            return "Show window"
        }
    }
    
    @objc private func toggleVideo() {
        guard let window = NSApp.windows.first else { return }
        if window.isVisible {
            window.orderOut(nil)
            statusItem.button?.image = stopImage
        } else {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
            statusItem.button?.image = playImage
        }
        statusItem.menu = menu
    }
    
    @objc private func nextVideo() {
        
        videoManager.pickNextRandom()
    }
    
    @objc private func quitApp() {
        NSApp.terminate(nil)
    }
    
}


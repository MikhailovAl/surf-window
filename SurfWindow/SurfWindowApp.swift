import SwiftUI
import AppKit
import AVKit

class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBarController = StatusBarController()
    }
}

class StatusBarController {
    private let statusItem: NSStatusItem
    private let playImage = NSImage(systemSymbolName: "play.circle.fill", accessibilityDescription: "Play")
    private let stopImage = NSImage(systemSymbolName: "stop.circle.fill", accessibilityDescription: "Stop")

    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        if let button = statusItem.button {
            button.image = stopImage
            button.action = #selector(statusBarButtonClicked)
            button.target = self
        }
    }

    @objc private func statusBarButtonClicked() {
        guard let window = NSApp.windows.first else { return }
        if window.isVisible {
            window.orderOut(nil)
            statusItem.button?.image = playImage
        } else {
            NSApp.activate(ignoringOtherApps: true)
            window.makeKeyAndOrderFront(nil)
            statusItem.button?.image = stopImage
        }
    }
}

@main
struct SurfWindowApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(initialWidth: 150)
        }
        .windowStyle(DefaultWindowStyle())
    }
}

struct AVPlayerContainerView: NSViewRepresentable {
    let player: AVQueuePlayer

    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        view.player = player
        view.controlsStyle = .none
        view.videoGravity = .resizeAspect
        return view
    }

    func updateNSView(_ nsView: AVPlayerView, context: Context) {}
}

struct LocalVideoPlayerView {
    let player: AVQueuePlayer
    let looper: AVPlayerLooper?
    let aspectRatio: CGFloat

    init(fileNames: [String] = ["Video", "Video2"], fileExtension: String = "mp4") {
        // выбираем одно из имён случайно
        let fileName = fileNames.randomElement()!

        if let url = Bundle.main.url(forResource: fileName, withExtension: fileExtension) {
            let asset = AVURLAsset(url: url)
            if let track = asset.tracks(withMediaType: .video).first {
                let transformedSize = track.naturalSize.applying(track.preferredTransform)
                let videoSize = CGSize(width: abs(transformedSize.width), height: abs(transformedSize.height))
                aspectRatio = videoSize.height / videoSize.width
            } else {
                aspectRatio = 9.0 / 16.0
            }
            let item = AVPlayerItem(asset: asset)
            let queue = AVQueuePlayer()
            queue.isMuted = true
            player = queue
            looper = AVPlayerLooper(player: queue, templateItem: item)
        } else {
            player = AVQueuePlayer()
            looper = nil
            aspectRatio = 9.0 / 16.0
        }
    }
}

private struct WindowAccessor: NSViewRepresentable {
    let initialSize: CGSize
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
                // размер и пропорции
                window.setContentSize(initialSize)
                window.aspectRatio = initialSize
                
                // скрываем заголовок, но сохраняем скругление
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.styleMask.insert(.fullSizeContentView)
                
                // чтобы можно было тащить по фону
                window.isMovableByWindowBackground = true
                
                // скрываем кнопки, если не нужны
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                
                // чтобы окно было поверх всех (опционально)
                window.level = .floating
                
                // показывать на всех рабочих столах (spaces)
                window.collectionBehavior.insert(.canJoinAllSpaces)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

struct ContentView: View {
    let initialWidth: CGFloat
    private let videoInfo = LocalVideoPlayerView()

    var body: some View {
        let initialHeight = initialWidth * videoInfo.aspectRatio

        ZStack {
            GeometryReader { geo in
                let w = geo.size.width
                let h = w * videoInfo.aspectRatio

                AVPlayerContainerView(player: videoInfo.player)
                    .frame(width: w, height: h)
                    .position(x: w / 2, y: h / 2)
                    .onAppear { videoInfo.player.play() }
                    .onDisappear { videoInfo.player.pause() }
            }
            .frame(minWidth: initialWidth, minHeight: initialHeight)

            WindowAccessor(initialSize: CGSize(width: initialWidth, height: initialHeight))
                .frame(width: 0, height: 0)
        }
    }
}

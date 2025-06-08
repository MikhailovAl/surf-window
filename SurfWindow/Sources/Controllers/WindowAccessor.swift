import AppKit
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    
    let initialSize: CGSize
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            if let window = view.window {
               
                window.setContentSize(initialSize)
                window.aspectRatio = initialSize
                
              
                window.titleVisibility = .hidden
                window.titlebarAppearsTransparent = true
                window.styleMask.insert(.fullSizeContentView)
                
               
                window.isMovableByWindowBackground = true
                
                
                window.standardWindowButton(.closeButton)?.isHidden = true
                window.standardWindowButton(.miniaturizeButton)?.isHidden = true
                window.standardWindowButton(.zoomButton)?.isHidden = true
                
                
                window.level = .floating
                
               
                window.collectionBehavior.insert(.canJoinAllSpaces)
            }
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
    
}

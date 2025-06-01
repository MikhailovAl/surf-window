import AppKit
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    
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

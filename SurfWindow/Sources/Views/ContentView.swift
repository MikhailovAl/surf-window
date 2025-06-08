import SwiftUICore

struct ContentView: View {
    
    let initialWidth: CGFloat
    private let videoInfo = LocalVideoPlayerView()
    
    @State private var isHovered = false
    
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
            .frame(
                minWidth: initialWidth,
                minHeight: initialHeight
            )
            
            WindowAccessor(
                initialSize: CGSize(
                    width: initialWidth,
                    height: initialHeight
                )
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            Text(isHovered ? "Settings in status bar" : "")
                .font(.footnote)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.top, 8)
                .background(Color.clear)
                .contentShape(Rectangle())  
                .onHover { inside in
                    isHovered = inside
                }
        }
    }
    
}

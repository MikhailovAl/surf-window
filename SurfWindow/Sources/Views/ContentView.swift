import SwiftUICore

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
            .frame(width: 0, height: 0)
        }
    }
    
}

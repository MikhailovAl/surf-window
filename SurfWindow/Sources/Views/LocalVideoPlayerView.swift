import SwiftUI
import AVKit

struct LocalVideoPlayerView {
    
    let player: AVQueuePlayer
    let looper: AVPlayerLooper?
    let aspectRatio: CGFloat

    init(fileNames: [String] = ["Video", "Video2"], fileExtension: String = "mp4") {
        
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


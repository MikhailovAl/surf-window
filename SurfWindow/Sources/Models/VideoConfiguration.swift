import Foundation

struct VideoMetadata: Codable {
    let name: String
    let path: URL
    let aspectRatio: CGFloat?
    let loopCount: Int?
    let autoPlay: Bool
    
    init(name: String, path: URL, aspectRatio: CGFloat? = nil, loopCount: Int? = nil, autoPlay: Bool = true) {
        self.name = name
        self.path = path
        self.aspectRatio = aspectRatio
        self.loopCount = loopCount
        self.autoPlay = autoPlay
    }
}

class VideoConfiguration: ObservableObject {
    static let shared = VideoConfiguration()
    
    @Published private(set) var videos: [VideoMetadata] = []
    @Published private(set) var currentVideo: VideoMetadata?
    
    private let configFileName = "video_config.json"
    private var configFileURL: URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("SurfWindow")
            .appendingPathComponent(configFileName)
    }
    
    private init() {
        createConfigDirectoryIfNeeded()
        loadConfiguration()
    }
    
    func addVideo(name: String, path: URL, aspectRatio: CGFloat? = nil, loopCount: Int? = nil, autoPlay: Bool = true) {
        let metadata = VideoMetadata(name: name, path: path, aspectRatio: aspectRatio, loopCount: loopCount, autoPlay: autoPlay)
        videos.append(metadata)
        saveConfiguration()
    }
    
    func removeVideo(name: String) {
        videos.removeAll { $0.name == name }
        if currentVideo?.name == name {
            currentVideo = videos.first
        }
        saveConfiguration()
    }
    
    func selectVideo(name: String) {
        currentVideo = videos.first { $0.name == name }
    }
    
    func selectRandomVideo() {
        guard !videos.isEmpty else { return }
        var newVideo = currentVideo
        newVideo = videos.randomElement()
        currentVideo = newVideo
    }
    
    private func createConfigDirectoryIfNeeded() {
        guard let configFileURL = configFileURL else { return }
        try? FileManager.default.createDirectory(
            at: configFileURL.deletingLastPathComponent(),
            withIntermediateDirectories: true
        )
    }
    
    private func loadConfiguration() {
        guard let configFileURL = configFileURL,
              let data = try? Data(contentsOf: configFileURL) else {
            return
        }
        
        if let loadedVideos = try? JSONDecoder().decode([VideoMetadata].self, from: data) {
            videos = loadedVideos
            currentVideo = videos.first
        }
    }
    
    private func saveConfiguration() {
        guard let configFileURL = configFileURL,
              let data = try? JSONEncoder().encode(videos) else {
            return
        }
        
        try? data.write(to: configFileURL)
    }
}

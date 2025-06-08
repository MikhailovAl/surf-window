import Foundation
import Combine

final class VideoManager: ObservableObject {
    
    static let shared = VideoManager(names: ["Video"])
    
    @Published private(set) var currentName: String
    private let allNames: [String]
    
    init(names: [String]) {
        self.allNames = names
        self.currentName = names.first ?? ""
    }
    
    func pickNextRandom() {
        guard allNames.count > 1 else { return }
        var newName = currentName
        while newName == currentName {
            newName = allNames.randomElement() ?? currentName
        }
        currentName = newName
    }
    
}

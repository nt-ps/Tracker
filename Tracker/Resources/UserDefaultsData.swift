import Foundation

final class UserDefaultsData {

    static let shared = UserDefaultsData()
    
    var hasLaunchBefore: Bool {
        get { storage.bool(forKey: Keys.hasLaunchBefore.rawValue) }
        set { storage.set(newValue, forKey: Keys.hasLaunchBefore.rawValue) }
    }
    
    private enum Keys: String {
        case hasLaunchBefore
    }
    
    private let storage: UserDefaults = .standard
    
    private init() { }
}

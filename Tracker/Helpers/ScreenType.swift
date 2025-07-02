import Foundation

final class ScreenType {
    
    static var shared = ScreenType()
    
    var isWithIsland: Bool {
        switch height {
        case 568.0, 667.0, 736.0:
            return false
        default:
            return true
        }
    }
    
    private var height: CGFloat?
    
    private init() { }
    
    func setHeight(_ height: CGFloat) {
        self.height = height
    }
}

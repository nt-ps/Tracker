protocol CategoriesSourceProtocol {
    var delegate: CategoriesSourceDelegate? { get set }
    var categories: [String] { get }
    
    func addCategory(_ title: String) throws
}

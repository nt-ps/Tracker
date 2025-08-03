protocol CategoriesSourceProtocol {
    var delegate: CategoriesSourceDelegate? { get set }
    var categories: [String] { get }
    
    func addCategory(_ title: String) throws
    func updateCategory(_ oldTitle: String, newTitle: String) throws
    func deleteCategory(_ title: String) throws
}

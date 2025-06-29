import UIKit

protocol TrackersNavigatorItemProtocol: AnyObject {
    var collection: TrackersCollectionViewProtocol? { get set }
    var selectedDate: Date { get }
    
    func showStub()
}

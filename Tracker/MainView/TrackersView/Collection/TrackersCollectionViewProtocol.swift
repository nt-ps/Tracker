protocol TrackersCollectionViewProtocol: AnyObject {
    var navigator: TrackersNavigatorItemProtocol? { get set }
    
    func updateTrackersCollection()
    func close()
}

import UIKit

final class TrackersStubView: UIView {
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(named: imageName)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = labelText
        labelView.font = UIFont.systemFont(ofSize: labelSize, weight: .medium)
        labelView.textColor = .AppColors.black
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    } ()
    
    private let imageName = "TrackersStubImage"
    private let labelText = "Что будем отслеживать?"
    private let labelSize = 12.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(imageView)
        self.addSubview(labelView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("TrackersStubView.init(coder:) has not been implemented")
    }
    
    func close() {
        self.willMove(toSuperview: nil)
        self.removeFromSuperview()
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            labelView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            labelView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
}

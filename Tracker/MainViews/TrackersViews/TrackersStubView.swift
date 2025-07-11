import UIKit

final class TrackersStubView: UIView {
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let image = UIImage(resource: imageResource)
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
    
    // MARK: - UI Properties
    
    private let imageResource: ImageResource = .trackersStub
    private let labelText = "Что будем отслеживать?"
    private let labelSize = 12.0
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("TrackersStubView.init(coder:) has not been implemented")
    }
    
    // MARK: - UI Updates
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            labelView.topAnchor.constraint(
                equalTo: imageView.bottomAnchor,
                constant: 8
            ),
            labelView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }
}

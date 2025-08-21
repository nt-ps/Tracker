import UIKit

final class StubView: UIView {
    
    // MARK: - Views
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    } ()
    
    private lazy var labelView: UILabel = {
        let labelView = UILabel()
        labelView.text = labelText
        labelView.font = UIFont.systemFont(ofSize: labelSize, weight: .medium)
        labelView.textColor = .AppColors.black
        labelView.textAlignment = .center
        labelView.numberOfLines = 2
        labelView.translatesAutoresizingMaskIntoConstraints = false
        return labelView
    } ()
    
    // MARK: - UI Properties

    private let labelSize = 12.0
    
    // MARK: - Internal Properties
    
    var labelText: String? {
        didSet {
            labelView.text = labelText
        }
    }
    
    var imageResource: ImageResource? {
        didSet {
            if let imageResource {
                imageView.image = UIImage(resource: imageResource)
            }
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        addSubview(labelView)
        
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
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

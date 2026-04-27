import UIKit

class PetMatchCard: UIView {
    
    var onTap: (() -> Void)?
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let matchBadge = UIView()
    private let matchLabel = UILabel()
    private let infoStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Container
        containerView.backgroundColor = ThemeService.shared.surfaceColor
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 12
        addSubview(containerView)
        
        // Pet image placeholder
        imageView.backgroundColor = UIColor.systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "pawprint.fill")
        imageView.tintColor = ThemeService.shared.textSecondary
        containerView.addSubview(imageView)
        
        // Name
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = ThemeService.shared.textPrimary
        containerView.addSubview(nameLabel)
        
        // Breed
        breedLabel.font = .systemFont(ofSize: 14)
        breedLabel.textColor = ThemeService.shared.textSecondary
        containerView.addSubview(breedLabel)
        
        // Match badge
        matchBadge.backgroundColor = ThemeService.shared.backgroundColor
        matchBadge.layer.cornerRadius = 12
        containerView.addSubview(matchBadge)
        
        matchLabel.font = .systemFont(ofSize: 14, weight: .bold)
        matchLabel.textColor = ThemeService.shared.textPrimary
        matchBadge.addSubview(matchLabel)
        
        // Info stack
        infoStackView.axis = .horizontal
        infoStackView.spacing = 16
        infoStackView.distribution = .fillEqually
        containerView.addSubview(infoStackView)
        
        setupConstraints()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        matchBadge.translatesAutoresizingMaskIntoConstraints = false
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
            
            matchBadge.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            matchBadge.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            matchBadge.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            matchLabel.topAnchor.constraint(equalTo: matchBadge.topAnchor, constant: 6),
            matchLabel.bottomAnchor.constraint(equalTo: matchBadge.bottomAnchor, constant: -6),
            matchLabel.leadingAnchor.constraint(equalTo: matchBadge.leadingAnchor, constant: 10),
            matchLabel.trailingAnchor.constraint(equalTo: matchBadge.trailingAnchor, constant: -10),
            
            infoStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            infoStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            infoStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            infoStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with result: MatchResult) {
        let pet = result.pet
        nameLabel.text = pet.name
        breedLabel.text = "\(pet.breed) • \(pet.age)"
        matchLabel.text = "\(result.matchPercentage)% Match"
        
        // Add info items
        infoStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let ageItem = createInfoItem(icon: "clock", text: pet.age)
        let sizeItem = createInfoItem(icon: "ruler", text: pet.size.rawValue)
        let locationItem = createInfoItem(icon: "location", text: "\(Int(pet.distanceMiles)) mi")
        
        infoStackView.addArrangedSubview(ageItem)
        infoStackView.addArrangedSubview(sizeItem)
        infoStackView.addArrangedSubview(locationItem)
    }
    
    private func createInfoItem(icon: String, text: String) -> UIView {
        let container = UIView()
        
        let iconImage = UIImageView(image: UIImage(systemName: icon))
        iconImage.tintColor = ThemeService.shared.textSecondary
        iconImage.contentMode = .scaleAspectFit
        container.addSubview(iconImage)
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeService.shared.textSecondary
        container.addSubview(label)
        
        iconImage.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImage.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            iconImage.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            iconImage.widthAnchor.constraint(equalToConstant: 16),
            iconImage.heightAnchor.constraint(equalToConstant: 16),
            
            label.leadingAnchor.constraint(equalTo: iconImage.trailingAnchor, constant: 4),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor)
        ])
        
        return container
    }
    
    @objc private func cardTapped() {
        onTap?()
    }
}

class PetSmallCard: UICollectionViewCell {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        containerView.backgroundColor = ThemeService.shared.surfaceColor
        containerView.layer.cornerRadius = 12
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.08
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)
        
        imageView.backgroundColor = UIColor.systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(systemName: "pawprint.fill")
        imageView.tintColor = ThemeService.shared.textSecondary
        containerView.addSubview(imageView)
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = ThemeService.shared.textPrimary
        containerView.addSubview(nameLabel)
        
        breedLabel.font = .systemFont(ofSize: 12)
        breedLabel.textColor = ThemeService.shared.textSecondary
        containerView.addSubview(breedLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 120),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            breedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            breedLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with pet: Pet) {
        nameLabel.text = pet.name
        breedLabel.text = pet.breed
    }
}
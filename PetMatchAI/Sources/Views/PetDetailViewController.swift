import UIKit

class PetDetailViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let matchBadge = UIView()
    private let matchLabel = UILabel()
    
    private let infoSection = UIView()
    private let descriptionLabel = UILabel()
    private let traitsStackView = UIStackView()
    private let shelterCard = UIView()
    private let applyButton = UIButton(type: .system)
    private let favoriteButton = UIButton(type: .system)
    
    private let pet: Pet
    
    init(pet: Pet) {
        self.pet = pet
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configure()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = pet.name
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .plain, target: self, action: #selector(favoriteTapped))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Image
        imageView.backgroundColor = UIColor.systemGray5
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "pawprint.fill")
        imageView.tintColor = ThemeService.shared.textSecondary
        contentView.addSubview(imageView)
        
        // Name & Breed
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(nameLabel)
        
        breedLabel.font = .systemFont(ofSize: 16)
        breedLabel.textColor = ThemeService.shared.textSecondary
        contentView.addSubview(breedLabel)
        
        // Match badge
        matchBadge.backgroundColor = ThemeService.shared.colors.success.withAlphaComponent(0.15)
        matchBadge.layer.cornerRadius = 12
        contentView.addSubview(matchBadge)
        
        matchLabel.font = .systemFont(ofSize: 14, weight: .bold)
        matchLabel.textColor = ThemeService.shared.colors.success
        matchBadge.addSubview(matchLabel)
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textColor = ThemeService.shared.textSecondary
        descriptionLabel.numberOfLines = 0
        contentView.addSubview(descriptionLabel)
        
        // Traits
        traitsStackView.axis = .horizontal
        traitsStackView.spacing = 8
        traitsStackView.distribution = .fillEqually
        contentView.addSubview(traitsStackView)
        
        // Shelter card
        shelterCard.backgroundColor = ThemeService.shared.surfaceColor
        shelterCard.layer.cornerRadius = 12
        contentView.addSubview(shelterCard)
        
        // Apply button
        applyButton.setTitle("Apply to Adopt", for: .normal)
        applyButton.setTitleColor(.white, for: .normal)
        applyButton.backgroundColor = ThemeService.shared.colors.primary
        applyButton.layer.cornerRadius = 12
        applyButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        applyButton.addTarget(self, action: #selector(applyTapped), for: .touchUpInside)
        contentView.addSubview(applyButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        matchBadge.translatesAutoresizingMaskIntoConstraints = false
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        traitsStackView.translatesAutoresizingMaskIntoConstraints = false
        shelterCard.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 300),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            breedLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            matchBadge.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor),
            matchBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            matchLabel.topAnchor.constraint(equalTo: matchBadge.topAnchor, constant: 8),
            matchLabel.bottomAnchor.constraint(equalTo: matchBadge.bottomAnchor, constant: -8),
            matchLabel.leadingAnchor.constraint(equalTo: matchBadge.leadingAnchor, constant: 12),
            matchLabel.trailingAnchor.constraint(equalTo: matchBadge.trailingAnchor, constant: -12),
            
            descriptionLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            traitsStackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            traitsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            traitsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            traitsStackView.heightAnchor.constraint(equalToConstant: 80),
            
            shelterCard.topAnchor.constraint(equalTo: traitsStackView.bottomAnchor, constant: 24),
            shelterCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            shelterCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            shelterCard.heightAnchor.constraint(equalToConstant: 100),
            
            applyButton.topAnchor.constraint(equalTo: shelterCard.bottomAnchor, constant: 24),
            applyButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            applyButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            applyButton.heightAnchor.constraint(equalToConstant: 50),
            applyButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func configure() {
        nameLabel.text = pet.name
        breedLabel.text = "\(pet.breed) • \(pet.age) • \(pet.gender)"
        descriptionLabel.text = pet.description
        matchLabel.text = "92% Match"
        
        // Add trait badges
        let traits = [
            ("heart.fill", pet.isGoodWithKids ? "Good with kids" : "Not for kids"),
            ("house.fill", pet.canBeAlone ? "Can be alone" : "Needs company"),
            ("dollarsign.circle", "$\(Int(pet.adoptionFee)) fee")
        ]
        
        for (icon, text) in traits {
            let traitView = createTraitView(icon: icon, text: text)
            traitsStackView.addArrangedSubview(traitView)
        }
        
        // Shelter info
        let shelterLabel = UILabel()
        shelterLabel.text = pet.shelterName
        shelterLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        shelterLabel.textColor = ThemeService.shared.textPrimary
        shelterCard.addSubview(shelterLabel)
        
        let locationLabel = UILabel()
        locationLabel.text = "\(pet.shelterLocation) • \(Int(pet.distanceMiles)) mi away"
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = ThemeService.shared.textSecondary
        shelterCard.addSubview(locationLabel)
        
        shelterLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            shelterLabel.topAnchor.constraint(equalTo: shelterCard.topAnchor, constant: 16),
            shelterLabel.leadingAnchor.constraint(equalTo: shelterCard.leadingAnchor, constant: 16),
            
            locationLabel.topAnchor.constraint(equalTo: shelterLabel.bottomAnchor, constant: 4),
            locationLabel.leadingAnchor.constraint(equalTo: shelterCard.leadingAnchor, constant: 16)
        ])
    }
    
    private func createTraitView(icon: String, text: String) -> UIView {
        let container = UIView()
        container.backgroundColor = ThemeService.shared.surfaceColor
        container.layer.cornerRadius = 8
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = ThemeService.shared.colors.primary
        iconView.contentMode = .scaleAspectFit
        container.addSubview(iconView)
        
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 12)
        label.textColor = ThemeService.shared.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 2
        container.addSubview(label)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 4),
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -4),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        
        return container
    }
    
    @objc private func favoriteTapped() {
        // Toggle favorite
        let isFavorite = navigationItem.rightBarButtonItem?.image == UIImage(systemName: "heart.fill")
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: isFavorite ? "heart" : "heart.fill")
    }
    
    @objc private func applyTapped() {
        let alert = UIAlertController(title: "Application Submitted!", message: "The shelter will contact you soon.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
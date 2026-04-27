import UIKit

class BrowseViewController: UIViewController {
    
    private let searchBar = UISearchBar()
    private let filterScrollView = UIScrollView()
    private let filterStackView = UIStackView()
    private var collectionView: UICollectionView!
    
    private var pets: [Pet] = Pet.samplePets
    private var filteredPets: [Pet] = []
    private var selectedFilters: Set<String> = []
    
    private let filterOptions = ["All", "Dogs", "Cats", "Birds", "Small Pets", "Near Me", "Under $200"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredPets = pets
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Browse Pets"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupSearchBar()
        setupFilters()
        setupCollectionView()
    }
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search by breed, name..."
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        view.addSubview(searchBar)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func setupFilters() {
        filterScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(filterScrollView)
        
        filterStackView.axis = .horizontal
        filterStackView.spacing = 8
        filterScrollView.addSubview(filterStackView)
        
        for (index, filter) in filterOptions.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(filter, for: .normal)
            button.setTitleColor(index == 0 ? .white : ThemeService.shared.textPrimary, for: .normal)
            button.backgroundColor = index == 0 ? ThemeService.shared.colors.primary : ThemeService.shared.surfaceColor
            button.layer.cornerRadius = 16
            button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
            button.tag = index
            button.addTarget(self, action: #selector(filterTapped(_:)), for: .touchUpInside)
            filterStackView.addArrangedSubview(button)
        }
        
        filterScrollView.translatesAutoresizingMaskIntoConstraints = false
        filterStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterScrollView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 8),
            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterScrollView.heightAnchor.constraint(equalToConstant: 40),
            
            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor),
            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor),
            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor),
            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
            filterStackView.heightAnchor.constraint(equalTo: filterScrollView.heightAnchor)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BrowsePetCell.self, forCellWithReuseIdentifier: "BrowsePetCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    @objc private func filterTapped(_ sender: UIButton) {
        // Reset all buttons
        for case let button as UIButton in filterStackView.arrangedSubviews {
            button.setTitleColor(ThemeService.shared.textPrimary, for: .normal)
            button.backgroundColor = ThemeService.shared.surfaceColor
        }
        
        // Highlight selected
        sender.setTitleColor(.white, for: .normal)
        sender.backgroundColor = ThemeService.shared.colors.primary
        
        applyFilters()
    }
    
    private func applyFilters() {
        let filter = filterOptions[0]
        
        switch filter {
        case "Dogs":
            filteredPets = pets.filter { $0.species == .dog }
        case "Cats":
            filteredPets = pets.filter { $0.species == .cat }
        case "Birds":
            filteredPets = pets.filter { $0.species == .bird }
        case "Small Pets":
            filteredPets = pets.filter { $0.species == .smallAnimal || $0.species == .reptile || $0.species == .fish }
        case "Near Me":
            filteredPets = pets.filter { $0.distanceMiles <= 25 }
        case "Under $200":
            filteredPets = pets.filter { $0.adoptionFee <= 200 }
        default:
            filteredPets = pets
        }
        
        collectionView.reloadData()
    }
}

extension BrowseViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowsePetCell", for: indexPath) as! BrowsePetCell
        cell.configure(with: filteredPets[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: width + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PetDetailViewController(pet: filteredPets[indexPath.item])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension BrowseViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            applyFilters()
        } else {
            filteredPets = pets.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.breed.lowercased().contains(searchText.lowercased())
            }
            collectionView.reloadData()
        }
    }
}

class BrowsePetCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let breedLabel = UILabel()
    private let matchLabel = UILabel()
    private let priceLabel = UILabel()
    
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
        imageView.layer.cornerRadius = 12
        imageView.image = UIImage(systemName: "pawprint.fill")
        imageView.tintColor = ThemeService.shared.textSecondary
        containerView.addSubview(imageView)
        
        nameLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        nameLabel.textColor = ThemeService.shared.textPrimary
        containerView.addSubview(nameLabel)
        
        breedLabel.font = .systemFont(ofSize: 12)
        breedLabel.textColor = ThemeService.shared.textSecondary
        containerView.addSubview(breedLabel)
        
        matchLabel.font = .systemFont(ofSize: 12, weight: .medium)
        matchLabel.textColor = ThemeService.shared.colors.success
        containerView.addSubview(matchLabel)
        
        priceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        priceLabel.textColor = ThemeService.shared.colors.primary
        containerView.addSubview(priceLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        breedLabel.translatesAutoresizingMaskIntoConstraints = false
        matchLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            breedLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            breedLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            matchLabel.topAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 4),
            matchLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            
            priceLabel.centerYAnchor.constraint(equalTo: matchLabel.centerYAnchor),
            priceLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with pet: Pet) {
        nameLabel.text = pet.name
        breedLabel.text = "\(pet.breed) • \(pet.age)"
        matchLabel.text = "\(pet.species.rawValue)"
        priceLabel.text = "$\(Int(pet.adoptionFee))"
    }
}
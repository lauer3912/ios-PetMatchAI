import UIKit

class FavoritesViewController: UIViewController {
    
    private let emptyStateView = UIView()
    private let collectionView: UICollectionView
    
    private var favorites: [Pet] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadFavorites()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupEmptyState()
        
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BrowsePetCell.self, forCellWithReuseIdentifier: "BrowsePetCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        let iconView = UIImageView(image: UIImage(systemName: "heart.slash"))
        iconView.tintColor = ThemeService.shared.textSecondary
        iconView.contentMode = .scaleAspectFit
        emptyStateView.addSubview(iconView)
        
        let titleLabel = UILabel()
        titleLabel.text = "No Favorites Yet"
        titleLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        titleLabel.textColor = ThemeService.shared.textPrimary
        titleLabel.textAlignment = .center
        emptyStateView.addSubview(titleLabel)
        
        let subtitleLabel = UILabel()
        subtitleLabel.text = "Browse pets and tap the heart icon to save your favorites here."
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = ThemeService.shared.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        emptyStateView.addSubview(subtitleLabel)
        
        let browseButton = UIButton(type: .system)
        browseButton.setTitle("Browse Pets", for: .normal)
        browseButton.setTitleColor(.white, for: .normal)
        browseButton.backgroundColor = ThemeService.shared.colors.primary
        browseButton.layer.cornerRadius = 12
        browseButton.addTarget(self, action: #selector(browseTapped), for: .touchUpInside)
        emptyStateView.addSubview(browseButton)
        
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        browseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            iconView.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            iconView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor),
            
            browseButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            browseButton.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            browseButton.widthAnchor.constraint(equalToConstant: 160),
            browseButton.heightAnchor.constraint(equalToConstant: 44),
            browseButton.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func loadFavorites() {
        // Load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "favorites"),
           let saved = try? JSONDecoder().decode([Pet].self, from: data) {
            favorites = saved
        }
        
        updateEmptyState()
    }
    
    private func updateEmptyState() {
        emptyStateView.isHidden = !favorites.isEmpty
        collectionView.isHidden = favorites.isEmpty
    }
    
    @objc private func browseTapped() {
        tabBarController?.selectedIndex = 1
    }
}

extension FavoritesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrowsePetCell", for: indexPath) as! BrowsePetCell
        cell.configure(with: favorites[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 44) / 2
        return CGSize(width: width, height: width + 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = PetDetailViewController(pet: favorites[indexPath.item])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
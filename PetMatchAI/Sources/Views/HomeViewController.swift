import UIKit

class HomeViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    // Header
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let profileButton = UIButton(type: .system)
    
    // Match section
    private let matchSectionLabel = UILabel()
    private let topMatchCard = PetMatchCard()
    private let viewAllButton = UIButton(type: .system)
    
    // Quick actions
    private let quickActionsLabel = UILabel()
    private let quizButton = UIButton(type: .system)
    private let browseButton = UIButton(type: .system)
    
    // Recent section
    private let recentLabel = UILabel()
    private let recentCollectionView: UICollectionView
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 160, height: 200)
        layout.minimumInteritemSpacing = 12
        recentCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "PetMatchAI"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Scroll view setup
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        setupHeader()
        setupMatchSection()
        setupQuickActions()
        setupRecentSection()
    }
    
    private func setupHeader() {
        headerLabel.text = "Find Your Perfect Pet"
        headerLabel.font = .systemFont(ofSize: 28, weight: .bold)
        headerLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(headerLabel)
        
        subtitleLabel.text = "AI-powered matching to find your ideal companion"
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = ThemeService.shared.textSecondary
        contentView.addSubview(subtitleLabel)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupMatchSection() {
        matchSectionLabel.text = "Your Top Match"
        matchSectionLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        matchSectionLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(matchSectionLabel)
        
        contentView.addSubview(topMatchCard)
        
        matchSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        topMatchCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            matchSectionLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            matchSectionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            topMatchCard.topAnchor.constraint(equalTo: matchSectionLabel.bottomAnchor, constant: 12),
            topMatchCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            topMatchCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            topMatchCard.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func setupQuickActions() {
        quickActionsLabel.text = "Quick Actions"
        quickActionsLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        quickActionsLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(quickActionsLabel)
        
        quizButton.setTitle("Take Quiz", for: .normal)
        quizButton.setImage(UIImage(systemName: "list.bullet.clipboard"), for: .normal)
        quizButton.backgroundColor = ThemeService.shared.backgroundColor
        quizButton.setTitleColor(ThemeService.shared.textPrimary, for: .normal)
        quizButton.tintColor = ThemeService.shared.textPrimary
        quizButton.layer.cornerRadius = 12
        quizButton.layer.borderWidth = 1
        quizButton.layer.borderColor = UIColor.systemGray4.cgColor
        quizButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        quizButton.addTarget(self, action: #selector(quizTapped), for: .touchUpInside)
        contentView.addSubview(quizButton)
        
        browseButton.setTitle("Browse Pets", for: .normal)
        browseButton.setImage(UIImage(systemName: "pawprint"), for: .normal)
        browseButton.backgroundColor = ThemeService.shared.backgroundColor
        browseButton.setTitleColor(ThemeService.shared.textPrimary, for: .normal)
        browseButton.tintColor = ThemeService.shared.textPrimary
        browseButton.layer.cornerRadius = 12
        browseButton.layer.borderWidth = 1
        browseButton.layer.borderColor = UIColor.systemGray4.cgColor
        browseButton.contentEdgeInsets = UIEdgeInsets(top: 12, left: 16, bottom: 12, right: 16)
        browseButton.addTarget(self, action: #selector(browseTapped), for: .touchUpInside)
        contentView.addSubview(browseButton)
        
        quickActionsLabel.translatesAutoresizingMaskIntoConstraints = false
        quizButton.translatesAutoresizingMaskIntoConstraints = false
        browseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            quickActionsLabel.topAnchor.constraint(equalTo: topMatchCard.bottomAnchor, constant: 24),
            quickActionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            quizButton.topAnchor.constraint(equalTo: quickActionsLabel.bottomAnchor, constant: 12),
            quizButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            browseButton.topAnchor.constraint(equalTo: quickActionsLabel.bottomAnchor, constant: 12),
            browseButton.leadingAnchor.constraint(equalTo: quizButton.trailingAnchor, constant: 12)
        ])
    }
    
    private func setupRecentSection() {
        recentLabel.text = "Recently Viewed"
        recentLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        recentLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(recentLabel)
        
        recentCollectionView.backgroundColor = .clear
        recentCollectionView.showsHorizontalScrollIndicator = false
        recentCollectionView.register(PetSmallCard.self, forCellWithReuseIdentifier: "PetSmallCard")
        recentCollectionView.dataSource = self
        recentCollectionView.delegate = self
        contentView.addSubview(recentCollectionView)
        
        recentLabel.translatesAutoresizingMaskIntoConstraints = false
        recentCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            recentLabel.topAnchor.constraint(equalTo: quizButton.bottomAnchor, constant: 24),
            recentLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            recentCollectionView.topAnchor.constraint(equalTo: recentLabel.bottomAnchor, constant: 12),
            recentCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            recentCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            recentCollectionView.heightAnchor.constraint(equalToConstant: 200),
            recentCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func loadData() {
        // Load sample data
        let userProfile = UserProfile.default
        let pets = Pet.samplePets
        let matches = MatchingService.shared.getTopMatches(for: userProfile, pets: pets, limit: 1)
        
        if let topMatch = matches.first {
            topMatchCard.configure(with: topMatch)
            topMatchCard.onTap = { [weak self] in
                self?.showPetDetail(topMatch.pet)
            }
        }
    }
    
    @objc private func quizTapped() {
        let quizVC = OnboardingViewController()
        navigationController?.pushViewController(quizVC, animated: true)
    }
    
    @objc private func browseTapped() {
        tabBarController?.selectedIndex = 1
    }
    
    private func showPetDetail(_ pet: Pet) {
        let detailVC = PetDetailViewController(pet: pet)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Pet.samplePets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetSmallCard", for: indexPath) as! PetSmallCard
        cell.configure(with: Pet.samplePets[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let pet = Pet.samplePets[indexPath.item]
        showPetDetail(pet)
    }
}
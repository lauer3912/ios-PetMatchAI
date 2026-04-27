import UIKit

class ProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let avatarView = UIView()
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let locationLabel = UILabel()
    
    private let statsStackView = UIStackView()
    private let quizProgressCard = UIView()
    private let settingsTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let settingsSections = [
        ("Preferences", ["Notifications", "Location", "Theme"]),
        ("Account", ["Edit Profile", "Privacy Policy", "Terms of Service"]),
        ("Subscription", ["Upgrade to Premium", "Manage Subscription"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setupAvatar()
        setupStats()
        setupQuizCard()
        setupSettings()
        setupConstraints()
    }
    
    private func setupAvatar() {
        avatarView.backgroundColor = ThemeService.shared.Colors.primary
        avatarView.layer.cornerRadius = 50
        contentView.addSubview(avatarView)
        
        avatarLabel.text = "JD"
        avatarLabel.font = .systemFont(ofSize: 28, weight: .bold)
        avatarLabel.textColor = .white
        avatarLabel.textAlignment = .center
        avatarView.addSubview(avatarLabel)
        
        nameLabel.text = "Pet Lover"
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.textColor = ThemeService.shared.textPrimary
        nameLabel.textAlignment = .center
        contentView.addSubview(nameLabel)
        
        locationLabel.text = "Los Angeles, CA"
        locationLabel.font = .systemFont(ofSize: 14)
        locationLabel.textColor = ThemeService.shared.textSecondary
        locationLabel.textAlignment = .center
        contentView.addSubview(locationLabel)
        
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupStats() {
        statsStackView.axis = .horizontal
        statsStackView.distribution = .fillEqually
        statsStackView.spacing = 16
        contentView.addSubview(statsStackView)
        
        let stats = [
            ("heart.fill", "12", "Matches"),
            ("clock.fill", "5", "Viewed"),
            ("star.fill", "3", "Saved")
        ]
        
        for (icon, value, label) in stats {
            let statView = createStatView(icon: icon, value: value, label: label)
            statsStackView.addArrangedSubview(statView)
        }
        
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func createStatView(icon: String, value: String, label: String) -> UIView {
        let container = UIView()
        container.backgroundColor = ThemeService.shared.surfaceColor
        container.layer.cornerRadius = 12
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = ThemeService.shared.Colors.primary
        iconView.contentMode = .scaleAspectFit
        container.addSubview(iconView)
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 20, weight: .bold)
        valueLabel.textColor = ThemeService.shared.textPrimary
        valueLabel.textAlignment = .center
        container.addSubview(valueLabel)
        
        let descLabel = UILabel()
        descLabel.text = label
        descLabel.font = .systemFont(ofSize: 12)
        descLabel.textColor = ThemeService.shared.textSecondary
        descLabel.textAlignment = .center
        container.addSubview(descLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            iconView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            valueLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 8),
            valueLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            
            descLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: 2),
            descLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            descLabel.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])
        
        return container
    }
    
    private func setupQuizCard() {
        quizProgressCard.backgroundColor = ThemeService.shared.surfaceColor
        quizProgressCard.layer.cornerRadius = 12
        contentView.addSubview(quizProgressCard)
        
        let titleLabel = UILabel()
        titleLabel.text = "Profile Completion"
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.textColor = ThemeService.shared.textPrimary
        quizProgressCard.addSubview(titleLabel)
        
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progress = 0.8
        progressBar.progressTintColor = ThemeService.shared.Colors.primary
        progressBar.trackTintColor = UIColor.systemGray4
        quizProgressCard.addSubview(progressBar)
        
        let percentLabel = UILabel()
        percentLabel.text = "80% Complete"
        percentLabel.font = .systemFont(ofSize: 12)
        percentLabel.textColor = ThemeService.shared.textSecondary
        quizProgressCard.addSubview(percentLabel)
        
        let completeButton = UIButton(type: .system)
        completeButton.setTitle("Complete Quiz", for: .normal)
        completeButton.setTitleColor(.white, for: .normal)
        completeButton.backgroundColor = ThemeService.shared.Colors.primary
        completeButton.layer.cornerRadius = 8
        completeButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        completeButton.addTarget(self, action: #selector(completeQuizTapped), for: .touchUpInside)
        quizProgressCard.addSubview(completeButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        percentLabel.translatesAutoresizingMaskIntoConstraints = false
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: quizProgressCard.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: quizProgressCard.leadingAnchor, constant: 16),
            
            progressBar.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressBar.leadingAnchor.constraint(equalTo: quizProgressCard.leadingAnchor, constant: 16),
            progressBar.trailingAnchor.constraint(equalTo: completeButton.leadingAnchor, constant: -16),
            progressBar.heightAnchor.constraint(equalToConstant: 8),
            
            percentLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 4),
            percentLabel.leadingAnchor.constraint(equalTo: quizProgressCard.leadingAnchor, constant: 16),
            percentLabel.bottomAnchor.constraint(equalTo: quizProgressCard.bottomAnchor, constant: -16),
            
            completeButton.centerYAnchor.constraint(equalTo: quizProgressCard.centerYAnchor),
            completeButton.trailingAnchor.constraint(equalTo: quizProgressCard.trailingAnchor, constant: -16),
            completeButton.widthAnchor.constraint(equalToConstant: 120),
            completeButton.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        quizProgressCard.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSettings() {
        settingsTableView.backgroundColor = .clear
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        contentView.addSubview(settingsTableView)
        
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            avatarView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            avatarView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarView.widthAnchor.constraint(equalToConstant: 100),
            avatarView.heightAnchor.constraint(equalToConstant: 100),
            
            avatarLabel.centerXAnchor.constraint(equalTo: avatarView.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: avatarView.centerYAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 12),
            nameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            locationLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            statsStackView.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 24),
            statsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statsStackView.heightAnchor.constraint(equalToConstant: 100),
            
            quizProgressCard.topAnchor.constraint(equalTo: statsStackView.bottomAnchor, constant: 24),
            quizProgressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            quizProgressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            quizProgressCard.heightAnchor.constraint(equalToConstant: 80),
            
            settingsTableView.topAnchor.constraint(equalTo: quizProgressCard.bottomAnchor, constant: 8),
            settingsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            settingsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            settingsTableView.heightAnchor.constraint(equalToConstant: 300),
            settingsTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func completeQuizTapped() {
        let quizVC = OnboardingViewController()
        navigationController?.pushViewController(quizVC, animated: true)
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settingsSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsSections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsSections[section].0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.textLabel?.text = settingsSections[indexPath.section].1[indexPath.row]
        cell.textLabel?.textColor = ThemeService.shared.textPrimary
        cell.accessoryType = .disclosureIndicator
        cell.backgroundColor = ThemeService.shared.surfaceColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
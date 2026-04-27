import UIKit

class OnboardingViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let questionsContainer = UIView()
    private let nextButton = UIButton(type: .system)
    private let skipButton = UIButton(type: .system)
    
    private var currentQuestionIndex = 0
    private var userProfile = UserProfile.default
    
    private let questions: [(question: String, options: [String], keyPath: String, values: [Any])] = [
        ("What type of home do you live in?", ["Apartment", "House with Yard", "House without Yard", "Studio"], "livingSpace", ["apartment", "houseWithYard", "houseNoYard", "apartment"]),
        ("Do you have a yard?", ["Yes", "No"], "hasYard", [true, false]),
        ("Do you have children at home?", ["Yes", "No"], "hasChildren", [true, false]),
        ("Do you have other pets?", ["Yes", "No"], "hasOtherPets", [true, false]),
        ("Do you work from home?", ["Yes, full time", "Sometimes", "No"], "workFromHome", [true, true, false]),
        ("How many hours per day will your pet be alone?", ["Less than 4", "4-6 hours", "More than 6"], "hoursAwayFromHome", [4, 6, 8]),
        ("What is your monthly pet budget?", ["Under $50", "$50-$100", "$100-$200", "$200+"], "maxMonthlyBudget", [50.0, 75.0, 150.0, 250.0]),
        ("Are you a first-time pet owner?", ["Yes", "No"], "isFirstTimeOwner", [true, false]),
        ("Preferred pet size?", ["Small", "Medium", "Large", "No preference"], "preferredSize", ["small", "medium", "large", "medium"]),
        ("Preferred energy level?", ["Low - Couch potato", "Moderate - Regular walks", "High - Very active", "No preference"], "preferredEnergy", ["low", "moderate", "high", "moderate"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        showQuestion(at: 0)
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Pet Match Quiz"
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.font = .systemFont(ofSize: 28, weight: .bold)
        titleLabel.textColor = ThemeService.shared.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = ThemeService.shared.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Answer a few questions to find your perfect match"
        contentView.addSubview(subtitleLabel)
        
        progressView.progressTintColor = ThemeService.shared.Colors.primary
        progressView.trackTintColor = UIColor.systemGray4
        contentView.addSubview(progressView)
        
        questionsContainer.backgroundColor = .clear
        contentView.addSubview(questionsContainer)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = ThemeService.shared.Colors.primary
        nextButton.layer.cornerRadius = 12
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        contentView.addSubview(nextButton)
        
        skipButton.setTitle("Skip Quiz", for: .normal)
        skipButton.setTitleColor(ThemeService.shared.textSecondary, for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped), for: .touchUpInside)
        contentView.addSubview(skipButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        questionsContainer.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            progressView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            questionsContainer.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 32),
            questionsContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            questionsContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            nextButton.topAnchor.constraint(equalTo: questionsContainer.bottomAnchor, constant: 32),
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            skipButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 16),
            skipButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            skipButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func showQuestion(at index: Int) {
        guard index < questions.count else {
            completeQuiz()
            return
        }
        
        currentQuestionIndex = index
        let q = questions[index]
        
        // Update progress
        progressView.setProgress(Float(index + 1) / Float(questions.count), animated: true)
        titleLabel.text = q.question
        
        // Clear previous options
        questionsContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // Add option buttons
        var lastView: UIView?
        for (optionIndex, option) in q.options.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(option, for: .normal)
            button.setTitleColor(ThemeService.shared.textPrimary, for: .normal)
            button.backgroundColor = ThemeService.shared.surfaceColor
            button.layer.cornerRadius = 12
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.tag = optionIndex
            button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
            questionsContainer.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: questionsContainer.leadingAnchor),
                button.trailingAnchor.constraint(equalTo: questionsContainer.trailingAnchor),
                button.heightAnchor.constraint(equalToConstant: 56),
                button.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? questionsContainer.topAnchor, constant: lastView == nil ? 0 : 12)
            ])
            
            lastView = button
        }
        
        // Update button text
        if index == questions.count - 1 {
            nextButton.setTitle("Complete Quiz", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        let q = questions[currentQuestionIndex]
        
        // Highlight selected
        for case let button as UIButton in questionsContainer.subviews {
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.backgroundColor = ThemeService.shared.surfaceColor
        }
        sender.layer.borderColor = ThemeService.shared.Colors.primary.cgColor
        sender.backgroundColor = ThemeService.shared.Colors.primary.withAlphaComponent(0.1)
        
        // Store answer
        let value = q.values[sender.tag]
        switch q.keyPath {
        case "livingSpace":
            userProfile.livingSpace = LivingSpace.allCases.first { $0.rawValue == q.options[sender.tag] } ?? .apartment
        case "hasYard":
            userProfile.hasYard = value as? Bool ?? false
        case "hasChildren":
            userProfile.hasChildren = value as? Bool ?? false
        case "hasOtherPets":
            userProfile.hasOtherPets = value as? Bool ?? false
        case "workFromHome":
            if sender.tag == 0 {
                userProfile.workFromHome = true
                userProfile.hoursAwayFromHome = 2
            } else if sender.tag == 1 {
                userProfile.workFromHome = true
                userProfile.hoursAwayFromHome = 5
            } else {
                userProfile.workFromHome = false
                userProfile.hoursAwayFromHome = 8
            }
        case "hoursAwayFromHome":
            userProfile.hoursAwayFromHome = value as? Int ?? 6
        case "maxMonthlyBudget":
            userProfile.maxMonthlyBudget = value as? Double ?? 150
        case "isFirstTimeOwner":
            userProfile.isFirstTimeOwner = value as? Bool ?? true
        case "preferredSize":
            userProfile.preferredSize = PetSize.allCases[sender.tag]
        case "preferredEnergy":
            userProfile.preferredEnergy = EnergyLevel.allCases[sender.tag]
        default:
            break
        }
    }
    
    @objc private func nextTapped() {
        showQuestion(at: currentQuestionIndex + 1)
    }
    
    @objc private func skipTapped() {
        completeQuiz()
    }
    
    private func completeQuiz() {
        userProfile.quizCompleted = true
        userProfile.quizCompletionDate = Date()
        
        // Save to UserDefaults
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "userProfile")
            UserDefaults.standard.set(true, forKey: "hasCompletedQuiz")
        }
        
        // Navigate to main app
        let mainTabBar = MainTabBarController()
        mainTabBar.modalPresentationStyle = .fullScreen
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = mainTabBar
            window.makeKeyAndVisible()
        }
    }
}
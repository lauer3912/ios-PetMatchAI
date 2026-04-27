import UIKit

class QuizViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let progressView = UIProgressView(progressViewStyle: .default)
    private let questionLabel = UILabel()
    private let optionsStackView = UIStackView()
    
    private let nextButton = UIButton(type: .system)
    private let backButton = UIButton(type: .system)
    
    private var currentQuestionIndex = 0
    private var userAnswers: [String: Any] = [:]
    private let questions: [QuizQuestionModel]
    
    init(questions: [QuizQuestionModel]) {
        self.questions = questions
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayQuestion()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Pet Match Quiz"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeTapped))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        progressView.progressTintColor = ThemeService.shared.Colors.primary
        progressView.trackTintColor = UIColor.systemGray4
        contentView.addSubview(progressView)
        
        questionLabel.font = .systemFont(ofSize: 24, weight: .bold)
        questionLabel.textColor = ThemeService.shared.textPrimary
        questionLabel.numberOfLines = 0
        questionLabel.textAlignment = .center
        contentView.addSubview(questionLabel)
        
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 12
        optionsStackView.distribution = .fillEqually
        contentView.addSubview(optionsStackView)
        
        nextButton.setTitle("Next", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = ThemeService.shared.Colors.primary
        nextButton.layer.cornerRadius = 12
        nextButton.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .touchUpInside)
        nextButton.isHidden = true
        contentView.addSubview(nextButton)
        
        backButton.setTitle("Back", for: .normal)
        backButton.setTitleColor(ThemeService.shared.textSecondary, for: .normal)
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.isHidden = true
        contentView.addSubview(backButton)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        progressView.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
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
            
            progressView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            questionLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 32),
            questionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            questionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            optionsStackView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 32),
            optionsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            optionsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            
            nextButton.topAnchor.constraint(equalTo: optionsStackView.bottomAnchor, constant: 32),
            nextButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            nextButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            nextButton.heightAnchor.constraint(equalToConstant: 50),
            
            backButton.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: 12),
            backButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            backButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
    
    private func displayQuestion() {
        guard currentQuestionIndex < questions.count else {
            completeQuiz()
            return
        }
        
        let question = questions[currentQuestionIndex]
        
        progressView.setProgress(Float(currentQuestionIndex + 1) / Float(questions.count), animated: true)
        questionLabel.text = question.text
        
        optionsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for (index, option) in question.options.enumerated() {
            let button = createOptionButton(title: option, tag: index)
            optionsStackView.addArrangedSubview(button)
        }
        
        nextButton.isHidden = true
        backButton.isHidden = currentQuestionIndex == 0
        
        if currentQuestionIndex == questions.count - 1 {
            nextButton.setTitle("Complete", for: .normal)
        } else {
            nextButton.setTitle("Next", for: .normal)
        }
    }
    
    private func createOptionButton(title: String, tag: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(ThemeService.shared.textPrimary, for: .normal)
        button.backgroundColor = ThemeService.shared.surfaceColor
        button.layer.cornerRadius = 12
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.clear.cgColor
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.tag = tag
        button.addTarget(self, action: #selector(optionSelected(_:)), for: .touchUpInside)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        return button
    }
    
    @objc private func optionSelected(_ sender: UIButton) {
        let question = questions[currentQuestionIndex]
        
        // Reset all buttons
        for case let button as UIButton in optionsStackView.arrangedSubviews {
            button.layer.borderColor = UIColor.clear.cgColor
            button.backgroundColor = ThemeService.shared.surfaceColor
        }
        
        // Highlight selected
        sender.layer.borderColor = ThemeService.shared.Colors.primary.cgColor
        sender.backgroundColor = ThemeService.shared.Colors.primary.withAlphaComponent(0.1)
        
        // Store answer
        userAnswers[question.key] = question.values[sender.tag]
        
        nextButton.isHidden = false
    }
    
    @objc private func nextTapped() {
        currentQuestionIndex += 1
        displayQuestion()
    }
    
    @objc private func backTapped() {
        currentQuestionIndex -= 1
        displayQuestion()
    }
    
    @objc private func closeTapped() {
        let alert = UIAlertController(title: "Exit Quiz?", 
                                      message: "Your progress will be lost.", 
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Exit", style: .destructive) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel))
        present(alert, animated: true)
    }
    
    private func completeQuiz() {
        // Build user profile from answers
        var profile = UserProfile.default
        
        if let livingSpace = userAnswers["livingSpace"] as? LivingSpace {
            profile.livingSpace = livingSpace
        }
        if let hasYard = userAnswers["hasYard"] as? Bool {
            profile.hasYard = hasYard
        }
        if let hasChildren = userAnswers["hasChildren"] as? Bool {
            profile.hasChildren = hasChildren
        }
        if let hasOtherPets = userAnswers["hasOtherPets"] as? Bool {
            profile.hasOtherPets = hasOtherPets
        }
        if let workFromHome = userAnswers["workFromHome"] as? Bool {
            profile.workFromHome = workFromHome
            profile.hoursAwayFromHome = workFromHome ? 2 : 8
        }
        if let hoursAway = userAnswers["hoursAwayFromHome"] as? Int {
            profile.hoursAwayFromHome = hoursAway
        }
        if let budget = userAnswers["maxMonthlyBudget"] as? Double {
            profile.maxMonthlyBudget = budget
        }
        if let firstTime = userAnswers["isFirstTimeOwner"] as? Bool {
            profile.isFirstTimeOwner = firstTime
        }
        if let preferredSize = userAnswers["preferredSize"] as? PetSize {
            profile.preferredSize = preferredSize
        }
        if let preferredEnergy = userAnswers["preferredEnergy"] as? EnergyLevel {
            profile.preferredEnergy = preferredEnergy
        }
        
        profile.quizCompleted = true
        profile.quizCompletionDate = Date()
        
        // Save profile
        DataService.shared.saveUserProfile(profile)
        DataService.shared.setQuizCompleted(true)
        
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

// MARK: - Quiz Question Model
struct QuizQuestionModel {
    let text: String
    let options: [String]
    let values: [Any]
    let key: String
}

// MARK: - Quiz Data
extension QuizViewController {
    static func defaultQuizQuestions() -> [QuizQuestionModel] {
        return [
            QuizQuestionModel(
                text: "What type of home do you live in?",
                options: ["Apartment", "House with Yard", "House without Yard", "Studio"],
                values: [LivingSpace.apartment, LivingSpace.houseWithYard, LivingSpace.houseNoYard, LivingSpace.apartment],
                key: "livingSpace"
            ),
            QuizQuestionModel(
                text: "Do you have a yard?",
                options: ["Yes", "No"],
                values: [true, false],
                key: "hasYard"
            ),
            QuizQuestionModel(
                text: "Do you have children at home?",
                options: ["Yes", "No"],
                values: [true, false],
                key: "hasChildren"
            ),
            QuizQuestionModel(
                text: "Do you have other pets?",
                options: ["Yes", "No"],
                values: [true, false],
                key: "hasOtherPets"
            ),
            QuizQuestionModel(
                text: "Do you work from home?",
                options: ["Yes, full time", "Sometimes", "No"],
                values: [true, true, false],
                key: "workFromHome"
            ),
            QuizQuestionModel(
                text: "How many hours per day will your pet be alone?",
                options: ["Less than 4", "4-6 hours", "More than 6"],
                values: [4, 6, 8],
                key: "hoursAwayFromHome"
            ),
            QuizQuestionModel(
                text: "What is your monthly pet budget?",
                options: ["Under $50", "$50-$100", "$100-$200", "$200+"],
                values: [50.0, 75.0, 150.0, 250.0],
                key: "maxMonthlyBudget"
            ),
            QuizQuestionModel(
                text: "Are you a first-time pet owner?",
                options: ["Yes", "No"],
                values: [true, false],
                key: "isFirstTimeOwner"
            ),
            QuizQuestionModel(
                text: "Preferred pet size?",
                options: ["Small", "Medium", "Large", "No preference"],
                values: [PetSize.small, PetSize.medium, PetSize.large, PetSize.medium],
                key: "preferredSize"
            ),
            QuizQuestionModel(
                text: "Preferred energy level?",
                options: ["Low - Couch potato", "Moderate - Regular walks", "High - Very active", "No preference"],
                values: [EnergyLevel.low, EnergyLevel.moderate, EnergyLevel.high, EnergyLevel.moderate],
                key: "preferredEnergy"
            )
        ]
    }
}
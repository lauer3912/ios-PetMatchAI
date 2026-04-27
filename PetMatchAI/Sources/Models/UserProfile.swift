import Foundation

struct UserProfile: Codable {
    var name: String
    var location: String
    var photoURL: String?
    var preferredDistance: Int // miles
    
    // Lifestyle quiz answers
    var livingSpace: LivingSpace
    var hasYard: Bool
    var hasChildren: Bool
    var childrenAges: [Int]
    var hasOtherPets: Bool
    var otherPetTypes: [PetSpecies]
    var workFromHome: Bool
    var hoursAwayFromHome: Int
    var isFirstTimeOwner: Bool
    var preferredSize: PetSize
    var preferredEnergy: EnergyLevel
    var maxMonthlyBudget: Double
    var preferredSpecies: [PetSpecies]
    var isAllergicToCats: Bool
    var isAllergicToDogs: Bool
    
    var quizCompleted: Bool
    var quizCompletionDate: Date?
    
    static var `default`: UserProfile {
        return UserProfile(
            name: "",
            location: "",
            photoURL: nil,
            preferredDistance: 50,
            livingSpace: .apartment,
            hasYard: false,
            hasChildren: false,
            childrenAges: [],
            hasOtherPets: false,
            otherPetTypes: [],
            workFromHome: false,
            hoursAwayFromHome: 8,
            isFirstTimeOwner: true,
            preferredSize: .medium,
            preferredEnergy: .moderate,
            maxMonthlyBudget: 200,
            preferredSpecies: [.dog, .cat],
            isAllergicToCats: false,
            isAllergicToDogs: false,
            quizCompleted: false,
            quizCompletionDate: nil
        )
    }
}

struct QuizQuestion {
    let id: Int
    let question: String
    let options: [QuizOption]
    let category: QuizCategory
}

struct QuizOption {
    let text: String
    let value: String
}

enum QuizCategory: String {
    case livingSpace = "Living Space"
    case lifestyle = "Lifestyle"
    case family = "Family"
    case budget = "Budget"
    case preferences = "Preferences"
}

struct MatchResult {
    let pet: Pet
    let matchPercentage: Int
    let matchReasons: [String]
    let dealbreakers: [String]
}
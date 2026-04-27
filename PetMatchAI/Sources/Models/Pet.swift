import Foundation

enum PetSpecies: String, CaseIterable, Codable {
    case dog = "Dog"
    case cat = "Cat"
    case bird = "Bird"
    case fish = "Fish"
    case reptile = "Reptile"
    case smallAnimal = "Small Animal"
    
    var icon: String {
        switch self {
        case .dog: return "🐕"
        case .cat: return "🐈"
        case .bird: return "🐦"
        case .fish: return "🐟"
        case .reptile: return "🦎"
        case .smallAnimal: return "🐹"
        }
    }
}

enum PetSize: String, CaseIterable, Codable {
    case small = "Small"
    case medium = "Medium"
    case large = "Large"
}

enum EnergyLevel: String, CaseIterable, Codable {
    case low = "Low"
    case moderate = "Moderate"
    case high = "High"
    case veryHigh = "Very High"
}

enum LivingSpace: String, CaseIterable, Codable {
    case apartment = "Apartment"
    case houseWithYard = "House with Yard"
    case houseNoYard = "House without Yard"
    case studio = "Studio"
}

struct Pet: Codable, Identifiable {
    let id: String
    let name: String
    let species: PetSpecies
    let breed: String
    let age: String
    let size: PetSize
    let gender: String
    let photos: [String]
    let description: String
    
    // Personality traits
    let energyLevel: EnergyLevel
    let isGoodWithKids: Bool
    let isGoodWithDogs: Bool
    let isGoodWithCats: Bool
    let isGoodWithStrangers: Bool
    let canBeAlone: Bool
    
    // Care requirements
    let groomingNeeds: String
    let exerciseNeeds: String
    let commonHealthIssues: [String]
    let estimatedMonthlyCost: Double
    let adoptionFee: Double
    let lifespanYears: Int
    
    // Location
    let shelterName: String
    let shelterLocation: String
    let distanceMiles: Double
    
    // Matching
    var matchScore: Int = 0
    
    static func == (lhs: Pet, rhs: Pet) -> Bool {
        return lhs.id == rhs.id
    }
}

// Sample data for development
extension Pet {
    static let samplePets: [Pet] = [
        Pet(id: "1", name: "Max", species: .dog, breed: "Golden Retriever", age: "2 years", size: .large, gender: "Male", photos: ["max1", "max2", "max3"], description: "Max is a friendly and energetic Golden Retriever who loves to play fetch and swim.", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "High - regular brushing needed", exerciseNeeds: "High - 2+ hours daily", commonHealthIssues: ["Hip dysplasia", "Eye issues"], estimatedMonthlyCost: 150, adoptionFee: 250, lifespanYears: 12, shelterName: "Happy Paws Shelter", shelterLocation: "Los Angeles, CA", distanceMiles: 15),
        
        Pet(id: "2", name: "Luna", species: .cat, breed: "Siamese", age: "1 year", size: .small, gender: "Female", photos: ["luna1", "luna2"], description: "Luna is a vocal and affectionate Siamese cat who loves to cuddle.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: false, canBeAlone: true, groomingNeeds: "Low - occasional brushing", exerciseNeeds: "Moderate - playtime needed", commonHealthIssues: ["Progressive retinal atrophy"], estimatedMonthlyCost: 80, adoptionFee: 150, lifespanYears: 15, shelterName: "Feline Friends", shelterLocation: "San Francisco, CA", distanceMiles: 22),
        
        Pet(id: "3", name: "Buddy", species: .dog, breed: "Beagle", age: "4 years", size: .medium, gender: "Male", photos: ["buddy1", "buddy2", "buddy3"], description: "Buddy is a curious and friendly Beagle who follows his nose everywhere!", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Low - occasional brushing", exerciseNeeds: "High - 1-2 hours daily", commonHealthIssues: ["Ear infections", "Obesity"], estimatedMonthlyCost: 100, adoptionFee: 200, lifespanYears: 14, shelterName: "Rescue Me", shelterLocation: "Seattle, WA", distanceMiles: 8),
        
        Pet(id: "4", name: "Whiskers", species: .cat, breed: "Maine Coon", age: "3 years", size: .medium, gender: "Male", photos: ["whiskers1", "whiskers2"], description: "Whiskers is a gentle giant who loves to lounge and be brushed.", energyLevel: .low, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "High - daily brushing required", exerciseNeeds: "Low - occasional play", commonHealthIssues: ["Hypertrophic cardiomyopathy"], estimatedMonthlyCost: 120, adoptionFee: 175, lifespanYears: 13, shelterName: "Cozy Cats", shelterLocation: "Portland, OR", distanceMiles: 35),
        
        Pet(id: "5", name: "Rocky", species: .dog, breed: "German Shepherd", age: "5 years", size: .large, gender: "Male", photos: ["rocky1", "rocky2"], description: "Rocky is a loyal and intelligent German Shepherd looking for an active family.", energyLevel: .veryHigh, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: false, isGoodWithStrangers: false, canBeAlone: true, groomingNeeds: "Moderate - weekly brushing", exerciseNeeds: "Very High - 3+ hours daily", commonHealthIssues: ["Hip dysplasia", "Elbow dysplasia"], estimatedMonthlyCost: 180, adoptionFee: 300, lifespanYears: 11, shelterName: "K9 Rescue", shelterLocation: "Denver, CO", distanceMiles: 45),
        
        Pet(id: "6", name: "Coco", species: .bird, breed: "Cockatiel", age: "1 year", size: .small, gender: "Female", photos: ["coco1", "coco2"], description: "Coco is a cheerful cockatiel who loves to whistle and dance.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Low - occasional bath", exerciseNeeds: "Moderate - out of cage time", commonHealthIssues: ["Respiratory infections"], estimatedMonthlyCost: 40, adoptionFee: 75, lifespanYears: 20, shelterName: "Wings of Hope", shelterLocation: "Austin, TX", distanceMiles: 12)
    ]
}
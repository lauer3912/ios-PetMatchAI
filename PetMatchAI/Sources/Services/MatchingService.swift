import Foundation

class MatchingService {
    static let shared = MatchingService()
    
    private init() {}
    
    func calculateMatchScore(user: UserProfile, pet: Pet) -> MatchResult {
        var score = 0
        var reasons: [String] = []
        var dealbreakers: [String] = []
        
        // Species preference check
        if user.preferredSpecies.contains(pet.species) {
            score += 25
            reasons.append("Matches your preferred \(pet.species.rawValue)")
        } else {
            score -= 50
            dealbreakers.append("Not your preferred pet type")
        }
        
        // Allergy check
        if pet.species == .cat && user.isAllergicToCats {
            dealbreakers.append("You are allergic to cats")
            score = 0
        }
        if pet.species == .dog && user.isAllergicToDogs {
            dealbreakers.append("You are allergic to dogs")
            score = 0
        }
        
        // Size preference
        if user.preferredSize == pet.size {
            score += 15
            reasons.append("Perfect size for your preference")
        } else if pet.size == .medium {
            score += 5
        }
        
        // Energy level match
        let energyMatch = calculateEnergyMatch(user: user, pet: pet)
        score += energyMatch.score
        reasons.append(contentsOf: energyMatch.reasons)
        
        // Living space compatibility
        if pet.species == .dog && user.livingSpace == .apartment {
            if pet.size == .large {
                dealbreakers.append("Large dog may struggle in an apartment")
                score -= 20
            } else {
                score += 5
                reasons.append("Good fit for apartment living")
            }
        }
        
        if pet.species == .dog && user.hasYard {
            score += 10
            reasons.append("Your yard is perfect for this dog")
        }
        
        // Family compatibility
        if user.hasChildren && pet.isGoodWithKids {
            score += 15
            reasons.append("Great with children")
        } else if user.hasChildren && !pet.isGoodWithKids {
            dealbreakers.append("Not recommended for homes with children")
            score -= 30
        }
        
        // Other pets compatibility
        if user.hasOtherPets {
            var compatibleWithOthers = true
            if pet.species == .dog && !pet.isGoodWithDogs {
                compatibleWithOthers = false
            }
            if pet.species == .cat && !pet.isGoodWithCats {
                compatibleWithOthers = false
            }
            if compatibleWithOthers {
                score += 10
                reasons.append("Good with other pets")
            } else {
                score -= 15
            }
        }
        
        // Alone time compatibility
        if user.hoursAwayFromHome > 6 && !pet.canBeAlone {
            dealbreakers.append("This pet needs more companionship than you can provide")
            score -= 25
        } else if user.hoursAwayFromHome <= 4 {
            score += 10
            reasons.append("Your schedule fits this pet's needs")
        }
        
        // First-time owner check
        if user.isFirstTimeOwner {
            if pet.species == .dog && (pet.breed == "German Shepherd" || pet.breed == "Rottweiler") {
                score -= 10
                reasons.append("May be challenging for first-time owners")
            } else {
                score += 5
            }
        }
        
        // Budget check
        if pet.estimatedMonthlyCost <= user.maxMonthlyBudget {
            score += 10
            reasons.append("Fits your budget")
        } else {
            score -= 15
            reasons.append("May be more expensive than your budget allows")
        }
        
        // Clamp score to 0-100
        let finalScore = max(0, min(100, score))
        
        return MatchResult(
            pet: pet,
            matchPercentage: finalScore,
            matchReasons: reasons,
            dealbreakers: dealbreakers
        )
    }
    
    private func calculateEnergyMatch(user: UserProfile, pet: Pet) -> (score: Int, reasons: [String]) {
        var score = 0
        var reasons: [String] = []
        
        switch user.preferredEnergy {
        case .low:
            if pet.energyLevel == .low || pet.energyLevel == .moderate {
                score = 20
                reasons.append("Energy level matches your lifestyle")
            } else if pet.energyLevel == .high {
                score = -10
                reasons.append("May require more exercise than you prefer")
            }
        case .moderate:
            if pet.energyLevel == .moderate {
                score = 20
                reasons.append("Perfect energy match")
            } else if pet.energyLevel == .low || pet.energyLevel == .high {
                score = 10
            }
        case .high:
            if pet.energyLevel == .high || pet.energyLevel == .veryHigh {
                score = 20
                reasons.append("Matches your active lifestyle")
            } else {
                score = -5
            }
        case .veryHigh:
            if pet.energyLevel == .veryHigh {
                score = 20
                reasons.append("Perfect for your very active lifestyle")
            } else if pet.energyLevel == .high {
                score = 10
            }
        }
        
        return (score, reasons)
    }
    
    func getTopMatches(for user: UserProfile, pets: [Pet], limit: Int = 20) -> [MatchResult] {
        let results = pets.map { calculateMatchScore(user: user, pet: $0) }
        let filtered = results.filter { $0.matchPercentage >= 30 || $0.dealbreakers.isEmpty }
        return filtered.sorted { $0.matchPercentage > $1.matchPercentage }.prefix(limit).map { $0 }
    }
}
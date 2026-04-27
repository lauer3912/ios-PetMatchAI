import XCTest
@testable import PetMatchAI

final class PetMatchAITests: XCTestCase {

    func testPetModelInitialization() throws {
        let pet = Pet(
            id: "test-1",
            name: "Buddy",
            species: .dog,
            breed: "Golden Retriever",
            age: "2 years",
            size: .large,
            gender: "Male",
            photos: ["photo1"],
            description: "A friendly dog",
            energyLevel: .high,
            isGoodWithKids: true,
            isGoodWithDogs: true,
            isGoodWithCats: false,
            isGoodWithStrangers: true,
            canBeAlone: false,
            groomingNeeds: "Weekly brushing",
            exerciseNeeds: "2 hours daily",
            commonHealthIssues: ["Hip dysplasia"],
            estimatedMonthlyCost: 150,
            adoptionFee: 250,
            lifespanYears: 12,
            shelterName: "Test Shelter",
            shelterLocation: "Los Angeles, CA",
            distanceMiles: 15
        )
        
        XCTAssertEqual(pet.name, "Buddy")
        XCTAssertEqual(pet.species, .dog)
        XCTAssertEqual(pet.breed, "Golden Retriever")
        XCTAssertEqual(pet.adoptionFee, 250)
    }
    
    func testMatchingServiceCalculatesScore() throws {
        let userProfile = UserProfile.default
        let testPet = Pet.samplePets[0] // Max the Golden Retriever
        
        let result = MatchingService.shared.calculateMatchScore(user: userProfile, pet: testPet)
        
        XCTAssertGreaterThan(result.matchPercentage, 0)
        XCTAssertLessThanOrEqual(result.matchPercentage, 100)
    }
    
    func testUserProfileDefaultValues() throws {
        let profile = UserProfile.default
        
        XCTAssertFalse(profile.quizCompleted)
        XCTAssertEqual(profile.preferredDistance, 50)
        XCTAssertEqual(profile.maxMonthlyBudget, 200)
    }
    
    func testPetSpeciesIconMapping() throws {
        XCTAssertEqual(PetSpecies.dog.icon, "🐕")
        XCTAssertEqual(PetSpecies.cat.icon, "🐈")
        XCTAssertEqual(PetSpecies.bird.icon, "🐦")
    }
}
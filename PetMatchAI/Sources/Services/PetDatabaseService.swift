import Foundation

class PetDatabaseService {
    static let shared = PetDatabaseService()
    
    private var petCache: [Pet]?
    
    func loadPets(completion: @escaping ([Pet]) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let cached = self.petCache {
                completion(cached)
            } else {
                let pets = self.generatePetDatabase()
                self.petCache = pets
                completion(pets)
            }
        }
    }
    
    func refreshPets(completion: @escaping ([Pet]) -> Void) {
        petCache = nil
        loadPets(completion: completion)
    }
    
    private func generatePetDatabase() -> [Pet] {
        return [
            // Dogs
            Pet(id: "d1", name: "Max", species: .dog, breed: "Golden Retriever", age: "2 years", size: .large, gender: "Male", photos: ["max1", "max2"], description: "Max is a friendly and energetic Golden Retriever who loves to play fetch and swim. Great with kids!", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Weekly brushing required", exerciseNeeds: "2+ hours daily", commonHealthIssues: ["Hip dysplasia", "Eye issues"], estimatedMonthlyCost: 150, adoptionFee: 250, lifespanYears: 12, shelterName: "Happy Paws Shelter", shelterLocation: "Los Angeles, CA", distanceMiles: 15),
            
            Pet(id: "d2", name: "Buddy", species: .dog, breed: "Beagle", age: "4 years", size: .medium, gender: "Male", photos: ["buddy1", "buddy2"], description: "Buddy is a curious and friendly Beagle who follows his nose everywhere! Very playful and good with other dogs.", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Low - occasional brushing", exerciseNeeds: "1-2 hours daily", commonHealthIssues: ["Ear infections", "Obesity"], estimatedMonthlyCost: 100, adoptionFee: 200, lifespanYears: 14, shelterName: "Rescue Me Center", shelterLocation: "Seattle, WA", distanceMiles: 8),
            
            Pet(id: "d3", name: "Luna", species: .dog, breed: "Labrador Retriever", age: "1 year", size: .large, gender: "Female", photos: ["luna1", "luna2"], description: "Luna is an intelligent and gentle Labrador. She loves to learn new tricks and is great with children.", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Moderate - weekly brushing", exerciseNeeds: "2 hours daily", commonHealthIssues: ["Hip dysplasia"], estimatedMonthlyCost: 130, adoptionFee: 275, lifespanYears: 11, shelterName: "Forever Home Rescue", shelterLocation: "San Francisco, CA", distanceMiles: 22),
            
            Pet(id: "d4", name: "Rocky", species: .dog, breed: "German Shepherd", age: "5 years", size: .large, gender: "Male", photos: ["rocky1", "rocky2"], description: "Rocky is a loyal and intelligent German Shepherd looking for an active family. Very protective but gentle.", energyLevel: .veryHigh, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: false, isGoodWithStrangers: false, canBeAlone: true, groomingNeeds: "Moderate - weekly brushing", exerciseNeeds: "3+ hours daily", commonHealthIssues: ["Hip dysplasia", "Elbow dysplasia"], estimatedMonthlyCost: 180, adoptionFee: 300, lifespanYears: 11, shelterName: "K9 Rescue", shelterLocation: "Denver, CO", distanceMiles: 45),
            
            Pet(id: "d5", name: "Daisy", species: .dog, breed: "French Bulldog", age: "3 years", size: .small, gender: "Female", photos: ["daisy1", "daisy2"], description: "Daisy is a cute and compact French Bulldog. Perfect for apartment living. Loves to cuddle.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Low - occasional cleaning of wrinkles", exerciseNeeds: "Moderate - daily walks", commonHealthIssues: ["Breathing issues", "Spine problems"], estimatedMonthlyCost: 120, adoptionFee: 350, lifespanYears: 12, shelterName: "Urban Pet Rescue", shelterLocation: "New York, NY", distanceMiles: 12),
            
            Pet(id: "d6", name: "Charlie", species: .dog, breed: "Poodle", age: "6 years", size: .medium, gender: "Male", photos: ["charlie1", "charlie2"], description: "Charlie is an elegant and hypoallergenic Poodle. Very smart and easy to train. Loves human companionship.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "High - regular grooming required", exerciseNeeds: "1 hour daily", commonHealthIssues: ["Hip dysplasia", "Eye issues"], estimatedMonthlyCost: 160, adoptionFee: 280, lifespanYears: 15, shelterName: "Paws & Claws", shelterLocation: "Chicago, IL", distanceMiles: 30),
            
            Pet(id: "d7", name: "Bella", species: .dog, breed: "Siberian Husky", age: "2 years", size: .large, gender: "Female", photos: ["bella1", "bella2"], description: "Bella is a beautiful and energetic Husky. Needs lots of exercise and loves cold weather. Great for active families.", energyLevel: .veryHigh, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "High - daily brushing during shedding season", exerciseNeeds: "3+ hours daily", commonHealthIssues: ["Eye issues", "Hip dysplasia"], estimatedMonthlyCost: 170, adoptionFee: 325, lifespanYears: 13, shelterName: "Northern Lights Rescue", shelterLocation: "Minneapolis, MN", distanceMiles: 55),
            
            Pet(id: "d8", name: "Cooper", species: .dog, breed: "Cocker Spaniel", age: "4 years", size: .medium, gender: "Male", photos: ["cooper1", "cooper2"], description: "Cooper is a happy and affectionate Cocker Spaniel. Loves attention and is great with kids of all ages.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "High - regular grooming and ear cleaning", exerciseNeeds: "1-2 hours daily", commonHealthIssues: ["Ear infections", "Eye issues"], estimatedMonthlyCost: 140, adoptionFee: 225, lifespanYears: 14, shelterName: "Happy Tails Rescue", shelterLocation: "Austin, TX", distanceMiles: 18),
            
            // Cats
            Pet(id: "c1", name: "Whiskers", species: .cat, breed: "Maine Coon", age: "3 years", size: .medium, gender: "Male", photos: ["whiskers1", "whiskers2"], description: "Whiskers is a gentle giant Maine Coon. Very affectionate and loves to be brushed. Great family cat.", energyLevel: .low, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "High - daily brushing required", exerciseNeeds: "Low - occasional play", commonHealthIssues: ["Hypertrophic cardiomyopathy", "Hip dysplasia"], estimatedMonthlyCost: 100, adoptionFee: 175, lifespanYears: 13, shelterName: "Cozy Cats Rescue", shelterLocation: "Portland, OR", distanceMiles: 35),
            
            Pet(id: "c2", name: "Luna", species: .cat, breed: "Siamese", age: "1 year", size: .small, gender: "Female", photos: ["luna_cat1", "luna_cat2"], description: "Luna is a vocal and affectionate Siamese cat who loves to cuddle. Very social and needs attention.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: false, canBeAlone: true, groomingNeeds: "Low - occasional brushing", exerciseNeeds: "Moderate - playtime needed", commonHealthIssues: ["Progressive retinal atrophy", "Asthma"], estimatedMonthlyCost: 80, adoptionFee: 150, lifespanYears: 15, shelterName: "Feline Friends", shelterLocation: "San Francisco, CA", distanceMiles: 22),
            
            Pet(id: "c3", name: "Shadow", species: .cat, breed: "British Shorthair", age: "5 years", size: .medium, gender: "Male", photos: ["shadow1", "shadow2"], description: "Shadow is a calm and dignified British Shorthair. Independent but affectionate. Great for busy professionals.", energyLevel: .low, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Low - weekly brushing", exerciseNeeds: "Low - occasional play", commonHealthIssues: ["Hypertrophic cardiomyopathy"], estimatedMonthlyCost: 70, adoptionFee: 160, lifespanYears: 16, shelterName: "Whisker Haven", shelterLocation: "Boston, MA", distanceMiles: 40),
            
            Pet(id: "c4", name: "Cleo", species: .cat, breed: "Persian", age: "4 years", size: .small, gender: "Female", photos: ["cleo1", "cleo2"], description: "Cleo is a beautiful and regal Persian cat. Loves to be pampered and groomed. Very calm temperament.", energyLevel: .low, isGoodWithKids: false, isGoodWithDogs: false, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "High - daily brushing and eye cleaning", exerciseNeeds: "Low", commonHealthIssues: ["Breathing issues", "Eye issues"], estimatedMonthlyCost: 130, adoptionFee: 200, lifespanYears: 14, shelterName: "Royal Cat Society", shelterLocation: "Los Angeles, CA", distanceMiles: 25),
            
            Pet(id: "c5", name: "Mochi", species: .cat, breed: "Ragdoll", age: "2 years", size: .medium, gender: "Male", photos: ["mochi1", "mochi2"], description: "Mochi is a soft and floppy Ragdoll who loves to be held. Very docile and great with children.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Moderate - regular brushing", exerciseNeeds: "Moderate", commonHealthIssues: ["Bladder stones", "Heart disease"], estimatedMonthlyCost: 90, adoptionFee: 185, lifespanYears: 15, shelterName: "Ragdoll Rescue", shelterLocation: "San Diego, CA", distanceMiles: 38),
            
            Pet(id: "c6", name: "Oliver", species: .cat, breed: "Domestic Shorthair", age: "6 months", size: .small, gender: "Male", photos: ["oliver1", "oliver2"], description: "Oliver is an energetic and playful kitten. Loves to chase toys and explore. Looking for a fun family!", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: true, isGoodWithCats: true, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Low", exerciseNeeds: "High - lots of playtime", commonHealthIssues: ["None known"], estimatedMonthlyCost: 50, adoptionFee: 100, lifespanYears: 18, shelterName: "Kitten Kaboodle", shelterLocation: "Phoenix, AZ", distanceMiles: 10),
            
            // Birds
            Pet(id: "b1", name: "Coco", species: .bird, breed: "Cockatiel", age: "1 year", size: .small, gender: "Female", photos: ["coco1", "coco2"], description: "Coco is a cheerful cockatiel who loves to whistle and dance. Very social and enjoys human interaction.", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: true, groomingNeeds: "Low - occasional bath", exerciseNeeds: "Moderate - out of cage time", commonHealthIssues: ["Respiratory infections"], estimatedMonthlyCost: 40, adoptionFee: 75, lifespanYears: 20, shelterName: "Wings of Hope", shelterLocation: "Austin, TX", distanceMiles: 12),
            
            Pet(id: "b2", name: "Rio", species: .bird, breed: "Sun Conure", age: "2 years", size: .small, gender: "Male", photos: ["rio1", "rio2"], description: "Rio is a vibrant and colorful Sun Conure. Very playful and loves to perform tricks. Needs lots of attention.", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Low", exerciseNeeds: "High - supervised out of cage time", commonHealthIssues: ["Feather plucking"], estimatedMonthlyCost: 55, adoptionFee: 120, lifespanYears: 25, shelterName: "Parrot Paradise", shelterLocation: "Miami, FL", distanceMiles: 28),
            
            // Small Animals
            Pet(id: "s1", name: "Peanut", species: .smallAnimal, breed: "Guinea Pig", age: "2 years", size: .small, gender: "Male", photos: ["peanut1", "peanut2"], description: "Peanut is a sweet and gentle guinea pig who loves to squeak for vegetables. Very social and needs a friend!", energyLevel: .moderate, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Low - regular cage cleaning", exerciseNeeds: "Moderate - floor time needed", commonHealthIssues: ["Vitamin C deficiency"], estimatedMonthlyCost: 30, adoptionFee: 40, lifespanYears: 6, shelterName: "Small Paws Rescue", shelterLocation: "Philadelphia, PA", distanceMiles: 20),
            
            Pet(id: "s2", name: "Hopper", species: .smallAnimal, breed: "Dutch Rabbit", age: "1 year", size: .small, gender: "Female", photos: ["hopper1", "hopper2"], description: "Hopper is an energetic and curious rabbit who loves to explore and do zoomies. Great for families!", energyLevel: .high, isGoodWithKids: true, isGoodWithDogs: false, isGoodWithCats: false, isGoodWithStrangers: true, canBeAlone: false, groomingNeeds: "Moderate - weekly brushing", exerciseNeeds: "High - lots of space to run", commonHealthIssues: ["Dental issues", "Ear infections"], estimatedMonthlyCost: 45, adoptionFee: 55, lifespanYears: 8, shelterName: "Bunny Haven", shelterLocation: "Denver, CO", distanceMiles: 42)
        ]
    }
    
    func getPetsBySpecies(_ species: PetSpecies) -> [Pet] {
        return petCache?.filter { $0.species == species } ?? []
    }
    
    func getPet(byId id: String) -> Pet? {
        return petCache?.first { $0.id == id }
    }
    
    func getPetsNearLocation(miles: Double) -> [Pet] {
        return petCache?.filter { $0.distanceMiles <= miles } ?? []
    }
    
    func getPetsUnderAdoptionFee(_ fee: Double) -> [Pet] {
        return petCache?.filter { $0.adoptionFee <= fee } ?? []
    }
}
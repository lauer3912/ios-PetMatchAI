import Foundation

class DataService {
    static let shared = DataService()
    
    private let favoritesKey = "favoritePets"
    private let recentViewsKey = "recentlyViewedPets"
    private let userProfileKey = "userProfile"
    private let quizCompletedKey = "hasCompletedQuiz"
    
    // MARK: - User Profile
    func saveUserProfile(_ profile: UserProfile) {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: userProfileKey)
        }
    }
    
    func loadUserProfile() -> UserProfile {
        guard let data = UserDefaults.standard.data(forKey: userProfileKey),
              let profile = try? JSONDecoder().decode(UserProfile.self, from: data) else {
            return UserProfile.default
        }
        return profile
    }
    
    func isQuizCompleted() -> Bool {
        return UserDefaults.standard.bool(forKey: quizCompletedKey)
    }
    
    func setQuizCompleted(_ completed: Bool) {
        UserDefaults.standard.set(completed, forKey: quizCompletedKey)
        if completed {
            let profile = loadUserProfile()
            var updatedProfile = profile
            updatedProfile.quizCompleted = true
            updatedProfile.quizCompletionDate = Date()
            saveUserProfile(updatedProfile)
        }
    }
    
    // MARK: - Favorites
    func addToFavorites(_ pet: Pet) {
        var favorites = loadFavorites()
        if !favorites.contains(where: { $0.id == pet.id }) {
            favorites.append(pet)
            saveFavorites(favorites)
        }
    }
    
    func removeFromFavorites(_ pet: Pet) {
        var favorites = loadFavorites()
        favorites.removeAll { $0.id == pet.id }
        saveFavorites(favorites)
    }
    
    func loadFavorites() -> [Pet] {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey),
              let pets = try? JSONDecoder().decode([Pet].self, from: data) else {
            return []
        }
        return pets
    }
    
    func isFavorite(_ pet: Pet) -> Bool {
        return loadFavorites().contains { $0.id == pet.id }
    }
    
    private func saveFavorites(_ pets: [Pet]) {
        if let data = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }
    
    // MARK: - Recently Viewed
    func addToRecentlyViewed(_ pet: Pet) {
        var recent = loadRecentlyViewed()
        // Remove if already exists
        recent.removeAll { $0.id == pet.id }
        // Add to front
        recent.insert(pet, at: 0)
        // Keep only last 20
        if recent.count > 20 {
            recent = Array(recent.prefix(20))
        }
        saveRecentlyViewed(recent)
    }
    
    func loadRecentlyViewed() -> [Pet] {
        guard let data = UserDefaults.standard.data(forKey: recentViewsKey),
              let pets = try? JSONDecoder().decode([Pet].self, from: data) else {
            return []
        }
        return pets
    }
    
    private func saveRecentlyViewed(_ pets: [Pet]) {
        if let data = try? JSONEncoder().encode(pets) {
            UserDefaults.standard.set(data, forKey: recentViewsKey)
        }
    }
    
    // MARK: - Clear All Data
    func clearAllData() {
        UserDefaults.standard.removeObject(forKey: favoritesKey)
        UserDefaults.standard.removeObject(forKey: recentViewsKey)
        UserDefaults.standard.removeObject(forKey: userProfileKey)
        UserDefaults.standard.removeObject(forKey: quizCompletedKey)
    }
    
    // MARK: - Export Data
    func exportUserData() -> Data? {
        let exportData = ExportData(
            userProfile: loadUserProfile(),
            favorites: loadFavorites(),
            recentlyViewed: loadRecentlyViewed()
        )
        return try? JSONEncoder().encode(exportData)
    }
}

struct ExportData: Codable {
    let userProfile: UserProfile
    let favorites: [Pet]
    let recentlyViewed: [Pet]
}
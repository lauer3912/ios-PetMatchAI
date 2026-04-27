import Foundation

class SubscriptionService {
    static let shared = SubscriptionService()
    
    private let premiumKey = "isPremiumUser"
    private let expirationKey = "premiumExpiration"
    
    var isPremium: Bool {
        get {
            let isPurchased = UserDefaults.standard.bool(forKey: premiumKey)
            if isPurchased {
                if let expiration = UserDefaults.standard.object(forKey: expirationKey) as? Date {
                    return expiration > Date()
                }
            }
            return false
        }
        return UserDefaults.standard.bool(forKey: premiumKey)
    }
    
    var subscriptionPlans: [SubscriptionPlan] {
        return [
            SubscriptionPlan(name: "Monthly", price: 4.99, period: .monthly),
            SubscriptionPlan(name: "Yearly", price: 39.99, period: .yearly)
        ]
    }
    
    func purchaseSubscription(plan: SubscriptionPlan) {
        // In a real app, this would use StoreKit to process the purchase
        // For now, we simulate a successful purchase
        UserDefaults.standard.set(true, forKey: premiumKey)
        
        let expirationDate: Date
        switch plan.period {
        case .monthly:
            expirationDate = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        case .yearly:
            expirationDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
        }
        UserDefaults.standard.set(expirationDate, forKey: expirationKey)
    }
    
    func restorePurchases() {
        // In a real app, this would check with StoreKit for previous purchases
        // For now, we just check if there was a past purchase
    }
    
    func cancelSubscription() {
        UserDefaults.standard.set(false, forKey: premiumKey)
        UserDefaults.standard.removeObject(forKey: expirationKey)
    }
}

struct SubscriptionPlan {
    let name: String
    let price: Double
    let period: SubscriptionPeriod
    
    var formattedPrice: String {
        return "$\(String(format: "%.2f", price))/\(period == .monthly ? "mo" : "yr")"
    }
}

enum SubscriptionPeriod {
    case monthly
    case yearly
}

// MARK: - Notification Service
class NotificationService {
    static let shared = NotificationService()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleMatchNotification(for pet: Pet) {
        let content = UNMutableNotificationContent()
        content.title = "New Match Found!"
        content.body = "\(pet.name) is a \(pet.matchScore)% match for you! Tap to view."
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: pet.id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleWeeklyRecommendation() {
        let content = UNMutableNotificationContent()
        content.title = "Your Weekly Matches"
        content.body = "Check out new pets that match your lifestyle!"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 10
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "weekly_matches", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(for petId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [petId])
    }
}

import UserNotifications
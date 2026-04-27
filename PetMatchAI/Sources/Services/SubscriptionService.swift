import Foundation

class SubscriptionService {
    static let shared = SubscriptionService()
    
    private let premiumKey = "isPremiumUser"
    private let expirationKey = "premiumExpiration"
    
    var isPremium: Bool {
        let isPurchased = UserDefaults.standard.bool(forKey: premiumKey)
        if isPurchased {
            if let expiration = UserDefaults.standard.object(forKey: expirationKey) as? Date {
                return expiration > Date()
            }
        }
        return false
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
        let expiration = plan.period == .monthly ?
            Calendar.current.date(byAdding: .month, value: 1, to: Date()) :
            Calendar.current.date(byAdding: .year, value: 1, to: Date())
        
        UserDefaults.standard.set(true, forKey: premiumKey)
        UserDefaults.standard.set(expiration, forKey: expirationKey)
        
        NotificationCenter.default.post(name: .subscriptionStatusChanged, object: nil)
    }
    
    func restorePurchases() {
        // In a real app, this would call StoreKit to restore purchases
        // For demo purposes, we'll just post a notification
        NotificationCenter.default.post(name: .subscriptionStatusChanged, object: nil)
    }
    
    func cancelSubscription() {
        UserDefaults.standard.set(false, forKey: premiumKey)
        UserDefaults.standard.removeObject(forKey: expirationKey)
        NotificationCenter.default.post(name: .subscriptionStatusChanged, object: nil)
    }
    
    func getSubscriptionStatus() -> SubscriptionStatus {
        if isPremium {
            if let expiration = UserDefaults.standard.object(forKey: expirationKey) as? Date {
                let daysRemaining = Calendar.current.dateComponents([.day], from: Date(), to: expiration).day ?? 0
                return .active(expiration: expiration, daysRemaining: daysRemaining)
            }
            return .active(expiration: Date(), daysRemaining: 0)
        }
        return .notSubscribed
    }
    
    func getExpirationDate() -> Date? {
        return UserDefaults.standard.object(forKey: expirationKey) as? Date
    }
}

enum SubscriptionPeriod {
    case monthly
    case yearly
}

struct SubscriptionPlan {
    let name: String
    let price: Double
    let period: SubscriptionPeriod
    
    var formattedPrice: String {
        return String(format: "$%.2f", price)
    }
    
    var monthlyPrice: Double {
        switch period {
        case .monthly:
            return price
        case .yearly:
            return price / 12.0
        }
    }
}

enum SubscriptionStatus {
    case notSubscribed
    case active(expiration: Date, daysRemaining: Int)
    case expired
    
    var isActive: Bool {
        switch self {
        case .active:
            return true
        case .notSubscribed, .expired:
            return false
        }
    }
}

extension Notification.Name {
    static let subscriptionStatusChanged = Notification.Name("subscriptionStatusChanged")
}

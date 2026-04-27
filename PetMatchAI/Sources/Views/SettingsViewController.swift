import UIKit

class SettingsViewController: UIViewController {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private let sections = [
        ("Preferences", [
            SettingsItem(icon: "bell.fill", title: "Notifications", type: .toggle, key: "notificationsEnabled"),
            SettingsItem(icon: "location.fill", title: "Location", type: .navigation, key: "location"),
            SettingsItem(icon: "moon.fill", title: "Theme", type: .selection, key: "theme")
        ]),
        ("Account", [
            SettingsItem(icon: "person.fill", title: "Edit Profile", type: .navigation, key: "editProfile"),
            SettingsItem(icon: "lock.fill", title: "Privacy Policy", type: .navigation, key: "privacy"),
            SettingsItem(icon: "doc.text.fill", title: "Terms of Service", type: .navigation, key: "terms"),
            SettingsItem(icon: "square.and.arrow.up", title: "Export Data", type: .action, key: "exportData")
        ]),
        ("Subscription", [
            SettingsItem(icon: "star.fill", title: "Upgrade to Premium", type: .highlight, key: "upgrade"),
            SettingsItem(icon: "creditcard.fill", title: "Manage Subscription", type: .navigation, key: "manageSub")
        ]),
        ("About", [
            SettingsItem(icon: "info.circle.fill", title: "Version 1.0.0", type: .info, key: "version"),
            SettingsItem(icon: "trash.fill", title: "Delete Account", type: .destructive, key: "deleteAccount")
        ])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = ThemeService.shared.backgroundColor
        title = "Settings"
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SettingsToggleCell.self, forCellReuseIdentifier: "SettingsToggleCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func handleAction(for item: SettingsItem) {
        switch item.key {
        case "editProfile":
            let alert = UIAlertController(title: "Edit Profile", message: "Profile editing coming soon", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        case "exportData":
            exportData()
        case "upgrade":
            showUpgradeScreen()
        case "deleteAccount":
            confirmDeleteAccount()
        case "privacy":
            break
        case "terms":
            break
        default:
            break
        }
    }
    
    private func exportData() {
        if let data = DataService.shared.exportUserData(),
           let jsonString = String(data: data, encoding: .utf8) {
            let activityVC = UIActivityViewController(activityItems: [jsonString], applicationActivities: nil)
            present(activityVC, animated: true)
        }
    }
    
    private func showUpgradeScreen() {
        let alert = UIAlertController(title: "Upgrade to Premium", message: "Premium features:\n• Unlimited matches\n• Advanced AI insights\n• Ad-free experience\n• Priority placement", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Monthly $4.99", style: .default) { [weak self] _ in
            self?.purchaseSubscription(.monthly)
        })
        alert.addAction(UIAlertAction(title: "Yearly $39.99", style: .default) { [weak self] _ in
            self?.purchaseSubscription(.yearly)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func purchaseSubscription(_ period: SubscriptionPeriod) {
        let plan = SubscriptionPlan(name: period == .monthly ? "Monthly" : "Yearly", 
                                    price: period == .monthly ? 4.99 : 39.99, 
                                    period: period)
        SubscriptionService.shared.purchaseSubscription(plan: plan)
        
        let successAlert = UIAlertController(title: "Success!", message: "You are now a Premium member", preferredStyle: .alert)
        successAlert.addAction(UIAlertAction(title: "OK", style: .default))
        present(successAlert, animated: true)
    }
    
    private func confirmDeleteAccount() {
        let alert = UIAlertController(title: "Delete Account", 
                                      message: "Are you sure you want to delete your account? This action cannot be undone.", 
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            DataService.shared.clearAllData()
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                window.rootViewController = UINavigationController(rootViewController: OnboardingViewController())
                window.makeKeyAndVisible()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].1.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].1[indexPath.row]
        
        switch item.type {
        case .toggle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsToggleCell", for: indexPath) as! SettingsToggleCell
            cell.configure(with: item)
            cell.onToggle = { [weak self] isOn in
                UserDefaults.standard.set(isOn, forKey: item.key)
                self?.handleAction(for: item)
            }
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
            cell.configure(with: item)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = sections[indexPath.section].1[indexPath.row]
        handleAction(for: item)
    }
}

// MARK: - Models
struct SettingsItem {
    let icon: String
    let title: String
    let type: SettingsItemType
    let key: String
}

enum SettingsItemType {
    case toggle
    case navigation
    case selection
    case action
    case destructive
    case info
    case highlight
}

// MARK: - Cells
class SettingsCell: UITableViewCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = ThemeService.shared.surfaceColor
        
        iconView.tintColor = ThemeService.shared.colors.primary
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(titleLabel)
        
        valueLabel.font = .systemFont(ofSize: 14)
        valueLabel.textColor = ThemeService.shared.textSecondary
        contentView.addSubview(valueLabel)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: valueLabel.leadingAnchor, constant: -8)
        ])
    }
    
    func configure(with item: SettingsItem) {
        iconView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        
        switch item.type {
        case .navigation:
            accessoryType = .disclosureIndicator
            titleLabel.textColor = ThemeService.shared.textPrimary
        case .destructive:
            accessoryType = .none
            titleLabel.textColor = ThemeService.shared.colors.error
            iconView.tintColor = ThemeService.shared.colors.error
        case .highlight:
            accessoryType = .none
            titleLabel.textColor = ThemeService.shared.colors.primary
            iconView.tintColor = ThemeService.shared.colors.primary
        case .info:
            accessoryType = .none
            titleLabel.textColor = ThemeService.shared.textSecondary
        default:
            accessoryType = .none
            titleLabel.textColor = ThemeService.shared.textPrimary
        }
    }
}

class SettingsToggleCell: UITableViewCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    
    var onToggle: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = ThemeService.shared.surfaceColor
        selectionStyle = .none
        
        iconView.tintColor = ThemeService.shared.colors.primary
        iconView.contentMode = .scaleAspectFit
        contentView.addSubview(iconView)
        
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = ThemeService.shared.textPrimary
        contentView.addSubview(titleLabel)
        
        toggle.onTintColor = ThemeService.shared.colors.primary
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        contentView.addSubview(toggle)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: SettingsItem) {
        iconView.image = UIImage(systemName: item.icon)
        titleLabel.text = item.title
        toggle.isOn = UserDefaults.standard.bool(forKey: item.key)
    }
    
    @objc private func toggleChanged() {
        onToggle?(toggle.isOn)
    }
}

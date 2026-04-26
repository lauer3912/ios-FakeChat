import UIKit

class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    struct SettingItem {
        let icon: String
        let iconColor: UIColor
        let title: String
        let subtitle: String?
        let type: SettingType
    }
    
    enum SettingType {
        case toggle(Bool)
        case navigation(String)
        case proBadge
    }
    
    private var settings: [[SettingItem]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSettings()
        setupUI()
    }
    
    private func setupSettings() {
        settings = [
            // Appearance
            [
                SettingItem(icon: "moon.fill", iconColor: Design.purple, title: "Dark Mode", subtitle: nil, type: .toggle(true)),
                SettingItem(icon: "hand.tap.fill", iconColor: Design.cyan, title: "Haptic Feedback", subtitle: nil, type: .toggle(true))
            ],
            // Defaults
            [
                SettingItem(icon: "message.fill", iconColor: Design.cyan, title: "Default App", subtitle: "iMessage", type: .navigation("app")),
                SettingItem(icon: "photo.fill", iconColor: Design.pink, title: "Default Wallpaper", subtitle: "Default", type: .navigation("wallpaper"))
            ],
            // Premium
            [
                SettingItem(icon: "crown.fill", iconColor: Design.yellow, title: "Upgrade to Pro", subtitle: "$2.99/month", type: .proBadge),
                SettingItem(icon: "star.fill", iconColor: Design.orange, title: "Rate App", subtitle: nil, type: .navigation("rate")),
                SettingItem(icon: "envelope.fill", iconColor: Design.green, title: "Send Feedback", subtitle: nil, type: .navigation("feedback"))
            ],
            // About
            [
                SettingItem(icon: "info.circle.fill", iconColor: .white, title: "Version", subtitle: "1.0.0", type: .navigation("version"))
            ]
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = Design.bgPrimary
        title = "Settings"
        
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "SettingsCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell
        let item = settings[indexPath.section][indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = settings[indexPath.section][indexPath.row]
        
        switch item.type {
        case .navigation(let action):
            handleNavigation(action: action)
        case .proBadge:
            handleProUpgrade()
        default:
            break
        }
    }
    
    private func handleNavigation(action: String) {
        // Handle navigation actions
    }
    
    private func handleProUpgrade() {
        let alert = UIAlertController(title: "Upgrade to Pro", message: "Get access to all premium features!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Later", style: .cancel))
        alert.addAction(UIAlertAction(title: "Upgrade", style: .default))
        present(alert, animated: true)
    }
}

class SettingsCell: UITableViewCell {
    private let iconContainer = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let arrowIcon = UIImageView()
    private let proBadge = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Design.bgSecondary
        selectionStyle = .default
        
        // Icon container
        iconContainer.layer.cornerRadius = 8
        contentView.addSubview(iconContainer)
        
        // Icon
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        iconContainer.addSubview(iconView)
        
        // Title
        titleLabel.font = Design.Typography.body
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.font = Design.Typography.caption
        subtitleLabel.textColor = Design.cyan.withAlphaComponent(0.7)
        contentView.addSubview(subtitleLabel)
        
        // Toggle
        toggleSwitch.onTintColor = Design.cyan
        toggleSwitch.isHidden = true
        contentView.addSubview(toggleSwitch)
        
        // Arrow
        arrowIcon.image = UIImage(systemName: "chevron.right")
        arrowIcon.tintColor = UIColor.white.withAlphaComponent(0.3)
        arrowIcon.isHidden = true
        contentView.addSubview(arrowIcon)
        
        // Pro badge
        proBadge.text = "PRO"
        proBadge.font = Design.Typography.caption
        proBadge.textColor = Design.bgPrimary
        proBadge.backgroundColor = Design.yellow
        proBadge.layer.cornerRadius = 4
        proBadge.clipsToBounds = true
        proBadge.textAlignment = .center
        proBadge.isHidden = true
        contentView.addSubview(proBadge)
        
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        proBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 32),
            iconContainer.heightAnchor.constraint(equalToConstant: 32),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            arrowIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 10),
            
            proBadge.widthAnchor.constraint(equalToConstant: 40),
            proBadge.heightAnchor.constraint(equalToConstant: 20),
            proBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            proBadge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: SettingsViewController.SettingItem) {
        iconView.image = UIImage(systemName: item.icon)
        iconContainer.backgroundColor = item.iconColor.withAlphaComponent(0.2)
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        subtitleLabel.isHidden = item.subtitle == nil
        
        toggleSwitch.isHidden = true
        arrowIcon.isHidden = true
        proBadge.isHidden = true
        
        switch item.type {
        case .toggle(let isOn):
            toggleSwitch.isHidden = false
            toggleSwitch.isOn = isOn
        case .navigation:
            arrowIcon.isHidden = false
        case .proBadge:
            proBadge.isHidden = false
        }
    }
}
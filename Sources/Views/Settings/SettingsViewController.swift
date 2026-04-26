import UIKit

class SettingsViewController: UIViewController {
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    private struct SettingItem {
        let icon: String
        let iconColor: UIColor
        let title: String
        let subtitle: String?
        let type: SettingType
    }
    
    private enum SettingType {
        case toggle(Bool)
        case navigation
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
            [
                SettingItem(icon: "moon.fill", iconColor: UIColor(hex: "A855F7"), title: "Dark Mode", subtitle: nil, type: .toggle(true)),
                SettingItem(icon: "hand.tap.fill", iconColor: UIColor(hex: "00D4FF"), title: "Haptic Feedback", subtitle: nil, type: .toggle(true))
            ],
            [
                SettingItem(icon: "message.fill", iconColor: UIColor(hex: "007AFF"), title: "Default App", subtitle: "iMessage", type: .navigation),
                SettingItem(icon: "photo.fill", iconColor: UIColor(hex: "FF2D7A"), title: "Default Wallpaper", subtitle: "Default", type: .navigation)
            ],
            [
                SettingItem(icon: "crown.fill", iconColor: UIColor(hex: "FFFC00"), title: "Upgrade to Pro", subtitle: "$2.99/month", type: .proBadge),
                SettingItem(icon: "star.fill", iconColor: UIColor(hex: "FF9F0A"), title: "Rate App", subtitle: nil, type: .navigation),
                SettingItem(icon: "envelope.fill", iconColor: UIColor(hex: "30D158"), title: "Send Feedback", subtitle: nil, type: .navigation)
            ],
            [
                SettingItem(icon: "info.circle.fill", iconColor: UIColor.white, title: "Version", subtitle: "1.0.0", type: .navigation)
            ]
        ]
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = "Settings"
        
        tableView.backgroundColor = .black
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
    }
}

class SettingsCell: UITableViewCell {
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let toggleSwitch = UISwitch()
    private let proBadge = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = UIColor(hex: "1C1C1E")
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        contentView.addSubview(iconView)
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .regular)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 13, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        contentView.addSubview(subtitleLabel)
        
        toggleSwitch.onTintColor = UIColor(hex: "00D4FF")
        toggleSwitch.isHidden = true
        contentView.addSubview(toggleSwitch)
        
        proBadge.text = "PRO"
        proBadge.font = .systemFont(ofSize: 10, weight: .bold)
        proBadge.textColor = .black
        proBadge.backgroundColor = UIColor(hex: "FFFC00")
        proBadge.layer.cornerRadius = 4
        proBadge.clipsToBounds = true
        proBadge.textAlignment = .center
        proBadge.isHidden = true
        contentView.addSubview(proBadge)
        
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        proBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 14),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 8),
            subtitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            proBadge.widthAnchor.constraint(equalToConstant: 36),
            proBadge.heightAnchor.constraint(equalToConstant: 18),
            proBadge.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            proBadge.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(with item: SettingsViewController.SettingItem) {
        iconView.image = UIImage(systemName: item.icon)
        iconView.tintColor = item.iconColor
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        subtitleLabel.isHidden = item.subtitle == nil
        
        toggleSwitch.isHidden = true
        proBadge.isHidden = true
        
        switch item.type {
        case .toggle(let isOn):
            toggleSwitch.isHidden = false
            toggleSwitch.isOn = isOn
        case .proBadge:
            proBadge.isHidden = false
        case .navigation:
            break
        }
    }
}
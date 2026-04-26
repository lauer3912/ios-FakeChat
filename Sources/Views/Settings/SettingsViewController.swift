import UIKit

class SettingsViewController: UIViewController {
    
    private var tableView: UITableView!
    
    private enum Section: Int, CaseIterable {
        case appearance
        case defaults
        case about
        
        var title: String {
            switch self {
            case .appearance: return "Appearance"
            case .defaults: return "Defaults"
            case .about: return "About"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Design.Colors.backgroundPrimary
        title = "Settings"
        
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Design.Colors.backgroundPrimary
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.register(SettingSwitchCell.self, forCellReuseIdentifier: "SettingSwitchCell")
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sec = Section(rawValue: section) else { return 0 }
        switch sec {
        case .appearance: return 1
        case .defaults: return 2
        case .about: return 2
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .appearance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingSwitchCell", for: indexPath) as! SettingSwitchCell
            cell.configure(title: "Dark Mode", isOn: AppTheme.shared.isDarkMode) { isOn in
                AppTheme.shared.isDarkMode = isOn
            }
            return cell
            
        case .defaults:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            if indexPath.row == 0 {
                cell.configure(title: "Default App", value: AppTheme.shared.defaultApp.displayName)
            } else {
                cell.configure(title: "Default Wallpaper", value: AppTheme.shared.defaultWallpaper.displayName)
            }
            return cell
            
        case .about:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
            if indexPath.row == 0 {
                cell.configure(title: "Version", value: "1.0.0")
            } else {
                cell.configure(title: "Privacy Policy", value: nil, showChevron: true)
            }
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        triggerHaptic()
        
        guard let section = Section(rawValue: indexPath.section) else { return }
        
        switch section {
        case .defaults:
            if indexPath.row == 0 {
                showAppPicker()
            } else {
                showWallpaperPicker()
            }
        case .about:
            if indexPath.row == 1 {
                openPrivacyPolicy()
            }
        default:
            break
        }
    }
    
    private func showAppPicker() {
        let alert = UIAlertController(title: "Default App", message: nil, preferredStyle: .actionSheet)
        
        for app in ChatApp.allCases {
            alert.addAction(UIAlertAction(title: app.displayName, style: .default) { [weak self] _ in
                AppTheme.shared.defaultApp = app
                self?.tableView.reloadData()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func showWallpaperPicker() {
        let alert = UIAlertController(title: "Default Wallpaper", message: nil, preferredStyle: .actionSheet)
        
        for wallpaper in WallpaperType.allCases {
            alert.addAction(UIAlertAction(title: wallpaper.displayName, style: .default) { [weak self] _ in
                AppTheme.shared.defaultWallpaper = wallpaper
                self?.tableView.reloadData()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    private func openPrivacyPolicy() {
        if let url = URL(string: "https://lauer3912.github.io/ios-FakeChat/docs/PrivacyPolicy.html") {
            UIApplication.shared.open(url)
        }
    }
}

// MARK: - Setting Cell
class SettingCell: UITableViewCell {
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
        backgroundColor = Design.Colors.backgroundSecondary
        
        titleLabel.font = Design.Typography.body
        titleLabel.textColor = Design.Colors.textPrimary
        contentView.addSubview(titleLabel)
        
        valueLabel.font = Design.Typography.body
        valueLabel.textColor = Design.Colors.textSecondary
        valueLabel.textAlignment = .right
        contentView.addSubview(valueLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.Spacing.lg),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            valueLabel.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: Design.Spacing.md)
        ])
    }
    
    func configure(title: String, value: String?, showChevron: Bool = false) {
        titleLabel.text = title
        valueLabel.text = value
        accessoryType = showChevron ? .disclosureIndicator : .none
    }
}

// MARK: - Setting Switch Cell
class SettingSwitchCell: UITableViewCell {
    private let titleLabel = UILabel()
    private let toggle = UISwitch()
    private var onToggle: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Design.Colors.backgroundSecondary
        selectionStyle = .none
        
        titleLabel.font = Design.Typography.body
        titleLabel.textColor = Design.Colors.textPrimary
        contentView.addSubview(titleLabel)
        
        toggle.onTintColor = Design.Colors.accentCyan
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        contentView.addSubview(toggle)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.Spacing.lg),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg),
            toggle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, isOn: Bool, onToggle: @escaping (Bool) -> Void) {
        titleLabel.text = title
        toggle.isOn = isOn
        self.onToggle = onToggle
    }
    
    @objc private func toggleChanged() {
        onToggle?(toggle.isOn)
    }
}
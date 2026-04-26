import UIKit

class SettingsViewController: UIViewController {
    private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Settings"
        view.backgroundColor = AppTheme.background

        navigationController?.navigationBar.prefersLargeTitles = true

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppTheme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func showProUpgrade() {
        let alert = UIAlertController(title: "Upgrade to Pro", message: "Get access to all templates, advanced apps, and no watermark for $2.99", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Upgrade", style: .default) { _ in })
        alert.addAction(UIAlertAction(title: "Not Now", style: .cancel))
        present(alert, animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // Appearance
        case 1: return 2 // Preferences
        case 2: return 2 // About
        case 3: return 1 // Pro
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Appearance"
        case 1: return "Preferences"
        case 2: return "About"
        case 3: return nil
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            cell.configure(title: "Dark Mode", isOn: AppTheme.isDarkMode) { isOn in
                AppTheme.isDarkMode = isOn
            }
            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell
            if indexPath.row == 0 {
                cell.configure(title: "Haptic Feedback", isOn: AppTheme.hapticEnabled) { isOn in
                    AppTheme.hapticEnabled = isOn
                }
            } else {
                cell.configure(title: "Default Chat App", isOn: true) { _ in }
                cell.accessoryType = .disclosureIndicator
            }
            return cell

        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.backgroundColor = AppTheme.surface
            cell.textLabel?.textColor = AppTheme.textPrimary
            if indexPath.row == 0 {
                cell.textLabel?.text = "Privacy Policy"
                cell.accessoryType = .disclosureIndicator
            } else {
                cell.textLabel?.text = "Version 1.0"
                cell.accessoryType = .none
                cell.textLabel?.textColor = AppTheme.textSecondary
            }
            return cell

        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            cell.backgroundColor = Theme.accentCyan.withAlphaComponent(0.15)
            cell.textLabel?.text = "Upgrade to Pro ✨"
            cell.textLabel?.textColor = Theme.accentCyan
            cell.textLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            cell.accessoryType = .disclosureIndicator
            return cell

        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 && indexPath.row == 0 {
            if let url = URL(string: "https://lauer3912.github.io/ios-FakeChat/docs/PrivacyPolicy.html") {
                UIApplication.shared.open(url)
            }
        } else if indexPath.section == 3 {
            showProUpgrade()
        }
    }
}

class SwitchCell: UITableViewCell {
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
        backgroundColor = AppTheme.surface
        selectionStyle = .none

        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = AppTheme.textPrimary
        contentView.addSubview(titleLabel)

        toggle.onTintColor = Theme.accentCyan
        toggle.addTarget(self, action: #selector(toggleChanged), for: .valueChanged)
        contentView.addSubview(toggle)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        toggle.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
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
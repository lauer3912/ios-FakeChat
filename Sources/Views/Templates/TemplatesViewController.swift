import UIKit

class TemplatesViewController: UIViewController {
    private var tableView: UITableView!
    private var templates: [ChatTemplate] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTemplates()
    }

    private func setupUI() {
        title = "Templates"
        view.backgroundColor = AppTheme.background

        navigationController?.navigationBar.prefersLargeTitles = true

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppTheme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TemplateCell.self, forCellReuseIdentifier: "TemplateCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadTemplates() {
        templates = [
            createTemplate(title: "Celebrity Roast", subtitle: "Hilarious celebrity comeback", app: .iMessage),
            createTemplate(title: "Boss Prank", subtitle: "Tell your boss you're sick", app: .whatsapp),
            createTemplate(title: "Crush Confession", subtitle: "Finally tell them how you feel", app: .iMessage),
            createTemplate(title: "Group Chat Chaos", subtitle: "Start a chaotic group conversation", app: .telegram),
            createTemplate(title: "Mom Pranked", subtitle: "Classic mom prank template", app: .iMessage)
        ]
        tableView.reloadData()
    }

    private func createTemplate(title: String, subtitle: String, app: ChatApp) -> ChatTemplate {
        let contact1 = Contact(name: "Me", avatar: .emoji("😎"))
        let contact2 = Contact(name: "Friend", avatar: .emoji("🤪"))
        let messages = [
            Message(senderId: contact1.id, text: "Hey you won't believe this!", timestamp: Date()),
            Message(senderId: contact2.id, text: "What happened??", timestamp: Date()),
            Message(senderId: contact1.id, text: "I just won $1M from crypto!", timestamp: Date()),
            Message(senderId: contact2.id, text: "WHAT?! That's amazing! 🚀", timestamp: Date())
        ]
        let conversation = Conversation(app: app, contacts: [contact1, contact2], messages: messages)
        return ChatTemplate(title: title, subtitle: subtitle, conversation: conversation)
    }
}

extension TemplatesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templates.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCell", for: indexPath) as! TemplateCell
        cell.configure(with: templates[indexPath.row], index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let template = templates[indexPath.row]
        let editorVC = ChatEditorViewController(chatApp: template.conversation.chatApp)
        navigationController?.pushViewController(editorVC, animated: true)
        triggerHaptic()
    }

    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }
    }
}

class TemplateCell: UITableViewCell {
    private let iconView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppTheme.surface
        accessoryType = .disclosureIndicator

        iconView.layer.cornerRadius = 12
        iconView.addSubview(iconLabel)
        contentView.addSubview(iconView)

        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = AppTheme.textPrimary
        contentView.addSubview(titleLabel)

        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = AppTheme.textSecondary
        contentView.addSubview(subtitleLabel)

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 50),
            iconView.heightAnchor.constraint(equalToConstant: 50),

            iconLabel.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),

            subtitleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 12),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }

    func configure(with template: ChatTemplate, index: Int) {
        titleLabel.text = template.title
        subtitleLabel.text = template.subtitle

        let icons = ["💬", "✈️", "📱", "👻", "🎮"]
        let appColors: [UIColor] = [
            UIColor(hex: "007AFF"),
            UIColor(hex: "0088CC"),
            UIColor(hex: "25D366"),
            UIColor(hex: "FFFC00"),
            UIColor(hex: "5865F2")
        ]
        let iconIndex = index % icons.count
        iconLabel.text = icons[iconIndex]
        iconView.backgroundColor = appColors[iconIndex].withAlphaComponent(0.2)
    }
}
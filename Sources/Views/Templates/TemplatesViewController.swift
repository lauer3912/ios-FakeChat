import UIKit

class TemplatesViewController: UIViewController {
    private var tableView: UITableView!
    private var templates: [ChatTemplate] = []
    
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadTemplates()
    }
    
    private func setupUI() {
        view.backgroundColor = Design.bgPrimary
        
        // Header
        headerLabel.text = "Templates"
        headerLabel.font = Design.Typography.largeTitle
        headerLabel.textColor = .white
        view.addSubview(headerLabel)
        
        subtitleLabel.text = "Start with a prank"
        subtitleLabel.font = Design.Typography.body
        subtitleLabel.textColor = Design.cyan
        view.addSubview(subtitleLabel)
        
        // Table with inset group style
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TemplateCell.self, forCellReuseIdentifier: "TemplateCell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Design.Spacing.lg),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Design.Spacing.xs),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            
            tableView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Design.Spacing.md),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadTemplates() {
        templates = [
            createTemplate(title: "Celebrity Roast", subtitle: "Hilarious celebrity comeback", emoji: "😂", color: Design.pink),
            createTemplate(title: "Boss Prank", subtitle: "Tell your boss you're sick", emoji: "💼", color: Design.orange),
            createTemplate(title: "Crush Confession", subtitle: "Finally tell them how you feel", emoji: "❤️", color: Design.pink),
            createTemplate(title: "Group Chat Chaos", subtitle: "Start a chaotic group conversation", emoji: "🎉", color: Design.purple),
            createTemplate(title: "Mom Pranked", subtitle: "Classic mom prank template", emoji: "😱", color: Design.cyan)
        ]
        tableView.reloadData()
    }
    
    private func createTemplate(title: String, subtitle: String, emoji: String, color: UIColor) -> ChatTemplate {
        let contact1 = Contact(name: "Me", avatar: .emoji("😎"))
        let contact2 = Contact(name: "Friend", avatar: .emoji("🤪"))
        let messages = [
            Message(senderId: contact1.id, text: "Hey you won't believe this!", timestamp: Date()),
            Message(senderId: contact2.id, text: "What happened??", timestamp: Date()),
            Message(senderId: contact1.id, text: "I just won $1M from crypto!", timestamp: Date()),
            Message(senderId: contact2.id, text: "WHAT?! That's amazing! 🚀", timestamp: Date())
        ]
        let conversation = Conversation(app: .iMessage, contacts: [contact1, contact2], messages: messages)
        return ChatTemplate(title: title, subtitle: subtitle, conversation: conversation)
    }
    
    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        triggerHaptic()
        
        let template = templates[indexPath.row]
        let editorVC = ChatEditorViewController(chatApp: template.conversation.chatApp)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

class TemplateCell: UITableViewCell {
    private let cardView = UIView()
    private let iconLabel = UILabel()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowIcon = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        // Card
        cardView.backgroundColor = Design.bgSecondary
        cardView.layer.cornerRadius = Design.Radius.medium
        contentView.addSubview(cardView)
        
        // Icon container
        let iconContainer = UIView()
        iconContainer.backgroundColor = Design.glassBg
        iconContainer.layer.cornerRadius = 22
        iconContainer.layer.borderWidth = 1
        iconContainer.layer.borderColor = Design.glassBorder.cgColor
        cardView.addSubview(iconContainer)
        
        // Emoji
        iconLabel.font = .systemFont(ofSize: 24)
        iconLabel.textAlignment = .center
        iconContainer.addSubview(iconLabel)
        
        // Title
        titleLabel.font = Design.Typography.headline
        titleLabel.textColor = .white
        cardView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.font = Design.Typography.footnote
        subtitleLabel.textColor = Design.cyan.withAlphaComponent(0.8)
        cardView.addSubview(subtitleLabel)
        
        // Arrow
        arrowIcon.image = UIImage(systemName: "chevron.right")
        arrowIcon.tintColor = UIColor.white.withAlphaComponent(0.3)
        cardView.addSubview(arrowIcon)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        arrowIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            iconContainer.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            iconContainer.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 44),
            iconContainer.heightAnchor.constraint(equalToConstant: 44),
            
            iconLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -12),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 14),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.trailingAnchor.constraint(equalTo: arrowIcon.leadingAnchor, constant: -12),
            
            arrowIcon.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            arrowIcon.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            arrowIcon.widthAnchor.constraint(equalToConstant: 12),
            arrowIcon.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        Design.Shadows.apply(to: cardView.layer, color: .black, opacity: 0.3, radius: 15, offset: CGSize(width: 0, height: 5))
    }
    
    func configure(with template: ChatTemplate, index: Int) {
        titleLabel.text = template.title
        subtitleLabel.text = template.subtitle
        
        let emojis = ["😂", "💼", "❤️", "🎉", "😱"]
        iconLabel.text = emojis[index % emojis.count]
    }
}
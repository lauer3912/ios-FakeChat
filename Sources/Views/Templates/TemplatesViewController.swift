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
        view.backgroundColor = .black
        title = "Templates"
        
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.backgroundColor = .black
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TemplateCell.self, forCellReuseIdentifier: "TemplateCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = 80
        view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadTemplates() {
        templates = [
            createTemplate(title: "Celebrity Roast", subtitle: "Hilarious comeback", emoji: "😂", color: UIColor(hex: "FF2D7A")),
            createTemplate(title: "Boss Prank", subtitle: "Classic work prank", emoji: "💼", color: UIColor(hex: "FF9F0A")),
            createTemplate(title: "Crush Confession", subtitle: "Tell them how you feel", emoji: "❤️", color: UIColor(hex: "E1306C")),
            createTemplate(title: "Group Chaos", subtitle: "Start drama", emoji: "🎉", color: UIColor(hex: "A855F7")),
            createTemplate(title: "Mom Pranked", subtitle: "Classic comedy", emoji: "😱", color: UIColor(hex: "00D4FF"))
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
        cell.configure(with: templates[indexPath.row])
        return cell
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
        backgroundColor = .black
        selectionStyle = .none
        
        iconLabel.font = .systemFont(ofSize: 28)
        contentView.addSubview(iconLabel)
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        contentView.addSubview(titleLabel)
        
        subtitleLabel.font = .systemFont(ofSize: 14, weight: .regular)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        contentView.addSubview(subtitleLabel)
        
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconLabel.widthAnchor.constraint(equalToConstant: 40),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: iconLabel.trailingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(with template: ChatTemplate) {
        titleLabel.text = template.title
        subtitleLabel.text = template.subtitle
        
        // Extract emoji from title or use default
        if template.title.contains("Celebrity") {
            iconLabel.text = "😂"
        } else if template.title.contains("Boss") {
            iconLabel.text = "💼"
        } else if template.title.contains("Crush") {
            iconLabel.text = "❤️"
        } else if template.title.contains("Group") {
            iconLabel.text = "🎉"
        } else {
            iconLabel.text = "😱"
        }
    }
}
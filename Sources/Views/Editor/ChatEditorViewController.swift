import UIKit

class ChatEditorViewController: UIViewController {
    private let chatApp: ChatApp
    private var conversation = Conversation(app: ChatApp.iMessage)
    private var tableView: UITableView!
    private var previewButton: UIButton!

    init(chatApp: ChatApp) {
        self.chatApp = chatApp
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConversation()
    }

    private func setupUI() {
        title = "Create Chat"
        view.backgroundColor = AppTheme.background

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add Message", style: .plain, target: self, action: #selector(addMessageTapped))
        navigationItem.rightBarButtonItem?.tintColor = Theme.accentCyan

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppTheme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "AddCell")
        view.addSubview(tableView)

        previewButton = UIButton(type: .system)
        previewButton.setTitle("Preview Screenshot", for: .normal)
        previewButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        previewButton.backgroundColor = Theme.accentCyan
        previewButton.setTitleColor(.black, for: .normal)
        previewButton.layer.cornerRadius = 16
        previewButton.addTarget(self, action: #selector(previewTapped), for: .touchUpInside)
        view.addSubview(previewButton)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        previewButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: previewButton.topAnchor, constant: -16),

            previewButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previewButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            previewButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            previewButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    private func setupConversation() {
        let userContact = Contact(name: "Me", avatar: .emoji("😎"), isOnline: false)
        let otherContact = Contact(name: "John", avatar: .emoji("😄"), isOnline: true)
        conversation.contacts = [userContact, otherContact]

        let timestamp = Date()
        let msg1 = Message(senderId: userContact.id, text: "Hey, what's up?", timestamp: timestamp.addingTimeInterval(-300), status: .read)
        let msg2 = Message(senderId: otherContact.id, text: "Not much, just hanging out 👋", timestamp: timestamp, status: .delivered)
        conversation.messages = [msg1, msg2]
    }

    @objc private func addMessageTapped() {
        let alert = UIAlertController(title: "Add Message", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Sent by Me", style: .default) { [weak self] _ in
            self?.showAddMessageUI(isSentByMe: true)
        })
        alert.addAction(UIAlertAction(title: "Sent by Other", style: .default) { [weak self] _ in
            self?.showAddMessageUI(isSentByMe: false)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    private func showAddMessageUI(isSentByMe: Bool) {
        let contact = isSentByMe ? conversation.contacts[0] : conversation.contacts[1]

        let alert = UIAlertController(title: "Message from \(contact.name)", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter message text"
        }

        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            let message = Message(senderId: contact.id, text: text, timestamp: Date(), status: .sent)
            self?.conversation.messages.append(message)
            self?.tableView.reloadData()
            self?.triggerHaptic()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }

    @objc private func previewTapped() {
        let previewVC = PreviewViewController(conversation: conversation)
        navigationController?.pushViewController(previewVC, animated: true)
    }

    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}

extension ChatEditorViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 2 // Contacts
        case 1: return conversation.messages.count
        case 2: return 1 // Add button
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0: return "Contacts"
        case 1: return "Messages (\(conversation.messages.count))"
        case 2: return nil
        default: return nil
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
            if indexPath.row < conversation.contacts.count {
                cell.configure(with: conversation.contacts[indexPath.row])
            }
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
            let message = conversation.messages[indexPath.row]
            let contact = conversation.contacts.first { $0.id == message.senderId }
            let isSentByMe = message.senderId == conversation.contacts.first?.id
            cell.configure(with: message, contactName: contact?.name ?? "Unknown", chatApp: chatApp, isSentByMe: isSentByMe)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath)
            cell.textLabel?.text = "+ Add Message"
            cell.textLabel?.textColor = Theme.accentCyan
            cell.backgroundColor = AppTheme.surface
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            addMessageTapped()
        }
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section == 1 else { return nil }
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.conversation.messages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

class ContactCell: UITableViewCell {
    private let avatarLabel = UILabel()
    private let nameLabel = UILabel()
    private let statusDot = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppTheme.surface
        selectionStyle = .default

        avatarLabel.font = .systemFont(ofSize: 32)
        contentView.addSubview(avatarLabel)

        nameLabel.font = .systemFont(ofSize: 17, weight: .medium)
        nameLabel.textColor = AppTheme.textPrimary
        contentView.addSubview(nameLabel)

        statusDot.layer.cornerRadius = 5
        contentView.addSubview(statusDot)

        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusDot.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            avatarLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 12),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusDot.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 8),
            statusDot.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusDot.widthAnchor.constraint(equalToConstant: 10),
            statusDot.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func configure(with contact: Contact) {
        switch contact.avatar {
        case .emoji(let e): avatarLabel.text = e
        case .image: avatarLabel.text = "🧑"
        }
        nameLabel.text = contact.name
        statusDot.backgroundColor = contact.isOnline ? Theme.success : Theme.textSecondary
    }
}

class MessageCell: UITableViewCell {
    private let bubbleView = UIView()
    private let senderLabel = UILabel()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()

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

        bubbleView.layer.cornerRadius = 18
        contentView.addSubview(bubbleView)

        senderLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        senderLabel.textColor = Theme.accentCyan
        bubbleView.addSubview(senderLabel)

        messageLabel.font = .systemFont(ofSize: 16)
        messageLabel.numberOfLines = 0
        bubbleView.addSubview(messageLabel)

        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.textColor = AppTheme.textSecondary
        bubbleView.addSubview(timeLabel)

        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 280),
            senderLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            senderLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            senderLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 6),
            timeLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
            timeLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with message: Message, contactName: String, chatApp: ChatApp, isSentByMe: Bool) {
        senderLabel.text = contactName
        messageLabel.text = message.text

        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: message.timestamp)

        bubbleView.backgroundColor = isSentByMe ? chatApp.bubbleSentColor : chatApp.bubbleReceivedColor
        messageLabel.textColor = isSentByMe ? (chatApp.isDarkBackground ? .white : .black) : (chatApp.isDarkBackground ? .white : .black)
    }
}
import UIKit

class ChatEditorViewController: UIViewController {
    
    private let chatApp: ChatApp
    private var conversation: Conversation
    private var contacts: [Contact] = []
    private var messages: [Message] = []
    
    // UI Components
    private let headerView = UIView()
    private let contactAvatarView = UIView()
    private let contactAvatarLabel = UILabel()
    private let contactNameLabel = UILabel()
    private let contactStatusLabel = UILabel()
    private let tableView = UITableView()
    private let inputBar = UIView()
    private let messageInputField = UITextField()
    private let sendButton = UIButton()
    private let addMessageButton = UIButton()
    
    init(chatApp: ChatApp) {
        self.chatApp = chatApp
        self.conversation = Conversation(app: chatApp)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigation()
        setupInitialData()
    }
    
    private func setupNavigation() {
        title = chatApp.displayName
        navigationController?.navigationBar.prefersLargeTitles = false
        
        // Preview button
        let previewButton = UIBarButtonItem(
            image: UIImage(systemName: "eye"),
            style: .plain,
            target: self,
            action: #selector(previewTapped)
        )
        navigationItem.rightBarButtonItem = previewButton
    }
    
    private func setupUI() {
        view.backgroundColor = Design.Colors.backgroundPrimary
        
        // Header View
        headerView.backgroundColor = Design.Colors.backgroundSecondary
        view.addSubview(headerView)
        
        // Contact Avatar
        contactAvatarView.backgroundColor = chatApp.primaryColor.withAlphaComponent(0.2)
        contactAvatarView.layer.cornerRadius = 24
        headerView.addSubview(contactAvatarView)
        
        contactAvatarLabel.font = .systemFont(ofSize: 24)
        contactAvatarLabel.textAlignment = .center
        contactAvatarView.addSubview(contactAvatarLabel)
        
        // Contact Name
        contactNameLabel.font = Design.Typography.headline
        contactNameLabel.textColor = Design.Colors.textPrimary
        headerView.addSubview(contactNameLabel)
        
        // Contact Status
        contactStatusLabel.font = Design.Typography.caption1
        contactStatusLabel.textColor = Design.Colors.textSecondary
        headerView.addSubview(contactStatusLabel)
        
        // Table View
        tableView.backgroundColor = Design.Colors.backgroundPrimary
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MessageCell.self, forCellReuseIdentifier: "MessageCell")
        tableView.keyboardDismissMode = .interactive
        view.addSubview(tableView)
        
        // Input Bar
        inputBar.backgroundColor = Design.Colors.backgroundSecondary
        view.addSubview(inputBar)
        
        // Add Message Button
        addMessageButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addMessageButton.tintColor = chatApp.primaryColor
        addMessageButton.addTarget(self, action: #selector(addMessageTapped), for: .touchUpInside)
        inputBar.addSubview(addMessageButton)
        
        // Message Input
        messageInputField.backgroundColor = Design.Colors.backgroundPrimary
        messageInputField.textColor = Design.Colors.textPrimary
        messageInputField.font = Design.Typography.body
        messageInputField.placeholder = "Type a message..."
        messageInputField.layer.cornerRadius = Design.Radius.large
        messageInputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        messageInputField.leftViewMode = .always
        messageInputField.delegate = self
        inputBar.addSubview(messageInputField)
        
        // Send Button
        sendButton.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        sendButton.tintColor = chatApp.primaryColor
        sendButton.addTarget(self, action: #selector(sendTapped), for: .touchUpInside)
        inputBar.addSubview(sendButton)
        
        // Layout
        setupConstraints()
    }
    
    private func setupConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        contactAvatarView.translatesAutoresizingMaskIntoConstraints = false
        contactAvatarLabel.translatesAutoresizingMaskIntoConstraints = false
        contactNameLabel.translatesAutoresizingMaskIntoConstraints = false
        contactStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        inputBar.translatesAutoresizingMaskIntoConstraints = false
        addMessageButton.translatesAutoresizingMaskIntoConstraints = false
        messageInputField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // Header
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 80),
            
            contactAvatarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: Design.Spacing.lg),
            contactAvatarView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            contactAvatarView.widthAnchor.constraint(equalToConstant: 48),
            contactAvatarView.heightAnchor.constraint(equalToConstant: 48),
            
            contactAvatarLabel.centerXAnchor.constraint(equalTo: contactAvatarView.centerXAnchor),
            contactAvatarLabel.centerYAnchor.constraint(equalTo: contactAvatarView.centerYAnchor),
            
            contactNameLabel.leadingAnchor.constraint(equalTo: contactAvatarView.trailingAnchor, constant: Design.Spacing.md),
            contactNameLabel.topAnchor.constraint(equalTo: contactAvatarView.topAnchor, constant: Design.Spacing.xs),
            
            contactStatusLabel.leadingAnchor.constraint(equalTo: contactAvatarView.trailingAnchor, constant: Design.Spacing.md),
            contactStatusLabel.topAnchor.constraint(equalTo: contactNameLabel.bottomAnchor, constant: Design.Spacing.xs),
            
            // Table
            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),
            
            // Input Bar
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputBar.heightAnchor.constraint(equalToConstant: 60),
            
            addMessageButton.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: Design.Spacing.lg),
            addMessageButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            addMessageButton.widthAnchor.constraint(equalToConstant: 36),
            addMessageButton.heightAnchor.constraint(equalToConstant: 36),
            
            messageInputField.leadingAnchor.constraint(equalTo: addMessageButton.trailingAnchor, constant: Design.Spacing.md),
            messageInputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -Design.Spacing.md),
            messageInputField.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            messageInputField.heightAnchor.constraint(equalToConstant: 40),
            
            sendButton.trailingAnchor.constraint(equalTo: inputBar.trailingAnchor, constant: -Design.Spacing.lg),
            sendButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 36),
            sendButton.heightAnchor.constraint(equalToConstant: 36)
        ])
    }
    
    private func setupInitialData() {
        // Add a default contact
        let defaultContact = Contact(name: "John Doe", avatar: .emoji("😎"), isOnline: true)
        contacts = [defaultContact]
        conversation.contacts = contacts
        
        // Add sample messages
        let receivedMsg = Message(senderId: defaultContact.id, text: "Hey! How are you?", timestamp: Date().addingTimeInterval(-300), status: .read)
        let sentMsg = Message(senderId: Message.currentUserId, text: "I'm good! Just testing this app", timestamp: Date().addingTimeInterval(-60), status: .delivered)
        
        messages = [receivedMsg, sentMsg]
        conversation.messages = messages
        
        updateContactUI()
        tableView.reloadData()
    }
    
    private func updateContactUI() {
        guard let contact = contacts.first else { return }
        contactAvatarLabel.text = contact.avatar.display
        contactNameLabel.text = contact.name
        contactStatusLabel.text = contact.isOnline ? "online" : contact.lastSeenText
    }
    
    // MARK: - Actions
    
    @objc private func previewTapped() {
        triggerHaptic()
        let previewVC = PreviewViewController(conversation: conversation)
        navigationController?.pushViewController(previewVC, animated: true)
    }
    
    @objc private func addMessageTapped() {
        triggerHaptic()
        showAddMessageAlert()
    }
    
    @objc private func sendTapped() {
        guard let text = messageInputField.text, !text.isEmpty else { return }
        triggerHaptic()
        
        let newMessage = Message(
            senderId: Message.currentUserId,
            text: text,
            timestamp: Date(),
            status: .sent
        )
        
        messages.append(newMessage)
        conversation.messages = messages
        messageInputField.text = ""
        
        tableView.insertRows(at: [IndexPath(row: messages.count - 1, section: 0)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: messages.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    private func showAddMessageAlert() {
        let alert = UIAlertController(title: "Add Message", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Sent Message (Me)", style: .default) { [weak self] _ in
            self?.showMessageInputAlert(isSent: true)
        })
        
        alert.addAction(UIAlertAction(title: "Received Message", style: .default) { [weak self] _ in
            self?.showMessageInputAlert(isSent: false)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showMessageInputAlert(isSent: Bool) {
        let alert = UIAlertController(title: isSent ? "Sent Message" : "Received Message", message: nil, preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Enter message text..."
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty else { return }
            
            let senderId = isSent ? Message.currentUserId : (self?.contacts.first?.id ?? UUID())
            let newMessage = Message(
                senderId: senderId ?? Message.currentUserId,
                text: text,
                timestamp: Date(),
                status: isSent ? .sent : .delivered
            )
            
            self?.messages.append(newMessage)
            self?.conversation.messages = self?.messages ?? []
            self?.tableView.reloadData()
            self?.tableView.scrollToRow(at: IndexPath(row: (self?.messages.count ?? 1) - 1, section: 0), at: .bottom, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ChatEditorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as! MessageCell
        let message = messages[indexPath.row]
        let isMe = message.senderId == Message.currentUserId
        cell.configure(with: message, isSentByMe: isMe, chatApp: chatApp)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ChatEditorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITextFieldDelegate
extension ChatEditorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendTapped()
        return true
    }
}

// MARK: - Message Cell
class MessageCell: UITableViewCell {
    private let bubbleView = UIView()
    private let messageLabel = UILabel()
    private let timeLabel = UILabel()
    private let statusImageView = UIImageView()
    
    private var bubbleLeadingConstraint: NSLayoutConstraint!
    private var bubbleTrailingConstraint: NSLayoutConstraint!
    
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
        
        bubbleView.layer.cornerRadius = Design.Radius.medium
        contentView.addSubview(bubbleView)
        
        messageLabel.font = Design.Typography.body
        messageLabel.numberOfLines = 0
        bubbleView.addSubview(messageLabel)
        
        timeLabel.font = Design.Typography.caption2
        timeLabel.textColor = Design.Colors.textSecondary
        contentView.addSubview(timeLabel)
        
        statusImageView.contentMode = .scaleAspectFit
        statusImageView.tintColor = Design.Colors.accentCyan
        contentView.addSubview(statusImageView)
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        
        bubbleLeadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.Spacing.lg)
        bubbleTrailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.Spacing.xs),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: Design.Spacing.md),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: Design.Spacing.lg),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -Design.Spacing.lg),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -Design.Spacing.md),
            
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Design.Spacing.xs),
            
            timeLabel.topAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: Design.Spacing.xs),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Design.Spacing.xs),
            
            statusImageView.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 14),
            statusImageView.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    func configure(with message: Message, isSentByMe: Bool, chatApp: ChatApp) {
        messageLabel.text = message.text
        
        // Time formatting
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = formatter.string(from: message.timestamp)
        
        // Bubble color
        if isSentByMe {
            bubbleView.backgroundColor = chatApp.primaryColor
            messageLabel.textColor = .white
            bubbleLeadingConstraint.isActive = false
            bubbleTrailingConstraint.isActive = true
            
            timeLabel.trailingAnchor.constraint(equalTo: statusImageView.leadingAnchor, constant: -Design.Spacing.xs).isActive = true
            statusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg).isActive = true
            
            // Status
            switch message.status {
            case .sending:
                statusImageView.image = UIImage(systemName: "clock")
            case .sent:
                statusImageView.image = UIImage(systemName: "checkmark")
            case .delivered:
                statusImageView.image = UIImage(systemName: "checkmark.circle")
            case .read:
                statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            case .failed:
                statusImageView.image = UIImage(systemName: "exclamationmark.circle")
                statusImageView.tintColor = Design.Colors.error
            }
            statusImageView.isHidden = false
        } else {
            bubbleView.backgroundColor = Design.Colors.backgroundSecondary
            messageLabel.textColor = Design.Colors.textPrimary
            bubbleTrailingConstraint.isActive = false
            bubbleLeadingConstraint.isActive = true
            
            statusImageView.isHidden = true
        }
    }
}
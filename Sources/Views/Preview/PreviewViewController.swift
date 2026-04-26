import UIKit

class PreviewViewController: UIViewController {
    private let conversation: Conversation
    private var previewView: ChatPreviewView!
    private var exportButton: UIButton!
    private var formatSegment: UISegmentedControl!

    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Preview"
        view.backgroundColor = AppTheme.background

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareTapped))
        navigationItem.rightBarButtonItem?.tintColor = Theme.accentCyan

        formatSegment = UISegmentedControl(items: ["Phone", "Square", "Story"])
        formatSegment.selectedSegmentIndex = 0
        formatSegment.addTarget(self, action: #selector(formatChanged), for: .valueChanged)
        view.addSubview(formatSegment)

        previewView = ChatPreviewView(conversation: conversation)
        previewView.layer.cornerRadius = 20
        previewView.layer.masksToBounds = true
        view.addSubview(previewView)

        exportButton = UIButton(type: .system)
        exportButton.setTitle("Save to Photos", for: .normal)
        exportButton.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        exportButton.backgroundColor = Theme.accentCyan
        exportButton.setTitleColor(.black, for: .normal)
        exportButton.layer.cornerRadius = 16
        exportButton.addTarget(self, action: #selector(saveToPhotos), for: .touchUpInside)
        view.addSubview(exportButton)

        formatSegment.translatesAutoresizingMaskIntoConstraints = false
        previewView.translatesAutoresizingMaskIntoConstraints = false
        exportButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            formatSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            formatSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            formatSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            previewView.topAnchor.constraint(equalTo: formatSegment.bottomAnchor, constant: 16),
            previewView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            previewView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 1.0),

            exportButton.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: 16),
            exportButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            exportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            exportButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            exportButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }

    @objc private func formatChanged() {
        let multiplier: CGFloat
        switch formatSegment.selectedSegmentIndex {
        case 0: multiplier = 1.0 // Phone
        case 1: multiplier = 1.0 // Square
        case 2: multiplier = 16.0/9.0 // Story
        default: multiplier = 1.0
        }

        previewView.constraints.forEach { constraint in
            if constraint.firstAttribute == .height {
                constraint.isActive = false
            }
        }
        previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: multiplier).isActive = true

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func shareTapped() {
        let image = previewView.renderToImage()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }

    @objc private func saveToPhotos() {
        let image = previewView.renderToImage()
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        } else {
            let alert = UIAlertController(title: "Saved!", message: "Screenshot saved to Photos", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            triggerHaptic()
        }
    }

    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

class ChatPreviewView: UIView {
    private let conversation: Conversation
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let statusBarView = UIView()
    private let headerView = UIView()
    private let messagesView = UIView()

    init(conversation: Conversation) {
        self.conversation = conversation
        super.init(frame: .zero)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = conversation.chatApp.chatBackgroundColor

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        setupStatusBar()
        setupHeader()
        setupMessages()

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        statusBarView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        messagesView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            statusBarView.topAnchor.constraint(equalTo: contentView.topAnchor),
            statusBarView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            statusBarView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            statusBarView.heightAnchor.constraint(equalToConstant: 47),

            headerView.topAnchor.constraint(equalTo: statusBarView.bottomAnchor),
            headerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 60),

            messagesView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 8),
            messagesView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            messagesView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            messagesView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -80)
        ])
    }

    private func setupStatusBar() {
        statusBarView.backgroundColor = conversation.chatApp.chatBackgroundColor

        let timeLabel = UILabel()
        timeLabel.text = "9:41"
        timeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        timeLabel.textColor = conversation.chatApp.isDarkBackground ? .white : .black
        statusBarView.addSubview(timeLabel)

        let batteryIcon = UIImageView(image: UIImage(systemName: "battery.100"))
        batteryIcon.tintColor = conversation.chatApp.isDarkBackground ? .white : .black
        statusBarView.addSubview(batteryIcon)

        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        batteryIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: statusBarView.centerYAnchor, constant: 10),
            timeLabel.leadingAnchor.constraint(equalTo: statusBarView.leadingAnchor, constant: 20),
            batteryIcon.centerYAnchor.constraint(equalTo: statusBarView.centerYAnchor, constant: 10),
            batteryIcon.trailingAnchor.constraint(equalTo: statusBarView.trailingAnchor, constant: -20)
        ])
    }

    private func setupHeader() {
        headerView.backgroundColor = conversation.chatApp.chatBackgroundColor

        let avatarLabel = UILabel()
        avatarLabel.text = "😄"
        avatarLabel.font = .systemFont(ofSize: 36)
        headerView.addSubview(avatarLabel)

        let nameLabel = UILabel()
        nameLabel.text = conversation.contacts.last?.name ?? "Chat"
        nameLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        nameLabel.textColor = conversation.chatApp.isDarkBackground ? .white : .black
        headerView.addSubview(nameLabel)

        let statusLabel = UILabel()
        statusLabel.text = "online"
        statusLabel.font = .systemFont(ofSize: 13)
        statusLabel.textColor = conversation.chatApp.isDarkBackground ? UIColor.white.withAlphaComponent(0.6) : UIColor.black.withAlphaComponent(0.6)
        headerView.addSubview(statusLabel)

        avatarLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            avatarLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            avatarLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 12),
            nameLabel.bottomAnchor.constraint(equalTo: headerView.centerYAnchor, constant: -2),
            statusLabel.leadingAnchor.constraint(equalTo: avatarLabel.trailingAnchor, constant: 12),
            statusLabel.topAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 2)
        ])
    }

    private func setupMessages() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        messagesView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: messagesView.topAnchor, constant: 16),
            stackView.leadingAnchor.constraint(equalTo: messagesView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: messagesView.trailingAnchor, constant: -16)
        ])

        let formatter = DateFormatter()
        formatter.timeStyle = .short

        var lastSenderId: UUID?
        var lastDate: Date?

        for message in conversation.messages {
            let isSent = message.senderId == conversation.contacts.first?.id
            let contact = conversation.contacts.first { $0.id == message.senderId }

            let bubbleView = createBubble(text: message.text, isSent: isSent, contactName: contact?.name ?? "", time: formatter.string(from: message.timestamp), chatApp: conversation.chatApp)
            stackView.addArrangedSubview(bubbleView)

            lastSenderId = message.senderId
            lastDate = message.timestamp
        }
    }

    private func createBubble(text: String, isSent: Bool, contactName: String, time: String, chatApp: ChatApp) -> UIView {
        let container = UIView()

        let bubble = UIView()
        bubble.layer.cornerRadius = 18
        bubble.backgroundColor = isSent ? chatApp.bubbleSentColor : chatApp.bubbleReceivedColor
        container.addSubview(bubble)

        let nameLabel = UILabel()
        nameLabel.text = isSent ? "" : contactName
        nameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        nameLabel.textColor = chatApp.isDarkBackground ? Theme.accentCyan : chatApp.primaryColor
        bubble.addSubview(nameLabel)

        let textLabel = UILabel()
        textLabel.text = text
        textLabel.font = .systemFont(ofSize: 16)
        textLabel.textColor = chatApp.isDarkBackground ? .white : .black
        textLabel.numberOfLines = 0
        bubble.addSubview(textLabel)

        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.textColor = chatApp.isDarkBackground ? UIColor.white.withAlphaComponent(0.5) : UIColor.black.withAlphaComponent(0.5)
        bubble.addSubview(timeLabel)

        container.translatesAutoresizingMaskIntoConstraints = false
        bubble.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: container.superview!.topAnchor),
            container.bottomAnchor.constraint(equalTo: container.superview!.bottomAnchor),
            container.widthAnchor.constraint(equalToConstant: 300),

            bubble.topAnchor.constraint(equalTo: container.topAnchor),
            bubble.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            bubble.widthAnchor.constraint(lessThanOrEqualToConstant: 260),

            nameLabel.topAnchor.constraint(equalTo: bubble.topAnchor, constant: 10),
            nameLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 14),
            nameLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14),

            textLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            textLabel.leadingAnchor.constraint(equalTo: bubble.leadingAnchor, constant: 14),
            textLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14),

            timeLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: bubble.trailingAnchor, constant: -14),
            timeLabel.bottomAnchor.constraint(equalTo: bubble.bottomAnchor, constant: -8)
        ])

        if isSent {
            bubble.trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
        } else {
            bubble.leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        }

        return container
    }

    func renderToImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: bounds.size)
        return renderer.image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
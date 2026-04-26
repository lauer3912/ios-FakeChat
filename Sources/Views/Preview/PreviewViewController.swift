import UIKit

class PreviewViewController: UIViewController {
    
    private let conversation: Conversation
    private var exportFormat: ExportFormat = .portrait
    
    private let previewView = UIView()
    private let formatSegment = UISegmentedControl()
    private let saveButton = UIButton()
    private let shareButton = UIButton()
    
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
        view.backgroundColor = Design.Colors.backgroundPrimary
        title = "Preview"
        
        // Format Segment
        formatSegment.insertSegment(withTitle: "Portrait", at: 0, animated: false)
        formatSegment.insertSegment(withTitle: "Square", at: 1, animated: false)
        formatSegment.insertSegment(withTitle: "Full", at: 2, animated: false)
        formatSegment.selectedSegmentIndex = 0
        formatSegment.addTarget(self, action: #selector(formatChanged), for: .valueChanged)
        view.addSubview(formatSegment)
        
        // Preview Container
        previewView.backgroundColor = Design.Colors.backgroundSecondary
        previewView.layer.cornerRadius = Design.Radius.large
        previewView.clipsToBounds = true
        view.addSubview(previewView)
        
        // Buttons
        saveButton.setTitle("Save to Photos", for: .normal)
        saveButton.setImage(UIImage(systemName: "square.and.arrow.down"), for: .normal)
        saveButton.backgroundColor = Design.Colors.accentCyan
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.tintColor = .black
        saveButton.layer.cornerRadius = Design.Radius.medium
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        view.addSubview(saveButton)
        
        shareButton.setTitle("Share", for: .normal)
        shareButton.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        shareButton.backgroundColor = Design.Colors.backgroundSecondary
        shareButton.setTitleColor(Design.Colors.textPrimary, for: .normal)
        shareButton.tintColor = Design.Colors.textPrimary
        shareButton.layer.cornerRadius = Design.Radius.medium
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = Design.Colors.accentCyan.cgColor
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
        view.addSubview(shareButton)
        
        // Layout
        formatSegment.translatesAutoresizingMaskIntoConstraints = false
        previewView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            formatSegment.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Design.Spacing.lg),
            formatSegment.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            formatSegment.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Spacing.lg),
            
            previewView.topAnchor.constraint(equalTo: formatSegment.bottomAnchor, constant: Design.Spacing.lg),
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            previewView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -Design.Spacing.xl * 2),
            previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor, multiplier: 16.0/9.0),
            
            saveButton.topAnchor.constraint(equalTo: previewView.bottomAnchor, constant: Design.Spacing.xl),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Spacing.lg),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            shareButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: Design.Spacing.md),
            shareButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            shareButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Spacing.lg),
            shareButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        renderPreview()
    }
    
    private func renderPreview() {
        // Clear existing subviews
        previewView.subviews.forEach { $0.removeFromSuperview() }
        
        // Calculate size based on format
        let containerWidth = previewView.bounds.width
        let containerHeight = previewView.bounds.height
        
        let previewContent = createPreviewContent(width: containerWidth, height: containerHeight)
        previewView.addSubview(previewContent)
        
        previewContent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewContent.topAnchor.constraint(equalTo: previewView.topAnchor),
            previewContent.leadingAnchor.constraint(equalTo: previewView.leadingAnchor),
            previewContent.trailingAnchor.constraint(equalTo: previewView.trailingAnchor),
            previewContent.bottomAnchor.constraint(equalTo: previewView.bottomAnchor)
        ])
    }
    
    private func createPreviewContent(width: CGFloat, height: CGFloat) -> UIView {
        let container = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        container.backgroundColor = Design.Colors.backgroundPrimary
        
        // Header
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 60))
        headerView.backgroundColor = Design.Colors.backgroundSecondary
        container.addSubview(headerView)
        
        // Back button placeholder
        let backImage = UIImageView(image: UIImage(systemName: "chevron.left"))
        backImage.tintColor = Design.Colors.textPrimary
        backImage.frame = CGRect(x: 16, y: 20, width: 24, height: 20)
        headerView.addSubview(backImage)
        
        // Contact name
        let nameLabel = UILabel(frame: CGRect(x: 50, y: 15, width: width - 100, height: 20))
        nameLabel.text = conversation.contacts.first?.name ?? "Chat"
        nameLabel.font = Design.Typography.headline
        nameLabel.textColor = Design.Colors.textPrimary
        nameLabel.textAlignment = .center
        headerView.addSubview(nameLabel)
        
        // Messages area
        let messagesView = UIView(frame: CGRect(x: 0, y: 60, width: width, height: height - 100))
        container.addSubview(messagesView)
        
        // Render messages
        var yOffset: CGFloat = 10
        for message in conversation.messages {
            let isMe = message.senderId == Message.currentUserId
            let bubbleHeight: CGFloat = 44
            
            let bubbleView = UIView(frame: CGRect(
                x: isMe ? width - 200 - 16 : 16,
                y: yOffset,
                width: 200,
                height: bubbleHeight
            ))
            bubbleView.backgroundColor = isMe ? conversation.app.primaryColor : Design.Colors.backgroundSecondary
            bubbleView.layer.cornerRadius = Design.Radius.medium
            messagesView.addSubview(bubbleView)
            
            let textLabel = UILabel(frame: bubbleView.bounds.insetBy(dx: 12, dy: 12))
            textLabel.text = message.text
            textLabel.font = Design.Typography.body
            textLabel.textColor = isMe ? .white : Design.Colors.textPrimary
            textLabel.numberOfLines = 0
            bubbleView.addSubview(textLabel)
            
            yOffset += bubbleHeight + 8
        }
        
        // Input bar
        let inputBar = UIView(frame: CGRect(x: 0, y: height - 40, width: width, height: 40))
        inputBar.backgroundColor = Design.Colors.backgroundSecondary
        container.addSubview(inputBar)
        
        let inputField = UIView(frame: CGRect(x: 50, y: 6, width: width - 100, height: 28))
        inputField.backgroundColor = Design.Colors.backgroundPrimary
        inputField.layer.cornerRadius = 14
        inputBar.addSubview(inputField)
        
        return container
    }
    
    @objc private func formatChanged() {
        triggerHaptic()
        switch formatSegment.selectedSegmentIndex {
        case 0: exportFormat = .portrait
        case 1: exportFormat = .square
        default: exportFormat = .full
        }
        renderPreview()
    }
    
    @objc private func saveTapped() {
        triggerHaptic()
        
        // Generate screenshot
        let renderer = UIGraphicsImageRenderer(bounds: previewView.bounds)
        let image = renderer.image { context in
            previewView.drawHierarchy(in: previewView.bounds, afterScreenUpdates: true)
        }
        
        // Save to photos
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(imageSaved), nil)
    }
    
    @objc private func imageSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            showAlert(title: "Error", message: error.localizedDescription)
        } else {
            showAlert(title: "Saved", message: "Image saved to your photo library")
        }
    }
    
    @objc private func shareTapped() {
        triggerHaptic()
        
        let renderer = UIGraphicsImageRenderer(bounds: previewView.bounds)
        let image = renderer.image { context in
            previewView.drawHierarchy(in: previewView.bounds, afterScreenUpdates: true)
        }
        
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(activityVC, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
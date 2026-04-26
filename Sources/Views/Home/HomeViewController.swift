import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var chatApps = ChatApp.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        title = ""
        
        // Collection with full width cards
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatAppCardCell.self, forCellWithReuseIdentifier: "ChatAppCardCell")
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatAppCardCell", for: indexPath) as! ChatAppCardCell
        cell.configure(with: chatApps[indexPath.item], index: indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        let app = chatApps[indexPath.item]
        let editorVC = ChatEditorViewController(chatApp: app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

// MARK: - Chat App Card Cell (TikTok/Instagram Style)
class ChatAppCardCell: UICollectionViewCell {
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let appNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let chevronView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
    }
    
    private func setupUI() {
        containerView.layer.cornerRadius = 16
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        // Icon
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        containerView.addSubview(iconView)
        
        // App Name
        appNameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        appNameLabel.textColor = .white
        containerView.addSubview(appNameLabel)
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        containerView.addSubview(descriptionLabel)
        
        // Chevron
        chevronView.image = UIImage(systemName: "chevron.right")
        chevronView.tintColor = UIColor.white.withAlphaComponent(0.5)
        chevronView.contentMode = .scaleAspectFit
        containerView.addSubview(chevronView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        appNameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 44),
            iconView.heightAnchor.constraint(equalToConstant: 44),
            
            appNameLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            appNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            appNameLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -12),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 4),
            descriptionLabel.trailingAnchor.constraint(equalTo: chevronView.leadingAnchor, constant: -12),
            
            chevronView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chevronView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronView.widthAnchor.constraint(equalToConstant: 14),
            chevronView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add shadow to content view (not container)
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 10
        contentView.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
    
    func configure(with app: ChatApp, index: Int) {
        appNameLabel.text = app.displayName
        
        // Description for each app
        let descriptions = [
            "Blue bubbles • iOS Messages",
            "Secret chats • Cloud sync",
            "Snaps disappear • Filters",
            "End to end encryption",
            "Stories & Reactions",
            "Real-time updates",
            "Servers & Roles"
        ]
        descriptionLabel.text = descriptions[index % descriptions.count]
        
        // App-specific icon
        let symbolName: String
        let gradientColors: [CGColor]
        
        switch app {
        case .iMessage:
            symbolName = "message.fill"
            gradientColors = [UIColor(hex: "007AFF").cgColor, UIColor(hex: "5856D6").cgColor]
        case .telegram:
            symbolName = "paperplane.fill"
            gradientColors = [UIColor(hex: "0088CC").cgColor, UIColor(hex: "00D4FF").cgColor]
        case .snapchat:
            symbolName = "camera.fill"
            gradientColors = [UIColor(hex: "FFFC00").cgColor, UIColor(hex: "FF2D7A").cgColor]
        case .whatsapp:
            symbolName = "phone.fill"
            gradientColors = [UIColor(hex: "25D366").cgColor, UIColor(hex: "128C7E").cgColor]
        case .instagramDM:
            symbolName = "camera.fill"
            gradientColors = [UIColor(hex: "E1306C").cgColor, UIColor(hex: "F77737").cgColor]
        case .twitterX:
            symbolName = "at"
            gradientColors = [UIColor(hex: "FFFFFF").cgColor, UIColor(hex: "8E8E93").cgColor]
        case .discord:
            symbolName = "bubble.left.and.bubble.right.fill"
            gradientColors = [UIColor(hex: "5865F2").cgColor, UIColor(hex: "7289DA").cgColor]
        }
        
        iconView.image = UIImage(systemName: symbolName)
        
        // Gradient
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Subtle shadow color matching gradient
        contentView.layer.shadowColor = app.primaryColor.cgColor
        contentView.layer.shadowOpacity = 0.3
        contentView.layer.shadowRadius = 15
        contentView.layer.shadowOffset = CGSize(width: 0, height: 8)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer.removeFromSuperlayer()
    }
}
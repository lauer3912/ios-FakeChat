import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var chatApps = ChatApp.allCases
    
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        // Large bold title
        headerLabel.text = "Create"
        headerLabel.font = .systemFont(ofSize: 40, weight: .bold)
        headerLabel.textColor = .white
        view.addSubview(headerLabel)
        
        // Subtitle
        subtitleLabel.text = "Choose a chat platform"
        subtitleLabel.font = .systemFont(ofSize: 16, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.5)
        view.addSubview(subtitleLabel)
        
        // Collection layout - full width cards
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.sectionInset = .zero
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatAppCellV2.self, forCellWithReuseIdentifier: "ChatAppCellV2")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = true
        view.addSubview(collectionView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatAppCellV2", for: indexPath) as! ChatAppCellV2
        cell.configure(with: chatApps[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        let app = chatApps[indexPath.item]
        let editorVC = ChatEditorViewController(chatApp: app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

// MARK: - Premium Chat App Cell
class ChatAppCellV2: UICollectionViewCell {
    private let containerView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let gradientLayer = CAGradientLayer()
    private let glowLayer = CALayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 4, height: containerView.bounds.height)
        glowLayer.frame = iconContainerView.bounds.insetBy(dx: -10, dy: -10)
    }
    
    private func setupUI() {
        containerView.backgroundColor = UIColor(hex: "0D0D0D")
        containerView.layer.cornerRadius = 16
        contentView.addSubview(containerView)
        
        // Icon container with glow
        iconContainerView.layer.cornerRadius = 22
        iconContainerView.clipsToBounds = false
        containerView.addSubview(iconContainerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconContainerView.addSubview(iconImageView)
        
        // Name
        nameLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        nameLabel.textColor = .white
        containerView.addSubview(nameLabel)
        
        // Description
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.45)
        containerView.addSubview(descriptionLabel)
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = UIColor.white.withAlphaComponent(0.25)
        chevronImageView.contentMode = .scaleAspectFit
        containerView.addSubview(chevronImageView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 44),
            iconContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 16),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        // Shadow under entire card
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.4
        containerView.layer.shadowRadius = 12
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }
    
    func configure(with app: ChatApp) {
        nameLabel.text = app.displayName
        
        let (icon, desc, colors, glowColor) = appInfo(for: app)
        iconImageView.image = UIImage(systemName: icon)
        descriptionLabel.text = desc
        
        // Gradient bar on left
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Glow effect
        glowLayer.backgroundColor = glowColor.cgColor
        glowLayer.cornerRadius = 32
        glowLayer.shadowColor = glowColor.cgColor
        glowLayer.shadowOpacity = 0.6
        glowLayer.shadowRadius = 12
        glowLayer.shadowOffset = .zero
        iconContainerView.layer.insertSublayer(glowLayer, at: 0)
        
        // Icon container background
        if let firstColor = colors.first {
            iconContainerView.backgroundColor = UIColor(cgColor: firstColor).withAlphaComponent(0.15)
        }
    }
    
    private func appInfo(for app: ChatApp) -> (String, String, [CGColor], UIColor) {
        switch app {
        case .iMessage:
            return ("message.fill", "Blue bubbles • iOS native", [UIColor(hex: "007AFF").cgColor, UIColor(hex: "5856D6").cgColor], UIColor(hex: "007AFF"))
        case .telegram:
            return ("paperplane.fill", "Secret chats • Cloud sync", [UIColor(hex: "0088CC").cgColor, UIColor(hex: "00D4FF").cgColor], UIColor(hex: "0088CC"))
        case .snapchat:
            return ("camera.fill", "Snaps • Filters • Stories", [UIColor(hex: "FFFC00").cgColor, UIColor(hex: "FF2D7A").cgColor], UIColor(hex: "FFFC00"))
        case .whatsapp:
            return ("phone.fill", "End-to-end encryption", [UIColor(hex: "25D366").cgColor, UIColor(hex: "128C7E").cgColor], UIColor(hex: "25D366"))
        case .instagramDM:
            return ("camera.fill", "Stories • Reactions", [UIColor(hex: "E1306C").cgColor, UIColor(hex: "F77737").cgColor], UIColor(hex: "E1306C"))
        case .twitterX:
            return ("at", "Real-time updates", [UIColor(hex: "FFFFFF").cgColor, UIColor(hex: "888888").cgColor], UIColor.white)
        case .discord:
            return ("bubble.left.and.bubble.right.fill", "Servers • Roles", [UIColor(hex: "5865F2").cgColor, UIColor(hex: "7289DA").cgColor], UIColor(hex: "5865F2"))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer.removeFromSuperlayer()
        glowLayer.removeFromSuperlayer()
    }
}
import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var chatApps = ChatApp.allCases
    
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupGradientBackground()
    }
    
    private func setupGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            Design.bgPrimary.cgColor,
            Design.bgSecondary.cgColor,
            Design.bgPrimary.cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func setupUI() {
        // Title
        headerLabel.text = "Create"
        headerLabel.font = Design.Typography.largeTitle
        headerLabel.textColor = .white
        headerLabel.alpha = 0
        view.addSubview(headerLabel)
        
        // Subtitle
        subtitleLabel.text = "Choose your chat app"
        subtitleLabel.font = Design.Typography.body
        subtitleLabel.textColor = Design.cyan
        subtitleLabel.alpha = 0
        view.addSubview(subtitleLabel)
        
        // Layout
        let layout = createLayout()
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(AppCell.self, forCellWithReuseIdentifier: "AppCell")
        collectionView.alpha = 0
        view.addSubview(collectionView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Design.Spacing.lg),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Design.Spacing.xs),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.lg),
            
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Design.Spacing.lg),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.md),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Design.Spacing.md),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Design.Spacing.lg)
        ])
        
        // Animate in
        animateIn()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(180))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(180))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 20, trailing: 0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func animateIn() {
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut) {
            self.headerLabel.alpha = 1
            self.subtitleLabel.alpha = 1
            self.collectionView.alpha = 1
        }
        
        // Staggered cell animation
        for (index, _) in chatApps.enumerated() {
            let delay = 0.1 + Double(index) * 0.05
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
    }
    
    private func triggerHaptic() {
        if AppTheme.hapticEnabled {
            let generator = UIImpactFeedbackGenerator(style: .medium)
            generator.impactOccurred()
        }
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath) as! AppCell
        let app = chatApps[indexPath.item]
        cell.configure(with: app, isLight: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        
        // Scale animation
        if let cell = collectionView.cellForItem(at: indexPath) {
            UIView.animate(withDuration: 0.1, animations: {
                cell.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            }) { _ in
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                }
            }
        }
        
        let app = chatApps[indexPath.item]
        let editorVC = ChatEditorViewController(chatApp: app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

// MARK: - Premium App Cell with Glass Effect
class AppCell: UICollectionViewCell {
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
    private let iconContainer = UIView()
    private let iconImageView = UIImageView()
    private let nameLabel = UILabel()
    private let checkmarkView = UIImageView()
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
        gradientLayer.frame = containerView.bounds
        glowLayer.frame = containerView.bounds
    }
    
    private func setupUI() {
        // Glow layer
        glowLayer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.insertSublayer(glowLayer, at: 0)
        
        // Gradient container
        containerView.layer.cornerRadius = Design.Radius.large
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        // Icon container with glass effect
        iconContainer.backgroundColor = Design.glassBg
        iconContainer.layer.cornerRadius = 25
        iconContainer.layer.borderWidth = 1
        iconContainer.layer.borderColor = Design.glassBorder.cgColor
        containerView.addSubview(iconContainer)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconContainer.addSubview(iconImageView)
        
        // Name
        nameLabel.font = Design.Typography.headline
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        containerView.addSubview(nameLabel)
        
        // Checkmark for Pro
        checkmarkView.image = UIImage(systemName: "checkmark.circle.fill")
        checkmarkView.tintColor = Design.cyan
        checkmarkView.isHidden = true
        containerView.addSubview(checkmarkView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        checkmarkView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            iconContainer.widthAnchor.constraint(equalToConstant: 50),
            iconContainer.heightAnchor.constraint(equalToConstant: 50),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8),
            
            checkmarkView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            checkmarkView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            checkmarkView.widthAnchor.constraint(equalToConstant: 24),
            checkmarkView.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        // Shadow
        Design.Shadows.apply(to: containerView.layer, color: Design.cyan, opacity: 0.3, radius: 30, offset: CGSize(width: 0, height: 15))
    }
    
    func configure(with app: ChatApp, isLight: Bool) {
        nameLabel.text = app.displayName
        
        // Set gradient colors based on app
        gradientLayer.colors = Design.Gradients.forApp(app)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Icon
        let symbolName: String
        switch app {
        case .iMessage: symbolName = "message.fill"
        case .telegram: symbolName = "paperplane.fill"
        case .snapchat: symbolName = "camera.fill"
        case .whatsapp: symbolName = "phone.fill"
        case .instagramDM: symbolName = "camera.fill"
        case .twitterX: symbolName = "at"
        case .discord: symbolName = "bubble.left.and.bubble.right.fill"
        }
        iconImageView.image = UIImage(systemName: symbolName)
        
        // Glow
        glowLayer.backgroundColor = UIColor.clear.cgColor
        Design.Shadows.glow(to: containerView.layer, color: app.primaryColor, radius: 40)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer.removeFromSuperlayer()
        containerView.layer.shadowOpacity = 0
    }
}
import UIKit

class HomeViewController: UIViewController {
    private var collectionView: UICollectionView!
    private let chatApps = ChatApp.allCases
    
    private let headerLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Design.Colors.backgroundPrimary
        
        // Header
        headerLabel.text = "Create"
        headerLabel.font = Design.Typography.largeTitle
        headerLabel.textColor = Design.Colors.textPrimary
        view.addSubview(headerLabel)
        
        // Subtitle
        subtitleLabel.text = "Choose a chat platform"
        subtitleLabel.font = Design.Typography.subhead
        subtitleLabel.textColor = Design.Colors.textSecondary
        view.addSubview(subtitleLabel)
        
        // Collection Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.sectionInset = .zero
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Design.Colors.backgroundPrimary
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ChatAppCell.self, forCellWithReuseIdentifier: "ChatAppCell")
        collectionView.showsVerticalScrollIndicator = false
        view.addSubview(collectionView)
        
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Design.Spacing.xl),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.xl),
            
            subtitleLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: Design.Spacing.sm),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Design.Spacing.xl),
            
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: Design.Spacing.xl),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chatApps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatAppCell", for: indexPath) as! ChatAppCell
        cell.configure(with: chatApps[indexPath.item])
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        let app = chatApps[indexPath.item]
        let editorVC = ChatEditorViewController(chatApp: app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

// MARK: - Chat App Cell
class ChatAppCell: UICollectionViewCell {
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
        // Container
        containerView.backgroundColor = Design.Colors.backgroundSecondary
        containerView.layer.cornerRadius = Design.Radius.card
        contentView.addSubview(containerView)
        
        // Icon Container
        iconContainerView.layer.cornerRadius = 22
        iconContainerView.clipsToBounds = false
        containerView.addSubview(iconContainerView)
        
        // Icon
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconContainerView.addSubview(iconImageView)
        
        // Name
        nameLabel.font = Design.Typography.headline
        nameLabel.textColor = Design.Colors.textPrimary
        containerView.addSubview(nameLabel)
        
        // Description
        descriptionLabel.font = Design.Typography.footnote
        descriptionLabel.textColor = Design.Colors.textSecondary
        containerView.addSubview(descriptionLabel)
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = Design.Colors.textSecondary.withAlphaComponent(0.5)
        chevronImageView.contentMode = .scaleAspectFit
        containerView.addSubview(chevronImageView)
        
        // Layout
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.Spacing.xs),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.Spacing.xl),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.xl),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Design.Spacing.xs),
            
            iconContainerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Design.Spacing.xl),
            iconContainerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 44),
            iconContainerView.heightAnchor.constraint(equalToConstant: 44),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 22),
            iconImageView.heightAnchor.constraint(equalToConstant: 22),
            
            nameLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: Design.Spacing.lg),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Design.Spacing.lg),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: Design.Spacing.lg),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: Design.Spacing.xs),
            
            chevronImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Design.Spacing.xl),
            chevronImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 12),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        // Shadow
        Design.Shadow.apply(to: containerView.layer)
    }
    
    func configure(with app: ChatApp) {
        nameLabel.text = app.displayName
        iconImageView.image = UIImage(systemName: app.iconName)
        descriptionLabel.text = app.description
        
        // Gradient bar
        gradientLayer.colors = Design.Gradients.forApp(app)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        // Glow
        glowLayer.backgroundColor = app.primaryColor.cgColor
        glowLayer.cornerRadius = 32
        glowLayer.shadowColor = app.primaryColor.cgColor
        glowLayer.shadowOpacity = 0.6
        glowLayer.shadowRadius = 12
        glowLayer.shadowOffset = .zero
        iconContainerView.layer.insertSublayer(glowLayer, at: 0)
        
        // Icon background
        iconContainerView.backgroundColor = app.primaryColor.withAlphaComponent(0.15)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer.removeFromSuperlayer()
        glowLayer.removeFromSuperlayer()
    }
}
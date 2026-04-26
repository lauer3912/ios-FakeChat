import UIKit

class TemplatesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private let templates: [Template] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = Design.Colors.backgroundPrimary
        title = "Templates"
        
        // Collection Layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = Design.Spacing.lg
        layout.sectionInset = UIEdgeInsets(top: Design.Spacing.lg, left: Design.Spacing.lg, bottom: Design.Spacing.lg, right: Design.Spacing.lg)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = Design.Colors.backgroundPrimary
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(TemplateCell.self, forCellWithReuseIdentifier: "TemplateCell")
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension TemplatesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ChatApp.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TemplateCell", for: indexPath) as! TemplateCell
        let app = ChatApp.allCases[indexPath.item]
        cell.configure(with: app)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension TemplatesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Design.Spacing.lg * 3) / 2
        return CGSize(width: width, height: 160)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        triggerHaptic()
        let app = ChatApp.allCases[indexPath.item]
        let editorVC = ChatEditorViewController(chatApp: app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
}

// MARK: - Template Cell
class TemplateCell: UICollectionViewCell {
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
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
        containerView.layer.cornerRadius = Design.Radius.card
        containerView.clipsToBounds = true
        contentView.addSubview(containerView)
        
        gradientLayer.colors = Design.Gradients.accent
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        containerView.addSubview(iconView)
        
        titleLabel.font = Design.Typography.headline
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        descriptionLabel.font = Design.Typography.caption1
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 2
        containerView.addSubview(descriptionLabel)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        iconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -30),
            iconView.widthAnchor.constraint(equalToConstant: 40),
            iconView.heightAnchor.constraint(equalToConstant: 40),
            
            titleLabel.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: Design.Spacing.md),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Design.Spacing.sm),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Design.Spacing.sm),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Design.Spacing.xs),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Design.Spacing.sm),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -Design.Spacing.sm)
        ])
    }
    
    func configure(with app: ChatApp) {
        iconView.image = UIImage(systemName: app.iconName)
        titleLabel.text = app.displayName
        descriptionLabel.text = app.description
        gradientLayer.colors = Design.Gradients.forApp(app)
    }
}
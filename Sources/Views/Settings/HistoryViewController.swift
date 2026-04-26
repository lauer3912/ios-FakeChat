import UIKit

class HistoryViewController: UIViewController {
    
    private var tableView: UITableView!
    private var emptyStateView: UIView!
    private var historyItems: [HistoryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHistory()
    }
    
    private func setupUI() {
        view.backgroundColor = Design.Colors.backgroundPrimary
        title = "History"
        
        // Table View
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = Design.Colors.backgroundPrimary
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        view.addSubview(tableView)
        
        // Empty State
        emptyStateView = UIView()
        emptyStateView.isHidden = true
        view.addSubview(emptyStateView)
        
        let emptyImage = UIImageView(image: UIImage(systemName: "clock"))
        emptyImage.tintColor = Design.Colors.textSecondary
        emptyImage.contentMode = .scaleAspectFit
        emptyStateView.addSubview(emptyImage)
        
        let emptyLabel = UILabel()
        emptyLabel.text = "No saved conversations"
        emptyLabel.font = Design.Typography.headline
        emptyLabel.textColor = Design.Colors.textSecondary
        emptyLabel.textAlignment = .center
        emptyStateView.addSubview(emptyLabel)
        
        let emptySubLabel = UILabel()
        emptySubLabel.text = "Your saved chats will appear here"
        emptySubLabel.font = Design.Typography.subhead
        emptySubLabel.textColor = Design.Colors.textTertiary
        emptySubLabel.textAlignment = .center
        emptyStateView.addSubview(emptySubLabel)
        
        // Layout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyImage.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptySubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyImage.topAnchor.constraint(equalTo: emptyStateView.topAnchor),
            emptyImage.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyImage.widthAnchor.constraint(equalToConstant: 60),
            emptyImage.heightAnchor.constraint(equalToConstant: 60),
            
            emptyLabel.topAnchor.constraint(equalTo: emptyImage.bottomAnchor, constant: Design.Spacing.lg),
            emptyLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            
            emptySubLabel.topAnchor.constraint(equalTo: emptyLabel.bottomAnchor, constant: Design.Spacing.sm),
            emptySubLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptySubLabel.bottomAnchor.constraint(equalTo: emptyStateView.bottomAnchor)
        ])
    }
    
    private func loadHistory() {
        // Load from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "chat_history"),
           let items = try? JSONDecoder().decode([HistoryItem].self, from: data) {
            historyItems = items
        }
        updateUI()
    }
    
    private func saveHistory() {
        if let data = try? JSONEncoder().encode(historyItems) {
            UserDefaults.standard.set(data, forKey: "chat_history")
        }
    }
    
    private func updateUI() {
        emptyStateView.isHidden = !historyItems.isEmpty
        tableView.isHidden = historyItems.isEmpty
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        let item = historyItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        triggerHaptic()
        let item = historyItems[indexPath.row]
        let editorVC = ChatEditorViewController(chatApp: item.conversation.app)
        navigationController?.pushViewController(editorVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.historyItems.remove(at: indexPath.row)
            self?.saveHistory()
            self?.updateUI()
            completion(true)
        }
        
        let favoriteAction = UIContextualAction(style: .normal, title: "Favorite") { [weak self] _, _, completion in
            self?.historyItems[indexPath.row].conversation.isFavorite.toggle()
            self?.saveHistory()
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        favoriteAction.backgroundColor = Design.Colors.accentYellow
        
        return UISwipeActionsConfiguration(actions: [deleteAction, favoriteAction])
    }
}

// MARK: - History Cell
class HistoryCell: UITableViewCell {
    private let appIconView = UIImageView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let previewLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = Design.Colors.backgroundSecondary
        
        appIconView.contentMode = .scaleAspectFit
        appIconView.tintColor = Design.Colors.accentCyan
        contentView.addSubview(appIconView)
        
        titleLabel.font = Design.Typography.headline
        titleLabel.textColor = Design.Colors.textPrimary
        contentView.addSubview(titleLabel)
        
        dateLabel.font = Design.Typography.caption1
        dateLabel.textColor = Design.Colors.textSecondary
        contentView.addSubview(dateLabel)
        
        previewLabel.font = Design.Typography.subhead
        previewLabel.textColor = Design.Colors.textSecondary
        previewLabel.numberOfLines = 1
        contentView.addSubview(previewLabel)
        
        appIconView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        previewLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            appIconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Design.Spacing.lg),
            appIconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            appIconView.widthAnchor.constraint(equalToConstant: 32),
            appIconView.heightAnchor.constraint(equalToConstant: 32),
            
            titleLabel.leadingAnchor.constraint(equalTo: appIconView.trailingAnchor, constant: Design.Spacing.md),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.Spacing.md),
            
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg),
            dateLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Design.Spacing.md),
            
            previewLabel.leadingAnchor.constraint(equalTo: appIconView.trailingAnchor, constant: Design.Spacing.md),
            previewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Design.Spacing.xs),
            previewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Design.Spacing.lg)
        ])
    }
    
    func configure(with item: HistoryItem) {
        appIconView.image = UIImage(systemName: item.conversation.app.iconName)
        titleLabel.text = item.conversation.app.displayName
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: item.savedAt)
        
        if let lastMessage = item.conversation.messages.last {
            previewLabel.text = lastMessage.text
        }
    }
}
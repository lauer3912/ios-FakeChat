import UIKit

class HistoryViewController: UIViewController {
    private var tableView: UITableView!
    private var savedChats: [SavedConversation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadHistory()
    }

    private func setupUI() {
        title = "History"
        view.backgroundColor = AppTheme.background

        navigationController?.navigationBar.prefersLargeTitles = true

        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.backgroundColor = AppTheme.background
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryCell.self, forCellReuseIdentifier: "HistoryCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: "savedChats"),
           let decoded = try? JSONDecoder().decode([SavedConversation].self, from: data) {
            savedChats = decoded
        }
        tableView.reloadData()
    }

    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(savedChats) {
            UserDefaults.standard.set(encoded, forKey: "savedChats")
        }
    }
}

extension HistoryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedChats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
        cell.configure(with: savedChats[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let savedChat = savedChats[indexPath.row]
        let editorVC = ChatEditorViewController(chatApp: savedChat.conversation.chatApp)
        navigationController?.pushViewController(editorVC, animated: true)
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            self?.savedChats.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.saveHistory()
            completion(true)
        }

        let favorite = UIContextualAction(style: .normal, title: savedChats[indexPath.row].isFavorite ? "Unfavorite" : "Favorite") { [weak self] _, _, completion in
            self?.savedChats[indexPath.row].isFavorite.toggle()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            self?.saveHistory()
            completion(true)
        }
        favorite.backgroundColor = Theme.accentYellow

        return UISwipeActionsConfiguration(actions: [delete, favorite])
    }
}

class HistoryCell: UITableViewCell {
    private let thumbnailView = UIView()
    private let appLabel = UILabel()
    private let dateLabel = UILabel()
    private let messageCountLabel = UILabel()
    private let favoriteIcon = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = AppTheme.surface
        accessoryType = .disclosureIndicator

        thumbnailView.layer.cornerRadius = 8
        thumbnailView.backgroundColor = Theme.darkCard
        contentView.addSubview(thumbnailView)

        appLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        appLabel.textColor = AppTheme.textPrimary
        contentView.addSubview(appLabel)

        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = AppTheme.textSecondary
        contentView.addSubview(dateLabel)

        messageCountLabel.font = .systemFont(ofSize: 12)
        messageCountLabel.textColor = AppTheme.textSecondary
        contentView.addSubview(messageCountLabel)

        favoriteIcon.image = UIImage(systemName: "star.fill")
        favoriteIcon.tintColor = Theme.accentYellow
        favoriteIcon.isHidden = true
        contentView.addSubview(favoriteIcon)

        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        appLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        messageCountLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteIcon.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalToConstant: 50),
            thumbnailView.heightAnchor.constraint(equalToConstant: 50),

            appLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 12),
            appLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            appLabel.trailingAnchor.constraint(equalTo: favoriteIcon.leadingAnchor, constant: -8),

            dateLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 12),
            dateLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 4),

            messageCountLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 12),
            messageCountLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            messageCountLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -14),

            favoriteIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            favoriteIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteIcon.widthAnchor.constraint(equalToConstant: 20),
            favoriteIcon.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func configure(with savedChat: SavedConversation) {
        appLabel.text = savedChat.conversation.chatApp.displayName
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: savedChat.savedAt)
        messageCountLabel.text = "\(savedChat.conversation.messages.count) messages"
        favoriteIcon.isHidden = !savedChat.isFavorite
    }
}
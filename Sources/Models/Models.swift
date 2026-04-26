import UIKit

// MARK: - Chat App Types
enum ChatApp: String, CaseIterable, Codable {
    case iMessage
    case telegram
    case snapchat
    case whatsapp
    case instagramDM
    case twitterX
    case discord
    
    var displayName: String {
        switch self {
        case .iMessage: return "iMessage"
        case .telegram: return "Telegram"
        case .snapchat: return "Snapchat"
        case .whatsapp: return "WhatsApp"
        case .instagramDM: return "Instagram"
        case .twitterX: return "Twitter/X"
        case .discord: return "Discord"
        }
    }
    
    var iconName: String {
        switch self {
        case .iMessage: return "message.fill"
        case .telegram: return "paperplane.fill"
        case .snapchat: return "camera.fill"
        case .whatsapp: return "phone.fill"
        case .instagramDM: return "camera.fill"
        case .twitterX: return "at"
        case .discord: return "bubble.left.and.bubble.right.fill"
        }
    }
    
    var primaryColor: UIColor {
        switch self {
        case .iMessage: return UIColor(hex: "007AFF")
        case .telegram: return UIColor(hex: "0088CC")
        case .snapchat: return UIColor(hex: "FFFC00")
        case .whatsapp: return UIColor(hex: "25D366")
        case .instagramDM: return UIColor(hex: "E1306C")
        case .twitterX: return UIColor.white
        case .discord: return UIColor(hex: "5865F2")
        }
    }
    
    var secondaryColor: UIColor {
        switch self {
        case .iMessage: return UIColor(hex: "5856D6")
        case .telegram: return UIColor(hex: "00D4FF")
        case .snapchat: return UIColor(hex: "FF2D7A")
        case .whatsapp: return UIColor(hex: "128C7E")
        case .instagramDM: return UIColor(hex: "F77737")
        case .twitterX: return UIColor(hex: "888888")
        case .discord: return UIColor(hex: "7289DA")
        }
    }
    
    var description: String {
        switch self {
        case .iMessage: return "Blue bubbles • iOS native"
        case .telegram: return "Secret chats • Cloud sync"
        case .snapchat: return "Snaps • Filters • Stories"
        case .whatsapp: return "End-to-end encryption"
        case .instagramDM: return "Stories • Reactions"
        case .twitterX: return "Real-time updates"
        case .discord: return "Servers • Roles"
        }
    }
}

// MARK: - Avatar Type
enum AvatarType: Codable, Equatable {
    case emoji(String)
    case image(String) // filename or asset name
    
    var display: String {
        switch self {
        case .emoji(let e): return e
        case .image: return "👤"
        }
    }
}

// MARK: - Contact Model
struct Contact: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var avatar: AvatarType
    var isOnline: Bool
    var lastSeen: Date?
    
    init(id: UUID = UUID(), name: String, avatar: AvatarType = .emoji("😊"), isOnline: Bool = false, lastSeen: Date? = nil) {
        self.id = id
        self.name = name
        self.avatar = avatar
        self.isOnline = isOnline
        self.lastSeen = lastSeen
    }
    
    var lastSeenText: String {
        if isOnline { return "online" }
        guard let lastSeen = lastSeen else { return "offline" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return "last seen " + formatter.localizedString(for: lastSeen, relativeTo: Date())
    }
}

// MARK: - Message Status
enum MessageStatus: String, Codable {
    case sending
    case sent
    case delivered
    case read
    case failed
}

// MARK: - Message Model
struct Message: Codable, Identifiable, Equatable {
    let id: UUID
    let senderId: UUID
    let text: String
    let timestamp: Date
    var status: MessageStatus
    var reactions: [String]
    
    init(id: UUID = UUID(), senderId: UUID, text: String, timestamp: Date = Date(), status: MessageStatus = .sent, reactions: [String] = []) {
        self.id = id
        self.senderId = senderId
        self.text = text
        self.timestamp = timestamp
        self.status = status
        self.reactions = reactions
    }
    
    var isSentByMe: Bool {
        return senderId == currentUserId
    }
    
    static var currentUserId: UUID = UUID()
}

// MARK: - Wallpaper Type
enum WallpaperType: String, Codable, CaseIterable {
    case `default`
    case gradient1
    case gradient2
    case gradient3
    case gradient4
    case gradient5
    case gradient6
    case gradient7
    case gradient8
    case gradient9
    case gradient10
    
    var displayName: String {
        switch self {
        case .default: return "Default"
        case .gradient1: return "Midnight"
        case .gradient2: return "Ocean"
        case .gradient3: return "Sunset"
        case .gradient4: return "Forest"
        case .gradient5: return "Lavender"
        case .gradient6: return "Peach"
        case .gradient7: return "Mint"
        case .gradient8: return "Rose"
        case .gradient9: return "Sky"
        case .gradient10: return "Coal"
        }
    }
}

// MARK: - Conversation Model
struct Conversation: Codable, Identifiable {
    let id: UUID
    let app: ChatApp
    var contacts: [Contact]
    var messages: [Message]
    var wallpaper: WallpaperType
    let createdAt: Date
    var updatedAt: Date
    var isFavorite: Bool
    
    init(id: UUID = UUID(), app: ChatApp, contacts: [Contact] = [], messages: [Message] = [], wallpaper: WallpaperType = .default, createdAt: Date = Date(), updatedAt: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.app = app
        self.contacts = contacts
        self.messages = messages
        self.wallpaper = wallpaper
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.isFavorite = isFavorite
    }
}

// MARK: - Template Model
struct Template: Codable, Identifiable {
    let id: UUID
    let title: String
    let app: ChatApp
    let conversation: Conversation
    let isPremium: Bool
    
    init(id: UUID = UUID(), title: String, app: ChatApp, conversation: Conversation, isPremium: Bool = false) {
        self.id = id
        self.title = title
        self.app = app
        self.conversation = conversation
        self.isPremium = isPremium
    }
}

// MARK: - Export Format
enum ExportFormat: String, CaseIterable {
    case portrait // 9:16 for stories
    case square  // 1:1 for Instagram
    case full     // Full chat export
    
    var aspectRatio: CGFloat {
        switch self {
        case .portrait: return 9.0 / 16.0
        case .square: return 1.0
        case .full: return 4.0 / 3.0
        }
    }
}

// MARK: - App Settings
struct AppSettings: Codable {
    var isDarkMode: Bool
    var defaultApp: ChatApp
    var defaultWallpaper: WallpaperType
    var hapticEnabled: Bool
    
    static var `default`: AppSettings {
        return AppSettings(
            isDarkMode: true,
            defaultApp: .iMessage,
            defaultWallpaper: .default,
            hapticEnabled: true
        )
    }
}

// MARK: - History Item
struct HistoryItem: Codable, Identifiable {
    let id: UUID
    let conversation: Conversation
    let thumbnailPath: String?
    let savedAt: Date
    
    init(id: UUID = UUID(), conversation: Conversation, thumbnailPath: String? = nil, savedAt: Date = Date()) {
        self.id = id
        self.conversation = conversation
        self.thumbnailPath = thumbnailPath
        self.savedAt = savedAt
    }
}
import SwiftUI

enum ChatApp: String, CaseIterable, Identifiable {
    case iMessage = "iMessage"
    case telegram = "Telegram"
    case snapchat = "Snapchat"
    case whatsapp = "WhatsApp"
    case instagramDM = "Instagram"
    case twitterX = "X"
    case discord = "Discord"

    var id: String { rawValue }

    var displayName: String { rawValue }

    var primaryColor: Color {
        switch self {
        case .iMessage: return Color(hex: "007AFF")
        case .telegram: return Color(hex: "0088CC")
        case .snapchat: return Color(hex: "FFFC00")
        case .whatsapp: return Color(hex: "25D366")
        case .instagramDM: return Color(hex: "E1306C")
        case .twitterX: return Color.white
        case .discord: return Color(hex: "5865F2")
        }
    }

    var bubbleReceivedColor: Color {
        switch self {
        case .iMessage: return Color(hex: "E9E9EB")
        case .telegram: return Color(hex: "0088CC")
        case .snapchat: return Color.white
        case .whatsapp: return Color(hex: "DCF8C6")
        case .instagramDM: return Color(hex: "262626")
        case .twitterX: return Color.black
        case .discord: return Color(hex: "363636")
        }
    }

    var bubbleSentColor: Color {
        switch self {
        case .iMessage: return Color(hex: "007AFF")
        case .telegram: return Color(hex: "EFFDDE")
        case .snapchat: return Color(hex: "FFFFFF")
        case .whatsapp: return Color(hex: "DCF8C6")
        case .instagramDM: return Color(hex: "262626")
        case .twitterX: return Color.black
        case .discord: return Color(hex: "4752C4")
        }
    }

    var isDarkBackground: Bool {
        switch self {
        case .iMessage: return false
        case .telegram: return false
        case .snapchat: return true
        case .whatsapp: return false
        case .instagramDM: return true
        case .twitterX: return true
        case .discord: return true
        }
    }

    var chatBackgroundColor: Color {
        switch self {
        case .iMessage: return Color(hex: "FFFFFF")
        case .telegram: return Color(hex: "FFFFFF")
        case .snapchat: return Color.black
        case .whatsapp: return Color(hex: "ECE5DD")
        case .instagramDM: return Color(hex: "000000")
        case .twitterX: return Color.black
        case .discord: return Color(hex: "36393F")
        }
    }
}

enum MessageStatus: String, Codable {
    case sent = "Sent"
    case delivered = "Delivered"
    case read = "Read"
}

enum AvatarType: Codable, Equatable {
    case emoji(String)
    case image(String)
}

struct Contact: Identifiable, Codable, Equatable {
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
}

struct Message: Identifiable, Codable, Equatable {
    let id: UUID
    var senderId: UUID
    var text: String
    var timestamp: Date
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
}

struct Conversation: Identifiable, Codable {
    let id: UUID
    var app: String
    var contacts: [Contact]
    var messages: [Message]
    var wallpaperName: String?
    var createdAt: Date

    init(id: UUID = UUID(), app: ChatApp, contacts: [Contact] = [], messages: [Message] = [], wallpaperName: String? = nil, createdAt: Date = Date()) {
        self.id = id
        self.app = app.rawValue
        self.contacts = contacts
        self.messages = messages
        self.wallpaperName = wallpaperName
        self.createdAt = createdAt
    }

    var chatApp: ChatApp {
        ChatApp(rawValue: app) ?? .iMessage
    }
}

struct ChatTemplate: Identifiable, Codable {
    let id: UUID
    var title: String
    var subtitle: String
    var conversation: Conversation

    init(id: UUID = UUID(), title: String, subtitle: String, conversation: Conversation) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.conversation = conversation
    }
}

struct SavedConversation: Identifiable, Codable {
    let id: UUID
    var conversation: Conversation
    var thumbnailData: Data?
    var savedAt: Date
    var isFavorite: Bool

    init(id: UUID = UUID(), conversation: Conversation, thumbnailData: Data? = nil, savedAt: Date = Date(), isFavorite: Bool = false) {
        self.id = id
        self.conversation = conversation
        self.thumbnailData = thumbnailData
        self.savedAt = savedAt
        self.isFavorite = isFavorite
    }
}
import XCTest
@testable import ChatFaker

final class ChatFakerTests: XCTestCase {
    
    func testChatAppDisplayName() {
        XCTAssertEqual(ChatApp.iMessage.displayName, "iMessage")
        XCTAssertEqual(ChatApp.telegram.displayName, "Telegram")
        XCTAssertEqual(ChatApp.snapchat.displayName, "Snapchat")
        XCTAssertEqual(ChatApp.whatsapp.displayName, "WhatsApp")
        XCTAssertEqual(ChatApp.instagramDM.displayName, "Instagram")
        XCTAssertEqual(ChatApp.twitterX.displayName, "Twitter/X")
        XCTAssertEqual(ChatApp.discord.displayName, "Discord")
    }
    
    func testContactCreation() {
        let contact = Contact(name: "John", avatar: .emoji("😀"), isOnline: true)
        
        XCTAssertEqual(contact.name, "John")
        XCTAssertEqual(contact.avatar.display, "😀")
        XCTAssertTrue(contact.isOnline)
    }
    
    func testMessageCreation() {
        let message = Message(
            senderId: UUID(),
            text: "Hello World",
            timestamp: Date(),
            status: .sent
        )
        
        XCTAssertEqual(message.text, "Hello World")
        XCTAssertEqual(message.status, .sent)
        XCTAssertTrue(message.reactions.isEmpty)
    }
    
    func testConversationCreation() {
        let app = ChatApp.iMessage
        let contact = Contact(name: "Test User", avatar: .emoji("👤"))
        let message = Message(senderId: contact.id, text: "Test")
        
        let conversation = Conversation(
            app: app,
            contacts: [contact],
            messages: [message]
        )
        
        XCTAssertEqual(conversation.app, .iMessage)
        XCTAssertEqual(conversation.contacts.count, 1)
        XCTAssertEqual(conversation.messages.count, 1)
    }
    
    func testAppSettings() {
        let settings = AppSettings.default
        
        XCTAssertTrue(settings.isDarkMode)
        XCTAssertEqual(settings.defaultApp, .iMessage)
        XCTAssertTrue(settings.hapticEnabled)
    }
    
    func testWallpaperTypes() {
        XCTAssertEqual(WallpaperType.allCases.count, 10)
        XCTAssertEqual(WallpaperType.default.displayName, "Default")
    }
}
import XCTest

class FakeChatScreenshotTests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--reset-state"]
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - Home Screen (Create Tab)
    func testHomeScreen_iPhone16Pro() {
        // iPhone 16 Pro: 1290 x 2796
        captureScreenshot(name: "HomeScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
    }
    
    func testHomeScreen_iPhone16ProMax() {
        // iPhone 16 Pro Max: 1320 x 2868
        captureScreenshot(name: "HomeScreen-iPhone16ProMax", size: CGSize(width: 1320, height: 2868))
    }
    
    func testHomeScreen_iPhone15() {
        // iPhone 15: 1179 x 2556
        captureScreenshot(name: "HomeScreen-iPhone15", size: CGSize(width: 1179, height: 2556))
    }
    
    func testHomeScreen_iPadPro() {
        // iPad Pro 12.9": 2048 x 2732
        captureScreenshot(name: "HomeScreen-iPadPro", size: CGSize(width: 2048, height: 2732))
    }
    
    func testHomeScreen_iPhoneSE() {
        // iPhone SE: 750 x 1334
        captureScreenshot(name: "HomeScreen-iPhoneSE", size: CGSize(width: 750, height: 1334))
    }
    
    // MARK: - Templates Tab
    func testTemplatesScreen_iPhone16Pro() {
        navigateToTab(index: 1)
        captureScreenshot(name: "TemplatesScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - History Tab
    func testHistoryScreen_iPhone16Pro() {
        navigateToTab(index: 2)
        captureScreenshot(name: "HistoryScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - Settings Tab
    func testSettingsScreen_iPhone16Pro() {
        navigateToTab(index: 3)
        captureScreenshot(name: "SettingsScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - Chat Editor Screen
    func testChatEditor_iMessage() {
        // Navigate to iMessage editor
        tapChatApp(index: 0)
        captureScreenshot(name: "ChatEditor-iMessage", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Telegram() {
        // Navigate back and to Telegram
        navigationControllerBack()
        tapChatApp(index: 1)
        captureScreenshot(name: "ChatEditor-Telegram", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Snapchat() {
        navigationControllerBack()
        tapChatApp(index: 2)
        captureScreenshot(name: "ChatEditor-Snapchat", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_WhatsApp() {
        navigationControllerBack()
        tapChatApp(index: 3)
        captureScreenshot(name: "ChatEditor-WhatsApp", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Instagram() {
        navigationControllerBack()
        tapChatApp(index: 4)
        captureScreenshot(name: "ChatEditor-Instagram", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - Preview Screen
    func testPreviewScreen_iPhone16Pro() {
        navigateToEditor(for: .iMessage)
        // Assuming there's a preview button in editor
        if app.buttons["Preview"].exists {
            app.buttons["Preview"].tap()
        }
        captureScreenshot(name: "PreviewScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - Helper Methods
    
    private func navigateToTab(index: Int) {
        let tabs = app.tabBars.buttons
        if tabs.count > index {
            tabs.element(boundBy: index).tap()
        }
    }
    
    private func tapChatApp(index: Int) {
        // Home screen has collection view with chat apps
        let cells = app.collectionViews.cells
        if cells.count > index {
            cells.element(boundBy: index).tap()
        }
    }
    
    private func navigationControllerBack() {
        if app.buttons.element(boundBy: 0).exists {
            app.buttons.element(boundBy: 0).tap()
        }
    }
    
    private func navigateToEditor(for app: ChatApp) {
        // Start from home
        // Tap on the appropriate chat app
        switch app {
        case .iMessage: tapChatApp(index: 0)
        case .telegram: tapChatApp(index: 1)
        case .snapchat: tapChatApp(index: 2)
        case .whatsapp: tapChatApp(index: 3)
        case .instagramDM: tapChatApp(index: 4)
        case .twitterX: tapChatApp(index: 5)
        case .discord: tapChatApp(index: 6)
        }
    }
    
    private func captureScreenshot(name: String, size: CGSize) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
}

// MARK: - Device Configuration
extension FakeChatScreenshotTests {
    
    enum DeviceCategory {
        case iPhone16Pro
        case iPhone16ProMax
        case iPhone15
        case iPhoneSE
        case iPadPro12
    }
    
    func screenshotSize(for category: DeviceCategory) -> CGSize {
        switch category {
        case .iPhone16Pro: return CGSize(width: 1290, height: 2796)
        case .iPhone16ProMax: return CGSize(width: 1320, height: 2868)
        case .iPhone15: return CGSize(width: 1179, height: 2556)
        case .iPhoneSE: return CGSize(width: 750, height: 1334)
        case .iPadPro12: return CGSize(width: 2048, height: 2732)
        }
    }
}

// MARK: - Batch Screenshot Test
class FakeChatAllScreenshotsTest: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--reset-state"]
        app.launch()
    }
    
    func testGenerateAllScreenshots() {
        // Generate all required screenshots for App Store
        let devices: [(String, CGSize)] = [
            ("iPhone16Pro-6.9", CGSize(width: 1290, height: 2796)),
            ("iPhone16ProMax-6.7", CGSize(width: 1320, height: 2868)),
            ("iPhone15Pro-6.1", CGSize(width: 1179, height: 2556)),
            ("iPadPro12.9-3rd", CGSize(width: 2048, height: 2732))
        ]
        
        for (name, size) in devices {
            // Home Screen
            captureWithName("Home-\(name)")
            
            // Templates
            app.tabBars.buttons.element(boundBy: 1).tap()
            captureWithName("Templates-\(name)")
            
            // History
            app.tabBars.buttons.element(boundBy: 2).tap()
            captureWithName("History-\(name)")
            
            // Settings
            app.tabBars.buttons.element(boundBy: 3).tap()
            captureWithName("Settings-\(name)")
            
            // Back to home for next device
            app.tabBars.buttons.element(boundBy: 0).tap()
        }
    }
    
    private func captureWithName(_ name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
}
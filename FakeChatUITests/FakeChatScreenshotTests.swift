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
        captureScreenshot(name: "HomeScreen-iPhone16Pro")
    }
    
    // MARK: - Templates Tab
    func testTemplatesScreen_iPhone16Pro() {
        navigateToTab(index: 1)
        captureScreenshot(name: "TemplatesScreen-iPhone16Pro")
    }
    
    // MARK: - History Tab
    func testHistoryScreen_iPhone16Pro() {
        navigateToTab(index: 2)
        captureScreenshot(name: "HistoryScreen-iPhone16Pro")
    }
    
    // MARK: - Settings Tab
    func testSettingsScreen_iPhone16Pro() {
        navigateToTab(index: 3)
        captureScreenshot(name: "SettingsScreen-iPhone16Pro")
    }
    
    // MARK: - Chat Editor Screen
    func testChatEditor_iMessage() {
        tapCell(index: 0)
        captureScreenshot(name: "ChatEditor-iMessage")
    }
    
    func testChatEditor_Telegram() {
        navigateBackIfNeeded()
        tapCell(index: 1)
        captureScreenshot(name: "ChatEditor-Telegram")
    }
    
    func testChatEditor_Snapchat() {
        navigateBackIfNeeded()
        tapCell(index: 2)
        captureScreenshot(name: "ChatEditor-Snapchat")
    }
    
    func testChatEditor_WhatsApp() {
        navigateBackIfNeeded()
        tapCell(index: 3)
        captureScreenshot(name: "ChatEditor-WhatsApp")
    }
    
    func testChatEditor_Instagram() {
        navigateBackIfNeeded()
        tapCell(index: 4)
        captureScreenshot(name: "ChatEditor-Instagram")
    }
    
    // MARK: - Preview Screen
    func testPreviewScreen_iPhone16Pro() {
        tapCell(index: 0)
        captureScreenshot(name: "PreviewScreen-iPhone16Pro")
    }
    
    // MARK: - Helper Methods
    
    private func navigateToTab(index: Int) {
        let tabs = app.tabBars.buttons
        if tabs.count > index {
            tabs.element(boundBy: index).tap()
        }
    }
    
    private func tapCell(index: Int) {
        let cells = app.collectionViews.cells
        if cells.count > index {
            cells.element(boundBy: index).tap()
        }
    }
    
    private func navigateBackIfNeeded() {
        // Try to go back to home screen
        if app.navigationBars.buttons.count > 0 {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
    
    private func captureScreenshot(name: String) {
        // Wait for UI to settle
        sleep(1)
        
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        add(attachment)
    }
}

// MARK: - Batch Screenshot Test for All Required Screens
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
        // Required screenshots for App Store:
        // iPhone 6.9" (1290x2796): 5 screenshots
        // iPhone 6.5" (1320x2868): 5 screenshots
        // iPad 12.9" (2048x2732): 3 screenshots
        
        // Generate iPhone 16 Pro screenshots
        captureHomeScreen()
        captureTemplatesScreen()
        captureHistoryScreen()
        captureSettingsScreen()
        captureEditorScreen()
    }
    
    private func captureHomeScreen() {
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "HomeScreen-iPhone16Pro"
        add(attachment)
    }
    
    private func captureTemplatesScreen() {
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "TemplatesScreen-iPhone16Pro"
        add(attachment)
    }
    
    private func captureHistoryScreen() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "HistoryScreen-iPhone16Pro"
        add(attachment)
    }
    
    private func captureSettingsScreen() {
        app.tabBars.buttons.element(boundBy: 3).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "SettingsScreen-iPhone16Pro"
        add(attachment)
    }
    
    private func captureEditorScreen() {
        // Go back to home
        app.tabBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        
        // Tap first chat app
        app.collectionViews.cells.element(boundBy: 0).tap()
        sleep(2)
        
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "ChatEditorScreen-iPhone16Pro"
        add(attachment)
    }
}
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
        captureScreenshot(name: "HomeScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
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
        // Tap first cell (iMessage)
        tapCell(index: 0)
        captureScreenshot(name: "ChatEditor-iMessage", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Telegram() {
        navigateBackIfNeeded()
        tapCell(index: 1)
        captureScreenshot(name: "ChatEditor-Telegram", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Snapchat() {
        navigateBackIfNeeded()
        tapCell(index: 2)
        captureScreenshot(name: "ChatEditor-Snapchat", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_WhatsApp() {
        navigateBackIfNeeded()
        tapCell(index: 3)
        captureScreenshot(name: "ChatEditor-WhatsApp", size: CGSize(width: 1290, height: 2796))
    }
    
    func testChatEditor_Instagram() {
        navigateBackIfNeeded()
        tapCell(index: 4)
        captureScreenshot(name: "ChatEditor-Instagram", size: CGSize(width: 1290, height: 2796))
    }
    
    // MARK: - Preview Screen
    func testPreviewScreen_iPhone16Pro() {
        // Navigate to editor first
        tapCell(index: 0)
        
        // Look for preview button and tap it
        if app.buttons["Preview"].exists {
            app.buttons["Preview"].tap()
            captureScreenshot(name: "PreviewScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
        } else if app.buttons["preview"].exists {
            app.buttons["preview"].tap()
            captureScreenshot(name: "PreviewScreen-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
        } else {
            // Try navigation bar back button and look for preview
            captureScreenshot(name: "EditorDetail-iPhone16Pro", size: CGSize(width: 1290, height: 2796))
        }
    }
    
    // MARK: - Helper Methods
    
    private func navigateToTab(index: Int) {
        // Wait for tab bar to be present
        XCTAssertTrue(app.tabBars.buttons.waitForExistence(timeout: 5), "Tab bar should exist")
        let tabs = app.tabBars.buttons
        if tabs.count > index {
            tabs.element(boundBy: index).tap()
        }
    }
    
    private func tapCell(index: Int) {
        // Wait for collection view
        XCTAssertTrue(app.collectionViews.cells.waitForExistence(timeout: 5), "Collection view should exist")
        let cells = app.collectionViews.cells
        if cells.count > index {
            cells.element(boundBy: index).tap()
        }
    }
    
    private func navigateBackIfNeeded() {
        // Check if back button exists (we're in editor, need to go back to home)
        if app.buttons.count > 0 {
            // Try to find back button
            let backButton = app.buttons.element(boundBy: 0)
            if backButton.exists && backButton.label == "Create" {
                backButton.tap()
                return
            }
        }
        // Try navigation bar back
        if app.navigationBars.buttons.element(boundBy: 0).exists {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
    
    private func captureScreenshot(name: String, size: CGSize) {
        // Wait a moment for UI to settle
        sleep(1)
        
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.uniformTypeIdentifier = "public.png"
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
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
    
    private func captureTemplatesScreen() {
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "TemplatesScreen-iPhone16Pro"
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
    
    private func captureHistoryScreen() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "HistoryScreen-iPhone16Pro"
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
    
    private func captureSettingsScreen() {
        app.tabBars.buttons.element(boundBy: 3).tap()
        sleep(1)
        let screenshot = app.windows.firstMatch.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = "SettingsScreen-iPhone16Pro"
        attachment.uniformTypeIdentifier = "public.png"
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
        attachment.uniformTypeIdentifier = "public.png"
        add(attachment)
    }
}
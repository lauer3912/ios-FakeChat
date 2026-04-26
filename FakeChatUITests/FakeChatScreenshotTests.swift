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
        saveScreenshot(named: "HomeScreen-iPhone16Pro")
    }
    
    // MARK: - Templates Tab
    func testTemplatesScreen_iPhone16Pro() {
        navigateToTab(index: 1)
        saveScreenshot(named: "TemplatesScreen-iPhone16Pro")
    }
    
    // MARK: - History Tab
    func testHistoryScreen_iPhone16Pro() {
        navigateToTab(index: 2)
        saveScreenshot(named: "HistoryScreen-iPhone16Pro")
    }
    
    // MARK: - Settings Tab
    func testSettingsScreen_iPhone16Pro() {
        navigateToTab(index: 3)
        saveScreenshot(named: "SettingsScreen-iPhone16Pro")
    }
    
    // MARK: - Chat Editor Screens
    func testChatEditor_iMessage() {
        tapCell(index: 0)
        saveScreenshot(named: "ChatEditor-iMessage")
    }
    
    func testChatEditor_Telegram() {
        navigateBackIfNeeded()
        tapCell(index: 1)
        saveScreenshot(named: "ChatEditor-Telegram")
    }
    
    func testChatEditor_Snapchat() {
        navigateBackIfNeeded()
        tapCell(index: 2)
        saveScreenshot(named: "ChatEditor-Snapchat")
    }
    
    func testChatEditor_WhatsApp() {
        navigateBackIfNeeded()
        tapCell(index: 3)
        saveScreenshot(named: "ChatEditor-WhatsApp")
    }
    
    func testChatEditor_Instagram() {
        navigateBackIfNeeded()
        tapCell(index: 4)
        saveScreenshot(named: "ChatEditor-Instagram")
    }
    
    // MARK: - Preview Screen
    func testPreviewScreen_iPhone16Pro() {
        tapCell(index: 0)
        saveScreenshot(named: "PreviewScreen-iPhone16Pro")
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
        if app.navigationBars.buttons.count > 0 {
            app.navigationBars.buttons.element(boundBy: 0).tap()
        }
    }
    
    private func saveScreenshot(named name: String) {
        // Wait for UI to settle
        sleep(1)
        
        let screenshot = app.windows.firstMatch.screenshot()
        
        // Save to desktop with unique name
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let screenshotURL = desktopURL.appendingPathComponent("\(name).png")
        
        do {
            try screenshot.pngRepresentation.write(to: screenshotURL)
            print("Saved screenshot: \(screenshotURL.path)")
        } catch {
            print("Failed to save screenshot: \(error)")
        }
        
        // Also add as attachment
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        add(attachment)
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
        // Generate all required screenshots
        captureHomeScreen()
        captureTemplatesScreen()
        captureHistoryScreen()
        captureSettingsScreen()
        captureEditorScreen()
    }
    
    private func captureHomeScreen() {
        saveGlobalScreenshot(named: "HomeScreen-iPhone16Pro")
    }
    
    private func captureTemplatesScreen() {
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(1)
        saveGlobalScreenshot(named: "TemplatesScreen-iPhone16Pro")
    }
    
    private func captureHistoryScreen() {
        app.tabBars.buttons.element(boundBy: 2).tap()
        sleep(1)
        saveGlobalScreenshot(named: "HistoryScreen-iPhone16Pro")
    }
    
    private func captureSettingsScreen() {
        app.tabBars.buttons.element(boundBy: 3).tap()
        sleep(1)
        saveGlobalScreenshot(named: "SettingsScreen-iPhone16Pro")
    }
    
    private func captureEditorScreen() {
        app.tabBars.buttons.element(boundBy: 0).tap()
        sleep(1)
        app.collectionViews.cells.element(boundBy: 0).tap()
        sleep(2)
        saveGlobalScreenshot(named: "ChatEditorScreen-iPhone16Pro")
    }
    
    private func saveGlobalScreenshot(named name: String) {
        let screenshot = app.windows.firstMatch.screenshot()
        
        let desktopURL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first!
        let screenshotURL = desktopURL.appendingPathComponent("\(name).png")
        
        do {
            try screenshot.pngRepresentation.write(to: screenshotURL)
            print("Saved screenshot: \(screenshotURL.path)")
        } catch {
            print("Failed to save screenshot: \(error)")
        }
        
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        add(attachment)
    }
}
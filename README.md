# ChatFaker

**Create Hilarious Fake Chat Screenshots!**

A fake chat screenshot generator for iOS. Create realistic conversations from iMessage, Telegram, Snapchat, WhatsApp, Instagram DM, Twitter/X, and Discord.

## Features

- 7 chat apps supported
- Customizable contacts and messages
- Dark/Light theme
- Multiple export formats
- 5 free templates
- Pro features available

## App Store

- **Name**: ChatFaker
- **Bundle ID**: com.ggsheng.FakeChat
- **Privacy Policy**: https://lauer3912.github.io/ios-FakeChat/docs/PrivacyPolicy.html

## Development

### Requirements
- Xcode 15+
- iOS 17.0+
- Swift 5.9

### Setup

```bash
# Clone the repo
git clone https://github.com/lauer3912/ios-FakeChat.git
cd ios-FakeChat

# Generate Xcode project
./xcodegen generate

# Open in Xcode
open ChatFaker.xcodeproj
```

## Project Structure

```
ChatFaker/
├── Sources/
│   ├── App/           # AppDelegate, SceneDelegate, Info.plist
│   ├── Models/        # Data models
│   ├── Views/         # UIKit ViewControllers
│   └── Theme/         # Colors, fonts, design system
├── Resources/         # Assets.xcassets
├── AppStore/          # Listing, Screenshots, Assets
├── Docs/              # Documentation
└── project.yml        # XcodeGen configuration
```

## License

Private - All rights reserved
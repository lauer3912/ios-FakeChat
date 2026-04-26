# ChatFaker — Specification Document

## 1. Project Overview

- **Project Name**: ChatFaker
- **App Store Name**: ChatFaker
- **Bundle ID**: com.ggsheng.FakeChat
- **Core Functionality**: Generate realistic fake chat screenshots for iMessage, Telegram, Snapchat, WhatsApp, Instagram DM, Twitter/X, Discord. Used for pranks, social media content, and entertainment.
- **Target Users**: Teens and young adults (13-25) in Western markets (US, UK, Canada, Australia)
- **iOS Version Support**: iOS 15.0+
- **Language**: English only

---

## 2. UI/UX Specification

### Screen Structure

1. **HomeScreen** — Main dashboard with chat app selection
2. **ChatEditorScreen** — Create/edit fake conversation
3. **PreviewScreen** — Full-screen preview with export options
4. **TemplateGalleryScreen** — Browse pre-made conversation templates
5. **SettingsScreen** — App settings and theme toggle
6. **ProUpgradeScreen** — Paywall for premium features

### Navigation Structure
- UITabBarController with 4 tabs: Create, Templates, History, Settings
- Modal presentation for ProUpgrade

### Visual Design

#### Color Palette (Dark Neon Theme — default)
- **Background Primary**: #0D0D0F (near black)
- **Background Secondary**: #1A1A1F (card surface)
- **Accent Primary**: #00D4FF (cyan neon)
- **Accent Secondary**: #FF2D7A (hot pink)
- **Accent Tertiary**: #A855F7 (purple)
- **Text Primary**: #FFFFFF
- **Text Secondary**: #8E8E93
- **Success**: #30D158
- **Warning**: #FF9F0A

#### Color Palette (Light Theme)
- **Background Primary**: #F2F2F7
- **Background Secondary**: #FFFFFF
- **Accent Primary**: #007AFF
- **Text Primary**: #000000
- **Text Secondary**: #3C3C43 (60% opacity)

#### Typography
- **Font Family**: SF Pro (system)
- **Heading Large**: 34pt Bold
- **Heading Medium**: 22pt Bold
- **Body**: 17pt Regular
- **Caption**: 13pt Regular
- **Chat Bubble Text**: 16pt Regular

#### Spacing System (8pt grid)
- **Screen Margins**: 16pt
- **Card Padding**: 16pt
- **Item Spacing**: 12pt
- **Section Spacing**: 24pt

#### iOS-Specific
- Safe area handling for notch
- Dynamic Type support
- Haptic feedback on interactions

---

## 3. Functionality Specification

### Core Features (50+)

#### Chat App Selection (Free)
1. iMessage (blue bubbles)
2. Telegram (cyan accent)
3. Snapchat (yellow with ghost)
4. WhatsApp (green)
5. Instagram DM (gradient pink/purple)
6. Twitter/X (black with white text)
7. Discord (blurple #5865F2)

#### Contact Setup (Free)
8. Contact name input
9. Contact avatar (select from emoji or photo library)
10. Group chat support (up to 6 contacts)
11. Contact online status indicator
12. Contact timestamp ("online", "last seen 2m ago")

#### Message Composition (Free)
13. Add sent message
14. Add received message
15. Message text input (max 500 chars)
16. Timestamp per message (auto or custom)
17. Message delivery status (sent/delivered/read)
18. Typing indicator
19. Read receipts toggle
20. Message reactions (emoji)

#### Visual Elements (Free)
21. Chat background (app-specific default)
22. Chat wallpaper (select from 10 presets)
23. Screen notches/status bar simulation
24. Home indicator bar
25. Date separator between messages
26. Message tail/bubble rendering per app style

#### Export & Share (Free)
27. Save to Photos (PNG, high-res)
28. Share to social media
29. Copy to clipboard
30. Generate as square image (1:1) for Instagram
31. Generate as story image (9:16) for Snapchat/Instagram

#### Templates (Free)
32. 5 pre-made conversation templates
33. "Celebrity roast" template
34. "Boss prank" template
35. "Crush confession" template
36. "Group chat chaos" template
37. "Mom pranked" template

#### History (Free)
38. Save conversations to history
39. Favorites system
40. Delete history items
41. Re-edit from history

#### Settings (Free)
42. Dark/Light theme toggle
43. Default chat app preference
44. Default wallpaper preference
45. Haptic feedback toggle
46. App icon selection (3 variants)

### Pro Features (In-App Purchase $2.99)

#### Advanced Apps
47. Instagram DM (new style 2024)
48. TikTok DM style
49. Slack style
50. LinkedIn DM style
51. Spotify DM style

#### Advanced Export
52. GIF generation (3s animated)
53. Video export (5s, share-ready)
54. Batch generate (4 images at once)
55. Remove watermark option

#### Customization
56. Custom wallpaper from photo library
57. Custom contact photos
58. More reaction emoji options
59. Sound effects on message send

#### Templates
60. 20+ premium templates
61. Weekly new template drops
62. "Viral templates" category

### User Interactions
- Tap contact to edit
- Long press message to delete
- Swipe left on message to add reaction
- Pull to refresh template gallery
- Double-tap preview to toggle device frame

---

## 4. Technical Specification

### Architecture
- **Pattern**: MVVM with SwiftUI
- **UI Framework**: SwiftUI (primary) + UIKit (camera/photo picker)
- **State Management**: @StateObject, @Published, Combine
- **Data Persistence**: UserDefaults (history, settings), FileManager (images)

### Dependencies (SPM)
- None required (all native implementation)

### Asset Requirements

#### App Icons
- Standard 19-slot iOS icon set
- Design: Neon chat bubbles with glowing effect

#### Chat App Assets (SF Symbols + custom)
- iMessage bubble (custom)
- Telegram plane icon
- Snapchat ghost
- WhatsApp phone icon
- Instagram camera icon
- Twitter bird/X logo
- Discord logo

#### Wallpapers
- 10 preset chat backgrounds
- Stored as Assets.xcassets

#### Sound Effects
- Message send sound (short pop)
- Reaction pop sound

### Data Models

```
ChatApp: enum { iMessage, Telegram, Snapchat, WhatsApp, InstagramDM, TwitterX, Discord }

Contact: { id: UUID, name: String, avatar: AvatarType, isOnline: Bool, lastSeen: Date? }

Message: { id: UUID, senderId: UUID, text: String, timestamp: Date, status: MessageStatus, reactions: [Emoji] }

Conversation: { id: UUID, app: ChatApp, contacts: [Contact], messages: [Message], wallpaper: WallpaperType?, createdAt: Date }

Template: { id: UUID, title: String, app: ChatApp, conversation: Conversation }
```

### Key Technical Details
- **Screenshot Generation**: Render SwiftUI view to UIImage
- **High Resolution**: Generate at 3x scale for retina
- **Share**: UIActivityViewController for system share sheet
- **Haptics**: UIImpactFeedbackGenerator (.medium)
- **Theme**: @AppStorage for persistence

---

## 5. Privacy Policy URL
https://lauer3912.github.io/ios-FakeChat/docs/PrivacyPolicy.html

---

## 6. Screenshots Required
- iPhone 6.9" (1290x2796): 5 screenshots
- iPhone 6.5" (1284x2778): 5 screenshots
- iPad 12.9" (2048x2732): 3 screenshots

---

## 7. Review Notes

### Guideline 5.1.1 — Data Collection
- No personal data collection
- No analytics tracking
- All data stored locally on device

### Guideline 5.1.2 — Data Collection
- No account/login system
- No social features that collect data

### Guideline 2.3.1 — Safe Content
- Clear that generated images are fake
- No defamatory content creation tools
- User responsible for content they create
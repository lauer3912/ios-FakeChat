# ChatFaker 功能清单

## App 基本信息
- **App Store 名称**: ChatFaker
- **Bundle ID**: com.ggsheng.FakeChat (不变)
- **功能总数**: 62个
- **版本**: 1.0.0

---

## 核心功能（≥60）

| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 1 | Chat App Selection | 选择7种聊天应用：iMessage, Telegram, Snapchat, WhatsApp, Instagram DM, Twitter/X, Discord | P0 |
| 2 | iMessage Style | 蓝色气泡，iOS原生样式 | P0 |
| 3 | Telegram Style | 青色飞机图标，云同步标识 | P0 |
| 4 | Snapchat Style | 黄色幽灵图标，阅后即焚风格 | P0 |
| 5 | WhatsApp Style | 绿色电话图标，端到端加密标识 | P0 |
| 6 | Instagram DM Style | 渐变粉紫色，相机图标 | P0 |
| 7 | Twitter/X Style | 黑白设计，@符号 | P0 |
| 8 | Discord Style | 蓝紫色(blurple)，服务器角色 | P0 |
| 9 | Contact Name Input | 自定义联系人名称输入 | P0 |
| 10 | Contact Avatar | 选择emoji或照片库作为头像 | P0 |
| 11 | Group Chat Support | 支持最多6人群聊 | P0 |
| 12 | Online Status | 显示"在线"、"最后在线X分钟前" | P0 |
| 13 | Add Sent Message | 添加发送消息 | P0 |
| 14 | Add Received Message | 添加接收消息 | P0 |
| 15 | Message Text Input | 消息文本输入(最多500字符) | P0 |
| 16 | Timestamp | 每条消息时间戳(自动或自定义) | P0 |
| 17 | Delivery Status | 发送/已送达/已读状态 | P0 |
| 18 | Typing Indicator | 打字中指示器 | P0 |
| 19 | Read Receipts Toggle | 已读回执开关 | P0 |
| 20 | Message Reactions | 消息emoji反应 | P0 |
| 21 | Chat Background | 应用默认背景 | P0 |
| 22 | Chat Wallpaper | 10种预设壁纸选择 | P0 |
| 23 | Status Bar Simulation | 状态栏模拟(刘海屏) | P0 |
| 24 | Home Indicator | Home指示条 | P0 |
| 25 | Date Separator | 消息日期分隔符 | P0 |
| 26 | Bubble Tail Rendering | 每种应用专属气泡尾巴 | P0 |
| 27 | Save to Photos | 保存到照片(PNG高清) | P0 |
| 28 | Share to Social | 分享到社交媒体 | P0 |
| 29 | Copy to Clipboard | 复制到剪贴板 | P0 |
| 30 | Square Export | 1:1方形图片(Instagram) | P0 |
| 31 | Story Export | 9:16故事图片(Snapchat/Instagram) | P0 |
| 32 | 5 Pre-made Templates | 5个预设对话模板 | P0 |
| 33 | Celebrity Roast Template | 名人吐槽模板 | P1 |
| 34 | Boss Prank Template | 老板整蛊模板 | P1 |
| 35 | Crush Confession Template | 告白模板 | P1 |
| 36 | Group Chat Chaos Template | 群聊混乱模板 | P1 |
| 37 | Mom Pranked Template | 妈妈被整模板 | P1 |
| 38 | Save to History | 保存对话到历史记录 | P0 |
| 39 | Favorites System | 收藏夹系统 | P0 |
| 40 | Delete History | 删除历史记录 | P0 |
| 41 | Re-edit from History | 从历史记录重新编辑 | P0 |
| 42 | Dark/Light Theme Toggle | 深色/浅色主题切换 | P0 |
| 43 | Default App Preference | 默认聊天应用偏好 | P0 |
| 44 | Default Wallpaper Preference | 默认壁纸偏好 | P0 |
| 45 | Haptic Feedback Toggle | 触觉反馈开关 | P0 |
| 46 | App Icon Selection | 3种应用图标变体选择 | P1 |

## Pro 功能（App内购买 $2.99）

| # | 功能名称 | 描述 | 优先级 |
|---|---------|------|--------|
| 47 | Instagram DM 2024 Style | Instagram DM新样式(2024) | P1 |
| 48 | TikTok DM Style | TikTok私信样式 | P1 |
| 49 | Slack Style | Slack样式 | P1 |
| 50 | LinkedIn DM Style | LinkedIn私信样式 | P1 |
| 51 | Spotify DM Style | Spotify私信样式 | P1 |
| 52 | GIF Generation | 3秒GIF生成 | P1 |
| 53 | Video Export | 5秒视频导出 | P1 |
| 54 | Batch Generate | 一次生成4张图片 | P1 |
| 55 | Remove Watermark | 移除水印选项 | P1 |
| 56 | Custom Wallpaper from Photos | 从照片库自定义壁纸 | P1 |
| 57 | Custom Contact Photos | 自定义联系人照片 | P1 |
| 58 | More Reaction Emoji | 更多反应emoji选项 | P1 |
| 59 | Sound Effects | 消息发送音效 | P1 |
| 60 | 20+ Premium Templates | 20+高级模板 | P1 |
| 61 | Weekly New Templates | 每周新模板推送 | P1 |
| 62 | Viral Templates Category | 病毒模板分类 | P1 |

---

## 用户交互

| 交互 | 描述 |
|------|------|
| 点击联系人 | 编辑联系人 |
| 长按消息 | 删除消息 |
| 左滑消息 | 添加反应 |
| 下拉刷新 | 刷新模板库 |
| 双击预览 | 切换设备边框 |

---

## 无障碍功能

| 功能 | 状态 |
|------|------|
| VoiceOver标签 | 所有可交互元素设置accessibilityLabel |
| Dynamic Type | 使用.font(.body)等相对字号 |
| 颜色对比度 | ≥7:1 (WCAG AA) |
| 点击区域 | ≥44×44pt |

---

## 离线功能

| 功能 | 状态 |
|------|------|
| 本地数据存储 | UserDefaults + FileManager |
| 离线状态UI | 断网时正常显示 |
| 启动无网络依赖 | ✅ 完全支持 |
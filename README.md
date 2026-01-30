# Minion Mind

A web-based knowledge management application fully compatible with Obsidian vault format.

## Download

Download the latest version from the [Releases](https://github.com/femto/minion-mind-releases/releases) page.

| Platform | Download |
|----------|----------|
| macOS | [minion-mind-x.x.x.dmg](https://github.com/femto/minion-mind-releases/releases/latest) |
| Windows | [minion-mind-x.x.x-setup.exe](https://github.com/femto/minion-mind-releases/releases/latest) |
| Linux | [minion-mind-x.x.x.AppImage](https://github.com/femto/minion-mind-releases/releases/latest) |

## Features

- Full Obsidian vault compatibility
- `[[Wiki links]]` and `![[embeds]]` support
- Graph view visualization
- Full-text search
- Daily notes
- Tag management
- Plugin system
- Dark/Light mode

## Installation

### macOS

1. Download the `.dmg` file
2. Open and drag to Applications folder
3. **首次启动需要绕过 Gatekeeper 安全检查**（应用未签名）

#### 如果提示"已损坏，无法打开"

**方法1：右键打开（推荐）**
- 在 Finder 中找到 `Minion Mind.app`
- 按住 Control 点击（或右键点击）应用
- 选择「打开」
- 在弹出的对话框中点击「打开」

**方法2：系统设置中允许**
- 打开「系统设置」>「隐私与安全性」
- 找到被阻止的 Minion Mind 提示
- 点击「仍要打开」

**方法3：移除隔离属性（终端命令）**
```bash
# 方式A
xattr -d com.apple.quarantine "/Applications/Minion Mind.app"

# 方式B（如果上面不行）
xattr -cr "/Applications/Minion Mind.app"
```

### Windows
1. Download the `-setup.exe` file
2. Run the installer
3. Follow the installation wizard

### Linux
1. Download the `.AppImage` file
2. Make it executable: `chmod +x minion-mind-*.AppImage`
3. Run: `./minion-mind-*.AppImage`

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for version history.

## License

Proprietary software. All rights reserved.

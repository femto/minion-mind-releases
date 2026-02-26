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

#### Install via Homebrew (recommended)

```bash
brew install --cask femto/tap/minion-mind
```

Optional: install into user Applications folder.

```bash
brew install --cask --appdir=~/Applications femto/tap/minion-mind
```

If macOS still blocks launch due to quarantine, you can use:

```bash
brew install --cask --no-quarantine femto/tap/minion-mind
```

If you already installed via DMG, Homebrew may report an existing app at `/Applications/Minion Mind.app`.
You can either force-install or delete the existing app:

```bash
brew install --cask --force femto/tap/minion-mind
# or
rm -rf /Applications/Minion\ Mind.app
brew install --cask femto/tap/minion-mind
```

#### Install via DMG

1. Download the `.dmg` file
2. Open and drag to Applications folder
3. If macOS shows "damaged" or "unidentified developer" warning, run in Terminal:
```bash
xattr -d com.apple.quarantine "/Applications/Minion Mind.app"
# Or if the above doesn't work:
xattr -c "/Applications/Minion Mind.app"
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

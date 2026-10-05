#!/bin/bash

# Minion Mind GitHub Release Stats with Local Snapshot
# Usage: ./stats.sh

set -euo pipefail

if ! command -v jq >/dev/null 2>&1; then
  echo "错误: 未安装 jq (brew install jq)" >&2
  exit 1
fi

REPO="femto/minion-mind-releases"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SNAPSHOT_FILE="$SCRIPT_DIR/stats_snapshot.json"
DAILY_FILE="$SCRIPT_DIR/stats_daily.json"

# Initialize snapshot file if missing or not valid JSON
if ! jq -e 'type == "object"' "$SNAPSHOT_FILE" >/dev/null 2>&1; then
  echo '{"last_updated":"","versions":{}}' > "$SNAPSHOT_FILE"
fi

# Initialize daily file if missing or not valid JSON
if ! jq -e 'type == "object"' "$DAILY_FILE" >/dev/null 2>&1; then
  echo '{}' > "$DAILY_FILE"
fi

echo "📊 Minion Mind 下载统计"
echo "========================"
echo ""

# Fetch current data from GitHub (all releases, paginated)
echo "正在获取最新数据..."

# Convert to proper format: {tag: {dmg_arm64, dmg_x64, dmg_other, exe, deb, appimage, zip}}
GITHUB_DATA=$(gh api --paginate "repos/$REPO/releases?per_page=100" | jq -s '
  add | reduce .[] as $r ({};
    .[$r.tag_name] = {
      dmg_arm64: ([$r.assets[] | select(.name | test("arm64.*\\.dmg$")) | .download_count] | add // 0),
      dmg_x64: ([$r.assets[] | select(.name | test("x64.*\\.dmg$")) | .download_count] | add // 0),
      dmg_other: ([$r.assets[] | select(.name | test("\\.dmg$")) | select(.name | test("arm64|x64") | not) | .download_count] | add // 0),
      exe: ([$r.assets[] | select(.name | test("\\.exe$")) | .download_count] | add // 0),
      deb: ([$r.assets[] | select(.name | test("\\.deb$")) | .download_count] | add // 0),
      appimage: ([$r.assets[] | select(.name | test("\\.AppImage$")) | .download_count] | add // 0),
      zip: ([$r.assets[] | select(.name | test("\\.zip$")) | .download_count] | add // 0)
    }
  )
')

if [ "$(echo "$GITHUB_DATA" | jq 'length')" -eq 0 ]; then
  echo "错误: 未获取到任何 release 数据，已中止（未修改快照）" >&2
  exit 1
fi

# Merge with existing snapshot (keep old versions, update existing ones)
MERGED=$(jq -n \
  --argjson snapshot "$(cat "$SNAPSHOT_FILE")" \
  --argjson github "$GITHUB_DATA" \
  '{
    last_updated: (now | strftime("%Y-%m-%dT%H:%M:%SZ")),
    versions: ($snapshot.versions * $github)
  }')

# Save merged snapshot (write to temp file first so a failure never truncates it)
echo "$MERGED" > "$SNAPSHOT_FILE.tmp" && mv "$SNAPSHOT_FILE.tmp" "$SNAPSHOT_FILE"

# Calculate stats from merged data
STATS=$(echo "$MERGED" | jq '
  .versions | to_entries | reduce .[] as $v (
    {dmg_arm64: 0, dmg_x64: 0, dmg_other: 0, exe: 0, deb: 0, appimage: 0, zip: 0};
    .dmg_arm64 += ($v.value.dmg_arm64 // 0) |
    .dmg_x64 += ($v.value.dmg_x64 // 0) |
    .dmg_other += ($v.value.dmg_other // 0) |
    .exe += ($v.value.exe // 0) |
    .deb += ($v.value.deb // 0) |
    .appimage += ($v.value.appimage // 0) |
    .zip += ($v.value.zip // 0)
  )
')

DMG_ARM64=$(echo "$STATS" | jq '.dmg_arm64')
DMG_X64=$(echo "$STATS" | jq '.dmg_x64')
EXE=$(echo "$STATS" | jq '.exe')
DMG_OTHER=$(echo "$STATS" | jq '.dmg_other')
DEB=$(echo "$STATS" | jq '.deb')
APPIMAGE=$(echo "$STATS" | jq '.appimage')
ZIP=$(echo "$STATS" | jq '.zip')

MACOS=$((DMG_ARM64 + DMG_X64 + DMG_OTHER))
LINUX=$((DEB + APPIMAGE))
MANUAL=$((MACOS + EXE + LINUX))
TOTAL=$((MANUAL + ZIP))

VERSION_COUNT=$(echo "$MERGED" | jq '.versions | length')

# Daily tracking
TODAY=$(date +%Y-%m-%d)
YESTERDAY=$(date -v-1d +%Y-%m-%d 2>/dev/null || date -d "yesterday" +%Y-%m-%d)

# Save today's data
DAILY_DATA=$(jq -n \
  --argjson daily "$(cat "$DAILY_FILE")" \
  --arg today "$TODAY" \
  --argjson manual "$MANUAL" \
  --argjson auto "$ZIP" \
  --argjson total "$TOTAL" \
  '$daily + {($today): {manual: $manual, auto: $auto, total: $total}}')
echo "$DAILY_DATA" > "$DAILY_FILE.tmp" && mv "$DAILY_FILE.tmp" "$DAILY_FILE"

# Get yesterday's data for comparison
YESTERDAY_TOTAL=$(echo "$DAILY_DATA" | jq -r --arg d "$YESTERDAY" '.[$d].total // 0')
YESTERDAY_MANUAL=$(echo "$DAILY_DATA" | jq -r --arg d "$YESTERDAY" '.[$d].manual // 0')
YESTERDAY_AUTO=$(echo "$DAILY_DATA" | jq -r --arg d "$YESTERDAY" '.[$d].auto // 0')

# Calculate daily change
if [ "$YESTERDAY_TOTAL" -gt 0 ]; then
  DAILY_TOTAL=$((TOTAL - YESTERDAY_TOTAL))
  DAILY_MANUAL=$((MANUAL - YESTERDAY_MANUAL))
  DAILY_AUTO=$((ZIP - YESTERDAY_AUTO))
else
  DAILY_TOTAL="-"
  DAILY_MANUAL="-"
  DAILY_AUTO="-"
fi

echo ""
echo "📈 今日增量 ($TODAY):"
if [ "$DAILY_TOTAL" != "-" ]; then
  echo "  手动安装: +$DAILY_MANUAL"
  echo "  自动更新: +$DAILY_AUTO"
  echo "  总计:     +$DAILY_TOTAL"
else
  echo "  (无昨日数据对比)"
fi
echo ""

echo "📊 累计总量:"
echo "  手动安装 (.dmg/.exe/.deb/.AppImage): $MANUAL"
echo "  自动更新 (.zip):           $ZIP"
echo "  ------------------------"
echo "  总计:                      $TOTAL"
echo ""

echo "按平台分布:"
echo "  Windows: $EXE"
echo "  macOS: $MACOS"
echo "  Linux: $LINUX (deb $DEB / AppImage $APPIMAGE)"
echo ""

echo "macOS 架构分布:"
echo "  Apple Silicon (arm64): $DMG_ARM64"
echo "  Intel (x64): $DMG_X64"
echo "  未标注架构 (早期版本): $DMG_OTHER"
echo ""

echo "最近版本下载量:"
gh api "repos/$REPO/releases?per_page=5" --jq '.[] | "  \(.tag_name): \([.assets[] | select(.name | test("\\.(dmg|exe|deb|AppImage|zip)$")) | .download_count] | add // 0)"'
echo ""

echo "📁 快照文件: $SNAPSHOT_FILE"
echo "📅 每日记录: $DAILY_FILE"
echo "📦 跟踪版本数: $VERSION_COUNT"

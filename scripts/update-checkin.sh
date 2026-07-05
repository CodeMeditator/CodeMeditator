#!/usr/bin/env bash
# Update daily check-in image on GitHub profile README.
# Usage: ./scripts/update-checkin.sh /path/to/image.png [--push]
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHECKIN_DIR="$REPO_ROOT/assets/checkin"
README="$REPO_ROOT/README.md"
IMAGE="${1:-}"
PUSH=false

if [[ "${2:-}" == "--push" ]]; then
  PUSH=true
fi

if [[ -z "$IMAGE" || ! -f "$IMAGE" ]]; then
  echo "Usage: $0 /path/to/image.png [--push]" >&2
  exit 1
fi

DATE="$(date +%Y-%m-%d)"
CACHE_BUSTER="$(date +%Y%m%d)"

mkdir -p "$CHECKIN_DIR"

cp "$IMAGE" "$CHECKIN_DIR/latest.png"
cp "$IMAGE" "$CHECKIN_DIR/${DATE}.png"

CHECKIN_BLOCK="## 每日打卡 📅

<p align=\"center\">
  <img alt=\"Daily Check-in ${DATE}\" src=\"./assets/checkin/latest.png?v=${CACHE_BUSTER}\" width=\"640\" />
</p>"

python3 - "$README" "$CHECKIN_BLOCK" <<'PY'
import re
import sys
from pathlib import Path

readme_path = Path(sys.argv[1])
block = sys.argv[2]
text = readme_path.read_text(encoding="utf-8")

pattern = re.compile(
    r"## 每日打卡 📅\n\n<p align=\"center\">\n  <img[^>]+/>\n</p>\n?",
    re.MULTILINE,
)

if pattern.search(text):
    text = pattern.sub(block + "\n", text)
else:
    marker = "## Hi, I'm Richard. 👋\n\n"
    if marker in text:
        text = text.replace(marker, marker + block + "\n", 1)
    else:
        text = block + "\n" + text

readme_path.write_text(text, encoding="utf-8")
PY

cd "$REPO_ROOT"
git add "assets/checkin/latest.png" "assets/checkin/${DATE}.png" README.md

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git commit -m "chore: daily check-in ${DATE}"

if $PUSH; then
  git push origin master
  echo "Pushed. Profile: https://github.com/CodeMeditator"
fi

echo "Done. Check-in updated for ${DATE}."

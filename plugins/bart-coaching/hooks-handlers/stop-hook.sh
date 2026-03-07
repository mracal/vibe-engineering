#!/usr/bin/env bash
# Bart coaching Stop hook
# Checks if compound reflection was written this session
# If not, blocks exit and requests reflection
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMPOUND_TEMPLATE="$PLUGIN_ROOT/prompts/compound-template.md"

# Find reflections file
PROJECT_PATH="$(pwd)"
MEMORY_KEY=$(echo "$PROJECT_PATH" | sed 's|/|-|g; s|^-||')
MEMORY_DIR="$HOME/.claude/projects/-${MEMORY_KEY}/memory"
REFLECTIONS_FILE="$MEMORY_DIR/bart-reflections.md"
ARCHIVE_FILE="$MEMORY_DIR/bart-reflections-archive.md"

# Check if reflections file was modified in the last 10 minutes (proxy for "written this session")
if [[ -f "$REFLECTIONS_FILE" ]]; then
  MODIFIED=$(stat -c %Y "$REFLECTIONS_FILE" 2>/dev/null || stat -f %m "$REFLECTIONS_FILE" 2>/dev/null || echo 0)
  NOW=$(date +%s)
  AGE=$(( NOW - MODIFIED ))

  if [[ "$AGE" -lt 600 ]]; then
    # Reflection was written recently — allow exit
    exit 0
  fi
fi

# No recent reflection — block exit and request one
echo "SessionStart hook success: Compound reflection required"
echo ""
cat "$COMPOUND_TEMPLATE"
echo ""
echo "Reflections file: $REFLECTIONS_FILE"
echo "Archive file (for older reflections): $ARCHIVE_FILE"
echo ""
echo "IMPORTANT: Reflections use usage-based retention, not rolling window."
echo "Keep reflections that are frequently referenced or contain active growth patterns."
echo "Archive reflections that have been fully integrated (the lesson is learned)."
echo "When archiving, move the entry to $ARCHIVE_FILE with the date, don't delete it."

# Exit non-zero to block session exit
exit 1

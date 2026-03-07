#!/usr/bin/env bash
# Bart coaching SessionStart hook
# Outputs coaching context + past reflections (capped to prevent context bloat)
set -euo pipefail

PLUGIN_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COACHING="$PLUGIN_ROOT/prompts/coaching-context.md"

# Find auto-memory directory for current project
# Claude sets CWD to project root; memory lives under ~/.claude/projects/
PROJECT_PATH="$(pwd)"
MEMORY_KEY=$(echo "$PROJECT_PATH" | sed 's|/|-|g; s|^-||')
MEMORY_DIR="$HOME/.claude/projects/-${MEMORY_KEY}/memory"
REFLECTIONS_FILE="$MEMORY_DIR/bart-reflections.md"
ARCHIVE_FILE="$MEMORY_DIR/bart-reflections-archive.md"

# Output coaching context (core instructions)
cat "$COACHING"

echo ""
echo "## Past Compound Reflections"
echo ""

# Load recent reflections if they exist, hard cap at 500 chars to protect context
if [[ -f "$REFLECTIONS_FILE" ]]; then
  CONTENT=$(head -c 1500 "$REFLECTIONS_FILE")
  FULL_SIZE=$(wc -c < "$REFLECTIONS_FILE")
  echo "$CONTENT"
  if [[ "$FULL_SIZE" -gt 1500 ]]; then
    echo ""
    echo "[Truncated — full reflections: $REFLECTIONS_FILE]"
  fi
  if [[ -f "$ARCHIVE_FILE" ]]; then
    echo "[Archived reflections: $ARCHIVE_FILE]"
  fi
else
  echo "No past reflections found. This is your first coached session for this project."
  echo "Reflections file: $REFLECTIONS_FILE"
  if [[ -f "$ARCHIVE_FILE" ]]; then
    echo "[Archived reflections available: $ARCHIVE_FILE]"
  fi
fi

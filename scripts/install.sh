#!/bin/bash
#
# Install script for org-wide Claude Code settings
# This symlinks CLAUDE.global.md to ~/.claude/CLAUDE.md
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_GLOBAL="$AI_RULES_DIR/CLAUDE.global.md"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"

echo "Installing org-wide Claude Code settings..."

# Check if CLAUDE.global.md exists
if [ ! -f "$CLAUDE_GLOBAL" ]; then
    echo "Error: CLAUDE.global.md not found at $CLAUDE_GLOBAL"
    echo "Make sure you're running this from the ai-rules repository."
    exit 1
fi

# Create ~/.claude directory if it doesn't exist
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "Creating $CLAUDE_DIR..."
    mkdir -p "$CLAUDE_DIR"
fi

# Check if CLAUDE.md already exists
if [ -e "$CLAUDE_MD" ]; then
    if [ -L "$CLAUDE_MD" ]; then
        # It's a symlink - check if it points to our file
        CURRENT_TARGET="$(readlink "$CLAUDE_MD")"
        if [ "$CURRENT_TARGET" = "$CLAUDE_GLOBAL" ]; then
            echo "Already installed. Symlink is up to date."
            exit 0
        else
            echo "Existing symlink points to: $CURRENT_TARGET"
            echo "Updating to point to: $CLAUDE_GLOBAL"
            rm "$CLAUDE_MD"
        fi
    else
        # It's a regular file - back it up
        BACKUP="$CLAUDE_MD.backup.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing $CLAUDE_MD to $BACKUP"
        mv "$CLAUDE_MD" "$BACKUP"
    fi
fi

# Create the symlink
echo "Creating symlink: $CLAUDE_MD -> $CLAUDE_GLOBAL"
ln -s "$CLAUDE_GLOBAL" "$CLAUDE_MD"

echo ""
echo "Installation complete!"
echo ""
echo "The symlink has been created. To update settings in the future:"
echo "  1. Make changes to CLAUDE.global.md in ai-rules"
echo "  2. Commit and push via PR"
echo "  3. Run 'git pull' in your local ai-rules clone"
echo ""
echo "Your Claude Code sessions will now use org-wide settings."

#!/bin/bash
#
# Install script for org-wide Claude Code settings
# This symlinks CLAUDE.global.md to ~/.claude/CLAUDE.md
# and configures settings.local.json with MCP credentials
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AI_RULES_DIR="$(dirname "$SCRIPT_DIR")"
CLAUDE_GLOBAL="$AI_RULES_DIR/CLAUDE.global.md"
CLAUDE_DIR="$HOME/.claude"
CLAUDE_MD="$CLAUDE_DIR/CLAUDE.md"
SETTINGS_LOCAL="$CLAUDE_DIR/settings.local.json"

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
SYMLINK_EXISTS=false
if [ -e "$CLAUDE_MD" ]; then
    if [ -L "$CLAUDE_MD" ]; then
        # It's a symlink - check if it points to our file
        CURRENT_TARGET="$(readlink "$CLAUDE_MD")"
        if [ "$CURRENT_TARGET" = "$CLAUDE_GLOBAL" ]; then
            echo "Symlink already up to date."
            SYMLINK_EXISTS=true
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

# Create the symlink if needed
if [ "$SYMLINK_EXISTS" = false ]; then
    echo "Creating symlink: $CLAUDE_MD -> $CLAUDE_GLOBAL"
    ln -s "$CLAUDE_GLOBAL" "$CLAUDE_MD"
fi

echo ""
echo "Symlink created successfully."
echo ""

# Configure MCP credentials in settings.local.json
echo "Configuring MCP server credentials..."
echo ""
echo "The GitHub MCP server requires a Personal Access Token (PAT)."
echo "Generate one at: https://github.com/settings/tokens"
echo "Required scopes: repo, read:org"
echo ""

read -p "Enter your GitHub PAT (or press Enter to skip): " -s GITHUB_PAT
echo ""

if [ -n "$GITHUB_PAT" ]; then
    if [ -f "$SETTINGS_LOCAL" ]; then
        # Check if file already has env.GITHUB_PERSONAL_ACCESS_TOKEN
        if grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" "$SETTINGS_LOCAL" 2>/dev/null; then
            read -p "GitHub PAT already configured. Overwrite? [y/N]: " OVERWRITE
            if [ "$OVERWRITE" != "y" ] && [ "$OVERWRITE" != "Y" ]; then
                echo "Skipping GitHub PAT configuration."
                GITHUB_PAT=""
            fi
        fi
    fi
fi

if [ -n "$GITHUB_PAT" ]; then
    if [ -f "$SETTINGS_LOCAL" ]; then
        # File exists - need to merge env block
        if grep -q '"env"' "$SETTINGS_LOCAL" 2>/dev/null; then
            # env block exists - update or add the token
            # Use a temp file for the transformation
            TEMP_FILE=$(mktemp)
            # Simple approach: if env exists, add/update the token in it
            if grep -q "GITHUB_PERSONAL_ACCESS_TOKEN" "$SETTINGS_LOCAL"; then
                # Replace existing token
                sed "s/\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"[^\"]*\"/\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"$GITHUB_PAT\"/" "$SETTINGS_LOCAL" > "$TEMP_FILE"
            else
                # Add token to existing env block
                sed "s/\"env\": {/\"env\": {\n    \"GITHUB_PERSONAL_ACCESS_TOKEN\": \"$GITHUB_PAT\",/" "$SETTINGS_LOCAL" > "$TEMP_FILE"
            fi
            mv "$TEMP_FILE" "$SETTINGS_LOCAL"
        else
            # No env block - add one at the start of the JSON object
            TEMP_FILE=$(mktemp)
            sed "s/^{/{\\
  \"env\": {\\
    \"GITHUB_PERSONAL_ACCESS_TOKEN\": \"$GITHUB_PAT\"\\
  },/" "$SETTINGS_LOCAL" > "$TEMP_FILE"
            mv "$TEMP_FILE" "$SETTINGS_LOCAL"
        fi
        echo "Updated $SETTINGS_LOCAL with GitHub PAT."
    else
        # Create new settings.local.json
        cat > "$SETTINGS_LOCAL" << EOF
{
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "$GITHUB_PAT"
  }
}
EOF
        echo "Created $SETTINGS_LOCAL with GitHub PAT."
    fi
else
    echo "Skipping GitHub PAT configuration."
    echo "You can manually add it later to: $SETTINGS_LOCAL"
    echo ""
    echo "Example:"
    echo '  {'
    echo '    "env": {'
    echo '      "GITHUB_PERSONAL_ACCESS_TOKEN": "ghp_your_token_here"'
    echo '    }'
    echo '  }'
fi

echo ""
echo "Installation complete!"
echo ""
echo "To update org-wide settings in the future:"
echo "  1. Make changes to CLAUDE.global.md in ai-rules"
echo "  2. Commit and push via PR"
echo "  3. Run 'git pull' in your local ai-rules clone"
echo ""
echo "Your Claude Code sessions will now use org-wide settings."

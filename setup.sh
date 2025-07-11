#!/bin/bash
# Easy setup script for Claude-Gemini MCP Server

set -e

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Claude-Gemini MCP Server Setup${NC}"
echo ""

# Check if API key was provided
API_KEY="$1"
if [ -z "$API_KEY" ]; then
    echo -e "${RED}❌ Please provide your Gemini API key${NC}"
    echo "Usage: ./setup.sh YOUR_GEMINI_API_KEY"
    echo ""
    echo "Get a free API key at: https://aistudio.google.com/apikey"
    exit 1
fi

# Check Python version
echo "📋 Checking requirements..."
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python 3 is required but not installed.${NC}"
    exit 1
fi

PYTHON_VERSION=$(python3 -c 'import sys; print(".".join(map(str, sys.version_info[:2])))')
echo "✅ Python $PYTHON_VERSION found"

# Check Claude Code
if ! command -v claude &> /dev/null; then
    echo -e "${RED}❌ Claude Code CLI not found. Please install it first:${NC}"
    echo "npm install -g @anthropic-ai/claude-code"
    exit 1
fi
echo "✅ Claude Code CLI found"

# Create directory
echo ""
echo "📁 Creating MCP server directory..."
mkdir -p ~/.claude-mcp-servers/gemini-collab

# Copy server file
echo "📋 Installing server..."
cp server.py ~/.claude-mcp-servers/gemini-collab/

# Replace API key in server
sed -i.bak "0,/YOUR_API_KEY_HERE/s//${API_KEY}/" ~/.claude-mcp-servers/gemini-collab/server.py
rm ~/.claude-mcp-servers/gemini-collab/server.py.bak

# Install Python dependencies
# echo ""
# echo "📦 Installing Python dependencies..."
# pip3 install google-generativeai --quiet

# Remove any existing MCP configuration
echo ""
echo "🔧 Configuring Claude Code..."
claude mcp remove gemini-collab 2>/dev/null || true

# Add MCP server with global scope
claude mcp add --scope user gemini-collab python3 ~/.claude-mcp-servers/gemini-collab/server.py

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "🎉 You can now use Gemini in Claude Code from any directory!"
echo ""
echo "Try it out:"
echo "  1. Run: claude"
echo "  2. Type: /mcp (should show gemini-collab connected)"
echo "  3. Use: mcp__gemini-collab__ask_gemini"
echo "         prompt: \"Hello Gemini!\""
echo ""
echo "Available tools:"
echo "  • mcp__gemini-collab__ask_gemini"
echo "  • mcp__gemini-collab__gemini_code_review"
echo "  • mcp__gemini-collab__gemini_brainstorm"
echo ""
echo "Enjoy! 🚀"

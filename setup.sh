#!/bin/bash

###############################################################################
# Socket Security Demo - Local Setup & Test Script
#
# This script:
# 1. Installs the Socket npm CLI globally
# 2. Installs project dependencies
# 3. Runs a local Socket reachability scan
# 4. Verifies that .socket.facts.json was created
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
#
# Requirements:
#   - Node.js 20 or higher
#   - npm
#   - SOCKET_SECURITY_API_KEY environment variable (optional for some features)
###############################################################################

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Socket Security Demo - Local Setup & Test                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check Node.js version
echo -e "${YELLOW}[1/5]${NC} Checking Node.js version..."
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 20 ]; then
    echo -e "${RED}❌ Error: Node.js 20 or higher is required${NC}"
    echo -e "${RED}   Current version: $(node -v)${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Node.js $(node -v) detected${NC}"
echo ""

# Install Socket CLI globally
echo -e "${YELLOW}[2/5]${NC} Installing Socket CLI (npm)..."
if npm install -g @socketsecurity/socket; then
    echo -e "${GREEN}✅ Socket CLI installed successfully${NC}"
else
    echo -e "${RED}❌ Failed to install Socket CLI${NC}"
    exit 1
fi
echo ""

# Install project dependencies
echo -e "${YELLOW}[3/5]${NC} Installing project dependencies..."
if [ -f "package-lock.json" ]; then
    echo "   Using npm ci for reproducible install..."
    npm ci
else
    echo "   Using npm install..."
    npm install
fi
echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

# Check for API key (optional warning)
if [ -z "$SOCKET_SECURITY_API_KEY" ]; then
    echo -e "${YELLOW}⚠️  Warning: SOCKET_SECURITY_API_KEY not set${NC}"
    echo "   Some features may be limited without an API key."
    echo "   To set it: export SOCKET_SECURITY_API_KEY='your_key_here'"
    echo ""
fi

# Run Socket reachability scan
echo -e "${YELLOW}[4/5]${NC} Running Socket reachability scan..."
echo "   This may take a minute on first run..."
echo ""

if socket scan reach --target-path .; then
    echo ""
    echo -e "${GREEN}✅ Socket scan completed successfully${NC}"
else
    echo ""
    echo -e "${RED}❌ Socket scan failed${NC}"
    echo "   Check that you have a valid SOCKET_SECURITY_API_KEY set"
    exit 1
fi
echo ""

# Verify .socket.facts.json was created
echo -e "${YELLOW}[5/5]${NC} Verifying .socket.facts.json..."
if [ -f ".socket.facts.json" ]; then
    FILE_SIZE=$(ls -lh .socket.facts.json | awk '{print $5}')
    echo -e "${GREEN}✅ .socket.facts.json generated successfully${NC}"
    echo "   File size: $FILE_SIZE"
    echo ""

    # Show a preview of the file structure
    echo -e "${BLUE}📄 Facts file preview:${NC}"
    if command -v jq &> /dev/null; then
        echo "   $(jq -r 'keys | join(", ")' .socket.facts.json 2>/dev/null || echo "   [JSON data]")"
    else
        echo "   (install jq for pretty output)"
    fi
else
    echo -e "${RED}❌ .socket.facts.json not found${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║  Setup Complete! 🎉                                        ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}Next steps:${NC}"
echo "  1. Run the application:  npm start"
echo "  2. View in browser:      http://localhost:4000"
echo "  3. Push to GitHub:       git push"
echo "  4. Watch Actions tab:    GitHub will run Socket scan automatically"
echo ""
echo -e "${BLUE}Learn more:${NC}"
echo "  📚 Socket CLI:     https://docs.socket.dev/docs/socket-cli"
echo "  🔍 Reachability:   https://docs.socket.dev/docs/full-application-reachability"
echo ""

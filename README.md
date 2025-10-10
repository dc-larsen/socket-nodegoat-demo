# Socket Security GitHub Actions Demo

[![Socket Security Scan](https://github.com/yourusername/socket-nodegoat-demo/actions/workflows/socket-scan.yml/badge.svg)](https://github.com/yourusername/socket-nodegoat-demo/actions/workflows/socket-scan.yml)

This repository demonstrates how to use the [Socket CLI](https://docs.socket.dev/docs/socket-cli#/) (`@socketsecurity/cli` npm package) inside GitHub Actions to run full-application reachability scans on Node.js projects.

Based on the popular [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) security training application, this streamlined demo shows how Socket Security integrates seamlessly into CI/CD pipelines.

---

## 🎯 What This Demo Shows

- ✅ **npm CLI Integration**: Uses `@socketsecurity/cli` package (not Python CLI)
- ✅ **Reachability Analysis**: Generates `.socket.facts.json` for Tier 1 reachability insights
- ✅ **GitHub Actions Workflow**: Automated scanning on every push and pull request
- ✅ **Real Dependencies**: Scans actual npm packages (Express, MongoDB, Helmet, etc.)
- ✅ **Artifact Upload**: Stores scan results as downloadable artifacts

---

## 🚀 How It Works

### The Socket npm CLI Workflow

1. **Trigger**: Workflow runs on push, pull request, or issue comments
2. **Setup**: Installs Node.js 20, project dependencies, and Socket CLI
3. **Scan**: Executes `socket scan reach` to analyze the entire dependency tree
4. **Generate**: Creates `.socket.facts.json` with reachability data
5. **Upload**: Stores scan results as GitHub Actions artifacts
6. **Integrate**: Socket GitHub App consumes the facts file for enhanced security insights

### What Gets Scanned

This demo application includes realistic npm dependencies:

```json
{
  "dependencies": {
    "express": "^4.19.2",           // Web framework
    "body-parser": "^1.20.2",       // Request parsing
    "express-session": "^1.18.0",   // Session management
    "mongodb": "^6.5.0",            // Database driver
    "marked": "^12.0.1",            // Markdown parser
    "helmet": "^7.1.0",             // Security middleware
    "bcrypt-nodejs": "0.0.3",       // Password hashing
    "underscore": "^1.13.6",        // Utility library
    "serve-favicon": "^2.5.0"       // Favicon middleware
  }
}
```

Socket analyzes these dependencies for:
- 🔍 **Supply chain risks** (typosquatting, malware, suspicious behavior)
- 🎯 **Reachability** (which code paths actually execute in your app)
- 📊 **Vulnerabilities** (CVEs and security issues)
- 📦 **Maintenance status** (outdated or abandoned packages)

---

## ⚙️ Setup Instructions

### Prerequisites

- Node.js 20 or higher
- npm or yarn
- GitHub account
- Socket Security account ([sign up free](https://socket.dev))

### 1. Fork or Clone This Repository

```bash
# Clone the repository
git clone https://github.com/yourusername/socket-nodegoat-demo.git
cd socket-nodegoat-demo

# Install dependencies
npm install
```

### 2. Get Your Socket API Token

1. Log in to [Socket Security](https://socket.dev)
2. Navigate to **Settings → API Keys**
3. Generate a new API token for GitHub Actions

### 3. Configure GitHub Secrets

Add your Socket API token as a repository secret:

```bash
# Using GitHub CLI
gh secret set SOCKET_SECURITY_API_TOKEN

# Or manually:
# 1. Go to your repository on GitHub
# 2. Settings → Secrets and variables → Actions
# 3. New repository secret
# 4. Name: SOCKET_SECURITY_API_TOKEN
# 5. Value: your_socket_api_token_here
```

### 4. Trigger the Workflow

The workflow automatically runs on:
- Every `git push` to any branch
- Pull request events (opened, synchronized, reopened)
- Issue comments

To trigger manually:

```bash
# Make a change and push
echo "# Test" >> README.md
git add README.md
git commit -m "Test Socket scan"
git push
```

### 5. View Results

1. Go to **Actions** tab in your GitHub repository
2. Click on the latest **Socket Security Scan** workflow run
3. Check the **Run Socket Reachability Scan** step for output
4. Download the **socket-facts** artifact to inspect `.socket.facts.json`

---

## 🧪 Local Testing

You can run Socket scans locally before pushing to GitHub.

### Quick Setup Script

```bash
# Make the setup script executable
chmod +x setup.sh

# Run it
./setup.sh
```

This script will:
1. Install Socket CLI globally via npm
2. Install project dependencies
3. Run a local reachability scan
4. Verify `.socket.facts.json` was generated

### Manual Local Scan

```bash
# Install Socket CLI globally
npm install -g @socketsecurity/cli

# Install project dependencies
npm ci

# Set your API token
export SOCKET_SECURITY_API_TOKEN="your_api_token_here"

# Run reachability scan
socket scan reach --target-path .

# Check the results
ls -lh .socket.facts.json
cat .socket.facts.json | jq '.' # pretty print (requires jq)
```

### Run the Demo Application

```bash
# Start the server
npm start

# Visit in your browser
open http://localhost:4000

# Check health endpoint
curl http://localhost:4000/health
```

---

## 📁 Repository Structure

```
socket-nodegoat-demo/
├── .github/
│   └── workflows/
│       └── socket-scan.yml      # GitHub Actions workflow
├── server.js                     # Minimal Express application
├── package.json                  # Dependencies to scan
├── package-lock.json             # Locked dependency tree
├── setup.sh                      # Local testing script
├── .gitignore                    # Git ignore patterns
├── .env.example                  # Environment variable template
└── README.md                     # This file
```

---

## 🔐 Security Insights

### What Socket Detects

Socket's reachability analysis provides:

1. **Tier 1 Reachability**: Which vulnerable code is actually used in your app
2. **Supply Chain Risk**: Identifies suspicious packages before they cause harm
3. **Real-time Alerts**: Notifications for new vulnerabilities
4. **AI-Powered Analysis**: Smart detection of malicious patterns

### Example Issues Socket Catches

- 🚨 Malware and backdoors in dependencies
- ⚠️ Typosquatting attacks (e.g., `express` vs `expresss`)
- 📦 Install scripts that execute arbitrary code
- 🔓 Packages with known CVEs
- 🕷️ Network activity to suspicious domains

---

## 📚 Learn More

### Socket Documentation

- [Socket CLI Documentation](https://docs.socket.dev/docs/socket-cli#/)
- [Full Application Reachability](https://docs.socket.dev/docs/full-application-reachability#/)
- [GitHub Integration](https://docs.socket.dev/docs/github-integration)
- [Reachability Analysis Explained](https://socket.dev/blog/reachability-analysis)

### Related Resources

- [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) - Original security training app
- [OWASP Top 10](https://owasp.org/www-project-top-ten/) - Web application security risks
- [npm Security Best Practices](https://docs.npmjs.com/security-best-practices)

---

## 🛠️ Troubleshooting

### Common Issues

**Q: The workflow fails with "SOCKET_SECURITY_API_TOKEN not set"**
A: Make sure you've added your Socket API token as a repository secret (see [Setup Instructions](#setup-instructions))

**Q: `.socket.facts.json` is not generated**
A: Ensure you're using Node.js 20+ and the latest version of `@socketsecurity/cli`

**Q: Local scan fails with "command not found"**
A: Install Socket CLI globally: `npm install -g @socketsecurity/cli`

**Q: Scan takes a long time**
A: This is normal for first runs. Subsequent scans are faster due to caching.

### Getting Help

- 📧 [Socket Support](mailto:support@socket.dev)
- 💬 [Socket Community Slack](https://socket.dev/slack)
- 🐛 [Report Issues](https://github.com/SocketDev/socket-cli/issues)

---

## 🤝 Contributing

This is a demo repository, but contributions are welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License. See the original [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) project for additional attributions.

---

## 🙏 Acknowledgments

- **OWASP Foundation** for the original NodeGoat application
- **Socket Security** for providing advanced supply chain security tools
- **GitHub** for Actions automation platform

---

**Ready to secure your supply chain? [Get started with Socket Security →](https://socket.dev)**
# Test Socket scan workflow

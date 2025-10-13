# OWASP NodeGoat with Socket Security Integration

[![Socket Security Scan](https://github.com/dc-larsen/socket-nodegoat-demo/actions/workflows/socket-scan.yml/badge.svg)](https://github.com/dc-larsen/socket-nodegoat-demo/actions/workflows/socket-scan.yml)

> **Testing Tier 1 Reachability**: This PR tests Socket's Tier 1 reachability analysis with properly installed dependencies.

This repository combines the [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) vulnerable web application with [Socket Security](https://socket.dev) Tier 1 reachability analysis. It demonstrates how Socket's CLI integrates with GitHub Actions to provide advanced supply chain security scanning on real-world vulnerable applications.

## About This Project

**OWASP NodeGoat** is a deliberately vulnerable Node.js web application designed to teach OWASP Top 10 security risks. By integrating Socket Security's Tier 1 reachability analysis, this project shows:

- 🎯 **Real vulnerability detection** on actual vulnerable code paths
- 🔍 **Tier 1 reachability analysis** identifying which CVEs are exploitable in your code
- ⚡ **Automated CI/CD integration** via GitHub Actions
- 📊 **90% noise reduction** by focusing on reachable vulnerabilities only

## Socket Security Features

### What Gets Analyzed

Socket scans this vulnerable application for:
- **Supply chain risks** (malware, typosquatting, suspicious behavior)
- **Tier 1 Reachability** (which vulnerable functions are actually called)
- **CVEs and security issues** in dependencies
- **Maintenance status** (outdated or abandoned packages)

### Tier 1 Reachability

This project uses Socket's **Full Application Reachability** analysis:
1. GitHub Actions runs `socket scan reach` on every push
2. Generates `.socket.facts.json` with function-level call graph data
3. Socket GitHub App uses this file to show reachability in PRs
4. Dashboard displays which vulnerabilities are exploitable vs. unreachable

**Result**: Only see vulnerabilities that matter for your specific code paths.

---

## Quick Start

### Prerequisites

- Node.js 20 or higher
- MongoDB (local or Atlas)
- Socket Security account ([sign up free](https://socket.dev))
- GitHub account with Socket GitHub App installed

### 1. Clone and Install

```bash
git clone https://github.com/dc-larsen/socket-nodegoat-demo.git
cd socket-nodegoat-demo
npm install
```

### 2. Set Up MongoDB

**Option A: Local MongoDB**
```bash
# Install MongoDB Community Server
# Start mongod service
```

**Option B: MongoDB Atlas** (Free Tier)
```bash
# Create M0 cluster at https://cloud.mongodb.com
# Get connection string and set environment variable
export MONGODB_URI="mongodb://<username>:<password>@<cluster>/<dbname>..."
```

### 3. Seed the Database

```bash
npm run db:seed
```

This creates default user accounts:
- Admin: `admin` / `Admin_123`
- User 1: `user1` / `User1_123`
- User 2: `user2` / `User2_123`

### 4. Start the Application

```bash
# Start with node (port 4000)
npm start

# OR start with nodemon for development (port 5000)
npm run dev
```

Visit: http://localhost:4000

### 5. Configure Socket Security

#### Get Socket API Token

1. Log in to [Socket Security](https://socket.dev)
2. Navigate to **Settings → API Keys**
3. Generate a new API token

#### Add GitHub Secret

```bash
# Using GitHub CLI
gh secret set SOCKET_SECURITY_API_TOKEN

# Or manually in GitHub:
# Settings → Secrets and variables → Actions → New repository secret
```

#### Install Socket GitHub App

1. Visit https://github.com/apps/socket-security
2. Install on your repository
3. Grant necessary permissions

---

## Socket CLI Integration

### GitHub Actions Workflow

The workflow (`.github/workflows/socket-scan.yml`) automatically:

1. **Triggers** on every push and pull request
2. **Installs** Socket CLI via npm (`@socketsecurity/cli`)
3. **Runs** `socket scan reach` to perform Tier 1 reachability analysis
4. **Generates** `.socket.facts.json` with call graph data
5. **Commits** facts file to main branch (for Socket GitHub App)
6. **Uploads** artifact for manual inspection

### Local Socket Scanning

```bash
# Install Socket CLI globally
npm install -g @socketsecurity/cli

# Set your API token
export SOCKET_SECURITY_API_TOKEN="your_token_here"

# Run reachability scan
socket scan reach . --org your-org-slug

# Check the results
ls -lh .socket.facts.json
cat .socket.facts.json | jq '.'
```

### Pull Request Flow

1. Push changes → GitHub Actions generates `.socket.facts.json`
2. Create PR → Socket GitHub App runs automatically
3. Socket finds `.socket.facts.json` in repo → uses it for Tier 1 analysis
4. PR comment shows reachable vs. unreachable vulnerabilities
5. Dashboard displays security insights with context

---

## NodeGoat Vulnerabilities

This application intentionally includes OWASP Top 10 vulnerabilities:

- **A1 - Injection** (SQL/NoSQL injection)
- **A2 - Broken Authentication**
- **A3 - Sensitive Data Exposure**
- **A4 - XML External Entities (XXE)**
- **A5 - Broken Access Control**
- **A6 - Security Misconfiguration**
- **A7 - Cross-Site Scripting (XSS)**
- **A8 - Insecure Deserialization**
- **A9 - Using Components with Known Vulnerabilities**
- **A10 - Insufficient Logging & Monitoring**

Visit http://localhost:4000/tutorial after starting the app to learn about each vulnerability and how to fix it.

---

## Repository Structure

```
socket-nodegoat-demo/
├── .github/
│   └── workflows/
│       └── socket-scan.yml         # Socket CI/CD integration
├── app/
│   ├── routes/                     # Vulnerable route handlers
│   ├── views/                      # EJS templates
│   ├── data/                       # Data models
│   └── assets/                     # Static assets
├── config/                         # App configuration
├── artifacts/                      # DB seed scripts
├── server.js                       # Main application entry
├── package.json                    # Dependencies to scan
├── Gruntfile.js                    # Build tasks
├── .socket.facts.json              # Generated reachability data
└── README.md                       # This file
```

---

## Docker Deployment

```bash
# Build and start containers
docker-compose up

# Access at http://localhost:4000
```

The Docker setup includes:
- Node.js application container
- MongoDB container
- Automated database seeding

---

## Development

### Running Tests

```bash
# Run all tests
npm test

# Run E2E tests with Cypress
npm run test:e2e

# Run tests in CI mode
npm run test:ci
```

### Code Linting

```bash
# Uses JSHint configuration
npm run precommit
```

---

## Socket Dashboard

After pushing to GitHub:

1. **View Scans**: https://socket.dev
2. **Check PR Comments**: Socket GitHub App posts security findings
3. **Inspect Reachability**: See which vulnerabilities are Tier 1 reachable

---

## Security Warnings

⚠️ **DO NOT deploy this application to production!** ⚠️

This is a deliberately vulnerable application for educational purposes only. It contains multiple security flaws and should only be run in isolated development environments.

---

## Learn More

### Socket Documentation
- [Socket CLI](https://docs.socket.dev/docs/socket-cli)
- [Full Application Reachability](https://docs.socket.dev/docs/full-application-reachability)
- [GitHub Integration](https://docs.socket.dev/docs/github-integration)
- [Tier 1 Reachability Explained](https://docs.socket.dev/docs/reachability-analysis)

### NodeGoat Resources
- [OWASP NodeGoat](https://github.com/OWASP/NodeGoat)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Node.js Security Best Practices](https://nodejs.org/en/docs/guides/security/)

---

## Contributing

This is a demonstration repository. For issues or contributions:
- **Socket-related**: Submit issues to this repository
- **NodeGoat-related**: Submit to [OWASP/NodeGoat](https://github.com/OWASP/NodeGoat)

---

## License

- **NodeGoat**: Apache 2.0 (see [OWASP/NodeGoat](https://github.com/OWASP/NodeGoat))
- **Socket Integration**: MIT

---

## Acknowledgments

- **OWASP Foundation** for NodeGoat
- **Socket Security** for advanced supply chain protection
- **GitHub** for Actions automation

---

**Ready to see real vulnerability reachability analysis? [Get started with Socket →](https://socket.dev)**

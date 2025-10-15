# NodeGoat + Socket Security (Tier 1 Reachability)

[![Socket Security Scan](https://github.com/dc-larsen/socket-nodegoat-demo/actions/workflows/socket-scan.yml/badge.svg)](https://github.com/dc-larsen/socket-nodegoat-demo/actions/workflows/socket-scan.yml)

This repository is a clone of [OWASP NodeGoat](https://github.com/OWASP/NodeGoat) configured with **Socket Security CLI** to demonstrate **Tier 1 Full Application Reachability Analysis**.

NodeGoat is a deliberately vulnerable Node.js application designed to teach OWASP Top 10 security risks. By integrating Socket's reachability analysis, this project shows how to identify which CVEs are actually exploitable in your code vs. those that are unreachable.

## What's Different

This fork adds automated Socket CLI scanning via GitHub Actions:
- Runs `socket scan create --reach` on every push and pull request
- Performs Tier 1 reachability analysis on all dependencies
- Uploads scan results to Socket's servers for GitHub App integration
- Reduces security noise by ~90% by focusing on reachable vulnerabilities

## Quick Start

### Prerequisites

- **Node.js** 20 or higher
- **MongoDB** (local or [MongoDB Atlas free tier](https://www.mongodb.com/cloud/atlas))
- **Socket Security account** ([sign up free](https://socket.dev))

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

**Option B: MongoDB Atlas (Recommended)**
```bash
# Create free M0 cluster at https://cloud.mongodb.com
# Get connection string and set environment variable:
export MONGODB_URI="mongodb+srv://<username>:<password>@<cluster>/nodegoat"
```

### 3. Seed Database & Start Application

```bash
# Populate database with default users
npm run db:seed

# Start NodeGoat (runs on http://localhost:4000)
npm start
```

**Default user accounts:**
- Admin: `admin` / `Admin_123`
- User 1: `user1` / `User1_123`
- User 2: `user2` / `User2_123`

### 4. Explore Vulnerabilities

Visit http://localhost:4000/tutorial to learn about OWASP Top 10 vulnerabilities and how to exploit/fix them.

## Socket CLI Integration

### GitHub Actions Workflow

The workflow in `.github/workflows/socket-scan.yml` automatically:
1. Installs Socket CLI and project dependencies
2. Runs `socket scan create --reach` for Tier 1 reachability analysis
3. Uploads results to Socket's servers
4. Socket GitHub App uses this data to show reachability in PRs

### Local Socket Scanning

```bash
# Install Socket CLI
npm install -g socket

# Set your API token
export SOCKET_SECURITY_API_TOKEN="your_token_here"

# Run reachability scan
socket scan create --reach --org your-org-slug .
```

### Viewing Results

After pushing to GitHub:
1. **Dashboard**: View scans at https://socket.dev
2. **Pull Requests**: Socket GitHub App posts reachability findings
3. **Alerts**: Filter by "CVE Reachability" to see which vulnerabilities are exploitable

## Docker Deployment

```bash
docker-compose up
# Access at http://localhost:4000
```

The Docker setup includes Node.js application and MongoDB containers with automated database seeding.

## About NodeGoat

NodeGoat includes intentional implementations of the OWASP Top 10:
- **A1**: Injection (SQL/NoSQL)
- **A2**: Broken Authentication
- **A3**: Sensitive Data Exposure
- **A4**: XML External Entities (XXE)
- **A5**: Broken Access Control
- **A6**: Security Misconfiguration
- **A7**: Cross-Site Scripting (XSS)
- **A8**: Insecure Deserialization
- **A9**: Using Components with Known Vulnerabilities
- **A10**: Insufficient Logging & Monitoring

⚠️ **DO NOT deploy this application to production!** This is for educational purposes only.

## Learn More

- [Socket CLI Documentation](https://docs.socket.dev/docs/socket-cli)
- [Full Application Reachability](https://docs.socket.dev/docs/full-application-reachability)
- [OWASP NodeGoat](https://github.com/OWASP/NodeGoat)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

## License

- **NodeGoat**: Apache 2.0 (see [OWASP/NodeGoat](https://github.com/OWASP/NodeGoat))
- **Socket Integration**: MIT

/**
 * Socket Security Demo - Minimal NodeGoat Server
 *
 * This is a simplified version of OWASP NodeGoat to demonstrate
 * Socket Security's npm CLI integration with GitHub Actions.
 */

"use strict";

const express = require("express");
const bodyParser = require("body-parser");
const session = require("express-session");
const consolidate = require("consolidate");
const swig = require("swig");
const marked = require("marked");
const helmet = require("helmet");

const app = express();
const PORT = process.env.PORT || 4000;

// Security middleware (demonstrating npm dependencies)
app.use(helmet());

// Body parsing middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Session management
app.use(session({
    secret: "socket-demo-secret",
    resave: true,
    saveUninitialized: true,
    cookie: {
        httpOnly: true,
        maxAge: 24 * 60 * 60 * 1000 // 24 hours
    }
}));

// Template engine setup
app.engine("html", consolidate.swig);
app.set("view engine", "html");
app.set("views", __dirname + "/views");

// Serve static files
app.use(express.static(__dirname + "/public"));

// Configure marked for markdown processing
marked.setOptions({
    sanitize: true
});

// Basic routes
app.get("/", (req, res) => {
    res.send(`
        <!DOCTYPE html>
        <html>
        <head>
            <title>Socket Security Demo</title>
            <style>
                body {
                    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                    max-width: 800px;
                    margin: 50px auto;
                    padding: 20px;
                    background: #f5f5f5;
                }
                .container {
                    background: white;
                    padding: 40px;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                }
                h1 {
                    color: #2c3e50;
                    margin-bottom: 10px;
                }
                .subtitle {
                    color: #7f8c8d;
                    margin-bottom: 30px;
                }
                .info-box {
                    background: #e3f2fd;
                    border-left: 4px solid #2196f3;
                    padding: 15px;
                    margin: 20px 0;
                }
                code {
                    background: #f4f4f4;
                    padding: 2px 6px;
                    border-radius: 3px;
                    font-family: 'Courier New', monospace;
                }
                .footer {
                    margin-top: 30px;
                    padding-top: 20px;
                    border-top: 1px solid #eee;
                    color: #7f8c8d;
                    font-size: 14px;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>🔒 Socket Security Demo</h1>
                <p class="subtitle">GitHub Actions + npm CLI Reachability Integration</p>

                <div class="info-box">
                    <strong>✅ Server is running!</strong><br>
                    This minimal Node.js application demonstrates Socket Security's
                    npm CLI integration for reachability analysis.
                </div>

                <h2>What's Being Scanned?</h2>
                <p>This application includes several npm dependencies:</p>
                <ul>
                    <li><code>express</code> - Web framework</li>
                    <li><code>helmet</code> - Security middleware</li>
                    <li><code>mongodb</code> - Database driver</li>
                    <li><code>marked</code> - Markdown parser</li>
                    <li>...and more</li>
                </ul>

                <h2>GitHub Actions Workflow</h2>
                <p>When you push changes or open a PR, the Socket CLI:</p>
                <ol>
                    <li>Analyzes all dependencies</li>
                    <li>Performs reachability analysis</li>
                    <li>Generates <code>.socket.facts.json</code></li>
                    <li>Uploads results as workflow artifacts</li>
                </ol>

                <div class="footer">
                    <p>📚 Learn more: <a href="https://docs.socket.dev">docs.socket.dev</a></p>
                    <p>Based on <a href="https://github.com/OWASP/NodeGoat">OWASP NodeGoat</a></p>
                </div>
            </div>
        </body>
        </html>
    `);
});

app.get("/health", (req, res) => {
    res.json({
        status: "healthy",
        timestamp: new Date().toISOString(),
        dependencies: Object.keys(require("./package.json").dependencies).length
    });
});

app.get("/api/info", (req, res) => {
    res.json({
        app: "Socket NodeGoat Demo",
        version: require("./package.json").version,
        nodeVersion: process.version,
        uptime: process.uptime()
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`🚀 Socket Demo Server running on http://localhost:${PORT}`);
    console.log(`📊 Health check: http://localhost:${PORT}/health`);
    console.log(`🔍 Ready for Socket Security scanning!`);
});

module.exports = app;

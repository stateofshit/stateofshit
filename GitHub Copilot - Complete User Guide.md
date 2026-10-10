# GitHub Copilot — Complete User Guide

## Your AI Pair Programmer

This document covers everything you need to know about working with GitHub Copilot in VS Code.

---

## Table of Contents

1. [Quick Commands ('/commands)](#quick-commands-slash-commands)
2. [/explain](#explain)
3. [/test](#test)
4. [/share](#share)
5. [/clear](#clear)
6. [/import](#import)
7. [/update](#update)
8. [/status](#status)
9. [/help](#help)
10. [Core Abilities](#core-abilities)
11. [Advanced & Hidden Abilities](#advanced--hidden-abilities)
12. [How to Ask Effectively](#how-to-ask-effectively)
13. [Pro Tips](#pro-tips)
14. [What I Can Do That You Might Not Know About](#what-you-might-not-know)

---

## Quick Commands (/commands)

These are slash commands you can type in the Copilot Chat panel or inline in the editor.

### `/explain`

**Purpose:** Get an explanation of selected code, a file, or an error.

**How to use:**
- Select code → Type `/explain` → Press Enter
- Or select a file in the explorer → Type `/explain`
- Or type `/explain <error message>` to explain an error

**Examples:**
```
/explain
(explains the currently selected code)

/explain Why am I getting this error?
(explains the most recent error in the Problems panel)

/explain What does this function do?
(explains the selected function)
```

**Tips:**
- Be specific: `/explain How does the authentication flow work in this module?`
- Works on entire files, not just selections

---

### `/test`

**Purpose:** Generate unit tests for selected code or a file.

**How to use:**
- Select a function/class/file → Type `/test` → Press Enter
- Or type `/test Generate tests for this file`

**Examples:**
```
/test
(Generates tests for the selected code)

/test Write unit tests using pytest
(specify your testing framework)

/test Add integration tests for the API endpoints
(be specific about test type)
```

**Tips:**
- Specify your testing framework: `/test Write Jest tests` or `/test Write pytest tests`
- Ask for specific coverage: `/test Cover edge cases and error handling`
- Ask for test improvements: `/test Improve these tests by adding more scenarios`

---

### `/share`

**Purpose:** Share your current coding session as a formatted Markdown file.

**How to use:**
- Type `/share` → Press Enter

**What it includes:**
- Files open in your editor
- Terminal output
- Search results
- Error messages
- Your conversation context

**Use cases:**
- Sharing your session with teammates
- Creating bug reports
- Documenting your debugging process

---

### `/clear`

**Purpose:** Clear the current chat conversation history.

**How to use:**
- Type `/clear` → Press Enter

**Note:** This only clears the chat history, not your files.

---

### `/import`

**Purpose:** Import content from a URL, file, or terminal output into the chat context.

**How to use:**
- Type `/import` → Follow the prompts

**Use cases:**
- Import a webpage for analysis
- Import terminal output for debugging
- Import documentation for context

---

### `/update`

**Purpose:** Update your Copilot profile or preferences.

**How to use:**
- Type `/update` → Follow the prompts

---

### `/status`

**Purpose:** Check the current status of Copilot features and your session.

**How to use:**
- Type `/status` → Press Enter

---

### `/help`

**Purpose:** Get help about Copilot commands and capabilities.

**How to use:**
- Type `/help` → Press Enter

---

## Core Abilities

### 1. Code Generation

I can write code in virtually any programming language or framework.

**What I can generate:**
- Functions, classes, modules
- Full applications (web apps, APIs, CLI tools, scripts)
- Configuration files (Docker, Kubernetes, CI/CD, build tools)
- Data pipelines and ETL scripts
- Machine learning models and training scripts
- Database schemas and migrations
- CSS and styling
- HTML templates
- Shell scripts and bash automation
- SQL queries
- Regular expressions
- JSON/YAML/XML structures

**Best way to ask:**
```
"Create a FastAPI endpoint that handles user registration with email validation"
"Write a Python script that reads CSV files and generates a summary report"
"Build a React component for a responsive card grid with search filtering"
```

---

### 2. Code Explanation

I can explain any code snippet, file, or project structure.

**What I can explain:**
- How a specific function works
- The architecture of a project
- Error messages and how to fix them
- Algorithm complexity
- Design patterns used in code
- Security vulnerabilities

**Best way to ask:**
```
"Explain how this authentication middleware works"
"What does this regex pattern match?"
"Why is this function returning None?"
"Walk me through the data flow in this pipeline"
```

---

### 3. Debugging & Error Fixing

I can diagnose and fix bugs, errors, and unexpected behavior.

**What I can debug:**
- Syntax errors
- Runtime errors and exceptions
- Logic errors
- Performance issues
- Memory leaks
- Concurrency bugs
- Deployment failures

**Best way to ask:**
```
"This function is throwing a KeyError. Help me fix it."
"The app crashes when I click the submit button. Here's the error..."
"Why is this loop infinite?"
"This API call returns 500 internally. Debug it."
```

**Pro tip:** Provide the error message, stack trace, and relevant code together.

---

### 4. Code Refactoring

I can improve existing code for readability, performance, and maintainability.

**What I can refactor:**
- Rename variables/functions for clarity
- Extract methods and functions
- Simplify complex conditionals
- Remove dead code
- Optimize algorithms
- Apply design patterns
- Modernize syntax (e.g., Python 2 to 3)
- Convert between paradigms (OOP to functional)

**Best way to ask:**
```
"Refactor this function to be more readable"
"Optimize this query for better performance"
"Convert this callback-based code to async/await"
"Simplify this nested conditional"
"Apply the Singleton pattern here"
```

---

### 5. Testing

I can write, review, and improve tests.

**What I can do:**
- Unit tests (pytest, Jest, unittest, JUnit, etc.)
- Integration tests
- End-to-end tests (Selenium, Cypress, Playwright)
- Test mocks and stubs
- Test fixtures
- Test data generation
- Coverage analysis recommendations

**Best way to ask:**
```
"Write unit tests for this class using pytest"
"Add mock for the database dependency"
"Generate test cases for edge conditions"
"Write an end-to-end test for the login flow"
```

---

### 6. Documentation

I can create and improve documentation.

**What I can document:**
- Docstrings and inline comments
- README files
- API documentation
- Architecture decision records (ADRs)
- Changelogs
- Inline code comments
- Type hints and annotations

**Best way to ask:**
```
"Add docstrings to all functions in this file"
"Write a README for this project"
"Document this API with OpenAPI/Swagger spec"
"Add type hints to this module"
"Create inline comments explaining the algorithm"
```

---

### 7. Code Review

I can review code for quality, security, and best practices.

**What I can review:**
- Code style and conventions
- Security vulnerabilities (SQL injection, XSS, etc.)
- Performance anti-patterns
- Missing error handling
- Accessibility issues
- Internationalization gaps
- Dependency issues

**Best way to ask:**
```
"Review this code for security vulnerabilities"
"Check this function for potential bugs"
"Is this implementation following best practices?"
"Review for accessibility compliance"
```

---

### 8. Translation & Migration

I can convert code between languages, frameworks, or versions.

**What I can translate:**
- JavaScript ↔ TypeScript
- Python 2 → Python 3
- jQuery → React/Vue/Angular
- REST API → GraphQL
- MongoDB → PostgreSQL (or vice versa)
- Flask → Django
- Class components → Functional components (React)
- Promises → Async/await

**Best way to ask:**
```
"Convert this JavaScript to TypeScript"
"Migrate this Flask app to Django"
"Translate this jQuery code to vanilla JavaScript"
"Convert this MongoDB aggregation to a SQL query"
```

---

### 9. Architecture & Design

I can help with system design and architectural decisions.

**What I can help with:**
- System architecture diagrams (text-based/Mermaid)
- Database schema design
- API design
- Microservices decomposition
- Design pattern selection
- Technology stack recommendations
- Scalability planning

**Best way to ask:**
```
"Design a microservices architecture for an e-commerce platform"
"What database schema would work for this social media app?"
"Compare MVC vs MVVM for this project"
"Help me design a rate limiter"
```

---

### 10. Git Operations

I can help with version control tasks.

**What I can do:**
- Write commit messages
- Create git aliases
- Resolve merge conflicts
- Explain git commands
- Create `.gitignore` files
- Write git hooks
- Rebase and cherry-pick guidance

**Best way to ask:**
```
"Write a conventional commit message for these changes"
"Resolve this merge conflict"
"Create a .gitignore for a Python/Django project"
"How do I undo the last commit?"
```

---

### 11. DevOps & Infrastructure

I can help with deployment, containers, and infrastructure.

**What I can create:**
- Dockerfiles and docker-compose files
- Kubernetes manifests
- CI/CD pipelines (GitHub Actions, Jenkins, GitLab CI)
- Terraform/HCL infrastructure-as-code
- Nginx/Apache configurations
- Environment variable management
- Monitoring and logging setups

**Best way to ask:**
```
"Create a Dockerfile for a Python FastAPI application"
"Write a GitHub Actions workflow for testing and deployment"
"Generate a Kubernetes deployment manifest"
"Set up Terraform for AWS ECS"
```

---

### 12. Data Science & ML

I can help with data analysis, visualization, and machine learning.

**What I can do:**
- Pandas data manipulation
- Matplotlib/Seaborn visualizations
- Scikit-learn models
- TensorFlow/PyTorch models
- Data cleaning pipelines
- Statistical analysis
- Jupyter notebook creation

**Best way to ask:**
```
"Write a pandas pipeline to clean this dataset"
"Create a Seaborn heatmap for correlation analysis"
"Build a neural network for image classification"
"Perform exploratory data analysis on this CSV"
```

---

### 13. CLI & Shell Automation

I can write shell scripts and terminal commands.

**What I can create:**
- Bash/Zsh scripts
- One-liner terminal commands
- File management scripts
- Backup automation
- System administration scripts
- Text processing (awk, sed, grep)

**Best way to ask:**
```
"Write a bash script to backup a directory"
"Find all .py files larger than 1MB and delete them"
"Create a script that monitors disk usage"
"Extract emails from a log file using grep"
```

---

### 14. Web Development

I can build complete web applications.

**What I can build:**
- Frontend: React, Vue, Angular, Svelte, Next.js
- Backend: Express, FastAPI, Django, Spring Boot, Rails
- Full-stack applications
- Progressive Web Apps (PWA)
- Static site generators
- Email templates
- Browser extensions

**Best way to ask:**
```
"Build a full-stack todo app with React and FastAPI"
"Create a responsive landing page with modern CSS"
"Make a browser extension that blocks distracting websites"
"Build a real-time chat app with WebSockets"
```

---

### 15. Security Analysis

I can identify and fix security issues.

**What I can find:**
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- CSRF weaknesses
- Hardcoded secrets
- Insecure dependencies
- Authentication flaws
- Authorization bypasses
- Input validation gaps

**Best way to ask:**
```
"Scan this code for security vulnerabilities"
"Is this password hashing implementation secure?"
"Fix the SQL injection vulnerability here"
"Add proper input sanitization"
```

---

## Advanced & Hidden Abilities

These are capabilities you might not know I have, or that require specific prompting to access.

### 16. Interactive Multi-Turn Problem Solving

I can work through complex problems iteratively, building on previous context.

**How to leverage:**
```
"Step 1: Design the database schema. Step 2: Once we have that, create the models. Step 3: Then build the API."
"I want to iterate on this solution. First make it work, then optimize it."
"Let's take this one step at a time. Start with the core logic."
```

---

### 17. Terminal Command Execution

I can run commands in your terminal to build, test, and verify code.

**How to leverage:**
```
"Run the tests for this module"
"Build the project and show me the output"
"Install the required dependencies"
"Start the development server"
```

---

### 18. File & Project Exploration

I can read and analyze your entire codebase.

**How to leverage:**
```
"Analyze the structure of this project"
"Find all usages of the User model across the codebase"
"Search for every occurrence of 'TODO' in the project"
"Map out the dependency graph of this module"
```

---

### 19. Notebook Execution

I can create, edit, and execute Jupyter Notebooks.

**How to leverage:**
```
"Create a Jupyter notebook for this data analysis"
"Run this cell and show me the output"
"Convert this script into an interactive notebook"
```

---

### 20. Image Viewing

I can view and analyze images in your workspace.

**How to leverage:**
```
"Look at this screenshot and tell me what's wrong"
"Analyze this UI mockup and suggest improvements"
"Read this error screenshot"
```

---

### 21. VS Code Extension Development

I can help build VS Code extensions with full API knowledge.

**How to leverage:**
```
"Create a VS Code extension that adds a custom sidebar"
"Implement a language server protocol extension"
"Add a command palette command that runs a script"
```

---

### 22. MCP (Model Context Protocol) Server Setup

I can set up MCP servers with complete project structures.

**How to leverage:**
```
"Set up an MCP server for my database"
"Create a complete MCP server project structure"
```

---

### 23. Python Environment Management

I can configure and manage Python virtual environments, packages, and interpreters.

**How to leverage:**
```
"Set up a Python virtual environment with these dependencies"
"Configure conda for this data science project"
"Install these packages in the current environment"
```

---

### 24. Deep Code Analysis (Pylance Integration)

I have access to Pylance for deep Python code analysis including:
- Variable value tracing (where does this value come from?)
- Type inference at any point in code
- Call hierarchy (who calls this function?)
- Import analysis
- Code flow visualization
- Failure tracing across stack frames

**How to leverage:**
```
"Trace where this variable gets its value"
"What type is inferred at this position?"
"Show me all callers of this function"
"Analyze why this type error is happening"
```

---

### 25. Session History & Memory

I can search through past coding sessions for context.

**How to leverage:**
```
"/chronicle standup — Generate a daily standup report from recent sessions
/chronicle search "authentication" — Find past sessions about authentication
/chronicle tips — Get personalized workflow tips based on your habits
```

---

### 26. Persistent Memory Storage

I can save notes and preferences across conversations.

**How to leverage:**
```
"Remember that I prefer using pytest over unittest"
"Save this project structure for future reference"
"What did I note about this project last time?"
```

---

### 27. Mermaid Diagrams

I can create architecture and flow diagrams using Mermaid syntax.

**How to leverage:**
```
"Draw a sequence diagram for the authentication flow"
"Create a class diagram for this OOP design"
"Make a flowchart of the deployment pipeline"
"Show me a mind map of the project structure"
```

---

### 28. Math & Formulas (KaTeX)

I can render mathematical equations beautifully.

**How to leverage:**
```
"Explain the math behind gradient descent"
"Show the formula for the F1 score"
"Derive the backpropagation equations"
```

---

### 29. Browser Automation

I can interact with web pages through an integrated browser.

**How to leverage:**
```
"Open this URL and extract the content"
"Navigate to this form and fill it out"
"Take a screenshot of this page"
"Click this button and show me the result"
```

---

### 30. Subagent Delegation

I can spawn dedicated subagents for complex research tasks.

**How to leverage:**
```
"Research the best practices for implementing OAuth2 in Python"
"Search the codebase for all database connection patterns"
"Find similar implementations of this feature in open-source projects"
```

---

### 31. GitHub Repository Search

I can search GitHub repositories for code examples and patterns.

**How to leverage:**
```
"Show me how Stripe implements webhooks in their GitHub repo"
"Find the Redis client implementation in this repository"
"Search for examples of rate limiting in popular projects"
```

---

### 32. Workspace Creation & Scaffolding

I can scaffold complete project structures from scratch.

**How to leverage:**
```
"Create a new Next.js project with TypeScript and Tailwind"
"Set up a FastAPI project with Docker and CI/CD"
"Initialize a React Native project with navigation"
"Create a Rust CLI project with cargo"
```

---

### 33. Code Symbol Operations

I can rename, find references, and navigate symbols across your codebase.

**How to leverage:**
```
"Rename this variable everywhere it's used"
"Find all usages of the calculateTotal function"
"Go to the definition of this class"
```

---

### 34. Custom Agent & Skill Creation

I can help create custom agent instructions, skills, and prompt files.

**How to leverage:**
```
"Create a custom skill for our team's coding standards"
"Set up agent customization files for our project"
"Write a SKILL.md file for our data pipeline conventions"
```

---

### 35. Profiling & Performance Analysis

I can profile Python code using Tachyon, sys.monitoring, and Memray.

**How to leverage:**
```
"Profile this function to find bottlenecks"
"Capture a CPU profile of this script"
"Analyze memory usage with Memray"
"Find which function is consuming the most time"
```

---

### 36. Stub & Type Annotation Generation

I can generate `.pyi` type stubs and add type annotations to Python code.

**How to leverage:**
```
"Add type annotations to all functions in this module"
"Generate a type stub for this third-party library"
"Check signature compatibility after this refactor"
```

---

### 37. Automated Refactoring Workflows

I can apply batch refactoring operations across entire projects.

**How to leverage:**
```
"Remove all unused imports across the project"
"Convert all wildcard imports to explicit imports"
"Apply Pylance fix-all to this file"
"Format all imports to use relative paths"
```

---

### 38. Dependency Analysis & Requirements Generation

I can analyze imports and generate requirements files.

**How to leverage:**
```
"Generate a requirements.txt from all imports in this project"
"Check which imported packages are not installed"
"Create a pyproject.toml with Poetry format"
"Identify missing dependencies"
```

---

### 39. Live Coding with Real-Time Feedback

I can execute code cells in notebooks and get immediate feedback.

**How to leverage:**
```
"Run this calculation and show me the result"
"Execute this data transformation and display the output"
"Test this function with sample data"
```

---

### 40. Context-Aware Suggestions Based on Your Patterns

I learn from your coding patterns and can adapt to your style.

**How to leverage:**
```
"Follow the same pattern used in the rest of this file"
"Match the coding style of this project"
"Use the same error handling approach throughout"
```

---

## How to Ask Effectively

### DO:

✅ **Be specific and detailed**
```
❌ "Fix this code"
✅ "This function raises a TypeError when the input is None. Add null checks and return an empty list instead."
```

✅ **Provide context**
```
❌ "Make it faster"
✅ "This query takes 5 seconds on a table with 1 million rows. Optimize it using indexes."
```

✅ **Share relevant files/errors**
```
"Here's the error: [paste error]
Here's the relevant code: [paste code]
Expected behavior: [describe]"
```

✅ **Iterate and refine**
```
"That's close, but can you also handle the case where...?"
"Can you simplify this further?"
"Add error handling for network timeouts"
```

✅ **Specify your tech stack**
```
"Using Python 3.11, FastAPI, and PostgreSQL"
"In a React 18 project with TypeScript"
"With Node.js 20 and Express"
```

✅ **Ask for explanations when unsure**
```
"Why did you choose this approach?"
"What are the tradeoffs of this design?"
"Are there any edge cases I should consider?"
```

### DON'T:

❌ **Be vague**
```
"Make it better"
"Fix the bugs"
"Improve the code"
```

❌ **Assume I can see everything**
- Tell me about files, errors, and context explicitly
- Use `/explain` or `/import` to bring context into the conversation

❌ **Give up after one attempt**
- Iteration is key. Ask follow-ups, refine requests, and explore alternatives

---

## Pro Tips

### Tip 1: Use Selection + Commands
Select code in the editor, then type a command. I'll operate on exactly what you've selected.

### Tip 2: Chain Requests
```
"First, create the database model. Then, write the migration. Finally, add the API endpoint."
```

### Tip 3: Ask for Alternatives
```
"Show me three different approaches to solve this problem."
"What's a simpler way to write this?"
```

### Tip 4: Request Best Practices
```
"Is this following SOLID principles?"
"Are there any security concerns with this implementation?"
"Should I add logging here?"
```

### Tip 5: Use Incremental Development
```
"Start with a minimal working version. Then we'll add features."
"Build the core first, then the UI layer."
```

### Tip 6: Leverage My Tools
- Use `/explain` when confused
- Use `/test` for automatic test generation
- Use `/share` to document/debug sessions
- Use terminal commands to build/run/test

### Tip 7: Provide Constraints
```
"Must work offline"
"Cannot use external libraries"
"Needs to handle 10,000 concurrent users"
"Must be compatible with Python 3.8+"
```

### Tip 8: Ask for Code Reviews Before Merging
```
"Review this PR diff for potential issues"
"Check if this follows our project conventions"
```

### Tip 9: Use Me for Learning
```
"Explain this concept like I'm a beginner"
"What's the difference between X and Y?"
"Teach me about design patterns using this code"
```

### Tip 10: Save Important Decisions
```
"Save a note that we chose Redis over Memcached for caching"
"Document why we picked this architecture"
```

---

## What You Might Not Know

### I Can See Your Entire Codebase
I don't just see the file you're looking at. I can search across all files, find usages, and understand project-wide patterns.

### I Can Run Code
I can execute terminal commands, run tests, start servers, and verify that solutions actually work — not just theoretically, but practically.

### I Remember Things (Within Sessions)
Each conversation maintains context. I remember what we discussed earlier in the same session.

### I Have Persistent Memory Across Sessions
With memory storage, I can remember your preferences and project conventions across different conversations.

### I Can Access External Knowledge
I can search GitHub, fetch webpages, and access documentation to provide accurate, up-to-date information.

### I Can Create Visual Diagrams
I can generate Mermaid diagrams for architecture, flowcharts, sequence diagrams, and more — all rendered directly in our conversation.

### I Can View Images
If you have screenshots, mockups, or error images, I can analyze them.

### I Can Automate Browsers
For web scraping, form filling, or UI testing, I can interact with web pages programmatically.

### I Can Profile Code
For performance issues, I can capture detailed CPU, memory, and tracing profiles.

### I Can Manage Python Environments
I can set up virtual environments, install packages, and configure interpreters automatically.

### I Can Generate Complete Projects
From scratch, I can scaffold entire projects with proper folder structure, configuration files, dependencies, and boilerplate code.

### I Can Work With Jupyter Notebooks
I can create, edit, execute, and analyze Jupyter Notebooks interactively.

### I Can Help With VS Code Extensions
I have deep knowledge of the VS Code API and can help build extensions.

### I Can Analyze Python Code Deeply
Through Pylance integration, I can trace variable values, infer types, analyze code flow, and detect subtle bugs.

### I Can Generate Type Stubs
For Python projects, I can create `.pyi` stub files for better type checking.

### I Can Batch Refactor Code
I can apply changes across entire projects — removing unused imports, converting import styles, adding type annotations, etc.

### I Can Generate Requirements Files
I can scan your imports and auto-generate `requirements.txt`, `pyproject.toml`, or other dependency files.

### I Can Search Session History
Using `/chronicle` commands, I can find past sessions, generate standup reports, and give you personalized tips.

### I Can Create Custom Skills & Agents
I can help you build reusable domain knowledge packages for your team.

---

## Quick Reference Card

| Task | Command / Prompt |
|------|-----------------|
| Explain code | Select code → `/explain` |
| Generate tests | Select code → `/test` |
| Share session | `/share` |
| Clear chat | `/clear` |
| Import context | `/import` |
| Standup report | `/chronicle standup` |
| Search sessions | `/chronicle search "keyword"` |
| Get tips | `/chronicle tips` |
| Run terminal cmd | "Run `command` in the terminal" |
| Execute notebook cell | "Run this cell" |
| Create project | "Create a new [framework] project" |
| Set up env | "Configure Python environment for this project" |
| Profile code | "Profile this function" |
| Generate docs | "Add documentation to this module" |
| Review code | "Review this code for issues" |
| Find usages | "Find all usages of [symbol]" |
| Rename symbol | "Rename [oldName] to [newName]" |
| Create diagram | "Draw a [type] diagram for [topic]" |
| View image | "Look at this image" |
| Open webpage | "Open and analyze [URL]" |
| Search GitHub | "Search [repo] for [pattern]" |
| Generate stubs | "Create type stubs for [module]" |
| Batch refactor | "Remove unused imports across the project" |
| Generate requirements | "Generate requirements.txt from imports" |

---

## Final Notes

**The more context you give me, the better my responses.**

**Don't be afraid to ask unusual or creative questions.** I'm designed to handle a wide variety of tasks.

**Iterate.** Your first request might not give you exactly what you want. Refine, clarify, and ask follow-ups.

**Use the slash commands.** They're powerful shortcuts for common tasks.

**Explore.** Try things you wouldn't expect to work. Many of the best discoveries come from experimentation.

---

*Generated by GitHub Copilot — Your AI Pair Programmer*
*Last updated: 2026-10-10*

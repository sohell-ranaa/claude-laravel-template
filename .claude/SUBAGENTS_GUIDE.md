# Subagents Guide - Laravel Project Template

## 🎯 What Are Subagents?

Subagents are specialized AI agents that Claude Code can spawn to handle complex, multi-step tasks autonomously. They work in the background and return results when done.

**Key Benefits:**
- 🚀 60-70% token savings on complex tasks
- ⚡ Faster results through parallel processing
- 🎯 Specialized expertise for specific tasks
- 📊 Better quality output through focused analysis

---

## 🤖 Built-in Subagents

### 1. **Explore Agent**
**Purpose:** Fast codebase exploration and pattern searching

**When to use:**
- Finding files by patterns or keywords
- Understanding codebase structure
- Searching across multiple files (5+)
- Answering "where is X?" questions

**Thoroughness levels:**
- `quick` - Fast surface-level search
- `medium` - Balanced depth (recommended)
- `very thorough` - Deep comprehensive analysis

**Example usage:**
```
"Use Explore agent with medium thoroughness to find all authentication-related files"
"Use Explore agent to show me the structure of the user management system"
```

**Token savings:** 60-75% vs manual Glob/Grep

---

### 2. **Plan Agent**
**Purpose:** Software architect for implementation planning

**When to use:**
- Planning new features before implementation
- Understanding architectural trade-offs
- Designing multi-file changes
- Identifying critical files for a task

**Example usage:**
```
"Use Plan agent to design a user notification system with email and in-app notifications"
"Use Plan agent to plan migration from session auth to API tokens"
```

**Token savings:** 70-80% vs trial-and-error coding

---

### 3. **General-Purpose Agent**
**Purpose:** Multi-step task handler for complex research

**When to use:**
- Complex searches requiring multiple rounds
- Tasks combining search + analysis + decisions
- Uncertain about file locations
- Research-heavy investigations

**Example usage:**
```
"Use general-purpose agent to analyze how payments flow from checkout to settlement"
"Use general-purpose agent to find all hardcoded API URLs and suggest configuration approach"
```

**Token savings:** 50-60% for complex research

---

## 📋 Creating Custom Slash Commands

You can create project-specific slash commands that invoke subagents with pre-configured prompts.

### Directory Structure
```
.claude/
└── commands/
    ├── explore-domain.md
    ├── plan-feature.md
    └── verify-rules.md
```

### Example: Explore Domain Command

**File:** `.claude/commands/explore-domain.md`
```markdown
---
description: Explore your domain-specific code
---

Use the Explore agent with "medium" thoroughness to search and analyze
domain-specific code in this project.

Focus on:
- [Entity 1] management workflows
- [Entity 2] business logic
- [Feature 3] integrations

Provide a comprehensive overview including:
- Key files and their responsibilities
- Database models and relationships
- Livewire components involved
- Business logic services
- API integrations

Present findings with file paths and line numbers.
```

**Usage:**
```
Type: /explore-domain
Get: Complete domain analysis
```

### Example: Plan Feature Command

**File:** `.claude/commands/plan-feature.md`
```markdown
---
description: Plan a new feature with architectural design
---

Use the Plan agent to design the implementation of a new feature.

**Instructions:** After invoking this command, describe the feature you want.

The Plan agent will:
1. Analyze existing codebase architecture
2. Identify affected files and components
3. Consider architectural trade-offs
4. Design step-by-step implementation plan
5. Flag potential conflicts or issues
6. Suggest best practices

**Project Context:**
- Laravel 11.x + Livewire 4.2
- Must use slug-based URLs (not IDs)
- Must use existing Blade components
- Files must be modular (<300 lines)

The plan will include:
- Files to create/modify
- Database migrations needed
- Livewire components structure
- Routes and URLs
- Business logic services
- Testing strategy
```

**Usage:**
```
Type: /plan-feature
Describe: "Add two-factor authentication via SMS"
Get: Complete implementation plan
```

---

## 🎓 Usage Patterns

### Pattern 1: Exploration → Planning → Implementation

```
Step 1: Use Explore agent to understand current system
  "Use Explore agent to map out current authentication system"

Step 2: Use Plan agent to design changes
  "Use Plan agent to add OAuth2 support to existing auth"

Step 3: Implement with full context
  (Start coding with comprehensive understanding)
```

### Pattern 2: Investigation → Analysis → Fix

```
Step 1: Use Explore agent to find related code
  "Use Explore agent to find all email notification code"

Step 2: Use general-purpose agent for deep analysis
  "Use general-purpose agent to trace why confirmation emails aren't sending"

Step 3: Fix with understanding
  (Apply fix knowing the complete flow)
```

### Pattern 3: Verification → Refactoring

```
Step 1: Use general-purpose agent to verify patterns
  "Use general-purpose agent to find all direct DB queries in controllers"

Step 2: Use Plan agent to design refactoring
  "Use Plan agent to refactor direct DB queries into repository pattern"

Step 3: Implement refactoring
  (Systematic refactoring with plan)
```

---

## 💡 Best Practices

### ✅ DO:

**1. Use for multi-file tasks**
```
Anything involving 5+ files → Subagent
Cross-feature analysis → Subagent
System-wide pattern search → Subagent
```

**2. Plan before coding**
```
Always use Plan agent for new features
Saves 75% tokens + prevents mistakes
Get architectural validation early
```

**3. Specify thoroughness appropriately**
```
Quick scan → "quick"
Most tasks → "medium"
Security audit → "very thorough"
```

**4. Combine with skills**
```
Subagent for exploration/planning
Skills for specific knowledge
Documentation for reference
```

### ❌ DON'T:

**1. Don't use for simple tasks**
```
Reading 1-2 files → Use Read tool
Simple search → Use Grep tool
Known file edit → Use Edit tool
```

**2. Don't over-specify upfront**
```
Let command invoke subagent
Add details in follow-up message
Keep initial prompt focused
```

**3. Don't spawn too many in parallel**
```
Use one at a time for clarity
Wait for results before next
Parallel only when truly independent
```

---

## 📊 Token Savings Examples

| Your Task | Traditional | With Subagent | Savings |
|-----------|-------------|---------------|---------|
| Plan new feature | 12,000 | 3,000 | 9,000 (75%) |
| Explore domain | 8,000 | 2,000 | 6,000 (75%) |
| Debug complex issue | 6,000 | 2,000 | 4,000 (67%) |
| Verify patterns | 5,000 | 2,000 | 3,000 (60%) |

**Project with 10 complex tasks:**
- Traditional: ~80,000 tokens
- With subagents: ~25,000 tokens
- **Savings: 55,000 tokens (69%)**

---

## 🔧 Customization for Your Project

### Step 1: Identify Common Tasks

List tasks you do frequently:
- Exploring specific domains (users, products, orders, etc.)
- Planning common feature types
- Verifying project-specific rules
- Analyzing domain-specific workflows

### Step 2: Create Slash Commands

For each common task, create a slash command in `.claude/commands/`:

```bash
.claude/commands/
├── explore-users.md       # Explore user management code
├── explore-products.md    # Explore product catalog code
├── plan-feature.md        # Plan new feature
├── verify-rules.md        # Verify project rules
└── analyze-workflow.md    # Analyze business workflows
```

### Step 3: Document in claude.md

Add your commands to the Subagent System section in `claude.md`:

```markdown
### Available Slash Commands

**Exploration:**
- `/explore-users` - Analyze user management system
- `/explore-products` - Analyze product catalog

**Planning:**
- `/plan-feature` - Design new feature implementation

**Analysis:**
- `/verify-rules` - Verify compliance with project rules
```

### Step 4: Train Your Team

Share this guide with your team:
1. When to use subagents vs direct tools
2. How to invoke with slash commands
3. How to interpret results
4. When to follow up with more specific questions

---

## 🆘 Troubleshooting

**Q: Subagent didn't find what I need?**
```
A: Be more specific in follow-up
   "Focus specifically on the payment processing service"
   "Look in the app/Services directory"
```

**Q: Should I use subagent or skill?**
```
A:
- Skill = Knowledge reference (patterns, components, rules)
- Subagent = Active search/analysis/planning
- Use both together for best results
```

**Q: Subagent output too long?**
```
A: Ask for summary
   "Summarize the key files in a table"
   "Give me just the top 3 most important findings"
```

**Q: How do I know if I'm saving tokens?**
```
A: If you would manually:
   - Read 5+ files → 60-75% savings
   - Plan complex feature → 70-80% savings
   - Multi-step investigation → 50-60% savings
```

---

## 📚 Resources

- **Claude Code Docs:** https://docs.anthropic.com/claude-code
- **Subagent Quick Ref:** This project's quick reference (if created)
- **Project claude.md:** Main configuration and guidelines

---

**Last Updated:** March 5, 2026
**Template Version:** 1.0
**For:** Laravel + Livewire projects

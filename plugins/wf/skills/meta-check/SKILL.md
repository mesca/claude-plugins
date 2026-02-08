---
name: meta-check
description: Analyze .claude directory and this plugin for inconsistencies, redundancies, and adherence to Claude Code best practices. Use when auditing skill definitions, checking plugin structure, validating settings files, or ensuring proper information hierarchy.
context: fork
---

# Meta Check Skill

Perform a comprehensive meta-analysis of the `.claude/` directory AND this plugin to identify inconsistencies, redundancies, and deviations from Claude Code best practices.

## When to Use This Skill

✅ **Use when:**
- Auditing .claude directory structure and organization
- Validating this plugin's structure and composition
- Checking skill definitions for proper scope and format
- Validating settings.json configuration
- Finding redundant content across instruction files
- Ensuring naming and style consistency
- Verifying information hierarchy (CLAUDE.md → PROJECT.md → Skills)

❌ **Don't use when:**
- Checking project code compliance (use /compliance-check instead)
- Verifying MCP server connectivity (use /mcp-check instead)
- Working on tasks unrelated to .claude or plugin configuration

## Usage

```bash
/meta-check [category]
```

**Categories:**
- `plugin` - This plugin's structure and composition
- `structure` - Directory structure and file organization
- `instructions` - CLAUDE.md and PROJECT.md analysis
- `skills` - Skill definitions and scope analysis
- `settings` - Configuration files (settings.json, etc.)
- `redundancy` - Cross-file duplication and overlap
- `consistency` - Naming, formatting, and style consistency
- `all` - Run all checks (default)

## What This Skill Checks

### 0. Plugin Structure (This Plugin)

Verify the `wf` plugin is correctly composed:

**Expected Plugin Structure**:
```
plugins/wf/
├── .claude-plugin/
│   └── plugin.json           # Plugin metadata (required)
├── hooks/
│   ├── hooks.json            # Hook definitions
│   └── *.sh                  # Hook scripts
└── skills/
    ├── compliance-check/     # command: true, subagent: true
    │   └── SKILL.md
    ├── meta-check/           # command: true, subagent: true
    │   └── SKILL.md
    ├── mcp-check/            # command: true, subagent: true
    │   └── SKILL.md
    └── <other-skills>/       # command: false (auto-loaded)
        └── SKILL.md
```

**Check for**:
- **plugin.json** exists and is valid JSON with required fields (name, description, version)
- **plugin.json** references hooks file if hooks exist
- **hooks/hooks.json** is valid JSON with proper hook structure
- **Hook scripts** are executable and exist at referenced paths
- **Skills** have proper frontmatter:
  - All skills have `name` and `description`
  - Command skills have `command: true` and `subagent: true`
  - Auto-loaded skills have `command: false`
- **Skill naming** matches directory names (kebab-case)
- **No orphaned files** in skills directories
- **Cross-references** between skills are valid (See Also sections)
- **${PROJECT_NAME}** used consistently (no hardcoded project names)
- **Python version** consistent across all skills

**Plugin Validation Checklist**:
```
# Plugin Structure
- [ ] plugin.json exists and valid
- [ ] hooks/hooks.json exists and valid (if hooks dir exists)
- [ ] All hook scripts are executable

# Skill Configuration
- [ ] compliance-check: command=true, subagent=true
- [ ] meta-check: command=true, subagent=true
- [ ] mcp-check: command=true, subagent=true
- [ ] All other skills: command=false

# Content Consistency
- [ ] No hardcoded project names (use ${PROJECT_NAME})
- [ ] Python version consistent (3.14+)
- [ ] All skills have "When to Use" sections
- [ ] All skills have "Output Format" sections
- [ ] See Also sections reference valid skills
- [ ] No duplicate content across skills
```

### 1. Directory Structure Compliance

Verify `.claude/` follows Claude Code standards:

**Expected Structure**:
```
.claude/
├── CLAUDE.md              # Main project instructions
├── PROJECT.md             # Project-specific conventions (optional)
├── settings.json          # Project settings (shared)
├── settings.local.json    # Personal settings (git-ignored)
├── skills/                # Skills (one capability per skill)
│   ├── skill1/
│   │   ├── SKILL.md       # Skill definition (required)
│   │   └── ...            # Supporting files (optional)
│   └── skill2/
│       └── SKILL.md
└── agents/                # Subagents (optional)
    ├── agent1.md
    └── agent2.md
```

**Check for**:
- Missing required files (CLAUDE.md)
- Unexpected file types or locations
- Proper directory naming (lowercase, hyphens)
- Git-ignored files that should be (.local.json)
- Files that shouldn't be git-ignored (settings.json)

### 2. Instruction File Analysis (CLAUDE.md & PROJECT.md)

Verify project instructions follow best practices:

**CLAUDE.md Requirements**:
- Clear, specific instructions (not vague)
- Properly structured with markdown headings
- Concrete examples over abstract rules
- "Use 2-space indentation" NOT "Format code properly"
- Hierarchical organization with bullet points
- Reference to PROJECT.md for project-specific conventions
- No redundancy with skills (instructions should reference skills)

**PROJECT.md Requirements**:
- Project-specific conventions only (not generic guidelines)
- Package name, import patterns, architecture specifics
- Should complement CLAUDE.md, not duplicate it
- Clear separation of concerns

**Check for**:
- Vague or abstract instructions
- Missing concrete examples
- Redundancy between CLAUDE.md and PROJECT.md
- Information that belongs in skills instead
- Outdated or conflicting instructions
- Missing critical project information
- Instructions duplicated in skills

### 3. Skills Analysis

Verify skills follow "one capability per skill" principle:

**Skill Structure**:
```markdown
---
name: skill-name
description: Clear, specific description. Use when [concrete scenarios]. NOT when [exclusions].
---

# Skill Name

## When to Use This Skill

✅ **Use when:**
- Specific scenario 1
- Specific scenario 2

❌ **Don't use when:**
- Exclusion 1
- Exclusion 2

## Instructions
[Detailed, focused instructions for ONE capability]
```

**Check for**:
- **Overly broad scope**: One skill should NOT cover "Document processing" - split into separate skills
- **Vague descriptions**: "Helps with documents" → "Extract text and tables from PDFs, fill forms, merge documents"
- **Missing trigger terms**: Description lacks keywords Claude would match
- **Redundant skills**: Multiple skills with overlapping purposes
- **Missing SKILL.md**: Skill directory without SKILL.md file
- **Unclear when-to-use**: Missing "Use when" and "Don't use when" sections
- **Generic instructions**: Should be specific to the skill's capability
- **Content duplication**: Instructions repeated across multiple skills
- **Skills vs Instructions**: Content that belongs in CLAUDE.md instead

### 4. Settings File Analysis

Verify configuration follows best practices:

**settings.json** (project-wide, committed):
```json
{
  "permissions": {
    "allow": ["Bash(pytest:*)", "Read(src/**)"],
    "ask": ["Write(**/*.md)"],
    "deny": ["Read(.env)", "Write(.env)"]
  },
  "env": {
    "PROJECT_ROOT": "."
  },
  "hooks": {
    "user-prompt-submit": "echo 'Hook triggered'"
  },
  "defaultMode": "ask"
}
```

**settings.local.json** (personal, git-ignored):
- Personal preferences that override project settings
- Should NOT be in version control

**Check for**:
- **.env protection incomplete**: Deny rules should use patterns like `Read(.env*)` and `Write(.env*)` to protect all .env variants (.env.local, .env.production, etc.)
- **.env protection for subdirectories**: Should also protect `Read(**/.env*)` and `Write(**/.env*)` for nested directories
- **Unnecessary permissions**: Overly broad allow rules
- **settings.local.json in git**: Use `git ls-files .claude/settings.local.json` to verify file is not tracked
- **settings.local.json not gitignored**: Should be in .gitignore for personal settings
- **Conflicting rules**: Allow and deny rules that conflict
- **Invalid JSON**: Syntax errors (use `python3 -m json.tool settings.json`)
- **Deprecated settings**: Old or removed configuration options
- **Missing hooks validation**: Hooks that reference non-existent scripts
- **Environment variable leakage**: Secrets in settings.json

### 5. Redundancy Analysis

Identify duplicate or overlapping content:

**Cross-File Duplication**:
- Same instructions in CLAUDE.md, PROJECT.md, and skills
- Same instructions in multiple skills
- Settings that contradict instructions

**Content Overlap**:
- Skills with overlapping scopes
- Instructions better suited for skills (or vice versa)
- Documentation of same concept in multiple places

**Check for**:
- Exact text duplication (copy-paste)
- Semantic duplication (same concept, different words)
- Hierarchical violations (specific info in general file)
- Reverse violations (general info in specific file)

**Example Issues**:
```
CLAUDE.md: "Use Google-style docstrings"
documentation skill: "Use Google-style docstrings with Args, Returns..."
❌ REDUNDANT: Skill should have the details, CLAUDE.md should reference skill

compliance-check skill: Checks project adherence
meta-check skill: Checks .claude directory
✅ NOT REDUNDANT: Different scopes and purposes
```

### 6. Consistency Analysis

Verify naming, formatting, and style consistency:

**Naming Conventions**:
- **Files**: kebab-case (my-skill.md, not my_skill.md or MySkill.md)
- **Skills**: kebab-case directories (code-quality/, not code_quality/)
- **Skill names**: Match directory names

**Formatting Standards**:
- Consistent markdown heading levels
- Uniform code block formatting
- Consistent bullet point style (-, *, or numbered)
- Uniform emoji usage (prefer none per CLAUDE.md)
- Consistent YAML frontmatter format

**Style Consistency**:
- Tone and voice (imperative, declarative, etc.)
- Terminology (use same terms throughout)
- Example format (all use same structure)
- Section organization (similar skills use similar sections)

**Check for**:
- Mixed naming conventions
- Inconsistent heading hierarchy
- Different formatting styles
- Terminology inconsistencies
- Structural inconsistencies between similar files

### 7. Scope and Hierarchy Violations

Verify information is at the correct level:

**Hierarchy** (general → specific):
1. **CLAUDE.md**: Framework-level guidelines, tools, architecture
2. **PROJECT.md**: Project-specific conventions, package info
3. **Skills**: Detailed how-to for specific capabilities

**Violations to Check**:
- Specific implementation details in CLAUDE.md (should be in skills)
- Generic development guidelines in PROJECT.md (should be in CLAUDE.md)
- Skills that are too broad (should be split)
- Skills that are too narrow (should be combined)

**Examples**:
```
❌ CLAUDE.md: "Import logger with: from tth.core import logger"
   → Too specific, belongs in logging skill

✅ CLAUDE.md: "Never use print() - always use logger"
   ✅ logging skill: "Import: from tth.core import logger"
   → Proper hierarchy: CLAUDE.md has principle, skill has details

❌ PROJECT.md: "Write tests before implementation (TDD)"
   → Generic guideline, belongs in CLAUDE.md

✅ PROJECT.md: "Tests mirror architecture: tests/core/, tests/services/, tests/interfaces/"
   → Project-specific structure, correct location
```

### 8. Best Practices Compliance

Check adherence to Claude Code documentation:

**From Claude Code Docs**:
- Skills should be "narrowly scoped" (one capability)
- Descriptions should include "trigger terms" for discoverability
- Instructions should be "specific" not "vague"
- Settings should follow precedence rules
- Use subdirectories for organization

**Check for**:
- Best practice violations from official docs
- Anti-patterns mentioned in documentation
- Outdated patterns (deprecated features)
- Missing opportunities (hooks, MCP integration, etc.)

### 9. Integration and References

Verify cross-references and integrations:

**Internal References**:
- CLAUDE.md references skills correctly
- Skills don't reference each other (should be independent)
- Instructions point to correct file paths

**External Integrations**:
- MCP server references in instructions match .mcp.json
- Hook commands reference existing scripts
- Tool restrictions match available tools
- File path references are accurate

**Check for**:
- Broken references (skill mentioned but doesn't exist)
- Circular references (file A references B, B references A)
- Outdated references (renamed or moved files)
- Missing references (should point to skill but doesn't)
- Integration mismatches (instructions say one thing, config says another)

## Category Mapping

When user specifies a category:

- `plugin` → Category 0 (This Plugin Structure)
- `structure` → Category 1 (Directory Structure)
- `instructions` → Category 2 (CLAUDE.md & PROJECT.md)
- `skills` → Category 3 (Skills Analysis)
- `settings` → Category 4 (Settings Files)
- `redundancy` → Category 5 (Redundancy Analysis)
- `consistency` → Category 6 (Consistency Analysis)
- `all` → All categories (including plugin)

## Analysis Process

1. **Parse input**: Determine categories to check (default: all)
2. **Read Claude Code docs**: Review best practices for relevant areas
3. **Scan .claude directory**: Read all relevant files
4. **Cross-reference**: Check for redundancy and consistency
5. **Identify issues**: Document all violations and anti-patterns
6. **Prioritize**: Categorize as Critical, High, Medium, Low
7. **Provide recommendations**: Specific, actionable fixes

## Output Format

```markdown
# .claude Directory Meta-Analysis Report

## Summary
- Total issues found: X
- Critical: X | High: X | Medium: X | Low: X
- Overall health: X% (based on best practices compliance)

## Issues by Category

### 1. Directory Structure (X issues)
- [HIGH] Missing .gitignore for settings.local.json
- [MEDIUM] Unexpected file type: .claude/notes.txt

### 2. Instruction Files (X issues)
- [HIGH] CLAUDE.md contains vague instruction: "Write good code"
- [MEDIUM] PROJECT.md duplicates architecture section from CLAUDE.md:45-67

### 3. Skills (X issues)
- [CRITICAL] code-quality skill has overly broad scope - should be split
- [HIGH] logging skill description lacks trigger terms
- [MEDIUM] documentation skill duplicates content from CLAUDE.md

### 4. Settings (X issues)
- [CRITICAL] .env not protected - missing deny rule
- [HIGH] settings.local.json is committed to git (should be ignored)

### 5. Redundancy (X issues)
- [HIGH] Logging import instruction appears in 3 places
- [MEDIUM] Google docstring requirement duplicated across files

### 6. Consistency (X issues)
- [MEDIUM] Mixed naming: code-quality/ but test_helpers/
- [LOW] Inconsistent heading levels in skills

### 7. Scope & Hierarchy (X issues)
- [HIGH] CLAUDE.md contains specific import paths (belongs in skill)
- [MEDIUM] PROJECT.md has generic TDD guidelines (belongs in CLAUDE.md)

### 8. Best Practices (X issues)
- [HIGH] Skill lacks "When to Use" section
- [MEDIUM] Skill too complex - should be split

### 9. Integration (X issues)
- [HIGH] CLAUDE.md references 'formatting' skill but it doesn't exist
- [MEDIUM] Hook script path doesn't exist: scripts/pre-commit.sh

## Recommendations

### Immediate Actions (Critical/High Priority)

1. **Protect sensitive files**
   ```json
   // Add to settings.json
   "permissions": {
     "deny": ["Read(.env)", "Write(.env)", "Read(.env.*)", "Write(.env.*)"]
   }
   ```

2. **Fix settings.local.json leak**
   ```bash
   # Add to .gitignore
   echo ".claude/settings.local.json" >> .gitignore
   git rm --cached .claude/settings.local.json
   ```

3. **Split overly broad code-quality skill**
   - Extract to: naming-conventions/, docstrings/, type-hints/
   - Update CLAUDE.md references

4. **Remove redundant content**
   - Keep logging import instruction ONLY in logging skill
   - Reference skill from CLAUDE.md: "Use logging skill for patterns"

### Short-term Improvements (Medium Priority)

1. **Fix broken references**
   - CLAUDE.md:67 references 'formatting' skill → change to 'code-quality'
   - Update all cross-references after skill split

2. **Improve skill descriptions**
   - Add trigger terms to all skill descriptions
   - Add "When to Use" sections where missing

3. **Normalize naming**
   - Rename test_helpers/ → test-helpers/
   - Ensure all files use kebab-case

### Long-term Enhancements (Low Priority)

1. **Enhance skill documentation**
   - Add "Output Format" to skills where missing
   - Add "Examples" to all skills

2. **Improve consistency**
   - Standardize heading hierarchy across all skills
   - Use uniform bullet point style

## Compliance Checklist

- [ ] Directory structure follows Claude Code standards
- [ ] CLAUDE.md has specific, concrete instructions
- [ ] PROJECT.md has only project-specific conventions
- [ ] All skills are narrowly scoped (one capability each)
- [ ] Skill descriptions include trigger terms
- [ ] settings.json protects .env files
- [ ] settings.local.json is git-ignored
- [ ] No redundant content across files
- [ ] Consistent naming conventions throughout
- [ ] Information at correct hierarchy level
- [ ] All cross-references are valid
- [ ] No vague or abstract instructions
- [ ] Best practices from Claude Code docs followed

## Health Score Breakdown

- Structure: X% (Y/Z checks passed)
- Instructions: X%
- Skills: X%
- Settings: X%
- Redundancy: X% (lower is better)
- Consistency: X%
- Hierarchy: X%
- Best Practices: X%
- Integration: X%

**Overall Health: X%** (weighted average)
```

## Tools to Use

- **Read**: Examine all .claude files systematically
- **Glob**: Find files by pattern (.claude/**/*.md, etc.)
- **Grep**: Search for duplicate content, specific patterns
- **Bash**: Check git status, file permissions, json validation
- **WebFetch**: Reference Claude Code official documentation for verification

## Implementation Notes

1. **Be thorough**: Check every file in .claude directory
2. **Cross-reference**: Compare files against each other
3. **Use Claude Code docs**: Verify against official best practices
4. **Provide specifics**: Include file:line references for all issues
5. **Prioritize actionable**: Focus on issues that can be fixed
6. **Consider context**: Early-stage projects may not need everything
7. **Suggest concrete fixes**: Not just problems, but solutions

## Special Considerations

**New Projects**: May not have all files yet - distinguish missing vs wrong

**Legacy Projects**: May have pre-1.0 patterns - note but don't over-penalize

**Team Projects**: settings.json should be comprehensive for team consistency

**Personal Projects**: More flexibility in organization

---

**Note**: This is a meta-analysis tool - it checks the checker. Use `/compliance-check` to verify the actual codebase against the .claude guidelines.

## See Also

- **/compliance-check** - Audit project code compliance
- **/mcp-check** - Verify MCP server health
- **python** - Python conventions to verify in skills
- **documentation** - Documentation standards for skills

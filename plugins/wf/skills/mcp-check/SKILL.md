---
name: mcp-check
description: Verify MCP servers are configured and working correctly. Use when troubleshooting MCP issues, validating server setup, or diagnosing configuration problems.
command: true
subagent: true
---

# MCP Check Skill

Verify MCP servers are configured and working correctly. Check `.mcp.json` configuration and test basic functionality of configured MCP servers.

## When to Use This Skill

✅ **Use when:**
- Troubleshooting MCP server connectivity issues
- Setting up a new project with MCP servers
- Validating MCP configuration after changes
- Diagnosing server problems
- Verifying server health before running other commands

❌ **Don't use when:**
- Checking project code compliance (use /compliance-check instead)
- Analyzing .claude directory structure (use /meta-check instead)
- Working on tasks unrelated to MCP configuration

## Servers to Check

### 1. Configuration File

Verify `.mcp.json` exists and is properly structured:
- Check file exists at project root
- Verify JSON syntax is valid
- List all configured servers
- Check server URLs and parameters

### 2. Context7 Server

Test Context7 functionality (library documentation):
- Attempt to resolve a library ID (e.g., "pydantic")
- Verify response contains library information
- Check that documentation can be fetched
- Report any connection or configuration errors

Example test:
```
Try resolving "fastapi" library ID
Try fetching basic docs for a known library
```

### 3. Serena Server

Test Serena functionality (code intelligence):
- Check if Serena can list project directories
- Verify Serena can search for patterns
- Test symbol finding capabilities (if code exists)
- Report any connection or configuration errors

Example test:
```
Try listing the project root directory
Try searching for a common pattern like "def "
```

### 4. GitHub Server

Test GitHub MCP functionality (repository operations):
- Check if GitHub server is configured
- Verify authentication is working
- Test basic API access (list repos, get user info)
- Report any authentication or connection errors

Example test:
```
Try listing user repositories
Try fetching repository information
```

### 5. Playwright Server

Test Playwright MCP functionality (browser automation):
- Check if Playwright server is configured
- Verify browser can be launched
- Test basic navigation capability
- Report any configuration or dependency errors

Example test:
```
Try launching a browser instance
Try navigating to a simple URL
```

### 6. Common Issues

Check for common MCP configuration problems:
- Server paths are correct
- Required dependencies are installed
- Environment variables are set (if needed)
- Authentication tokens are valid
- Ports are not blocked
- Server processes can start

## Output Format

Provide a clear status report:

```
# MCP Server Health Check

## Configuration Status
- [✓] .mcp.json exists and is valid JSON
- [✓] X servers configured

## Server Status

### Context7
- Status: ✓ WORKING / ✗ FAILED / ⊘ NOT CONFIGURED
- Test: Resolved library 'pydantic' successfully
- Notes: [any issues or warnings]

### Serena
- Status: ✓ WORKING / ✗ FAILED / ⊘ NOT CONFIGURED
- Test: Listed project directory successfully
- Notes: [any issues or warnings]

### GitHub
- Status: ✓ WORKING / ✗ FAILED / ⊘ NOT CONFIGURED
- Test: Authenticated as 'username'
- Notes: [any issues or warnings]

### Playwright
- Status: ✓ WORKING / ✗ FAILED / ⊘ NOT CONFIGURED
- Test: Browser launched successfully
- Notes: [any issues or warnings]

## Overall Status
✓ All configured MCP servers are working correctly
OR
✗ Issues found - see details above

## Recommendations
[Any suggestions for fixing issues or improving configuration]
```

## Troubleshooting

If servers are not working:

1. **Check .mcp.json syntax**: Ensure valid JSON
2. **Verify server paths**: Confirm paths are correct
3. **Check dependencies**: Ensure MCP server packages are installed
4. **Review logs**: Look for error messages in Claude Code logs
5. **Check authentication**: Verify tokens and credentials
6. **Restart Claude Code**: Sometimes a restart resolves connection issues
7. **Check network**: Ensure no firewall blocks
8. **Consult docs**: See Claude Code MCP documentation

## Server-Specific Troubleshooting

### Context7
- Verify npm package is installed: `npx @anthropic/context7`
- Check network connectivity to documentation sources

### Serena
- Ensure Python environment is correctly configured
- Verify project path is accessible

### GitHub
- Check `GITHUB_TOKEN` environment variable
- Verify token has required scopes (repo, read:user)
- Test with: `gh auth status`

### Playwright
- Install browsers: `npx playwright install`
- Check system dependencies: `npx playwright install-deps`
- Verify no conflicting browser processes

## Notes

- This skill provides a quick health check
- It does not modify any configuration
- It only tests basic functionality
- Unconfigured servers are reported but not flagged as errors
- For detailed MCP setup, see `.mcp.json` and Claude Code docs

## See Also

- [Compliance Check](/compliance-check) - Check project code compliance
- [Meta Check](/meta-check) - Analyze .claude directory structure

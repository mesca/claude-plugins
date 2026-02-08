---
name: mcp-check
description: Verify MCP servers are configured and working correctly. Use when troubleshooting MCP issues, validating server setup, or diagnosing configuration problems.
context: fork
agent: general-purpose
---

# MCP Check

Verify that configured MCP servers are reachable and working correctly.

## Process

1. **Find configuration**: Read `.mcp.json` at project root (or the plugin's `.mcp.json`)
2. **Validate syntax**: Ensure valid JSON with proper structure
3. **Enumerate servers**: List all configured servers with their type (stdio, http, etc.)
4. **Test each server**: For each configured server, attempt a basic operation to verify connectivity
5. **Report results**: Summarize status of each server

## Testing Servers

For each server found in `.mcp.json`:

- **stdio servers** (command-based): Verify the command exists and is executable
- **HTTP/SSE servers**: Verify the URL is reachable
- **Servers with env vars**: Note any unset environment variables (e.g., `${GITHUB_TOKEN}`)

Attempt a simple, read-only operation with each server to confirm it responds.

## Common Issues

| Issue | Diagnosis |
|-------|-----------|
| Server not starting | Check command path, verify package is installed |
| Authentication failure | Check environment variables for tokens/keys |
| Connection refused | Check URL, port, and network connectivity |
| Missing dependencies | Run `npx` or `uvx` install for the server package |
| Timeout | Check network, firewall, or server process health |

## Troubleshooting Steps

1. **Check .mcp.json syntax**: Validate JSON
2. **Verify server paths**: Confirm commands exist
3. **Check dependencies**: Ensure server packages are installed
4. **Review environment**: Verify required env vars are set
5. **Check network**: Ensure no firewall blocks
6. **Restart Claude Code**: Sometimes resolves connection issues

## Output Format

```
# MCP Server Health Check

## Configuration
- .mcp.json: Found / Not Found
- Servers configured: N

## Server Status

### <server-name>
- Type: stdio / http / sse
- Status: WORKING / FAILED / UNCHECKED
- Test: <what was tested>
- Notes: <any issues>

(repeat for each server)

## Overall
All servers working / N issues found
```

## See Also

- **/compliance-check** — project code compliance
- **/meta-check** — .claude directory structure

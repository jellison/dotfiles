#!/bin/sh
# PreToolUse hook for Bash: deny commands that have built-in Claude Code tool
# equivalents and tell Claude which tool to use instead. Reduces permission
# prompts for find/grep/cat/head/tail/sed/awk by routing them to the proper
# tool (Glob, Grep, Read, Edit) at the harness level.

cmd=$(jq -r '.tool_input.command // ""')

# Extract the first word of the first command in the pipeline.
first=$(printf '%s' "$cmd" | sed -E 's/[|&;].*//' | awk '{print $1}')
# Strip path prefix so /usr/bin/grep also matches "grep".
first=$(basename "$first" 2>/dev/null)

emit_deny() {
  jq -n --arg msg "$1" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $msg
    }
  }'
  exit 0
}

case "$first" in
  find)
    emit_deny "Use the Glob tool to find files by pattern (e.g., src/**/*.ts) instead of bash 'find'. For complex queries combining file pattern + content, use Grep with the glob filter parameter."
    ;;
  grep|rg|egrep|fgrep|ripgrep)
    emit_deny "Use the Grep tool to search file contents instead of bash '$first'. Grep supports regex, glob filtering (path/type), multiline mode, and structured output."
    ;;
  cat)
    emit_deny "Use the Read tool to read files instead of bash 'cat'. Read returns numbered lines and supports offset/limit for partial reads."
    ;;
  head)
    emit_deny "Use the Read tool with the 'limit' parameter to read the first N lines instead of bash 'head'."
    ;;
  tail)
    emit_deny "Use the Read tool with 'offset' and 'limit' parameters instead of bash 'tail'."
    ;;
  sed)
    emit_deny "Use the Edit tool for in-place file modifications instead of bash 'sed'. Edit performs exact string replacement and supports replace_all."
    ;;
  awk)
    emit_deny "Use the Edit tool for file transformations, or Read the file and process content in your response, instead of bash 'awk'."
    ;;
esac

# No match — let the Bash command proceed normally.
exit 0

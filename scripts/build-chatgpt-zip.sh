#!/bin/bash
# Builds the archive uploaded to OpenAI's plugin portal
# (platform.openai.com/plugins): the portable manifest, the MCP server
# declaration, the skills and the icons — nothing else from this repository.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=dist/cinely-chatgpt-plugin.zip
mkdir -p dist && rm -f "$OUT"
for f in plugin.json mcp.json; do python3 -m json.tool "$f" > /dev/null; done
zip -q -r -X "$OUT" plugin.json mcp.json skills assets -x '*.DS_Store'
unzip -l "$OUT" | tail -n +4 | awk '{print $4}' | grep -v '^$' | sed '$d'
echo "$OUT  $(du -k "$OUT" | cut -f1) KB"

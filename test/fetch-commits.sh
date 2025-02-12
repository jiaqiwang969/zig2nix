#!/bin/bash

# 创建临时目录
tmpdir=$(mktemp -d)
cd "$tmpdir"

# 克隆仓库（如果只想要最近的提交，可以使用 --depth 参数）
git clone --depth 100 https://github.com/ziglang/zig.git
cd zig

# 开始创建 JSON
echo "{" > ../../date-commits.json

# 获取提交记录并格式化为 JSON
git log --since="2021-01-01" --until="2023-12-31" --date=short \
    --format=format:'  "%ad": {
    "commit": "%H",
    "description": "%s"
  },' | head -n -1 >> ../../date-commits.json

# 添加结束括号
echo "}" >> ../../date-commits.json

# 清理临时目录
cd ../..
rm -rf "$tmpdir"

# 验证 JSON 格式（如果有 jq 的话）
if command -v jq &> /dev/null; then
    jq '.' date-commits.json > date-commits-formatted.json && mv date-commits-formatted.json date-commits.json
fi

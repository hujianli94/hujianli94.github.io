#!/bin/bash

# auto_commit.sh - 自动提交并推送 Git 代码
set -e  # 遇到错误时立即退出

# 获取脚本所在目录并切换到该目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 获取当前时间戳
TIMESTAMP=$(date "+%Y-%m-%d-%H_%M_%S")

# 检查是否有未提交的更改
if git diff --quiet && git diff --staged --quiet; then
    echo "[INFO] 没有检测到更改，跳过提交。"
    exit 0
fi

# 暂存所有更改
echo "[INFO] 暂存所有未提交的更改到 stash..."
git stash push -m "Auto stash before pull"

# 拉取最新代码并合并更改
echo "[INFO] 拉取远程最新代码..."
if ! git pull --rebase origin main; then
    echo "[ERROR] 拉取失败，请手动解决冲突。"
    exit 1
fi

# 恢复暂存的更改
echo "[INFO] 恢复之前的更改..."
git stash pop || echo "[WARNING] 没有需要恢复的暂存更改。"

# 添加所有新文件和修改
echo "[INFO] 添加所有更改到暂存区..."
git add .

# 进行 Git 自动提交
echo "[INFO] 提交更改: auto commit at $TIMESTAMP"
git commit -m "auto commit at $TIMESTAMP"

# 推送到远程 main 分支
echo "[INFO] 推送到远程仓库..."
git push origin main

echo "[INFO] 操作完成！"

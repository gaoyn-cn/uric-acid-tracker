#!/bin/bash
# 尿酸管理助手 - 每日报告生成
# 生成报告内容，供 OpenClaw 发送

REPO="gaoyn-cn/uric-acid-tracker"
TODAY=$(date '+%Y-%m-%d')

# 获取网站状态
STATUS=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 -k "https://uric.ynotes.cc/" 2>/dev/null)
if [ "$STATUS" = "200" ]; then
    WEBSITE="✅ 正常"
else
    WEBSITE="❌ 异常 (HTTP $STATUS)"
fi

# 获取 GitHub 统计
STATS=$(curl -s "https://api.github.com/repos/$REPO" 2>/dev/null)
STARS=$(echo "$STATS" | grep -o '"stargazers_count": [0-9]*' | grep -o '[0-9]*' || echo "0")
FORKS=$(echo "$STATS" | grep -o '"forks_count": [0-9]*' | grep -o '[0-9]*' || echo "0")

# 输出报告
cat << EOF
📊 尿酸管理助手 - 每日报告
📅 $TODAY

🌐 网站状态: $WEBSITE

📈 GitHub:
⭐ Stars: $STARS
🍴 Forks: $FORKS

🔗 https://uric.ynotes.cc
EOF
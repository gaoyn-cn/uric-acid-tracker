#!/bin/bash
# 尿酸管理助手 - 每日访问统计报告
# 每天 9:00 发送飞书报告

REPO="gaoyn-cn/uric-acid-tracker"
WEBHOOK_URL="" # 需要配置飞书机器人webhook

# 获取 GitHub 仓库统计
get_github_stats() {
    local stats=$(curl -s "https://api.github.com/repos/$REPO")
    local stars=$(echo "$stats" | grep -o '"stargazers_count": [0-9]*' | grep -o '[0-9]*')
    local forks=$(echo "$stats" | grep -o '"forks_count": [0-9]*' | grep -o '[0-9]*')
    local watchers=$(echo "$stats" | grep -o '"watchers_count": [0-9]*' | grep -o '[0-9]*')
    
    # 获取今日访问量（从克隆统计）
    local traffic=$(curl -s "https://api.github.com/repos/$REPO/traffic/clones" 2>/dev/null)
    
    echo "⭐ Stars: $stars"
    echo "🍴 Forks: $forks"
    echo "👀 Watchers: $watchers"
}

# 获取网站可用性
check_website() {
    local status=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 -k "https://uric.ynotes.cc/" 2>/dev/null)
    if [ "$status" = "200" ]; then
        echo "✅ 网站状态: 正常 (HTTP $status)"
    else
        echo "❌ 网站状态: 异常 (HTTP $status)"
    fi
}

# 生成报告
generate_report() {
    local today=$(date '+%Y-%m-%d')
    local yesterday=$(date -d "yesterday" '+%Y-%m-%d')
    
    echo "━━━━━━━━━━━━━━━━━━"
    echo "📊 尿酸管理助手 - 每日报告"
    echo "📅 日期: $today 09:00"
    echo "━━━━━━━━━━━━━━━━━━"
    echo ""
    check_website
    echo ""
    echo "📈 GitHub 统计:"
    get_github_stats
    echo ""
    echo "🌐 访问地址: https://uric.ynotes.cc"
    echo "📦 仓库地址: https://github.com/$REPO"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━"
}

# 执行报告
generate_report

# 如果配置了飞书webhook，发送通知
if [ -n "$WEBHOOK_URL" ]; then
    report_content=$(generate_report)
    curl -X POST "$WEBHOOK_URL" \
        -H "Content-Type: application/json" \
        -d "{\"msg_type\":\"text\",\"content\":{\"text\":\"$report_content\"}}"
fi
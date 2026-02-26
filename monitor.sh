#!/bin/bash
# 尿酸管理助手 - 可用性监控脚本
# 每5分钟检查一次，失败时发送飞书告警

URL="https://uric.ynotes.cc"
WEBHOOK="https://open.feishu.cn/open-apis/bot/v2/hook/YOUR_WEBHOOK_URL" # 需要替换

check_health() {
    response=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 10 -k "$URL")
    
    if [ "$response" != "200" ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ 健康检查失败: HTTP $response"
        send_alert "⚠️ 尿酸管理助手告警\n\nURL: $URL\n状态: HTTP $response\n时间: $(date '+%Y-%m-%d %H:%M:%S')"
        return 1
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ 健康检查正常"
        return 0
    fi
}

send_alert() {
    # 发送飞书告警（需要配置webhook）
    echo "告警: $1"
}

# 运行检查
check_health
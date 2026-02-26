#!/bin/bash
# OpenClaw cron 触发脚本
# 每天 9:00 触发 CEO agent 发送飞书报告

# 这个文件会被 OpenClaw 的 cron 系统调用
# 或者通过 openclaw system event 触发

REPORT=$(cat /tmp/uric-daily-report.txt 2>/dev/null || echo "报告生成中...")

# 通过 OpenClaw CLI 发送消息到飞书群
# 格式: openclaw message send --channel feishu --target <chat_id> --message <message>
openclaw message send \
  --channel feishu \
  --account ceo \
  --target "oc_63d8f25b137c8defeb9f6210d9a88193" \
  --message "$REPORT" 2>/dev/null || echo "OpenClaw CLI not available, using fallback"

# 备用方案：记录日志
echo "[$(date)] Daily report sent: $REPORT" >> /var/log/uric-daily.log
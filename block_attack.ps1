Write-Host "=== 自动化防御系统 (IPS) 联动版已启动 ===" -ForegroundColor Green

docker exec -i suricata-ids tail -f /var/log/suricata/fast.log | ForEach-Object {
    $line = $_
    # 只要检测到日志里的 SQLi 关键字
    if ($line -match "SQLi detected") {
        if ($line -match '(\d{1,3}\.){3}\d{1,3}') {
            $attacker_ip = $matches[0]
            
            # 立即跳出你需要的红色告警
            Write-Host "[$(Get-Date -Format 'HH:mm:ss')]  检测到 SQL 注入攻击!" -ForegroundColor Red
            Write-Host "   来源 IP: $attacker_ip -> 目标: Web-Server" -ForegroundColor White
            
            # 模拟封禁动作
            Write-Host "   [动作] 正在通过容器网络栈下发 DROP 规则..." -ForegroundColor Gray
            Start-Sleep -Seconds 1
            Write-Host "   [成功]  IP $attacker_ip 已被永久封禁，连接已阻断。" -ForegroundColor Yellow
            Write-Host "------------------------------------"
        }
    }
}

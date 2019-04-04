# Basic Ping-Sweep
1..100 | ForEach-Object {
    Write-Output "192.168.86.$_"; ping -n 1 -w 100 192.168.86.$_
} | Select-String ttl
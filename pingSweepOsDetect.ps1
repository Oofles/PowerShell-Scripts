# Multi-subnet Ping Sweeper with basic OS detection
0..10 | 
ForEach-Object { $a = $_; 1..255 | 
    ForEach-Object { 
        $b = $_; ping -n 1 -w 10 "10.0.$a.$b" | 
        select-string TTL | 
        ForEach-Object { 
            if ($_ -match "ms") { 
                $ttl = $_.line.split('=')[2] -as [int]; if ($ttl -lt 65) { 
                    $os = "Linux" 
                } 
            ElseIf ($ttl -gt 64 -And $ttl -lt 129) { 
                $os = "Windows" } 
            else { 
                $os = "Cisco"}; 
            write-host "10.0.$a.$b OS: $os"; echo "10.0.$a.$b" >> scan_results.txt 
            }
        }
    } 
}
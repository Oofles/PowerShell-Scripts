$first_three = read-host "Enter the  first 3 octets of the target network, including the final '.' "
$Starting_IP = read-host "Enter starting ip (last octet)"
$Ending_IP= read-host "Enter ending ip (last octet)"
$iprange = $Starting_IP..$Ending_IP

Foreach($ip in $iprange){
    
    $I = $first_three+[string]$ip
    
    Start-Job -Name "Scanning $I" -ArgumentList $I -ScriptBlock{

        Try{
            $name = [System.Net.Dns]::GetHostByAddress($args[0]) | 
            Select-object HostName -ErrorAction Continue
        }
        Catch{
            Write-Host "Input null or non-resolved"
        }

        Try{
            $RDP_response = Test-NetConnection -ComputerName $args[0] `
            -CommonTCPPort RDP -InformationLevel Quiet -ErrorAction Continue
        }
        Catch{
           Write-Host "RDP Connection Failed" 
        }

        Try{
            $WINRM_response = Test-NetConnection -ComputerName $args[0] `
            -CommonTCPPort WINRM -InformationLevel Quiet -ErrorAction Continue
        }
        Catch{
           Write-Host "WINRM Connection Failed" 
        }

        Try{
            $HTTP_response = Test-NetConnection -ComputerName $args[0] `
            -CommonTCPPort HTTP -InformationLevel Quiet -ErrorAction Continue
        }
        Catch{
           Write-Host "HTTP Connection Failed" 
        }

        Try{
            $SMB_response = Test-NetConnection -ComputerName $args[0] `
            -CommonTCPPort SMB -InformationLevel Quiet -ErrorAction Continue
        }
        Catch{
           Write-Host "SMB Connection Failed" 
        }

        $properties = @{
            IP4_address = $args[0]
            Computer_Name = $name.HostName
            SMB_Status = $SMB_response
            HTTP_Status = $HTTP_response
            WINRM_Status = $WINRM_response
            RDP_Status = $RDP_response
        }

        New-Object -TypeName psobject -Property $properties

    }

    $memuse = Get-Counter -counter "\memory\% committed bytes in use"
    $percmem = $memuse.CounterSamples.cookedvalue
    Write-Host "Current mem usage is $percmem percent."
    While($percmem -gt 70){
        Write-Host "Mem is too high...throttling for your pleasure."; start-sleep 1
        $memuse = Get-Counter -counter "\memory\% committed bytes in use"
        $percmem = $memuse.CounterSamples.cookedvalue
        Write-Host "Current mem usage is $percmem percent."
    }
}

$report = Get-Job | Receive-Job -Wait -AutoRemoveJob


$date = Get-Date -Format yy_MM_dd_HHmmss

$current_dir = Get-Location


$report | Export-Clixml -path $current_dir\$date.xml

$report | ConvertTo-Html | Out-File $current_dir\$date.html

$report | ConvertTo-Json | Out-File $current_dir\$date.json

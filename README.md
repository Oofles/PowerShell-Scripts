# PowerShell-Scripts

Just a collection of PowerShell scripts that I wrote or borrowed for various purposes. 

## join_domain.ps1

Changes the computer name to be "Windows-[Last 6 of MAC]" and then joins to a domain using Admin credentials

You will need to manually change the domain name and domain admin username.

## port-sweep.ps1

This script accomplishes a few things:
- Prompts user for the IP Range
- Attempts a connection on DNS, RDP, WinRM, HTTP, and SMB
- Stores all the results into a PowerShell object with properties
- Multi-threaded based on the host's memory and won't exceed 70%
- Outputs to a XML, HTML, and JSON

--- 

## Ping Sweeps
Credit to https://pen-testing.sans.org/blog/2017/03/06/pen-test-poster-white-board-powershell-ping-sweeper/

### pingSweep.ps1

The most basic form of a PowerShell ping-sweep on a /24 network.

### parallelPingSweep.ps1

Using workflows, this takes a ping-sweep a bit further and launches multiple ping-sweeps in parallel (Multi-threaded PowerShell O.o )

---

## Under Construction

pingSweepOsDetect.ps1 - The if/else is broken I think - I'll come back to this later... probably, lol

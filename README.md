# PowerShell-Scripts

Just a collection of PowerShell scripts that I wrote or borrowed for various purposes. 

## join_domain.ps1

Changes the computer name to be "Windows-[Last 6 of MAC]" and then joins to a domain using Admin credentials

You will need to manually change the domain name and domain admin username.

## pingSweep.ps1

The most basic form of a PowerShell ping-sweep on a /24 network.

## parallelPingSweep.ps1

Using workflows, this takes a ping-sweep a bit further and launches multiple ping-sweeps in parallel (Multi-threaded PowerShell O.o )

# Multi-threaded Ping Sweep
workflow ParallelSweep { 
    foreach -parallel -throttlelimit 4 ($i in 1..255) {
        ping -n 1 -w 100 192.168.86.$i
    }
}; 

ParallelSweep | Select-String ttl
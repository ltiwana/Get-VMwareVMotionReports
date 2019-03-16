# Get-VMware-VMotion-Reports

Ever wonder how much time it takes to vMotion your VMs from datastore to datastore or host to host?

Usually, host to host vMotions are fairly quick if done in the same network but storage vMotions do take time.

This why I had to create this script: During our DR exercise, we move VMs from our temp hardware to our DR hardware. Every year we were trying different ideas to improve the performance but we didn't know if our improvements were working.

When you vMotion a VM, the start time and end time are written to that VM's events. I was able to create a PowerShell script to scrape this information and calculate how long it took for a VM to move from host to host or datastore to datastore.



## Running the script is simple enough:
All you need is PowerCLI and access to your vCenter environment.

Just open up PowerCLI on your computer and connect to vCenter and then run the script. The script queries each VM and scraps all the events.

In the end, the script will present your all the vMotions that were done in your environment.

<b>*Note</b>: TimeSpan is in minutes.

### Requirements:
PowerCLI and Access to vCenter and VM events.

*Note: I have tested this on VMware 5.5 version. 

### How to run:
Just open up PowerCLI and connect to vCenter using `Connect-VIServer vCenterServerName` and then run the script:

![Script Run](/Media/Images/Run.png)

### Results:

![Script Run](/Media/Images/Report.png)

*Note: TimeSpan is in minutes.

Your can read more about this [here.](https://www.linkedin.com/pulse/get-vmware-vmotion-performance-report-loveparteek-tiwana/)

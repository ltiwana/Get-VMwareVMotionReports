#. "C:\Program Files (x86)\VMware\Infrastructure\vSphere PowerCLI\Scripts\Initialize-PowerCLIEnvironment.ps1" $true
$VMotions = @()
$FromStorage = $null
$FromESX = $null
$ToStorage = $null
$ToESX = $null
$StartTime = $null
$FinishTime = $null

get-vm | foreach { 
    $VM = $_.name 
    "Querying $VM" 
    
    Get-VIEvent -Entity $vm  -MaxSamples 10000 | sort CreatedTime | ?{$_.ds -ne $null} |foreach { 
        
        $MSG = ($_.FullFormattedMessage | Out-String).Trim()
        
        if (!($MSG | Select-String -Pattern "DRS migrated")) {

            if (!($MSG | Select-String -Pattern "Completed the relocation of the virtual machine")) {

                $FromStorage = $MSG | foreach { ((($_  -split ",")[1]) -split "to")[0].trim() }
                $FromESX = $MSG | foreach { ((($_  -split ",")[0]) -split "from")[1].trim() }
                $ToStorage = $MSG | foreach { ((($_  -split ",")[2]) -split "in")[0].trim() }
                $ToESX = $MSG |  foreach { ((($_  -split ",")[1]) -split "to")[1].trim() }
                $StartTime = $_.CreatedTime
                
            }
            elseif ($MSG | Select-String -Pattern "Completed the relocation of the virtual machine") {
        
                $FinishTime = $_.CreatedTime
                $TimeSpan = (NEW-TIMESPAN –Start $StartTime –End $FinishTime).TotalMinutes
            
            }

            if ($FromStorage -and $FromESX -and $ToStorage -and $ToESX -and $StartTime -and $FinishTime) {

                $VMotions += New-Object PSObject -Property @{VMName=$VM ; StartTime=$StartTime ; FinishTime=$FinishTime ; FromStorage=$FromStorage ; ToStorage = $ToStorage ; FromESX = $FromESX ; ToESX=$ToESX ; TimeSpan=$TimeSpan ; VMMessage=$MSG}
                $FromStorage = $null
                $FromESX = $null
                $ToStorage = $null
                $ToESX = $null
                $StartTime = $null
                $FinishTime = $null

            }
        
        }

    }

}

$VMotions
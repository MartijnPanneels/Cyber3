param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("start", "stop")]
    [string]$Action,

    [string]$VMName
)

$VMs = @(
    "companyrouter",
    "dns",
    "web",
    "database",
    "employee",
    "isprouter",
    "homerouter",
    "remote-employee"
)

function Start-VM {
    param([string]$vm)
    Write-Host "Starting $vm..."
    VBoxManage startvm "$vm" --type headless
}

function Stop-VM {
    param([string]$vm)
    Write-Host "Stopping $vm..."
    VBoxManage controlvm "$vm" poweroff
}

if ($VMName) {
    if ($VMs -contains $VMName) {
        if ($Action -eq "start") { Start-VM $VMName }
        elseif ($Action -eq "stop") { Stop-VM $VMName }
    } else {
        Write-Host "Error: VM '$VMName' not found in list."
    }
} else {
    foreach ($vm in $VMs) {
        if ($Action -eq "start") { Start-VM $vm }
        elseif ($Action -eq "stop") { Stop-VM $vm }
    }
}

# .\vm-control.ps1 -Action start (-VMName _name_)
# .\vm-control.ps1 -Action stop (-VMName _name_)
param (
    [Parameter(Mandatory = $true)]
    [ValidateSet("start", "stop")]
    [string]$Action,

    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$VMNames
)

$VMs = @(
    "companyrouter",
    "dns",
    "web",
    "database",
    "employee",
    "isprouter",
    "homerouter",
    "remote-employee",
    "red"
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

if ($VMNames.Count -gt 0) {
    foreach ($vm in $VMNames) {
        if ($VMs -contains $vm) {
            if ($Action -eq "start") { Start-VM $vm }
            elseif ($Action -eq "stop") { Stop-VM $vm }
        } else {
            Write-Host "Error: VM '$vm' not found in list."
        }
    }
} else {
    foreach ($vm in $VMs) {
        if ($Action -eq "start") { Start-VM $vm }
        elseif ($Action -eq "stop") { Stop-VM $vm }
    }
}

# .\vm-control.ps1 -Action start vmname
# .\vm-control.ps1 -Action stop vmname

# .\vm-control.ps1 -Action start isprouter companyrouter dns employee red web homerouter remote-employee database
# .\vm-control.ps1 -Action stop isprouter companyrouter dns employee red web homerouter remote-employee database
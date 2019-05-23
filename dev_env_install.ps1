# NOTE: please ensure the ExecutionPolicy is RemoteAssigned before running this script in your PowerShell.
# You could do it by typing the following command in a PowerShell terminal with administration right:
#  Set-ExecutionPolicy RemoteAssigned

If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    exit
}

. ($PSScriptRoot + "\utils\utils.ps1")
. ($PSScriptRoot + "\config.ps1")

foreach ($key in $InstallList.keys) {
    Write-host ($key + ": " + $InstallList.$key)
    if (($key -eq "choco") -or ($key -eq "pscx") -or ($key -eq "powershell") -or ($key -eq "swig") -or ($key -eq "cmake")) {
        if (-not $InstallList.$key) {
            Write-Host ($key + " is mandatory. Start installing " + $key + "...")
        } else {
            Write-Host ("Start installing " + $key + "...")
        }
        $script_name = $PSScriptRoot + "\individual_install\" + $key + ".ps1"
        . $script_name
    } elseif ($InstallList.$key) {
        $script_name = $PSScriptRoot + "\individual_install\" + $key + ".ps1"
        . $script_name
    }
}
Print-Success "Successfully installed required software."

if ($Configure_Shell -eq $True) {
    Write-Host ("Starts configuring the PowerShell scripts and ConEmu.")
    $script_name = $PSScriptRoot + "\lab_shell_config\config_ps_scripts.ps1"
    $script_name = $PSScriptRoot + "\lab_shell_config\config_conemu.ps1"
} else {
    Print-Success ("Skip configuring the PowerShell scripts and ConEmu.")
}



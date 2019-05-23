. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

# upgrade PowerShell to the latest version to install the Window Management Framework
"Current PowerShell version: " + $PSVersionTable.PSVersion
if ($PSVersionTable.PSVersion.Major -gt 4) {
    "Already newer than version 5.0. Skip updating."
} else {
    choco update PowerShell -y
    if ($?) {
        Print-Success "Successfully updating PowerShell."
        "Please reboot your PC and rerun this script to continue..."
        # Read-Host "Press Enter to reboot your PC..." | Out-Null
        # Restart-Computer
    } else {
        Write-Error "Failed to update PowerShell. Aborts."
        exit
    }
}

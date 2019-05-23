. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install PSReadline
#  - Prerequisite: PowerShellGet, which is enabled since PowerShell 5.0
#########################################################################################
if ((Get-Module | sls "PSReadline").count -gt 0)  {
    Write-Host "PSReadline has already been installed. Skip installing PSReadline."
} else {
    Write-Host "PSReadline has not been installed yet. Installing PSReadline..."
    PowerShellGet\Install-Module PSReadline

    if ($?) {
        Print-Success  "PSReadline has been installed successfully."
    } else {
        Write-Host "Error happens while installing PSReadline. Installation Continues." -ForegroundColor Red
    }
}

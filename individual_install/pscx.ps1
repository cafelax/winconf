. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install Pscx from the Windows PowerShell store
#########################################################################################
if ((Get-Module | sls "pscx").count -gt 0)  {
        Write-Host "Pscx (PowerShell Community Extension) has already been installed. Skip installing Pscx."
} else {
    Write-Host "Pscx (PowerShell Community Extension) has not been installed yet. Installing PSReadline..."

    Push-Location $env:temp
    Save-Module -Name Pscx -Path $env:temp -RequiredVersion 3.2.2

    Install-Module -Name Pscx -RequiredVersion 3.2.2 -AllowClobber

    if ($?) {
        Print-Success "Pscx has been installed successfully."
    } else {
        Write-Error "Error happens while installing Pscx. Installation aborts."
        exit
    }

    Pop-Location
}

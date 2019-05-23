. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install ConEmu
#########################################################################################
if ((Get-InstalledSoftware | sls -Pattern "ConEmu").Count -gt 0) {
    Write-Green "ConEmu has been installed. Skip installing ConEmu."
} else {
    choco install conemu -y

    if ($?) {
        Print-Success "Successfully installed EonEmu."
    } else {
        Write-Error "An error happened while installing EonEmu."
    }
}

. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install GitHub
#########################################################################################
if ((Get-InstalledSoftware | sls -Pattern "github").Count -gt 0) {
    Write-Host "GitHub has been installed. Skip installing GitHub Desktop." -ForegroundColor Yellow
} else {
    # NOTE: The best way to install Github is still from its website.
    (new-object Net.WebClient).DownloadString("https://central.github.com/deployments/desktop/desktop/latest/win32") | iex

    if ($?) {
        Print-Success "Successfully downloaded and installed GitHub."
    } else {
        Write-Error "An error happened while downloading and installing GitHub."
    }
}

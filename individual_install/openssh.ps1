. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# to enable ssh and scp in the terminal
#########################################################################################
if ((clist -l | sls -Pattern "OpenSSH").Count -gt 0) {
    Write-Host "OpenSSH has been installed. Skip installing OpenSSH." -ForegroundColor Yellow
} else {
    choco install OpenSSH -y
    if ($?) {
        Print-Success "Successfully installed OpenSSH. Now enabled to use ssh/scp command in PowerShell."
    } else {
        Write-Warning "Unexpected error happened while installing OpenSSH. Continue the following steps..."
    }
}


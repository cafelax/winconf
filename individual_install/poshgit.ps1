. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install Poshgit to enable git information highlighting at the prompt of PowerShell
#########################################################################################
if ((clist -l | sls -Pattern "poshgit").Count -gt 0) {
    Write-Host "Poshgit has been installed. Skip installing Poshgit." -ForegroundColor Yellow
} else {
    choco install poshgit -y
    if ($?) {
        $gitpath = "C:\\Program Files\\Git\\bin"
        if (($env:path.split(';') | sls -pattern $gitpath).count -eq 0) {
            [Environment]::SetEnvironmentVariable("path", [Environment]::GetEnvironmentVariable("path", "user") + ";" + $gitpath, "user")
            Write-Host "The path to poshgit binaries has been installed." -ForegroundColor Green
        }
        Print-Success "Successfully installed poshgit."
    } else {
        Write-Warning "Error happened while installing poshgit."
    }
}

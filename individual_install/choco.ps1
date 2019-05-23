. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
### Chocolatey installation
#########################################################################################
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    # Install Chocolatey
    "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString(
        'https://Chocolatey.org/install.ps1'))
    if ($?) {
        Print-Success "Chocolatey has been installed successfully."
    } else {
        Write-Error "An unexpected error happened while installing Chocolatey. Aborts."
        exit
    }
} else {
    Write-Green "Chocolatey has been installed. Skip installing Chocolatey."
}

refreshenv

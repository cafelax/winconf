. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install Swig
#########################################################################################
if (-not (Get-Command swig -ErrorAction SilentlyContinue)) {
    "swig has not been installed yet. Installing swig..."
    choco install swig -y
    if (-not $?) {
        "Failed to install swig. Aborts."
        exit
    } else {
        "Adding swig into the system path..."
        $SwigPath = Join-Path $env:ChocolateyInstall '\lib\swig\tools\swigwin-3.0.9'
        add-EntryToUserPath $SwigPath
        Write-Host "The path to swig binaries has been added to the environment path." -ForegroundColor Green
        Print-Success "Successfully installed Swig"
    }
} else {
    "Swig has been installed. Skip installing swig."
}

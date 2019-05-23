. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
### cmake installation
#########################################################################################
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
    "cmake has not been installed yet. Installing cmake..."
    choco upgrade cmake --version=3.11.0 -y
    if (-not $?) {
        "Failed to install cmake. Aborts."
        exit
    } else {
        "Adding cmake into the system path..."
        $cmakePath = "C:\Program Files\CMake\bin"
        add-EntryToUserPath $cmakePath
        Print-Success "Cmake has been installed successfully."
    }
    refreshenv

} else {
    Write-Green "cmake has been installed. Skip installing cmake."
}

. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
# Install WinFlexBison_v2.5 used to compile CC-Light assembler
#########################################################################################

function remove-OldBison() {
    Write-Host "Please remove its path from the environment path using the following command: "
    Write-Host "   remove-EntryInEnvPath (Split-Path -Path (Get-Command bison.exe).Source)" -ForegroundColor cyan
    Write-Host "or remove the binary mannually using the command: "
    Write-Host "   rm ((Get-Command bison.exe).Source)" -ForegroundColor cyan
    Write-Host "Then rerun the script dev_env_install.ps1 using the command: "
    Write-Host "   . .\dev_env_install.ps1" -ForegroundColor cyan
    exit
}

function install-Bison3Choco() {
    choco install winflexbison3 -y

    if ($?) {
        Print-Success "Successfully installed WinFlexBison_v2.5."
    } else {
        Write-Error "Failed to install WinFlexBison_v2.5. Aborts."
        exit
    }

    $BisonPath = Join-Path $env:ChocolateyInstall '\lib\winflexbison3\tools'
    add-EntryToUserPath $BisonPath

    Write-Host "The path to WinFlexBison_v2.5 binaries has been added to the environment path." -ForegroundColor Green
    Print-Success "Successfully installed WinFlexBison_v2.5."
}

$ret = Get-Command bison.exe -ErrorAction SilentlyContinue
if ($ret -ne $null) {
    Write-Host "bison.exe found on this PC, but win_bison is required."
    remove-OldBison
}

$ret = Get-Command win_bison.exe -ErrorAction SilentlyContinue
if ($ret -ne $null){
    Write-Host "Found bison installed, check its version..."

    $flex_ver_info = win_flex.exe -V; $bison_ver_info = win_bison -V

    if (-not $?) {
        Write-Error "Error happens while getting the version number of flex and bison."
    }

    function extract-Version([string]$ver_info) {
        $ma = sls -InputObject $ver_info -Pattern "\d\.\d\.\d"
        return $ma.Matches[0].Value
    }

    $flex_ver  = extract-Version $flex_ver_info
    $bison_ver = extract-Version $bison_ver_info

    if ($bison_ver[0] -eq '3') {
        Write-Host ("Current Bison version:" + $bison_ver + "Requirement satisfied. Skip installing it.") -ForegroundColor Yellow
    } else {
        Write-Host ("Current Bison version:" + $bison_ver + ", but bison 3.0.x is required.") -ForegroundColor Yellow
        Write-Host "Uninstall the old version..." -ForegroundColor Yellow
        if ((clist -l | sls -Pattern "winflexbison" -SimpleMatch).Count -gt 0) {
            Write-Host "Found old version bison installed via Chocolatey. Uninstall it using Chocolatey..."

            choco uninstall winflexbison - y
            if ($?) {
                Write-Host "Successfully uninstalled old version bison. Now install WinFlexBison_v2.5." -ForegroundColor Green
                install-Bison3Choco
            } else {
                Write-Error "Failed to uninstall old version bison using Chocolatey. Aborts."
                exit
            }
        } else {
            Write-Host "Found old version bison installed independently. "
            remove-OldBison
            install-Bison3Choco
        }
    }
} else {
    Write-Host "Bison has not been installed. Start installing it." -ForegroundColor Green
    install-Bison3Choco
}

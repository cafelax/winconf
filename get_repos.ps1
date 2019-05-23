. ($PSScriptRoot + "\config.ps1")
. ($PSScriptRoot + "\utils\utils.ps1")



Push-Location $GitHubRepo

$PycQED_dir = $GitHubRepo + "\PycQED_py3"

git clone https://github.com/DiCarloLab-Delft/PycQED_py3.git
if (-not $?) {
    Write-Error "Error happened during cloning the PycQED repository. Installation aborts."
    exit
}

cd $PycQED_dir



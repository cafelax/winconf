# if the profile is not enabled due to the security policy, use the following commands to enable it.
# Set-ExecutionPolicy RemoteSigned
"Loading script " + $MyInvocation.MyCommand.Name + "."

# The following command will show all the verbose information
# $VerbosePreference="Continue"

# Usee UTF8 to solve encoding problem in non-English system
$OutputEncoding = New-Object -typename System.Text.UTF8Encoding

# load the configuration script
.($PSScriptRoot + "\local_config.ps1")

########################## Subdirectory path. ##########################
$SublimeAppdata = $env:APPDATA +"\Sublime Text 3\Packages\User"

## GitHub related
## PycQED
$PycQED = $GitHubRepos + "\PycQED_py3"
########################## End of Subdirectory Path ##########################


########################## Convenient cd commands ##########################

# GitHub related cd commands
function cdGithub {cd $GitHubRepos}
function cdPycQED {cd $PycQED}


########################## End of Convenient cd commands ##########################
# If I remember correctly, this line is to solve a problem when using Cython
$Env:VS90COMNTOOLS= $Env:VS140COMNTOOLS

# to launch Jupyter in Chrome
$env:BROWSER = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

# NOTE: after the Pscx has been installed, it is required to restart the entire ConEmu.
# Otherwise, the module Pscx cannot be found in PowerShell terminal.
Import-Module Pscx

# enable Virtual Studio compiler in the PowerShell
Invoke-BatchFile $VS_bat_path amd64


# load functions to test memory and show memory status.
.($PSScriptRoot + "\memory_utils.ps1")

### customize the ls command ###
$my_ls_script_path = $PSScriptRoot + "\PS_Modules\get-ChildItemColored\gcic-profile.ps1"
. $my_ls_script_path

$setScreenResolution = $PSScriptRoot + "\PS_Modules\set-ScreenResolution.ps1"
# Load more modules into the environment
# Enable setScreenResolution
Import-Module $setScreenResolution

# load various alias and functions
.($PSScriptRoot + "\my_alias.ps1")

# Set the default location for the shell
Set-Location $ps_default_dir
`
######################### Git prompt support #########################
# make the directory path into green, and start the input command in a new line.
function prompt {
    $origLastExitCode = $LASTEXITCODE

    $curPath = $ExecutionContext.SessionState.Path.CurrentLocation.Path

    $curPath = $curPath + " "

    Write-Host $curPath -ForegroundColor Green -NoNewline
    Write-VcsStatus
    $LASTEXITCODE = $origLastExitCode

    "`n$('>' * ($nestedPromptLevel + 1)) "
}
######################### End of Git prompt support #########################


# Welcome message
"Initialization finished."

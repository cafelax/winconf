"Loading script " + $MyInvocation.MyCommand.Name + "."

################################ alias #################################
if ((Test-Path alias:which) -eq $False) {New-Alias which get-command}
if ((Test-Path alias:cat) -eq $False) {New-Alias cat Get-Content}
if ((Test-Path alias:grep) -eq $False) {New-Alias grep Select-String}
if ((Test-Path alias:make) -eq $False) {New-Alias make nmake}
if ((Test-Path alias:ll) -eq $False) {New-Alias ll Get-ChildItem}

# remove the touch alias defined in the Pscx. Using the original one.
if ((Test-Path alias:touch) -eq $True) {Remove-Item alias:touch}

# editors
if ((Test-Path alias:s) -eq $False) {Set-Alias s  $subl_path}
if ((Test-Path alias:sublime) -eq $False) {Set-Alias sublime $subl_path}

############################## Functions ##############################

function getCommandPath($command) {
    Get-Command $command | Select-Object -ExpandProperty Definition
}

function jn {
    jupyter notebook
}

# The variable currentfolder contents the path of current directory.
function GetCurrentFolder
{
    $currentfolder=(Get-Item -Path ".\" -Verbose).FullName;
    echo $currentfolder
}

# Open the current directory in the file explorer.
function cf {
    Write-Host -NoNewline "opening: ";
    GetCurrentFolder;
    explorer (Get-Item -Path ".\" -Verbose).FullName
}


################## PowerShell related functions ##################
function getPSVersion() {
    $PSVersionTable.PSVersion
}
# PowerShell configuration
function getallpro {$profile | get-member -MemberType noteproperty}
# function pro { s $profile.CurrentUserAllHosts }
function pro {s $config_script_git_dir}

################## End of PowerShell related functions ##################


################## Directory and file operations ##################
function rmall {
    rm * -Recurse -Force
}
function rmrf($dirname) {
    rm -Recurse -Force $dirname
}

function newFile($filename) {
    New-Item -ItemType file $filename
}

function grepInDir($stringName, $include, $exclude)
{
     Get-ChildItem -Recurse -include $include -exclude $exclude | grep -pattern $stringName
}
################## End of Directory and file operations ##################

function getCOMPort {
    [System.IO.Ports.SerialPort]::getportnames()
}

################## Environment Variable related functions ##################
function printEnv {
    Get-ChildItem Env:
}

# add an environment variable
# accepted type: "user", "process", "machine"
function addEnvVar($name, $value, $type)
{
    $name_string = $name | Out-String
    $value_string = $value | Out-String
    $type_string = $type | Out-String
    $s_user = "user"
    if ($type_string.ToLower().CompareTo($s_user) -eq 0)
    {
        echo "match!"
        # $var_type = Environment
        [Environment]::SetEnvironmentVariable($name_string, $value_string, "user")
    }
}

function lsvariable
{
    ls variable:
}

function getComputerName() {
    $env:computername
}

################## End of Environment Variable related functions ##################


function udppip {
    python -m pip install --upgrade pip
}

function cmake.. {
    cmake -G "NMake Makefiles" ..
}

function Reload-Profile {
    & $profile.CurrentUserAllHosts
}

function getColors
{
    [enum]::GetValues([System.ConsoleColor]) | Foreach-Object {Write-Host $_ -ForegroundColor $_}
}

# Convenient functions for Git
function gitConflictFiles
{
    git diff --name-only --diff-filter=U
}

function gs {git status}


function ScreenResolution($w, $h){
    Set-ScreenResolution -Width $w -Height $h
}

function recoverScreen
{
    Set-ScreenResolution -Width 1920 -Height 1200
}

# Windows OS tools
function programAndFeatures {appwiz.cpl}
function systemProperty {sysdm.cpl}
function DeviceManager {devmgmt.msc}


function ConEmuToGit{cp $conemu_xml_path $conemu_xml_git }
function Reload_ConEmu_XML{cp $conemu_xml_git $conemu_xml_path }

function gitCleanAll {
    git clean -fX
    git clean -fd
    git reset --hard
}

function Show-Colors( ) {
  $colors = [Enum]::GetValues( [ConsoleColor] )
  $max = ($colors | foreach { "$_ ".Length } | Measure-Object -Maximum).Maximum
  foreach( $color in $colors ) {
    Write-Host (" {0,2} {1,$max} " -f [int]$color,$color) -NoNewline
    Write-Host "$color" -Foreground $color
  }
}

function sha1sum($filename) {
     Get-Hash $filename -Algorithm SHA1
}

function md5sum($filename) {
     Get-Hash $filename -Algorithm MD5
}

function sshroot() {
    if (-not ($ip -is [int])) {
        "One parameter (last field fo the ip address) is required."
    }
    elseif (($ip -lt 0) -or ($ip -gt 255)) {
        "The parameter (last field fo the ip address) should be from 0 to 255."
    }
    else {
        $full_ip = "192.168.0." + $ip
        $root_id = "root@" + $full_ip
        ssh $root_id
    }
}


function upload_ccl_firmware($ip, $rbf_filename) {
    if (-not ($ip -is [int])) {
        "One parameter (last field fo the ip address) is required."
    }
    elseif (-not (Test-Path $rbf_filename -PathType leaf))
    {
        "Cannot find the file specified by the filename: " + $rbf_filename
    }
    elseif (($ip -lt 0) -or ($ip -gt 255)) {
        "The parameter (last field fo the ip address) should be from 0 to 255."
    }
    else {
        $full_ip = "192.168.0." + $ip
        $root_id = "root@" + $full_ip

        $cur_time = Get-Date -UFormat "%Y%m%d_%H%M%S"
        $rbf_dir = "/mnt/sdcard/"
        $old_rbf_dir = $rbf_dir + "old"
        $target_CCLight = $rbf_dir + "CCLight.rbf"
        $back_cclight = $rbf_dir + "old/CCLight.rbf." + $cur_time

        ssh $root_id mkdir $old_rbf_dir

        ssh $root_id cp $target_CCLight $back_cclight

        "Backup" + $full_ip + ":" + $target_CCLight + " to " + $full_ip + ":" + $back_cclight

        $scp_source = $rbf_filename
        $scp_destination = $root_id + ":" + $target_CCLight
        "scp_Source: " + $scp_source
        "scp_Destination: " + $scp_destination

        scp $scp_source $scp_destination
    }
}

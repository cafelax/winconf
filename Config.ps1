## Though Visual Studio 2015 can work, it is highly recommended to use VS2017, which has been reported no bugs till now.
# for Visual Studio < VS2015, using a path similar to the following:
# $VS_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\vcvarsall.bat"
# for Visual Studio >= VS2017, using a path similar to the following:
$VS_bat_path = "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat"

$subl_path = "D:\Program Files (x86)\Microsoft VS Code\Code.exe"

# the root directory of anaconda
$anaconda_path = "D:\Anaconda"

# the directory you would like to be in when PowerShell is launched
$ps_default_dir = "D:"

# the directory for github repositories.
$GitHubRepo = "D:\GitHubRepos"
$systemc_path = "C:\Program Files\SystemC"
$graphviz_path = "C:\Program Files\graphviz"

$InstallList = [ordered]@{
    # a window software management system, required by the installation process.
    choco          = $True         # mandatory
    # Window Management Framework (PS > v 5.0.0) is required to install Pscx
    powershell     = $True         # mandatory
    # used to compile OpenQL and CCLight assembler
    cmake          = $True         # mandatory
    # this is required to invoke VS compiler correctly in the terminal
    pscx           = $True         # mandatory
    # used to invoke OpenQL and assembler from python
    swig           = $True         # mandatory
    # required to compile the assembler of CCLight
    flexbison      = $True
    # Use a fancy terminal to replace original ugly bule-background PS terminal.
    conemu         = $True
    # You know it.
    github         = $False
    # You know it.
    anaconda       = $False
    # enable easy command typing.
    psreadline     = $True
    # enable highlighting the git status.
    poshgit        = $True
    # required by QuMA_Sim
    systemc        = $True
    # enable ssh/scp related commands in the terminal. required by updating CCLight firmware.
    openssh        = $True
}

# If your PowerShell and ConEmu has been already configured, please modify the following key to $False.
$Configure_Shell = $True

$SystemC_64_bits = $True

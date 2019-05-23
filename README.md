# DevEnv
Contains tools to set up a complete development environment for the DiCarlo lab computers.

## Usage
The following steps are required to automate the environment installation process.

### Install Visual Studio 2017
Note, VS2017 is not covered by this automatic installation process. It is highly recommended to install VS2017 rather than VS2015.

### Ensure PowerShell can load scripts

Before doing anything, please execute the following command in a PowerShell terminal **with administrative privilege** to ensure PowerShell can load a script.
```PowerShell
Set-ExecutionPolicy RemoteSigned
```
If you have already done this in the past, this step is not required.  But reruning this command for multiple times should not introduce any problem.

### Start Installation
- Configure the several paths at the top of the file `Config.ps1`.
- Select which software you would like to install or skip by setting the value in the dictionary `InstallList` to `True` or `False`.
- Open a PowerShell terminal **with administration privilege**, use the following command to start automatic installation:
```PowerShell
. .\dev_env_install.ps1
```

If the installation exit without telling you all software is ready, please read the message, take the required action, and rerun the above command again. It may require run the command for multiple times, but it should not introduce any problem.

If you have used the automatic installation in the past, rerun this command will check if any software marked as required in the file `Config.ps1` is still valid, and if not install it. Rerun this command will not harm your system and you should be able to see green messages telling you your system has the required software.

### Additional Step - Linux commands
Execute the following command to enable Linux commands in your system:
```PowerShell
. .\linux_commands\install.ps1
```
**NOTE**, though it can work,  this step is not tested. It might rewrite some of the commands provided by other software, like `ssh` in OpenSSH. Be careful to use it.

## Software Included
The following software is enabled to be installed automatically. But you still need to configure them to be `True` in the file `Config.ps1`:
- Chocolatey (mandatory)
- PowerShell 5.x (mandatory)
- PowerShell Community Extension (Pscx, mandatory)
- swig (mandatory)
- cmake (mandatory)
- ConEmu
- flex & bison
- GitHub
- Anaconda
- SystemC
- poshgit
- openssh
- PSReadline

## To be supported:
- Automatically load advance PSReadline settings
- Support PycQED + Cython
- Support donwloading code from a closed repository on GitHub (CC-Light, Assembler, etc.)

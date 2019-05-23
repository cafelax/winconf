. ($PSScriptRoot + "\download_with_progress.ps1")
. ($PSScriptRoot + "\env_var_utils.ps1")

function Write-Green([string]$str) {Write-Host $str -ForegroundColor Green}

function Get-SWInBranch([microsoft.win32.RegistryKey]$registry, [string]$SubBranch) {

    $registrykey = $registry.OpenSubKey($Subbranch)
    if ($registrykey -eq $null) {
        return
    }

    # Write-Host ("Looking into the key: " + $registrykey.Name)
    $SubKeys = $registrykey.GetSubKeyNames()

    $SWInBranch = @()
    Foreach ($key in $subkeys)
    {
        $exactkey = $key
        $NewSubKey = $SubBranch + "\\" + $exactkey
        $ReadUninstall = $registry.OpenSubKey($NewSubKey)
        $DisplayName = $ReadUninstall.GetValue("DisplayName")
        # Add-Content -Path $output_fn $DisplayName -Encoding Unicode
        $SWInBranch += $DisplayName
    }

    return $SWInBranch
}

function Get-InstalledSoftware() {
    $InstalledSW = @()

    # find the software registered in the Localmachine
    [microsoft.win32.registrykey]$registry = [microsoft.win32.registrykey]::OpenRemoteBaseKey('Localmachine',$env:COMPUTERNAME)
    $SubBranches = (
        "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
        "Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
        "Software\Classes\Installer\Products"
    )
    foreach ($SubBranch in $SubBranches) {
        $InstalledSW += Get-SWInBranch $registry $SubBranch
    }

    # find the software registered in each user account
    $registry = [microsoft.win32.registrykey]::OpenRemoteBaseKey('Users',$env:COMPUTERNAME)
    $UsersSubKeys = $registry.GetSubKeyNames()
    $UserSubKeyExt = (
        "\Software\Microsoft\Windows\CurrentVersion\Uninstall",
        "\Software\Microsoft\Installer\Products"
    )
    foreach ($UsersSubKey in $UsersSubKeys) {
        foreach ($SubKeyExt in $UserSubKeyExt) {
            $SubBranch = $UsersSubKey + $SubKeyExt
            # "The current SubBranch is: " + $SubBranch
            $InstalledSW += Get-SWInBranch $registry $SubBranch
        }
    }

    return $InstalledSW
}

function Check-SwInstalled([string]$SwName) {
    return ((Get-InstalledSoftware | sls -Pattern "github").Count -gt 0)
}

function Print-Success([string]$info) {
    Write-Host "***************************************************************" -ForegroundColor Green
    Write-Host ("** " + $info) -ForegroundColor Green
    Write-Host "***************************************************************" -ForegroundColor Green
}

function check-DlPath([string]$target_path) {
    # if the path exists
    if (Test-Path -Path $target_path) {

        $success = $False
        while (-not $success) {
            [string]$check_info = $(Read-Host ("The file " + $target_path + `
                " already exists. Overwrite it, Continue without downloading, or abort ([O]/C/A)?"))

            if ($check_info -eq 'o' -or $check_info -eq [string]::empty) {
                rm $target_path
                if (-not $?) {
                    throw ("Unexpected error happened while removing the file " + $target_path)
                }
                return $True
            } elseif ($check_info -eq 'c') {
                return $False  # Do not download the file and continue.
            } elseif ($check_info -eq 'a') {
                Write-Warning "User aborts."
                return $null
            } else {
                Write-Host "Unrecognized user input. Please retry..."
                $success = $False
            }
        }
    } else { # the path does not exist. Download the file and continue.
        return $True
    }
}

function Prepare-Directory([string]$target_dir) {
    $dir_ready = $False

    if (-not (Test-Path -Path $target_dir)) {
        Write-Host ("Creating the directory '" + $target_dir + "' ...")
        mkdir $target_dir
        # Check if the creation succeeded.
        if (-not $?) {
            throw ("Failed to create the direcotry $target_dir.`n" +
            "Please check if you have the priviledge to create a directory in the target location. `n" +
            "Installation aborts.")
        } else {
            Write-Host ("Successfully created the directory '" + $target_dir + "'.")
            $dir_ready = $True
        }
    } else {
        if (Test-Path -Path $target_dir -PathType Leaf) {
            throw "There is already a file corresponding to the given path. Preparing directory fails."
        }
        # check if the directory is empty or not
        $directoryInfo = Get-ChildItem $target_dir | Measure-Object

        if ($directoryInfo.count -ne 0) {
            $dir_ready = $False
        } else {
            $dir_ready = $True
        }

        while (-not $dir_ready) {
            [string]$check_info = $(Read-Host ("Given path '$target_dir' is not empty. Continue by removing existing files ([Y]/N)? "))
            if ($check_info -eq 'no' -or $check_info -eq 'n') {
                throw "User aborted."
            } elseif ($check_info -eq 'yes' -or $check_info -eq 'y' -or $check_info -eq [string]::empty) {
                "Removing all files in the directory, and continue installation in the given directory..."
                rm "$target_dir\*" -Recurse -Force
                $dir_ready = $True
            } else {
                "Unrecognized user input. Please retry."
            }
        }
    }
    return $dir_ready
}

function my_download_file([string]$dlulr, [string]$dlpath) {
    Write-Host ("Try to downlad from:" + $dlulr)
    Write-Host ("with the downloading target: " + $dlpath)

    $ret = check-DlPath $dlpath
    if ($ret -eq $null) {  # user aborts.
        return $False
    }
    if ($ret) {            # overwrite the original file.
        Write-Host "Overwrite the existing file by downlading from: $dlpath"
        Write-Host "start downloading..."
        $start_time = Get-Date
        Measure-DownloadSpeed -Url $dlulr -Path $dlpath
        if ($?) {
            $end_time = Get-Date
            Write-Host ("Successfully downloading the file to " + $dlpath) -ForegroundColor Green
            Write-Host "Time taken: $($end_time.Subtract($start_time).Seconds) second(s)" -ForegroundColor Green
            return $True
        } else {
            Write-Error "An error happened while downloading file from $dlulr."
            return $False
        }
    }
}


function get-GitHubDlPath {
    Param
    (
        # Please provide the repository owner
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$Owner,

        # Please provide the name of the repository
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$Repository,

        # Please provide a branch to download from
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [string]$Branch = 'master',

        # Please provide a list of files/paths to download
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [string[]]$FilePath
    )

    $url = "https://raw.githubusercontent.com/$Owner/$Repository/$Branch/$FilePath"
    return $url
}

function get-GitHubRepoZipDlPath {
    Param
    (
        # Please provide the repository owner
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$Owner,

        # Please provide the name of the repository
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$Repository,

        # Please provide a branch to download from
        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [string]$Branch = 'master'
    )

    $url = "https://github.com/$Owner/$Repository/archive/$Branch.zip"
    return $url
}

function my_expand_archive {
    Param
    (
        # Please provide the repository owner
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$archive_path,

        # Please provide the name of the repository
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$target_path
    )
    Expand-Archive -Path $archive_path -OutputPath $target_path -Force

    if ($?) {
        Write-Host "Successfully unzipped the file $archive_path to $target_path." -ForegroundColor Green
        return $True
    } else {
        Write-Error ("Failed to unzip the file $archive_path. Installation aborts.")
        return $False
    }
}

function rm_line_in_file {
    Param
    (
        # Please provide the file name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$file,

        # Please provide pattern which is matched by the line to remove
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$line
    )
    Set-Content  -Path $file -Value (get-content -Path $file | Select-String -SimpleMatch $line -NotMatch)
}

function rm_line_in_file_regex {
    Param
    (
        # Please provide the file name
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [string]$file,

        # Please provide pattern which is matched by the line to remove
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [string]$line
    )
    Set-Content  -Path $file -Value (get-content -Path $file | Select-String -Pattern $line -NotMatch)
}

function check_is_admin {
    If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
        exit
    }
}

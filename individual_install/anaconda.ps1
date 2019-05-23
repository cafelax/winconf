If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    exit
}

. ($PSScriptRoot + "\..\utils\utils.ps1")
. ($PSScriptRoot + "\..\config.ps1")

#########################################################################################
# Install Anaconda3
#########################################################################################
function verify-Anaconda() {
    $condatmp_fn = "condatmp.txt"
    conda list > $condatmp_fn
    if ($?) {
        Print-Success "Anaconda3 has been verified to work properly."
    } else {
        Write-Error "Errors happens while verifying Anaconda. Please check and continue."
        exit
    }
}

if (Check-SwInstalled "Anaconda3") {
    Write-Host "Anaconda3 has been installed. Verifying..."
    verify-Anaconda
} else {
    $anaconda_dl_path = $PSScriptRoot + "\Anaconda3-5.1.0-Windows-x86_64.exe"
    $UrlAnaconda = "https://repo.continuum.io/archive/Anaconda3-5.1.0-Windows-x86_64.exe"
    my_download_file $UrlAnaconda  $anaconda_dl_path

    if ($ret -eq $False) {
        exit
    }

    Start-Process $anaconda_dl_path -Wait

    $ana_path_to_add =  $anaconda_path, 
                        ($anaconda_path + "\Scripts"),
                        ($anaconda_path + "\Library\bin")

    foreach ($sub_path in $ana_path_to_add) {
            add-EntryToUserPath($sub_path)    
    }

    verify-Anaconda
}

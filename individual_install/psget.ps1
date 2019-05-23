. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

#########################################################################################
## Install PsGet
#########################################################################################
# if ((Get-Module | sls "psget").count -gt 0) {
#     Write-Host "PsGet has already been installed. Skip installing PsGet."
# } else {
#     Write-Host "PsGet has not been installed yet. Installing PsGet..."

#     (new-object Net.WebClient).DownloadString("https://raw.githubusercontent.com/psget/psget/master/GetPsGet.ps1") | iex
#     if ($?) {
#         Write-Host "PsGet has been installed successfully, which enables the command Install-Module." -ForegroundColor Green
#     } else {
#         Write-Error "Error happens while installing PsGet. Installation Aborts."
#         exit
#     }
# }

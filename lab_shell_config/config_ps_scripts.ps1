. ($PSScriptRoot + "\..\utils\utils.ps1")
. ($PSScriptRoot + "\..\config.ps1")
check_is_admin

Write-Host "Start to configure PowerShell scripts..." -ForegroundColor Green

# Let PowerShell load the default configuration script
$profile_path = Split-Path -Path $PROFILE.CurrentUserAllHosts
New-Item -ItemType Directory -Force $profile_path
$line_to_invoke_my_script = ". """ + $PSScriptRoot + "\powershell_profile\profile.ps1"""

rm_line_in_file ($PROFILE.CurrentUserAllHosts).ToString() $line_to_invoke_my_script

Add-Content -Path $PROFILE.CurrentUserAllHosts  $line_to_invoke_my_script

# create a local path configuration file.
$local_config_path = $PSScriptRoot + "\powershell_profile\local_config.ps1"


# remove original configuration about the following variables:
$line_list = @("""Loading script.*",
    "ps_default_dir\s*=.*",
    "VS_bat_path\s*=.*",
    "subl_path\s*=.*",
    "GitHubRepo\s*=.*")

foreach ($line in $line_list) {
    rm_line_in_file_regex $local_config_path $line
}

# write new content for them
Add-Content -Path $local_config_path  "# Please feel free to add your own configuration in this file."
Add-Content -Path $local_config_path  """Loading script "" + `$MyInvocation.MyCommand.Name + ""."""
Add-Content -Path $local_config_path  "`$ps_default_dir = ""$ps_default_dir"""
Add-Content -Path $local_config_path  "`$VS_bat_path = ""$VS_bat_path"""
Add-Content -Path $local_config_path  "`$subl_path = ""$subl_path"""
Add-Content -Path $local_config_path  "`$GitHubRepo = ""$GitHubRepo"""

Print-Success "Successfully configured PowerShell scripts."

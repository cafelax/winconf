If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
    exit
}


. ($PSScriptRoot + "\..\..\utils\utils.ps1")
. ($PSScriptRoot + "\..\..\config.ps1")

#########################################################################################
### graphviz installation, required by dependency graph used in PycQED.
#########################################################################################
Prepare-Directory $graphviz_path

$GraphvizTarGzFilePath = ($PSScriptRoot + "\downloads\graphviz-2.38_x64.tar.gz")
$GraphvizTarFilePath = $PSScriptRoot + "\downloads"
$GraphvizTarFileName = ($GraphvizTarFilePath + "\graphviz-2.38_x64.tar")

#########################################################################################
#download graphviz zip from website
# $url = get-GitHubDlPath "mahkoCosmo" "GraphViz_x64" "master" "graphviz-2.38_x64.tar.gz"
# if (-not (my_download_file $url  $GraphvizTarGzFilePath)) {
#     exit
# }
#########################################################################################

if (-not (my_expand_archive $GraphvizTarGzFilePath  $GraphvizTarFilePath)) {
    exit
}
if (-not (my_expand_archive $GraphvizTarFileName  $graphviz_path)) {
    exit
}


$graphviz_bin_path = $graphviz_path + "\bin"

## add the bin directory of graphviz into the user environment variable `path`
add-EntryToUserPath $graphviz_bin_path

$libxml2_dll_path = ($PSScriptRoot + "\downloads\libxml2.dll")

Copy-Item $libxml2_dll_path $graphviz_bin_path

$pygraphviz_repo_url = get-GitHubRepoZipDlPath "pygraphviz" "pygraphviz" "master"
$pygraphviz_zip_path = ($PSScriptRoot + "\downloads\pygraphviz-master.zip")

##########################################################################################
##### At this moment, we do not download this file since this process is error prone.
#####    Instead, we use a copy already downloaded.
##########################################################################################
# $ret = my_download_file $pygraphviz_repo_url $pygraphviz_zip_path
# if ($ret -eq $False) {
#     exit
# }

Write-Host ("Unzipping the file: " + $pygraphviz_zip_path)
$pygraphviz_path = ($PSScriptRoot + "\downloads\pygraphviz-master\pygraphviz-master")
$pygraphviz_parent_path = ($PSScriptRoot + "\downloads\pygraphviz-master")

Prepare-Directory $pygraphviz_path
if (-not (my_expand_archive $pygraphviz_zip_path $pygraphviz_parent_path)) {
    exit
}


Copy-Item ($PSScriptRoot + "\downloads\graphviz.i") $pygraphviz_path
Copy-Item ($PSScriptRoot + "\downloads\graphviz_wrap.c") $pygraphviz_path

Push-Location $pygraphviz_path
python "$pygraphviz_path\setup.py" "install" "--include-path=$graphviz_path\include" "--library-path=$graphviz_path\lib"

if ($?) {
    Write-Host "Installation of pygraphviz has been finished. Please further check if everything is correct." -ForegroundColor Green
    Pop-Location
} else {
    Write-Error "Failed to install pygraphviz. Please check the error message."
    Pop-Location
    exit
}

#############################################################################################################
### Download graphviz.i and graphviz_wrap.c
#############################################################################################################
# $graphviz_i_url = get-GitHubDlPath "AdriaanRol" "AutoDepGraph" "master" "_install/graphviz.i"
# $graphviz_i_path = $PSScriptRoot + "\graphviz.i"
# $graphviz_wrap_c_url = get-GitHubDlPath "AdriaanRol" "AutoDepGraph" "master" "_install/graphviz_wrap.c"
# $graphviz_wrap_c_path = $PSScriptRoot + "\graphviz_wrap.c"


# $ret = my_download_file $graphviz_i_url  $graphviz_i_path
# if ($ret -eq $False) {  # user aborts.
#     exit
# }

# $ret = my_download_file $graphviz_wrap_c_url  $graphviz_wrap_c_path
# if ($ret -eq $False) {  # user aborts.
#     exit
# }
#############################################################################################################
### End of Download graphviz.i and graphviz_wrap.c
#############################################################################################################

Print-Success "Successfully Installed graphviz."



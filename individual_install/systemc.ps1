. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

. ($PSScriptRoot + "\..\config.ps1")

#########################################################################################
### systemc installation, required by QuMA_Sim
#########################################################################################
Prepare-Directory $systemc_path

#download systemc zip from website
$SystemC_Url = "http://www.accellera.org/images/downloads/standards/systemc/systemc-2.3.2.zip"
$systemZipPath = ($PSScriptRoot + "\systemc_2.3.2.zip")

$ret = my_download_file $SystemC_Url  $systemZipPath
if ($ret -eq $False) {  # user aborts.
    exit
}

# unzip
"Unzip the file: " + $systemZipPath
Expand-Archive -Path $systemZipPath -OutputPath $systemc_path

if ($?) {
    Write-Host "Unzipped Successfully." -ForegroundColor Green
} else {
    Write-Error ("Failed to unzip the file " + $systemZipPath + ". Installation aborts.")
    exit
}

#########################################
# compile and build systemc library
#########################################
$systemc_build_path = $systemc_path + "\systemc-2.3.2\build"
mkdir $systemc_build_path
Push-Location $systemc_build_path

# prepare the project
if ($SystemC_64_bits) {
    cmake -G "Visual Studio 15 2017 Win64" ../ -DCMAKE_CXX_STANDARD=11 -DCMAKE_BUILD_TYPE=Debug
} else {
    cmake ../ -DCMAKE_CXX_STANDARD=11 -DCMAKE_BUILD_TYPE=Debug
}
# Build & install SystemC
cmake --build $systemc_build_path

Pop-Location
Print-Success "Successfully Installed SystemC."

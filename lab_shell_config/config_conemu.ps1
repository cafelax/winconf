. ($PSScriptRoot + "\..\utils\utils.ps1")
check_is_admin

Write-Host "Start to configure ConEmu..." -ForegroundColor Green

$conemu_xml_path = $env:APPDATA + "\ConEmu.xml"
cp ($PSScriptRoot + "\ConEmu.xml") $conemu_xml_path

Print-Success "Successfully configured ConEmu."

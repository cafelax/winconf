. ($PSScriptRoot + "\..\utils\env_var_utils.ps1")

$nix_bin_path = $PSScriptRoot + "\bin"

add-EntryToUserPath $nix_bin_path

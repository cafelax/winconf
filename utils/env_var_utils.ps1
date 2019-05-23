
function dumpEnvVar([string]$var) {
    foreach ($entry in $var.split(';')) {
        Write-Host $entry -foregroundcolor black -backgroundcolor cyan
    }
}

function remove-EntryInEnvPath([string]$entry_to_remove) {
    # remove the trailing space and '\' symbol
    $entry_to_remove = $entry_to_remove.trim('\ ')

    $targetEnu = ("user", "machine")

    foreach ($target in $targetEnu) {

        $EnvVars = [Environment]::GetEnvironmentVariables($target)

        foreach ($EnvVar in $EnvVars.keys) {
            $oldPath = [Environment]::GetEnvironmentVariable($EnvVar, $target)

            Write-Host "*********************************************************************"
            Write-Host ("Old " + $target + ": " + $EnvVar)
            dumpEnvVar  $oldPath

            [string]$newPath = ""
            $found = $False
            foreach ($entry in $oldPath.split(';')) {
                # only keep the keys that are different to the target entry which is to be removed.
                if ($entry.trim('\ ') -eq $entry_to_remove) {
                    $found = $True
                } else {
                    $newPath += ($entry.trim() + ';')
                }
            }
            $newPath = $newPath.trim(';')

            Write-Host ("New " + $target + ": " + $EnvVar)
            dumpEnvVar $newPath

            if ($found) {
                [Environment]::SetEnvironmentVariable($EnvVar, $newPath, $target)
            }
        }
    }
}


function add-EntryToUserPath($newEntry) {
    if (($env:path.split(';') | sls -pattern $newEntry.trim('\ ') -SimpleMatch).count -eq 0) {
            [Environment]::SetEnvironmentVariable("path", [Environment]::GetEnvironmentVariable("path", "user") + ";"+ $newEntry, "user")
    }
    Write-Host ("The path '" + $newEntry + "' has been successfully added to the user path.") -Foregroundcolor Green
}

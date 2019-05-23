function Measure-DownloadSpeed {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position=0, HelpMessage = "Please enter a URL to download.")]
        [string] $Url
        ,
        [Parameter(Mandatory = $true, Position=1, HelpMessage = "Please enter a target path to download to.")]
        [string] $Path
    )

    Write-Host ("Try to download from: " + $Url)
    Write-Host ("Downloading target Path: " + $Path)

    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    function Get-ContentLength {
        [CmdletBinding()]
        param (
            [string] $Url
        )

        $Req = [System.Net.HttpWebRequest]::CreateHttp($Url);
        $Req.Method = 'HEAD';
        $Req.Proxy = $null;
        $Response = $Req.GetResponse();
        #Write-Output -InputObject $Response.ContentLength;
        Write-Output -InputObject $Response;
    }

    $FileSize = (Get-ContentLength -Url $Url).ContentLength;

    if (!$FileSize) {
        throw 'Download URL is invalid!';
    } else {
        Write-Host ("Verified that the downloading link is valid and the target file size is " + $FileSize)
    }

    # Resolve the fully qualified path to the target file on the filesystem
    # $Path = Resolve-Path -Path $Path;

    if (Test-Path -Path $Path) {
        throw ('File already exists: {0}' -f $Path);
    }

    # Instantiate a System.Net.WebClient object
    $wc = New-Object System.Net.WebClient;

    # Invoke asynchronous download of the URL specified in the -Url parameter
    $wc.DownloadFileAsync($Url, $Path);

    ##################################################
    # measure the real-time downloading speed.
    ##################################################
    # While the WebClient object is busy, continue calculating the download rate.
    # This could potentially be broken off into its own function, but hey there's procrastination for that.
    # while ($wc.IsBusy) {
    #     # Get the current time & file size
    #     #$OldSize = (Get-Item -Path $TargetPath).Length;
    #     $OldSize = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path).Length;
    #     $OldTime = Get-Date;

    #     # Wait a second
    #     Start-Sleep -Seconds 1;

    #     # Get the new time & file size
    #     $NewSize = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path).Length;
    #     $NewTime = Get-Date;

    #     # Calculate time difference and file size.
    #     $SizeDiff = $NewSize - $OldSize;
    #     $TimeDiff = $NewTime - $OldTime;

    #     # Recalculate download rate based off of actual time difference since
    #     # we can't assume precisely 1 second time difference due to file IO.
    #     $UpdatedSize = $SizeDiff / $TimeDiff.TotalSeconds;

    #     # Write-Host -Object $TimeDiff.TotalSeconds, $SizeDiff, $UpdatedSize;

    #     Write-Host -Object ("Downloading speed: {0:N2}MB/sec" -f ($UpdatedSize/1MB));
    # }

    while ($wc.IsBusy) {
        $NewSize = (New-Object -TypeName System.IO.FileInfo -ArgumentList $Path).Length;

        Start-Sleep -Seconds 1

        Write-Progress -Activity "Downlading in Progress from:$Url" -Status ("Downladed: {0}% " -f ($NewSize * 100 / $FileSize)) -PercentComplete ($NewSize * 100 / $FileSize);
        # Write-Progress -CurrentOperation ("Downlading finished {0} %" -f ($NewSize/$FileSize)) ( " {0}s ..." -f ($i*$sleep_iteration) )
    }
    Write-Progress -PercentComplete 100 -Completed "Finished downloading the file."
}

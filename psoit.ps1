Function GetPowersploit {
#    sendMsg -Message ":hourglass: ``Downloading PowerSploit to Client.. Please Wait`` :hourglass:"
    
    $Path = "$env:TEMP\PowerSploit.psd1"
    $tempDir = "$env:TEMP"
    $permDir = "$Env:HomeDrive$Env:HOMEPATH\Documents\PowerShell\Modules\PowerSploit"
    $zipFilePath = Join-Path $tempDir "PowerSploit.zip"

    If (!(Test-Path $Path)) {
        # Direct zipball link for v3.0.0
        $zipUrl = "https://github.com/PowerShellMafia/PowerSploit/archive/refs/tags/v3.0.0.zip"

        $wc = New-Object System.Net.WebClient
        $wc.Headers.Add("User-Agent", "PowerShell")
        $wc.DownloadFile($zipUrl, $zipFilePath)

        # Extract
        Expand-Archive -Path $zipFilePath -DestinationPath $tempDir -Force

        # The extracted folder name will be something like "PowerShellMafia-PowerSploit-xxxxxxxx"
        $extractedDir = Get-ChildItem $tempDir -Directory | Where-Object { $_.Name -like "PowerShellMafia-PowerSploit*" } | Select-Object -First 1

        # Create module folder
        if (!(Test-Path $permDir)) {
            New-Item -ItemType Directory -Path $permDir -Force | Out-Null
        }

        # Move all module content
        Move-Item -Path "$($extractedDir.FullName)\*" -Destination $permDir -Force

        # Marker file (not necessary, but kept from your version)
        New-Item -ItemType File -Path $Path -Force | Out-Null

        # Cleanup
        Remove-Item $zipFilePath -Force
        Remove-Item $extractedDir.FullName -Recurse -Force
    }

}
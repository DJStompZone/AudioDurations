<#
.SYNOPSIS
Retrieves the duration of a single audio file.

.DESCRIPTION
This function uses the Windows Shell to retrieve the duration metadata of a single audio file.
It supports various audio file formats such as .mp3, .wav, .m4a, and more.

.PARAMETER FilePath
The full path to the audio file for which to retrieve the duration.

.OUTPUTS
[TimeSpan]
Returns a TimeSpan object representing the duration of the audio file.

.EXAMPLE
PS C:\> Get-AudioDuration -FilePath "C:\Windows\media\tada.wav"
Returns the duration of the specified audio file.

.NOTES
Author: DJ Stomp <85457381+DJStompZone@users.noreply.github.com>
License: MIT
GitHub Repo: https://github.com/djstompzone/AudioDurations
#>
function Get-AudioDuration {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FilePath
    )

    if (-not (Test-Path $FilePath)) {
        Write-Error "File not found: $FilePath"
        return
    }

    $shell = New-Object -ComObject shell.application
    $folder = $shell.Namespace((Get-Item $FilePath).DirectoryName)
    $file = $folder.ParseName((Get-Item $FilePath).Name)
    $durationString = $folder.GetDetailsOf($file, 27)
    if (-not $durationString) {
        $durationString = "00:00:00"
    }
    return [TimeSpan]::ParseExact($durationString, "hh\:mm\:ss", [System.Globalization.CultureInfo]::InvariantCulture)
}

<#
.SYNOPSIS
Retrieves the total duration of all audio files in a specified folder.

.DESCRIPTION
This function calculates the total duration of all audio files in the specified folder.
It supports various audio file formats and can optionally search subdirectories with the -Recursive flag.
Progress is displayed during the operation to provide feedback on large file sets.

.PARAMETER FolderPath
The full path to the folder containing the audio files.

.PARAMETER Extensions
An array of file extensions to include in the search (default: .mp3, .wav, .m4a, .ogg, .opus, .aac, .flac).

.PARAMETER Recursive
A switch that, if specified, allows the function to search subdirectories recursively.

.OUTPUTS
[TimeSpan]
Returns a TimeSpan object representing the total duration of all audio files.

.EXAMPLE
PS C:\> Get-AudioDurations -FolderPath "C:\Windows\media"
Returns the total duration of all audio files in the specified folder.

.EXAMPLE
PS C:\> Get-AudioDurations -FolderPath "$env:USERPROFILE\Music" -Recursive
Returns the total duration of all audio files in the specified folder and its subdirectories.

.NOTES
Author: DJ Stomp <85457381+DJStompZone@users.noreply.github.com>
License: MIT
GitHub Repo: https://github.com/djstompzone/AudioDurations
#>
function Get-AudioDurations {
    param (
        [Parameter(Mandatory=$true)]
        [string]$FolderPath,
        [string[]]$Extensions = @(".mp3", ".wav", ".m4a", ".ogg", ".opus", ".aac", ".flac"),
        [switch]$Recursive
    )

    if (-not (Test-Path $FolderPath)) {
        Write-Error "Folder not found: $FolderPath"
        return
    }

    $shell = New-Object -ComObject shell.application
    $totalDuration = [TimeSpan]::Zero

    $searchOption = if ($Recursive) { 'Recurse' } else { 'TopDirectoryOnly' }
    $files = Get-ChildItem -Path $FolderPath -File -Recurse:$Recursive | Where-Object {
        $_.Extension -in $Extensions
    }

    $fileCount = $files.Count
    $i = 0

    foreach ($file in $files) {
        $i++
        Write-Progress -Activity "Processing audio files..." -Status "Processing file $i of $fileCount" -PercentComplete (($i / $fileCount) * 100)

        $folder = $shell.Namespace($file.DirectoryName)
        $fileItem = $folder.ParseName($file.Name)
        $durationString = $folder.GetDetailsOf($fileItem, 27)
        if (-not $durationString) {
            $durationString = "00:00:00"
        }
        $fileDuration = [TimeSpan]::ParseExact($durationString, "hh\:mm\:ss", [System.Globalization.CultureInfo]::InvariantCulture)
        $totalDuration = $totalDuration.Add($fileDuration)
    }

    Write-Progress -Completed -Activity "Processing audio files" -Status "Completed"

    return $totalDuration
}

Export-ModuleMember -Function Get-AudioDuration, Get-AudioDurations

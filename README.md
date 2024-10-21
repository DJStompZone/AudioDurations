# AudioDurations

AudioDurations is a PowerShell module for processing audio file duration metadata via the Windows shell. It should also be capable of supporting any other filetype that has a valid "length" property, such as video files.

## Installation

To install the AudioDurations module, you can add it to your PowerShell profile for easy access. Here's how you can do it:

1. Clone the repository or download the `AudioDurations.psm1` file.
2. Move the `AudioDurations.psm1` file to a directory of your choice. For example, `C:\PowerShellModules\AudioDurations\`.
3. Add the following line to your PowerShell profile script (`$PROFILE`):

```powershell
Import-Module C:\PowerShellModules\AudioDurations\AudioDurations.psm1
```

4. Save the profile script and restart your PowerShell session.

## Usage

### Get the Duration of a Single Audio File

To retrieve the duration of a single audio file, use the `Get-AudioDuration` function:

```powershell
Get-AudioDuration -FilePath "C:\Windows\media\tada.wav"
```

This will return the duration of the specified audio file as a `TimeSpan` object.

### Get the Total Duration of All Audio Files in a Folder

To calculate the total duration of all audio files in a specified folder, use the `Get-AudioDurations` function:

```powershell
Get-AudioDurations -FolderPath "C:\Windows\media"
```

You can also search subdirectories recursively by adding the `-Recursive` flag:

```powershell
Get-AudioDurations -FolderPath "$env:USERPROFILE\Music" -Recursive
```

This will return the total duration of all audio files in the specified folder and its subdirectories as a `TimeSpan` object.

## License

This module is licensed under the MIT License. See the [LICENSE](LICENSE) file for more details.

## Author

<details open>
  <summary>
    <h2>DJ Stomp</h2>
  </summary>
  <ul>
    <li>
      <a href="https://github.com/DJStompZone">
        <img alt="GitHub" height="26px" src="https://www.svgrepo.com/show/303615/github-icon-1-logo.svg">
      </a>
    </li>
    <li>
      <a href="https://discord.stomp.zone">
        <img height="26px" alt="Discord" src="https://www.svgrepo.com/show/353655/discord-icon.svg">
      </a>
    </li>
    <li>
      <a href="https://youtube.com/@djstompzone">
        <img height="26px" alt="YouTube" src="https://www.svgrepo.com/show/475700/youtube-color.svg">
      </a>
    </li>
    <li>
      <a href="https://soundcloud.com/djstompzone">
        <img height="26px" alt="SoundCloud" src="https://www.svgrepo.com/show/382735/soundcloud-sound-cloud.svg">
      </a>
    </li>
  </ul>
</details>

## GitHub Repository

[AudioDurations GitHub Repo](https://github.com/DJStompZone/AudioDurations)

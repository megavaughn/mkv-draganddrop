# mkv-draganddrop
A Windows batch file that allows video files to be dragged onto it for automatic transcoding (using ffmpeg) to a high quality MKV file.</br></br>
This is meant to be simple, easily customizable and quick (drag and drop, yeah!) for people to use.
## Usage
Simply place a copy (or shortcut) of mkvme.bat on your desktop and drag 1 or more video files to it! The following files will be output:
1. An mkv file at a visually lossless quality and relatively small file size with all audio and subtitle tracks copied from the original.
2. A log file containing the output (and any errors) from ffmpeg as it transcoded the input file.
3. A hash file containing the MD5 hash of the output file. This is useful for archiving or transfer.

## Installation
1. Install the latest version of ffmpeg (https://www.ffmpeg.org/) onto your Windows machine.
2. Make sure ffmpeg.exe is added to your PATH statement. To learn how, go here:</br>
   https://msdn.microsoft.com/en-us/library/office/ee537574(v=office.14).aspx
3. Make a shortcut to mkvme.bat somewhere (your Desktop is a great place)
4. Done!

## Requires
1. Windows XP or higher (only tested with Windows 7, 8 and 10)
2. ffmpeg to be installed and in your system PATH (tested with ffmpeg v3.2.2)

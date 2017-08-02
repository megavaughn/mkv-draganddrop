rem mkvme.bat
rem
rem This allows drag-and-drop conversion of video files into an MKV
rem Right now it only allows AVI or MKV files but that is easily cahnged below.
rem It will also output an MD5 hash of the file in case you want to transfer it!
rem
rem ffmpeg must be installed with its bin directory somewhere in your PATH.
rem
rem USAGE
rem Simply drag one or more AVI/MKV files onto this batch file
rem and MKVs will be created in the same directory as the AVI/MKVs.
rem 
rem If you want you can make a shortcut to this batch file
rem and drag to that shortcut if you prefer.
rem
rem Tested in Windows 7 and 10
rem Tested with ffmpeg version 3.2.2
rem

@cls
@echo off
setlocal ENABLEDELAYEDEXPANSION

rem ffmpeg uses a lot of resources
rem So make sure we're not running more than one instance of this script
set lockFile=%HOMEDRIVE%%HOMEPATH%\%~n0.lock
if exist "%lockFile%" (
    echo ABORTING - Script already running.
    echo If you believe this to be in error then delete %lockfile% and run again.
    echo.
    pause
    goto:eof
)

echo. > "%lockFile%"

rem These set the overall quality of the output h264 video stream
rem The defaults result in an almost visually lossless output file that is nice and small!
rem Refer to the ffmpeg documentation for more info:
rem https://trac.ffmpeg.org/wiki/Encode/H.264
set crfLevel=24
set x264Preset=slow

:processFile
if "%~f1"=="" goto :endProcessingFiles

set inputFileName=%~nx1

rem This tells what input filetypes are allowed (defaults to AVIs or MKVs)
rem But you can add more file types by adding if-statements below
rem
rem You can also set isValidVideoFile to 1 to just support all files
set isValidVideoFile=0
if %~x1==.avi set isValidVideoFile=1
if %~x1==.AVI set isValidVideoFile=1
if %~x1==.mkv set isValidVideoFile=1
if %~x1==.MKV set isValidVideoFile=1

cd /D "%~dp1"

echo Input File:      %inputFileName%
if !isValidVideoFile!==1 (
    rem Notice the output file name has the h264 presets appended to them. This can help with bookkeeping in archives.
    set outputFileName=%~n1_preset-%x264Preset%_crf-%crfLevel%.mkv
    if not exist "!outputFileName!" (
        rem Notice the log file name is given the same treatment as the output file name. This can help with bookkeeping in archives.
        set logFileName=!outputFileName:~0,-4!.log
        
        echo Output File:     !outputFileName!
        echo ffmpeg Log File: !logFileName!
        echo Transcode Start: !DATE! !TIME!
        
        rem Feel free to tinker with the ffmpeg settings below!
        rem But basically this transcodes all video streams to H264 and copies all audio and subtitle streams by default
        rem -ss 00:15:38 -t 00:00:20 
        ffmpeg -i "%inputFileName%" -map 0 -c:v libx264 -preset %x264Preset% -crf %crfLevel% -c:a copy -c:s copy "!outputFileName!" > "!logFileName!" 2>&1
        echo Transcode End:   !DATE! !TIME!
    ) else (
        echo SKIPPING FILE - %inputFileName%
        echo !outputFileName! already exists.
    )
) else (
    set outputFileName=%inputFileName%
)

rem An MD5 hash is generated in case you want to transfer or archive these (possibly) large files!
set hashFileName=!outputFileName!.md5
echo Hash File:       %hashFileName%
certutil -hashfile "!outputFileName!" MD5 > "%hashFileName%"
echo.

shift
goto :processFile

:endProcessingFiles
echo EXITING - All files processed.
echo.

del /q /f "%lockFile%"
pause

goto:eof

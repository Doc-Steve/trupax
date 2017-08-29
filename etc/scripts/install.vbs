set WshShell= WScript.CreateObject("WScript.Shell")
set fso = CreateObject("Scripting.FileSystemObject")
dir = WshShell.CurrentDirectory
set oShLnk = WshShell.CreateShortcut(WshShell.SpecialFolders("Desktop") & "\TruPax.lnk")
oShLnk.TargetPath = dir & "\jre\bin\javaw.exe"
oShLnk.Arguments = "-jar " & """" & dir & "\trupax.jar"""
oShLnk.WindowStyle = 1
oShLnk.IconLocation = dir & "\trupax.ico"
oShLnk.Description = "TruPax"
oShLnk.WorkingDirectory = dir
oShLnk.Save
WScript.Echo "There should be a shortcut to TruPax available on the desktop now."

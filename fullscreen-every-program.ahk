; This should be at the **top** level
GroupAdd, programs, ahk_exe chrome.exe
GroupAdd, programs, ahk_exe Code.exe
GroupAdd, programs, ahk_exe Anki.exe
GroupAdd, programs, ahk_exe Hyper.exe


;================================================
; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
;put this line near the top of your script: 
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir% 
;=============================================


#SingleInstance Force
#InstallMouseHook
Process, Priority,, B
idle      = 3000 ; Milliseconds to wait before entering full screen
margin    = 10 ;140  ; Screen boundaries for exiting full screen
tolerance = 4    ; Mouse distance to ignore in full screen
Loop {
 ;WinWaitActive, ahk_exe chrome.exe
 WinWaitActive, ahk_group programs
 SoundBeep, 1500
 SetTimer, Check, 350
 WinWaitNotActive
 SetTimer, Check, Off
 SoundBeep, 1000
}

#IfWinNotActive ahk_exe FreeTimer.exe
Check:
CoordMode, Mouse
lastX := x, lastY := y
MouseGetPos, x, y
WinGetPos,,, w, h, A
full     := w = A_ScreenWidth && h = A_ScreenHeight
moved    := Max(Abs(x - lastX), Abs(y - lastY)) > tolerance
inMargin := y < margin || y > A_ScreenHeight - margin
Send % !full && A_TimeIdleMouse > idle || full && inMargin && moved ? "{F11}" : ""
;Return

; Toggle Pause with F11 or F2
~F11::Pause, Toggle
return
~F2::Pause, Toggle
return



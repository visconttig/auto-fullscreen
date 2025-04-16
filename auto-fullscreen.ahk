;================================================
; WINDOW GROUPS
;================================================
GroupAdd, programs, ahk_exe chrome.exe
GroupAdd, programs, ahk_exe Code.exe
GroupAdd, programs, ahk_exe Anki.exe
GroupAdd, programs, ahk_exe Hyper.exe

;================================================
; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
;================================================
FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%

#SingleInstance Force
#InstallMouseHook
Process, Priority,, B

idle      := 2000 ; ⏳ Max time (ms) before entering full screen — adjust here
margin    := 10   ; Screen boundaries for exiting full screen
tolerance := 4    ; Mouse distance to ignore in full screen
maxWait   := 2000 ; ⏳ Max wait for active window detection — 2s max wait between checks

Loop {
    WinWaitActive, ahk_group programs,, % maxWait/1000
    if !ErrorLevel {
        SoundBeep, 1500

        ; Force fullscreen once immediately if not already
        WinGetPos,,, w, h, A
        if (w != A_ScreenWidth || h != A_ScreenHeight)
            Send, {F11}

        SetTimer, Check, 350
        WinWaitNotActive
        SetTimer, Check, Off
        SoundBeep, 1000
    } else {
        Sleep, 200
    }
}


Check:
CoordMode, Mouse
lastX := x, lastY := y
MouseGetPos, x, y, win, ctrl
WinGetClass, winClass, ahk_id %win%

WinGetPos,,, w, h, A
full     := w = A_ScreenWidth && h = A_ScreenHeight
moved    := Max(Abs(x - lastX), Abs(y - lastY)) > tolerance
inMargin := y < margin || y > A_ScreenHeight - margin

; Block fullscreen entry during address bar / extension use
blockFullscreenEntry := (winClass = "Chrome_WidgetWin_1" && WinActive("ahk_exe chrome.exe"))
if (!full && blockFullscreenEntry)
    return

; Exit fullscreen if mouse moved into margin
if (full && inMargin && moved) {
    Send, {F11}
    justExitedFullscreen := true
}
; Re-enter fullscreen if idle and allowed
else if (!full && A_TimeIdleMouse > idle && !justExitedFullscreen) {
    Send, {F11}
}
; Reset exit-block if mouse is now idle
else if (justExitedFullscreen && A_TimeIdleMouse > idle) {
    justExitedFullscreen := false
}

return



;================================================
; Toggle Pause with F11 or F2
;================================================
~F11::Pause, Toggle
return
~F2::Pause, Toggle
return

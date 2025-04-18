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

;;; Note to myself: 
; Letting everything go full-screen sounds like freedom, but ends in chaos. 
; Keep a whitelist or use a smart filter — your sanity will thank you 😄

#SingleInstance Force
#InstallMouseHook
Process, Priority,, B
idle      = 1000 ; Milliseconds to wait before entering full screen
margin    = 145   ; Screen boundaries for exiting full screen
tolerance = 0    ; Mouse distance to ignore in full screen


Loop {
    WinWaitActive, ahk_group programs
    SoundBeep, 1500
    SetTimer, Check, 350
    WinWaitNotActive
    SetTimer, Check, Off
    SoundBeep, 1000
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

; If we're inside the specified boundaries
; disable **entry** into fullscreen — but still allow **exit**
if (!full && inMargin) {
;    Tooltip, "In margin — blocking fullscreen"
    return
} 
if (!full && !inMargin && A_TimeIdleMouse > idle) {
 ;   Tooltip, "Entering fullscreen"
    Send, {F11}
    return
}
if (full && inMargin && moved) {
;    Tooltip, "Exiting fullscreen"
    Send, {F11}
    return
}
Tooltip
return


;================================================
; Toggle Pause with F11 or F2
;================================================
~F11::Pause, Toggle
return
~F2::Pause, Toggle
return

;================================================
; Toggle Margin Overlay with F9
;================================================
F9::
toggleOverlay := !toggleOverlay
if (toggleOverlay) {
    ; Top Margin
    Gui, MarginOverlay: +AlwaysOnTop -Caption +ToolWindow +E0x20
    Gui, MarginOverlay:Color, Red
    Gui, MarginOverlay:Show, x0 y0 w%A_ScreenWidth% h%margin%, TopBar

    ; Bottom Margin (calculate y-position first)
    bottomY := A_ScreenHeight - margin
    Gui, MarginOverlayBottom: +AlwaysOnTop -Caption +ToolWindow +E0x20
    Gui, MarginOverlayBottom:Color, Red
    Gui, MarginOverlayBottom:Show, x0 y%bottomY% w%A_ScreenWidth% h%margin%, BottomBar
} else {
    Gui, MarginOverlay:Destroy
    Gui, MarginOverlayBottom:Destroy
}
return

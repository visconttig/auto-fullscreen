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


;-----------------------------------------------
; Returns true if the active window is "snapped"
; left or right (half‑screen) on its monitor.
;-----------------------------------------------
IsSnapped() {
    ; Get window rect
    WinGetPos, WX, WY, WW, WH, A
    
    ; Find which monitor it lives on
    hMon :=  DllCall("MonitorFromPoint", "int", WX, "int", WY, "uint", 2, "Ptr")
    
    ; Prepare monitor-info structure (cbSize = 40 bytes)
    VarSetCapacity(mi, 40, 0)
    NumPut(40, mi, 0, "UInt")
    DllCall("GetMonitorInfo", "uint", hMon, "uint", &mi)
    
    workLeft   := NumGet(mi,  8, "Int")
    workTop    := NumGet(mi, 12, "Int")
    workRight  := NumGet(mi, 16, "Int")
    workBottom := NumGet(mi, 20, "Int")
    workW      := workRight - workLeft
    
    ; Calculate half‑width (integer)
    halfW := workW // 2
    
    ; Check for exact half‑width + flush to left/right
    if (WW = halfW) {
        if (WX = workLeft || WX = workLeft + halfW)
            return true
    }
    return false
}


Loop {
    WinWaitActive, ahk_group programs

    if(!IsSnapped()){ ; Only maximize if _not_ snapped / half-screen
        WinMaximize, A ; <-- Maximized by default (needed for certain programs like VSCode)
    }

    SoundBeep, 1500
    SetTimer, Check, 350
    WinWaitNotActive
    SetTimer, Check, Off
    SoundBeep, 1000
}

Check:
if(isSnapped()){
    return ; skip full-screen logic when snapped
}
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

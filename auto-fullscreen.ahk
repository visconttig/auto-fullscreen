;================================================
; WINDOW GROUPS
;================================================
GroupAdd, programs, ahk_exe chrome.exe
GroupAdd, programs, ahk_exe Code.exe
GroupAdd, programs, ahk_exe idea64.exe
GroupAdd, programs, ahk_exe pycharm64.exe
GroupAdd, programs, ahk_exe Hyper.exe
GroupAdd, programs, ahk_exe Postman.exe
GroupAdd, programs, ahk_exe Figma.exe
GroupAdd, programs, ahk_exe Anki.exe
GroupAdd, programs, ahk_exe Cold Turkey Blocker.exe
GroupAdd, programs, ahk_exe Everything.exe
;GroupAdd, programs, ahk_exe ApplicationFrameHost.exe ; Windows 'Settings' panel
;GroupAdd, programs, ahk_exe Explorer.exe ; Windows 'Control Panel' & 'File Explorer'

;================================================
; COPY SCRIPT TO StartUp FOLDER FOR AUTORUNNING
;================================================
; FileCreateShortcut, %A_ScriptFullPath%, %A_Startup%\%A_ScriptName%.lnk, %A_ScriptDir%

;;; Note to myself: 
; Making everything go full-screen sounds like freedom, but ends in chaos. 
; Keep a whitelist or use a smart filter — your sanity will thank you 😄

#SingleInstance Force
#InstallMouseHook
Process, Priority,, B
idle      = 1000 ; Milliseconds to wait before entering full screen
margin    = 45   ; Screen boundaries for exiting full screen
tolerance = 100    ; Mouse distance to ignore in full screen


Loop {
    WinWaitActive, ahk_group programs
    WinMaximize, A ; <-- Maximized by default (needed for certain programs like VSCode)
    SetTimer, Check, 350
    WinWaitNotActive
    SetTimer, Check, Off
}

Check:
CoordMode, Mouse
lastX := x, lastY := y
MouseGetPos, x, y, win, ctrl
WinGetClass, winClass, ahk_id %win%

; Block F11 if any modifier key is down
if ( GetKeyState("Ctrl", "P") 
    || GetKeyState("Alt", "P") 
    || GetKeyState("Shift", "P") 
    || GetKeyState("LWin", "P") 
    || GetKeyState("RWin", "P") ) {
      return
  }



WinGetPos,,, w, h, A
full     := w = A_ScreenWidth && h = A_ScreenHeight
moved    := Max(Abs(x - lastX), Abs(y - lastY)) > tolerance
inMargin := y < margin || y > A_ScreenHeight - margin

; If we're inside the specified boundaries
; disable **entry** into fullscreen — but still allow **exit**
if (!full && inMargin) {
;    In margin — blocking fullscreen
    Sleep, 10000 ; <--- for interacting with pinned extenstions
    return
} 
if (!full && !inMargin && A_TimeIdleMouse > idle) {
 ;  Entering fullscreen
    Send, {F11}
    return
}
if (full && inMargin && moved) {
;    Exiting fullscreen
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
; for pausing without triggering full-screen
+F11::Pause, Toggle 
return

;================================================
; Toggle Margin Overlay with F9
;================================================
; F9::
; toggleOverlay := !toggleOverlay
; if (toggleOverlay) {
;     ; Top Margin
;     Gui, MarginOverlay: +AlwaysOnTop -Caption +ToolWindow +E0x20
;     Gui, MarginOverlay:Color, Red
;     Gui, MarginOverlay:Show, x0 y0 w%A_ScreenWidth% h%margin%, TopBar

;     ; Bottom Margin (calculate y-position first)
;     bottomY := A_ScreenHeight - margin
;     Gui, MarginOverlayBottom: +AlwaysOnTop -Caption +ToolWindow +E0x20
;     Gui, MarginOverlayBottom:Color, Red
;     Gui, MarginOverlayBottom:Show, x0 y%bottomY% w%A_ScreenWidth% h%margin%, BottomBar
; } else {
;     Gui, MarginOverlay:Destroy
;     Gui, MarginOverlayBottom:Destroy
; }
; return

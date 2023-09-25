#InstallKeybdHook
#UseHook on

; vim_mouse_2.ahk
; vim bindings to control the mouse with the keyboard
; 
; Astrid Ivy (tokyo's fork)
; 2019-04-14
;
; Last updated 2023-20-9

global INSERT_MODE := false
global INSERT_QUICK := false
global NORMAL_MODE := true
global NORMAL_QUICK := false
global WASD := false

; mouse speed variables
; 1.8 before 0.982 1.5
global FORCE := 3
global RESISTANCE := 0.982

global VELOCITY_X := 0
global VELOCITY_Y := 0

global POP_UP := true

global DRAGGING := false

; Insert Mode by default
EnterInsertMode()

Accelerate(velocity, pos, neg) {
  If (pos == 0 && neg == 0) {
    Return 0
  }
  ; smooth deceleration 0.666 before:)
  Else If (pos + neg == 0) {
    Return velocity * 1
  }
  ; physicszzzzz
  Else {
    Return velocity * RESISTANCE + FORCE * (pos + neg)
  }
}

MoveCursor() {
  LEFT := 0
  DOWN := 0
  UP := 0
  RIGHT := 0
  
  LEFT := LEFT - GetKeyState("h", "P")
  DOWN := DOWN + GetKeyState("j", "P")
  UP := UP - GetKeyState("k", "P")
  RIGHT := RIGHT + GetKeyState("l", "P")
  
  If (NORMAL_MODE == false) {
    VELOCITY_X := 0
    VELOCITY_Y := 0
    SetTimer,, Off
  }
  
  VELOCITY_X := Accelerate(VELOCITY_X, LEFT, RIGHT)
  VELOCITY_Y := Accelerate(VELOCITY_Y, UP, DOWN)

  RestoreDPI:=DllCall("SetThreadDpiAwarenessContext","ptr",-3,"ptr") ; enable per-monitor DPI awareness

  MouseMove, %VELOCITY_X%, %VELOCITY_Y%, 0, R

}

EnterNormalMode(quick:=false) {
  NORMAL_QUICK := quick

  msg := "keyboard"
  If (WASD == false) {
    msg := msg
  }
  If (quick) {
    msg := msg . " (QUICK)"
  }
  ShowModePopup(msg)

  If (NORMAL_MODE) {
    Return
  }
  NORMAL_MODE := true
  INSERT_MODE := false
  INSERT_QUICK := false

  SetTimer, MoveCursor, 16
}


EnterInsertMode(quick:=false) {
  msg := "normal"
  If (quick) {
    msg := msg 
  }
  ShowModePopup(msg)
  INSERT_MODE := true
  INSERT_QUICK := quick
  NORMAL_MODE := false
  NORMAL_QUICK := false
}

ClickInsert(quick:=true) {
  Click
  EnterInsertMode(quick)
}

; FIXME:
; doesn't really work well
DoubleClickInsert(quick:=true) {
  Click
  Sleep, 100
  Click
  EnterInsertMode(quick)
}

ShowModePopup(msg) {
  ; clean up any lingering popups
  ClosePopup()
  center := MonitorLeftEdge() + (A_ScreenWidth // 2)
  popx := center - 75
  popy := (A_ScreenHeight // 2) - 15
  Progress, b x%popx% y%popy% zh0 w180 h50 fm20,, %msg%,,Colus
  SetTimer, ClosePopup, -1600
  POP_UP := true
}

ClosePopup() {
  Progress, Off
  POP_UP := false
}

Drag() {
  If (DRAGGING) {
    Click, Left, Up
    DRAGGING := false
  } else {
    Click, Left, Down
    DRAGGING := true
  }
}

RightDrag() {
  If (DRAGGING) {
    Click, Right, Up
    DRAGGING := false
  } else {
    Click, Right, Down
    DRAGGING := true
  }
}

MiddleDrag() {
  If (DRAGGING) {
    Click, Middle, Up
    DRAGGING := false
  } else {
    Send, {MButton down}
    DRAGGING := true
  }
}

ReleaseDrag(button) {
  Click, Middle, Up
  Click, button
  DRAGGING := false
}

Yank() {
  wx := 0
  wy := 0
  width := 0
  WinGetPos,wx,wy,width,,A
  center := wx + width - 180
  y := wy + 12
  MouseMove, center, y
  Drag()
}

MouseLeft() {
  Click
  DRAGGING := false
}

MouseRight() {
  Click, Right
  DRAGGING := false
}

MouseMiddle() {
  Click, Middle
  DRAGGING := false
}

JumpMiddle() {
  CoordMode, Mouse, Screen
  MouseMove, (A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

JumpMiddle2() {
  CoordMode, Mouse, Screen
  MouseMove, (A_ScreenWidth + A_ScreenWidth // 2), (A_ScreenHeight // 2)
  ;MouseMove, (- A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

JumpMiddle3() {
  CoordMode, Mouse, Screen
  MouseMove, (A_ScreenWidth * 2 + A_ScreenWidth // 2), (A_ScreenHeight // 2)
  ;MouseMove, (- A_ScreenWidth - A_ScreenWidth // 2), (A_ScreenHeight // 2)
}

MonitorLeftEdge() {
  mx := 0
  CoordMode, Mouse, Screen
  MouseGetPos, mx
  monitor := (mx // A_ScreenWidth)

  return monitor * A_ScreenWidth
}

MouseBack() {
  Click, X1
}

MouseForward() {
  Click, X2
}

ScrollUp() {
  Click, WheelUp
}

ScrollDown() {
  Click, WheelDown
}

ScrollUpMore() {
  Click, WheelUp
  Click, WheelUp
  Click, WheelUp
  Click, WheelUp
  Return
}

ScrollDownMore() {
  Click, WheelDown
  Click, WheelDown
  Click, WheelDown
  Click, WheelDown
  Return
}


; "FINAL" MODE SWITCH BINDINGS
mode := 0

sc029::
    if (mode == 0) {
        ; Enter Insert Mode
        EnterInsertMode()
        mode := 1
    } else {
        ; Enter Normal Mode
        EnterNormalMode()
        mode := 0
    }
return
;<#<!n:: EnterNormalMode()
;<#<!i:: EnterInsertMode()

; escape hatches
+Home:: Send, {Home}
+Insert:: Send, {Insert}


#If (NORMAL_MODE)
  ; focus window and enter Insert
  +`:: ClickInsert(false)
  ; Many paths to Quick Insert
  `:: ClickInsert(true)
  +S:: DoubleClickInsert()
  
  ; passthru to common "search" hotkey
  ~^f:: EnterInsertMode(true)
  ; passthru to Windows key
  ~LWIN:: EnterInsertMode(true)
  ; passthru for new tab
  ~^t:: EnterInsertMode(true)
  ; passthru for quick edits
  ~Delete:: EnterInsertMode(true)
  ; do not pass thru
  +;:: EnterInsertMode(true)
  ; intercept movement keys
  h:: Return
  j:: Return
  k:: Return
  l:: Return
  ; commands
  *i:: MouseLeft()
  *o:: MouseRight()
  *p:: MouseMiddle()
  ; do not conflict with y as in "scroll up"
  +Y:: Yank()
  v:: Drag()
  z:: RightDrag()
  c:: MiddleDrag()
  +M:: JumpMiddle()
  +,:: JumpMiddle2()
  +.:: JumpMiddle3()
  ; ahh what the heck, remove shift requirements for jump bindings
  ; maybe take "m" back if we ever make marks
  m:: JumpMiddle()
  ,:: JumpMiddle2()
  .:: JumpMiddle3()
  n:: MouseForward()
  b:: MouseBack()
  ; allow for modifier keys (or more importantly a lack of them) by lifting ctrl requirement for these hotkeys
  u:: ScrollUpMore()
  End:: Click, Up
  
; Addl Vim hotkeys that conflict with WASD mode
#If (NORMAL_MODE && WASD == false)
  e:: ScrollDown()
  y:: ScrollUp()
  d:: ScrollDownMore()
; No shift requirements in normal quick mode
#If (NORMAL_MODE && NORMAL_QUICK)
  
  m:: JumpMiddle()
  ,:: JumpMiddle2()
  .:: JumpMiddle3()
  y:: Yank()
  ; for windows explorer
#If (NORMAL_MODE && WinActive("ahk_class CabinetWClass"))
  ^h:: Send {Left}
  ^j:: Send {Down}
  ^k:: Send {Up}
  ^l:: Send {Right}
#If (INSERT_MODE)
  ; Normal (Quick) Mode

#If (INSERT_MODE && INSERT_QUICK)
  ~Enter:: EnterNormalMode()
  ; Copy and return to Normal Mode
  ~^c:: EnterNormalMode()
  Escape:: EnterNormalMode()

#IF (DRAGGING)
  LButton:: ReleaseDrag(1)
  MButton:: ReleaseDrag(2)
  RButton:: ReleaseDrag(3)
#If (POP_UP)
  Escape:: ClosePopup()
#If

; FUTURE CONSIDERATIONS
; AwaitKey function for vimesque multi keystroke commands (gg, yy, 2M, etc)
; "Marks" for remembering and restoring mouse positions (needs AwaitKey)
; v to let go of mouse when mouse is down with v (lemme crop in Paint.exe)
; z for click and release middle mouse? this has historically not worked well
; c guess that leaves c for hold / release right mouse (x is useful in chronmium)
; Whatever you can think of! Github issues and pull requests welcome

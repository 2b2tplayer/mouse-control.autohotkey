# mouse-control.autohotkey
AutoHotkey script with Vim bindings to control the mouse with the keyboard

## Why use a mouse control script?
This is my implementation of a hardware mouse, in software. As of 2023 I believe it has full
feature parity with an actual mouse, and has been optimized by daily use for several years.
Whatever your reasons for trying to drive the mouse with the keys, this is my very best attempt
at creating a program to do so, and I hope you find it as pleasant and convenient to use as I do.

#### AS OF (WHENEVER IT WAS) AHK has updated to "Version 2.0"
Luckily it turns out, you can install either version 1.1 or 2.0, as when
you try to run mouse-control.ahk in Version 2, it will happily download the old version
and run it appropriately. 

## Modes of Input
This program has modes of input, allowing the keys to *sometimes* drive the mouse, and
sometimes drive the keyboard (inspired by the text editor Vim). There's "Insert mode"
where the keys behave normally and "Normal mode" intercepting keys to move and control
the mouse instead. (These names are lifted from Vim. I'm aware, "Normal" mode isn't
very normal at all)

`Home` or `Win Alt n` enters Normal mode
`Insert` or `Win Alt i` enters Insert mode

### Normal mode

- `hjkl` move the mouse
- `m`, `,`, `.` jump to center of the screen
- `i` left click
- `o` right click
- `p` middle click
- `v` hold down left click (hit `v` or any mouse button again to release)
- `z` hold down right click (hit `z` or any mouse button again to release)
- `c` hold down middle click (hit `c` or any mouse button again to release)
- `e` scroll down
- `y` scroll up
- `d` scroll down faster
- `u` scroll up faster
- `Y` "yank" a window (reposition it) (press i to release)
- `b` "back" mouse button
- `n` "forward" mouse button
- `~` toggle between modes

### Insert mode

Acts like a normal keyboard.

### Normal "Quick" mode
If you're in persistent Insert mode and just need the mouse keys for a second, you can hold
down Capslock to enter Normal "Quick" mode, which has all the same hotkeys as Normal mode and
ends when Capslock is released.

### Insert "Quick" mode
To quickly edit some text then return to Normal mode, a "quick" mode is also available for Insert.
Great for typing into an address bar or a form field. `Capslock` toggles between Normal and quick
Insert mode.

##### Entering
From Normal mode
- `:` enter QI (Quick Insert mode)
- `Capslock` toggle between QI and Normal mode
- `LWIN` send left windows key to switch to insert mode
- `^f` send ctrl f then enter QI (commonly "search")
- `^t` send ctrl t then enter QI (new tab in the browser)
- `Delete` send Delete then enter QI (for quick fixes)

##### Exiting
From quick Insert mode:
- `^c` exit to Normal mode
- `Enter` send Enter then exit to Normal mode
- `Capslock` toggle between Quick Insert and Normal mode

`Home` enters Normal mode
`Insert` enters regular (persistent) Insert mode

## Last Remarks

#### Alternative to Numpad Mouse
I am aware of the Numpad Mouse feature included in Windows, and consider this a Massive improvement over
the builtin functionality. I'll say that again, for search optimization,
This is an alternative to Numpad Mouse with considerably better usability, and additional functionality.
It is a faster and more convenient alternative to Numpad Mouse. 

#### For Vim Purists
_"Why doesn't `i` take me into Insert mode and `Escape` put me in Normal mode! >:U"_

I made `i` left click. You've got `Win Alt i` which is a nice and unintrusive variant of `i`.
We didn't even used to have that when Win Alt was part of Quick modes so there you go.

`Escape` is too useful a key to bind to anything.  It was infuriating to hit Escape and not have
the expected effect so I took it out.

~ Sorry, nerds :^)

_"How come I can't make my own keybindings >:I"_

I like these ones. You can fork the repo to make your own, or make a pull request if you want to set up
managing an ini file :^)

#### The mouse moves too fast! (or too slow)

At the top of the file, mouse speed is controlled by two global variables, FORCE and RESISTANCE.
FORCE controls acceleration and RESISTANCE causes diminishing returns and implicitly creates a
terminal velocity.

Use the uncompiled .ahk script and you can change these to taste.

## Contact

Bug reports, questions, feature requests, and pull requests are all welcome.
Just open an issue on Github. (Or email me ! Don't be shy I'm really nice)

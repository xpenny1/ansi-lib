#!/usr/bin/env bash

readWaitTime="0.001"

CUU='A'  #Cursor Up	Moves the cursor n (default 1) cells in the given direction. If the cursor is already at the edge of the screen, this has no effect.
CUD='B'  #Cursor Down
CUF='C'  #Cursor Forward
CUB='D'  #Cursor Back
CNL='E'  #Cursor Next Line	Moves cursor to beginning of the line n (default 1) lines down. (not ANSI.SYS)
CPL='F'  #Cursor Previous Line	Moves cursor to beginning of the line n (default 1) lines up. (not ANSI.SYS)
CHA='G'  #Cursor Horizontal Absolute	Moves the cursor to column n (default 1). (not ANSI.SYS)
CUP='H'  #Cursor Position	Moves the cursor to row n, column m. The values are 1-based, and default to 1 (top left corner) if omitted. A sequence such as CSI ;5H is a synonym for CSI 1;5H as well as CSI 17;H is the same as CSI 17H and CSI 17;1H
ED='J'   #Erase in Display	Clears part of the screen. If n is 0 (or missing), clear from cursor to end of screen. If n is 1, clear from cursor to beginning of the screen. If n is 2, clear entire screen (and moves cursor to upper left on DOS ANSI.SYS). If n is 3, clear entire screen and delete all lines saved in the scrollback buffer (this feature was added for xterm and is supported by other terminal applications).
EDA='2J' #Erase in Display - All
EDB='1J' #Erase in Display - Beginning
EDE='J'  #Erase in Display - End
EL='K'   #Erase in Line	Erases part of the line. If n is 0 (or missing), clear from cursor to the end of the line. If n is 1, clear from cursor to beginning of the line. If n is 2, clear entire line. Cursor position does not change.
ELA='2K' #Erase in Line - All
ELB='1K' #Erase in Line - Beginning
ELE='K'  #Erase in Line - End
SU='S'   #Scroll Up	Scroll whole page up by n (default 1) lines. New lines are added at the bottom. (not ANSI.SYS)
SD='T'   #Scroll Down	Scroll whole page down by n (default 1) lines. New lines are added at the top. (not ANSI.SYS)
HVP='f'	 #Horizontal Vertical Position	Same as CUP, but counts as a format effector function (like CR or LF) rather than an editor function (like CUD or CNL). This can lead to different handling in certain terminal modes.[14]: Annex A
SGR='m'	 #Select Graphic Rendition	Sets colors and style of the characters following this code
DSR='6n' #Device Status Report	Reports the cursor position (CPR) by transmitting ESC[n;mR, where n is the row and m is the column.

readCursorPosition() {
    printf "\e[$DSR"
    read -s -n 1 -t $readWaitTime < /dev/tty
    read -s -n 1 -t $readWaitTime < /dev/tty
    local RCPpos RCPchar RCPvar
    while read -t $readWaitTime -s -n 1 RCPchar; do RCPpos="$RCPpos$RCPchar"; done < /dev/tty
    [[ -z $1 ]] && RCPvar="CursorPosition" || RCPvar="$1"
    eval "$RCPvar=\"${RCPpos::-1}\""
}
readTerminalSize() {
    local RTSvar RTSpos RTSmax
    [[ -z $1 ]] && RTSvar="TerminalSize" || RTSvar="$1"
    readCursorPosition RTSpos
    printf "\e[999;999$CUP"
    readCursorPosition RTSmax
    printf "\e[$RTSpos$CUP"
    eval "$RTSvar=\"$RTSmax\""
}

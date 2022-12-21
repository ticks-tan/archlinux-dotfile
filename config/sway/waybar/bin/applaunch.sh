#!/bin/bash
# app launcher
BG="#232730"
FG="#F0F0F0"
SEL_FG="#91C46C"
FONT="Maple Mono 18px"
BEMENU="bemenu -i -H 45 \
	--fb=$BG \
	--nb=$BG \
	--hb=$BG \
	--sb=$BG \
	--fbb=$BG \
	--ab=$BG \
	--tb=$BG \
	--nf=$FG \
	--hf=$SEL_FG \
	--fbf=$FG \
	--sf=$SEL_FG \
	--af=$FG \
	--scf=$FG \
	--fn=$FONT"
env BEMENU_BACKEND=wayland j4-dmenu-desktop --dmenu="${BEMENU}"

exit 0



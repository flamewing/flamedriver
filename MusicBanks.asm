; ===========================================================================
; ║                                                                         ║
; ║                             SONIC&K SOUND DRIVER                        ║
; ║                         Modified SMPS Z80 Type 2 DAC                    ║
; ║                                                                         ║
; ===========================================================================
; Disassembled by MarkeyJester
; Routines, pointers and stuff by Linncaki
; Thoroughly commented and improved (including optional bugfixes) by Flamewing
; ===========================================================================
; Permission to use, copy, modify, and/or distribute this software for any
; purpose with or without fee is hereby granted.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
; OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
; ===========================================================================
; Music Banks
; ===========================================================================
; Music Bank 1
; ---------------------------------------------------------------------------
Mus_Bank1_Start:	startBank
	Music_Master_Table
z80_UniVoiceBank:	include "Sound/UniBank.asm"
MusData_FBZ1:			include	"Sound/Music/FBZ1.asm"
MusData_FBZ2:			include	"Sound/Music/FBZ2.asm"
MusData_MHZ1:			include	"Sound/Music/MHZ1.asm"
MusData_MHZ2:			include	"Sound/Music/MHZ2.asm"
MusData_SOZ1:			include	"Sound/Music/SOZ1.asm"
MusData_SOZ2:			include	"Sound/Music/SOZ2.asm"
MusData_LRZ1:			include	"Sound/Music/LRZ1.asm"
MusData_LRZ2:			include	"Sound/Music/LRZ2.asm"
MusData_SSZ:			include	"Sound/Music/SSZ.asm"
MusData_DEZ1:			include	"Sound/Music/DEZ1.asm"
MusData_DEZ2:			include	"Sound/Music/DEZ2.asm"
MusData_Minib_SK:		include	"Sound/Music/Miniboss.asm"
MusData_Boss:			include	"Sound/Music/Zone Boss.asm"
MusData_DDZ:			include	"Sound/Music/DDZ.asm"
MusData_PachBonus:		include	"Sound/Music/Pachinko.asm"
MusData_SpecialS:		include	"Sound/Music/Special Stage.asm"
MusData_SlotBonus:		include	"Sound/Music/Slots.asm"
MusData_Knux:			include	"Sound/Music/Knuckles.asm"

	finishBank

; ---------------------------------------------------------------------------
; Music Bank 2
; ---------------------------------------------------------------------------
Mus_Bank2_Start:	startBank
	Music_Master_Table
					include "Sound/UniBank.asm"
MusData_Title:			include	"Sound/Music/Title.asm"
MusData_1UP:			include	"Sound/Music/1UP.asm"
MusData_Emerald:		include	"Sound/Music/Chaos Emerald.asm"
MusData_AIZ1:			include	"Sound/Music/AIZ1.asm"
MusData_AIZ2:			include	"Sound/Music/AIZ2.asm"
MusData_HCZ1:			include	"Sound/Music/HCZ1.asm"
MusData_HCZ2:			include	"Sound/Music/HCZ2.asm"
MusData_MGZ1:			include	"Sound/Music/MGZ1.asm"
MusData_MGZ2:			include	"Sound/Music/MGZ2.asm"
MusData_CNZ2:			include	"Sound/Music/CNZ2.asm"
MusData_CNZ1:			include	"Sound/Music/CNZ1.asm"

	finishBank

; ---------------------------------------------------------------------------
; Music Bank 3
; ---------------------------------------------------------------------------
Mus_Bank3_Start:	startBank
	Music_Master_Table
					include "Sound/UniBank.asm"
MusData_ICZ2:			include	"Sound/Music/ICZ2.asm"
MusData_ICZ1:			include	"Sound/Music/ICZ1.asm"
MusData_LBZ2:			include	"Sound/Music/LBZ2.asm"
MusData_LBZ1:			include	"Sound/Music/LBZ1.asm"
MusData_SKCredits:		include	"Sound/Music/Credits.asm"
MusData_GameOver:		include	"Sound/Music/Game Over.asm"
MusData_Continue:		include	"Sound/Music/Continue.asm"
MusData_Results:		include	"Sound/Music/Level Outro.asm"
MusData_Invic:			include	"Sound/Music/Invincible.asm"
MusData_Menu:			include	"Sound/Music/Menu.asm"
MusData_FinalBoss:		include	"Sound/Music/Final Boss.asm"
MusData_PresSega:		include	"Sound/Music/Game Complete.asm"

	finishBank

; ---------------------------------------------------------------------------
; Music Bank 4
; ---------------------------------------------------------------------------
Mus_Bank4_Start:	startBank
	Music_Master_Table
					include "Sound/UniBank.asm"
MusData_GumBonus:		include	"Sound/Music/Gum Ball Machine.asm"
MusData_ALZ:			include	"Sound/Music/Azure Lake.asm"
MusData_BPZ:			include	"Sound/Music/Balloon Park.asm"
MusData_DPZ:			include	"Sound/Music/Desert Palace.asm"
MusData_CGZ:			include	"Sound/Music/Chrome Gadget.asm"
MusData_EMZ:			include	"Sound/Music/Endless Mine.asm"
MusData_S3Credits:		include	"Sound/Music/Sonic 3 Credits.asm"
MusData_2PMenu:			include	"Sound/Music/Competition Menu.asm"
MusData_Drown:			include	"Sound/Music/Countdown.asm"

	finishBank
; ---------------------------------------------------------------------------

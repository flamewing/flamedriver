; ===============================================================
; ---------------------------------------------------------------
; SAMPLE BLASTER v.1.0
; 2013, Vladikcomper
; ---------------------------------------------------------------
;	* 2-channel DPCM playback
;	* Individual 256-step pitch per each channel
;	* Volume control and output filters support
;	* Maximum playback rate of 16 kHz
;	* Software mixer that removes clipping
; ---------------------------------------------------------------

	cpu	z80

; ---------------------------------------------------------------
; Registers Set
; ---------------------------------------------------------------
;
; DPCM A:
;	BC	= Decode table (C = stream byte)
;	D	= Pitch counter
;	E	= Decoded PCM byte
;	HL	= Stream position
;
; DPCM B:
;	A'	= Pitch counter
;	BC'	= Decode table (C = stream byte)
;	DE'	= Volume table (E = decoded byte)
;	HL'	= Stream position
;
; Misc:
;	IX	= 'MainLoop' jump offset
;	IY	=
;
; ---------------------------------------------------------------

; ---------------------------------------------------------------
; Variables
; ---------------------------------------------------------------

; System ports

YM_Port0_Reg	equ	4000h
YM_Port0_Val	equ	4001h
YM_Port1_Reg	equ	4002h
YM_Port1_Val	equ	4003h
BankRegister	equ	6000h
BankBase	equ	8000h

; Dynamic code locations

Pitch_DPCM_A	equ	Update_DPCM_A+1
Pitch_DPCM_B	equ	Update_DPCM_B+3

; ===============================================================
; ---------------------------------------------------------------
; Driver initialization code
; ---------------------------------------------------------------

SoundDriverInit:

	; Setup interrupts
	di
	di
	di
	im	1

	; Init stack
	ld	sp,Stack

	; Init YM
	ld	hl,YM_Port1_Reg
	ld	(hl),0B6h		; B6 C0 - Set pan to LR
	inc	l			;
	ld	(hl),0C0h		;
	ld	de,YM_Port0_Val
	ld	l,0			; hl = YM_Port0_Reg
	ld	a,80h
	ld	(hl),2Bh		; 2B 80h - Enable DAC
	ld	(de),a			;
	ld	(hl),2Ah		; 2A 80h - Start DAC output
	ld	(de),a			;

	; Make init input and play
	jp	SoundDriverInput

; ===============================================================
; ---------------------------------------------------------------
; Subroutine to bankswitch
; ---------------------------------------------------------------

LoadBank:
	push	de
	ld	de,BankRegister

	rept	8
	 ld	(de),a
	 rrca
	endm

        xor	a
        ld	(de),a
	pop	de
	ret

; ===============================================================
; ---------------------------------------------------------------
; Interrupt subroutine that checks for input
; ---------------------------------------------------------------

Interrupt:
	push	af
	ld	a,(Input_Flag)		; load input data
	or	a			; test it
	jr	z,+			; if zero, branch
	xor	a			; clear flag
	ld	(Input_Flag),a		;
	ld	ix,SoundDriverInput	; break the loop
+	pop	af
	ei
	reti

; ===============================================================


















; ===============================================================
; ---------------------------------------------------------------
; Main playback loop
; ---------------------------------------------------------------

MainLoop:

; ---------------------------------------------------------------
Update_DPCM_A:
	
	; Run pitch counter
	ld	a,0h			; 7	; load pitch factor
	add	a,d			; 4	; add pitch counter to it
	ld	d,a			; 4	; store new pitch value
	jr	nc,NoUpdate_DPCM_A	; 7/12	; branch if shouldn't update during this iteration

	; Load decode table and DPCM value
	djnz	SyncDec_DPCM_A		; 8/13	; jump if DPCM byte wasn't fully decoded
	ld	c,(hl)			; 7	; load new DPCM byte from stream
	ld	b,2h			; 7	; reset table position
	inc	hl			; 6	; next stream position
	inc	c			; 4	; increment DPCM byte
	jr	z,Stop_DPCM_A		; 7/12	; if byte was 0FFh (end of stream), branch

GetNibble_DPCM_A:
	; Calculate new PCM value
	ld	a,(bc)			; 7	; load new delta value
	add	a,e			; 4	; add old PCM value to it
	ld	e,a			; 4	; store new PCM value

	; Cycles: 76

; ---------------------------------------------------------------
Update_DPCM_B:
	exx				; 4

	; Run pitch counter
	ex	af,af'			; 4	; load pitch counter
	add	a,0h			; 7	; add pitch to it
	jr	nc,NoUpdate_DPCM_B	; 7/12	; branch if shouldn't update during this iteration
	ex	af,af'			; 4	; store pitch counter back
	
	; Load decode table and DPCM value
	djnz	SyncDec_DPCM_B		; 8/13	; jump if DPCM byte wasn't fully decoded
	ld	c,(hl)			; 7	; load new DPCM byte from stream
	ld	b,2h			; 7	; reset table position
	inc	hl			; 6	; next stream position
	inc	c			; 4	; increment DPCM byte
	jr	z,Stop_DPCM_B		; 7/12	; if byte was 0FFh (end of stream), branch

GetNibble_DPCM_B:
	; Calculate new PCM value
	ld	a,(bc)			; 7	; load new delta value
	add	a,e			; 4	; add old PCM value to it
	ld	e,a			; 4	; store new PCM value

GetVolume_DPCM_B:
	; Apply volume
	ld	a,(de)			; 7	; load volum'd byte from pre-defined table

	; Cycles: 87

; ---------------------------------------------------------------

MixChannels:
	exx				; 4

	add	a,e			; 4	; add two PCM values
	jp	pe,+			; 10	; if overflow, branch
	add	a,80h			; 7	; convert signed value to unsigned
	ld	(YM_Port0_Val),a	; 13	; send to DAC
	jp	(ix)			; 8	; return to the main loop

+	ccf				; 4	; perform magic
	sbc	a,a			; 4	; set A to 00h or FFh depending on overflow direction
	ld	(YM_Port0_Val),a	; 13	; send to DAC
	jp	(ix)			; 8	; return to the main loop

	; Cycles: 46

	; Total cycles:	76+87+46 = 211
	; Playback rate: 3,55 MHz / 211 ~= 16,8 kHz

; ---------------------------------------------------------------
; Loop synchronization code
; ---------------------------------------------------------------

NoUpdate_DPCM_A:	; 49 cycles
	jr	+			; 12
+	jr	+			; 12
+	jr	+			; 12
+	jr	Update_DPCM_B		; 12
	; Cycles: 48

; ---------------------------------------------------------------

NoUpdate_DPCM_B:	; 41 cycles
	ex	af,af'			; 4
	jr	+			; 12
+	jr	+			; 12
+	jr	GetVolume_DPCM_B	; 12
	; Cycles: 40

; ---------------------------------------------------------------

SyncDec_DPCM_A:		 ; 26 cycles
	nop
	jp	+
+	jr	GetNibble_DPCM_A
	; Cycles: 26

; ---------------------------------------------------------------

SyncDec_DPCM_B:		 ; 26 cycles
	nop
	jp	+
+	jr	GetNibble_DPCM_B
	; Cycles: 26

; ---------------------------------------------------------------
; Functions to stop playback
; ---------------------------------------------------------------

Stop_DPCM_A:
	xor	a
	ld	(Pitch_DPCM_A),a	; reset pitch
	ld	d,a			; clear pitch counter
	ld	e,a			; clear PCM sample
	jr	Update_DPCM_B

; ---------------------------------------------------------------
Stop_DPCM_B:
	ex	af,af'
	xor	a			; clear pitch counter
	ld	(Pitch_DPCM_B),a	; reset pitch
	ld	e,a			; clear PCM value
	ex	af,af'
	jr	GetVolume_DPCM_B

; ===============================================================
; ---------------------------------------------------------------
; RAM Variables
; ---------------------------------------------------------------

	org	0E0h

Input_Flag	db	1h		; input flag
Pause_Flag	db	0h		; pause flag (all playback stops)
Bank_Input	db	0h		; loads given bank (if zero, bank is not changed)

DPCM_A_Input	db	1h		; input flag (00h = No Update, 01h = Update/Unpause, 7Fh = Pitch Update, 80h = Stop/Pause)
DPCM_A_Pitch	db	0h		; pitch
DPCM_A_Pos	dw	DPCM_Silence	; start position
DPCM_A_Playing	db	0h		; playback flag

DPCM_B_Input	db	1h		;
DPCM_B_Pitch	db	0h		;
DPCM_B_Pos	dw	DPCM_Silence	;
DPCM_B_Playing	db	0h		;

DPCM_B_Volume	db	7h		; volume level

DPCM_Silence	db	-1h		;


		dw	0,0,0,0
Stack:

; ===============================================================















; ===============================================================
; ---------------------------------------------------------------
; DPCM decode tables
; ---------------------------------------------------------------

	align	100h

	; High nibble
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	db	80h,-40h,-20h,-10h,-8,-4,-2,-1,40h,20h,10h,8,4,2,1,0
	
	; Low nibble
	db	80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h,80h
	db	-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h,-40h
	db	-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h,-20h
	db	-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h,-10h
	db	-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8,-8
	db	-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4,-4
	db	-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2
	db	-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1
	db	40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h,40h
	db	20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h,20h
	db	10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h,10h
	db	8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8
	db	4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4
	db	2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
	db	1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
	db	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0


; ===============================================================
; ---------------------------------------------------------------
; Volume tables / Filters
; ---------------------------------------------------------------

VolumeTables:
	binclude "VolumeTables.bin"

; ===============================================================
; ---------------------------------------------------------------
; Driver control functions
; ---------------------------------------------------------------

SoundDriverInput:
	ld	ix,MainLoop		; revert loop jump offset back

; ---------------------------------------------------------------
PauseLoop:
	ld	a,(Pause_Flag)		; load pause flag
	or	a			; is it set?
	jr	z,Input_Bank		; if not, branch

	push	bc
	ld	b,20h			; set repeat count
	djnz	$			; do 20h idle iterations
	pop	bc
	ld	a,80h			; silence output
	ld	(YM_Port0_Val),a	; send to DAC
	jr	PauseLoop		; repeat

; ---------------------------------------------------------------
Input_Bank:
	ld	a,(Bank_Input)		; load bank
	or	a			; test it
	jr	z,Input_DPCM_A		; if it's zero, branch
	rst	LoadBank		; switch to this bank
	ld	(Bank_Input),a		; clear bank flag

; ===============================================================
Input_DPCM_A:
	ld	a,(DPCM_A_Input)	; load DPCM A input flag
	or	a			; test it
	jr	z,Input_DCPM_B		; if it's zero, branch
	jp	p,Load_DPCM_A

	ld	(DPCM_A_Pos),hl		; remember playback position
	ld	hl,DPCM_Silence		; force silence
	xor	a
	ld	(DPCM_A_Playing),a	; clear DPCM A playing flag
	jr	ResetInput_DPCM_A

; ---------------------------------------------------------------
Load_DPCM_A:
	inc	a
	jp	m,+			; if flag 7Fh, reload pitch only

	ld	b,1h			; force stream byte reload (null decode table)
	ld	de,0h			; reset PCM byte and pitch counter
	ld	hl,(DPCM_A_Pos)		; load stream position

	ld	(DPCM_A_Playing),a	; set DPCM playing flag

+	ld	a,(DPCM_A_Pitch)
	ld	(Pitch_DPCM_A),a	; update pitch

; ---------------------------------------------------------------
ResetInput_DPCM_A:
	xor	a
	ld	(DPCM_A_Input),a	; clear input flag

; ===============================================================
Input_DCPM_B:
	ld	a,(DPCM_B_Input)	; load DPCM B input flag
	or	a			; test it
	jr	z,Input_Done		; if it's zero, branch
	exx
	jp	p,Load_DPCM_B

	ld	(DPCM_B_Pos),hl		; remember playback position
	ld	hl,DPCM_Silence		; force silence
	xor	a
	ld	(DPCM_B_Playing),a	; clear DPCM B playing flag
	jr	ResetInput_DPCM_B

; ---------------------------------------------------------------
Load_DPCM_B:
	inc	a
	jp	m,+			; if flag 7Fh, reload pitch only

	ld	b,1h			; force stream byte reload (null decode table)
	ld	e,0h			; reset PCM byte
	ld	hl,(DPCM_B_Pos)
	ex	af,af'
	xor	a			; reset pitch counter
	ex	af,af'

	ld	(DPCM_B_Playing),a	; set DPCM playing flag

+	ld	a,(DPCM_B_Pitch)
	ld	(Pitch_DPCM_B),a	; update pitch
	ld	a,(DPCM_B_Volume)
	add	a,VolumeTables>>8	; add volume table base offset
	ld	d,a			; update volume

; ---------------------------------------------------------------
ResetInput_DPCM_B:
	exx
	xor	a
	ld	(DPCM_B_Input),a	; clear input flag

; ===============================================================
Input_Done:
	ei
	jp	(ix)			; back to 'MainLoop'

; ===============================================================

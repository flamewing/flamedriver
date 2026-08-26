; ---------------------------------------------------------------
; Registers set
; ---------------------------------------------------------------
;
;	BC	= DPCM decode table (C = sample)
;	DE	= YM Port 0 Data
; 	HL	= Current DPCM byte
;
;	B'	= Pitch counter
;	C'	= Pitch reload value
;	HL'	= Sample size
;
; ---------------------------------------------------------------

	exx

DecodeLoop:
	exx				; 4	; trail-optimization
	ld	c,(hl)			; 7	; load DPCM byte to decode
	ld	a,(bc)			; 7	; decode sample
	inc	b			; 4	; next decode table
	ld	(de),a			; 7	; set sample to DAC
	; Cycles: 29

	exx				; 4
	ld	b,c			; 4	; load pitch
	djnz	$			; 8	; do pitching
	exx				; 4
	; Cycles: 20

	ld	a,(bc)			; 7	; decode sample     
	dec	b			; 4	; pervious decode table
	ld	(de),a			; 7	; set sample to DAC 
	; Cycles: 18

	exx				; 4
	ld	b,c			; 4	; load pitch
	djnz	$			; 8	; do pitching
	dec	l			; 4	; decrease lower byte of sample size
	jp	nz,DecodeLoop		; 10	; if it remains, continue
	; Cycles: 30

	; Total cycles: 29 + 20 + 18 + 30 = 97
	; Max. Playback rate: 3.58 MHz / 48,5 =~ 74 kHz

	dec	h			; 4	; decrease high byter of sample size
	jp	nz,DecodeLoop		; 10	; if it remains, continue

	; <CODE TO STOP PLAYBACK>


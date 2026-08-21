		ld	iy, DecTable					; 14
		; ...
		ld	c, 80h							;  7
		ld	a, (hl)							;  7
		ld	(.sample1_rate+1), a			; 13
		ld	(.sample2_rate+1), a			; 13
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
.dac_playback_loop:
.sample1_rate:
		ld	b, 0Ah							;  7
		ei									;  4
		djnz	$							; 13*(b-1)+8

		di									;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
		ld	a, (hl)							;  7
		rlca								;  4
		rlca								;  4
		rlca								;  4
		rlca								;  4
		and	0Fh								;  7
		ld	(.sample1_index+2), a			; 13
		ld	a, c							;  4
.sample1_index:
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		ld	c, a							;  4
.sample2_rate:
		ld	b, 0Ah							;  7
		ei									;  4
		djnz	$							; 13*(b-1)+8

		di									;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
		ld	a, (hl)							;  7
		and	0Fh								;  7
		ld	(.sample2_index+2), a			; 13
		ld	a, c							;  4
.sample2_index:
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		ei									;  4
		ld	c, a							;  4
		ld	a, (zDACIndex)					; 13
		or	a								;  4
		jp	p, .dac_idle_loop				; 10

		inc	hl								;  6
		dec	de								;  6
		ld	a, d							;  4
		or	e								;  4
		jp	nz, .dac_playback_loop			; 10

		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		ld	iy, DecTable					; 14
		; ...
		ld	f, (hl)							;  7
		ld	f, a							;  4
		; ...
.dac_playback_loop:
		ld	b, f							;  4
		djnz	$							; 13*(b-1)+8

		ld	a, (hl)							;  7
		rlca								;  4
		rlca								;  4
		rlca								;  4
		rlca								;  4
		and	0Fh								;  7
		ld	iyl, a							;  8
		ld	a, c							;  4
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		ld	c, a							;  4
		ld	b, f							;  4
		djnz	$							; 13*(b-1)+8

		ld	a, (hl)							;  7
		and	0Fh								;  7
		ld	iyl, a							;  8
		ld	a, c							;  4
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		ld	c, a							;  4
		ld	a, (zDACIndex)					; 13
		or	a								;  4
		jp	p, .dac_idle_loop				; 10

		inc	hl								;  6
		dec	de								;  6
		ld	a, d							;  4
		or	e								;  4
		jp	nz, .dac_playback_loop			; 10

		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		ld	iy, DecTableHigh				; 14
		ld	ix, DecTable					; 14
		; ...
		ld	b, 80h							;  7
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
.dac_playback_loop:
		ld	a, (hl)							;  7
		ld	iyl, a							;  8
		and	0Fh								;  7
		ld	ixl, a							;  8
		ld	a, b							;  4
		; 34 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		; 44 + rate*13 cycles
		ld	b, a							;  4
		ld	a, (zDACIndex)					; 13
		or	a								;  4
		jp	p, .dac_idle_loop				; 10
		inc	hl								;  6
		dec	de								;  6
		ld	a, b							;  4
		; 47 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (ix+0)						; 19
		ld	b, a							;  4
		ld	(zYM2612_D0), a					; 13
		; 48 + rate*13 cycles
		ld	a, d							;  4
		or	e								;  4
		jp	nz, .dac_playback_loop			; 10
		; 18 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		ld	iy, DecTableHigh				; 14
		ld	ix, DecTable					; 14
		; ...
		ld	b, 80h							;  7
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
.dac_playback_loop:
		ld	a, (hl)							;  7
		ld	iyl, a							;  8
		and	0Fh								;  7
		ld	ixl, a							;  8
		ld	a, b							;  4
		; 34 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		; 44 + rate*13 cycles
		ld	b, a							;  4
		ld	a, (zDACIndex)					; 13
		bit	7,a								;  8
		jr	z, .dac_idle_loop				; T: 12; N: 7
		inc	hl								;  6
		dec	de								;  6
		ld	a, b							;  4
		; 48 cycles if continues, 53 cycles if not
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (ix+0)						; 19
		ld	b, a							;  4
		ld	(zYM2612_D0), a					; 13
		; 48 + rate*13 cycles
		ld	a, d							;  4
		or	e								;  4
		jp	nz, .dac_playback_loop			; 10
		; 18 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		ld	iy, DecTable					; 14
		; ...
		ld	b, 80h							;  7
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
.dac_playback_loop:
		xor	a								;  4
		rld									; 18
		ld	iyl, a							;  8
		ld	a, b							;  4
		; 34 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		; 44 + rate*13 cycles
		ld	b, a							;  4
		ld	a, (zDACIndex)					; 13
		rla									;  4
		jr	nc, .dac_idle_loop				; T: 12; N: 7
		ld	a,(hl)							;  7
		and	0Fh								;  7
		ld	iyl, a							;  8
		ld	a, b							;  4
		inc	hl								;  6
		; 60 cycles if continues, 65 cycles if not
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (iy+0)						; 19
		ld	(zYM2612_D0), a					; 13
		; 44 + rate*13 cycles
		ld	b, a							;  4
		dec	de								;  6
		ld	a, d							;  4
		or	e								;  4
		jp	nz, .dac_playback_loop			; 10
		; 28 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		; ...
		ld	b, 80h							;  7
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	iyl, e							;  8
		ld	iyu, d							;  8
		ld	d, (DecTable>>8)&0FFh			;  7
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
.dac_playback_loop:
		xor	a								;  4
		rld									; 18
		ld	e, a							;  4
		ld	a, b							;  4
		; 30 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (de)							;  7
		ld	b, a							;  4
		ld	(zYM2612_D0), a					; 13
		; 36 + rate*13 cycles
		ld	a, (zDACIndex)					; 13
		; Being deliberately slower here. Using rla / jr nc instead  would be
		; 3 cycles faster, but it would not only unbalance the duration of the
		; samples, but also it would break exact sample rate difference to S&K's
		; DAC loop.
		and	80h								;  7
		jr	z, .dac_idle_loop				; T: 12; N: 7
		ld	a,(hl)							;  7
		and	0Fh								;  7
		ld	e, a							;  4
		ld	a, b							;  4
		inc	hl								;  6
		dec	iy								; 10
		; 65 cycles if continues, 70 cycles if not
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		add	a, (de)							;  7
		ld	(zYM2612_D0), a					; 13
		; 32 + rate*13 cycles
		ld	b, a							;  4
		ld	a, iyl							;  8
		or	iyu								;  8
		jp	nz, .dac_playback_loop			; 10
		; 30 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		; Requires af' to also be saved and restored v-int
		; ...
		ld	a, 80h							;  7
		ex	af, af'							;  4
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	e, (hl)							;  7
		inc	hl								;  6
		ld	d, (hl)							;  7
		inc	hl								;  6
		ld	iyl, e							;  8
		ld	iyu, d							;  8
		ld	d, (DecTable>>8)&0FFh			;  7
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
.dac_playback_loop:
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		xor	a								;  4
		rld									; 18
		ld	e, a							;  4
		ld	a, (zDACIndex)					; 13
		ex	af, af'							;  4
		add	a, (de)							;  7
		ld	(zYM2612_D0), a					; 13
		; 75 + rate*13 cycles
		ld	b, c							;  4
		djnz	$							; 13*(b-1)+8
		; Being deliberately slower here. Using rla / jr nc instead  would be
		; 3 cycles faster, but it would not only unbalance the duration of the
		; samples, but also it would break exact sample rate difference to S&K's
		; DAC loop.
		ex	af, af'							;  4
		and	80h								;  7
		jr	z, .dac_idle_loop				; T: 12; N: 7
		ld	a,(hl)							;  7
		and	0Fh								;  7
		ld	e, a							;  4
		inc	hl								;  6
		dec	iy								; 10
		ld	a, iyl							;  8
		ex	af, af'							;  4
		add	a, (de)							;  7
		ld	(zYM2612_D0), a					; 13
		; 96 cycles if continues, 101 cycles if not
		ex	af, af'							;  4
		or	iyu								;  8
		jp	nz, .dac_playback_loop			; 10
		; 22 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
		; Requires af', bc' to also be saved and restored v-int
		ld	d, (DecTable>>8)&0FFh			;  7
		; ...
		ld	a, 80h							;  7
		ex	af, af'							;  4
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		ld	iyl, a							;  8
		inc	hl								;  6
		ld	a, (hl)							;  7
		ld	iyu, a							;  8
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
		ld	b, c							;  4
.dac_playback_loop:
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		xor	a								;  4
		rld									; 18
		ld	e, a							;  4
		ld	a, (zDACIndex)					; 13
		ex	af, af'							;  4
		ex	hl, de							;  4
		add	a, (hl)							;  7
		ld	(zYM2612_D0), a					; 13
		; 79 + rate*13 cycles
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		ex	af, af'							;  4
		rla									;  4
		jr	nc, .dac_idle_loop				; T: 12; N: 7
		ld	a,(de)							;  7
		and	0Fh								;  7
		ld	l, a							;  4
		inc	de								;  6
		dec	iy								; 10
		ld	a, iyl							;  8
		ex	af, af'							;  4
		add	a, (hl)							;  7
		ex	hl, de							;  4
		ld	(zYM2612_D0), a					; 13
		; 97 cycles if continues, 101 cycles if not
		ex	af, af'							;  4
		or	iyu								;  8
		jp	nz, .dac_playback_loop			; 10
		; 22 cycles
		xor	a								;  4
		ld	(zDACIndex),a					; 13
		jp	zPlayDigitalAudio				; 10
; ===========================================================================
zVInt:	rsttarget
		di									; Disable interrupts
		push	af							; Save af
		ex	af, af'							; Swap to shadow registers
		push	af							; Save af
		push	iy							; Save iy
		exx									; Save bc,de,hl

.doupdate:
		call	zUpdateEverything			; Update all tracks
		ld	a, (zPalFlag)					; Get PAL flag
		or	a								; Is it set?
		jr	z, .not_pal						; Branch if not (NTSC)
		ld	a, (zPalDblUpdCounter)			; Get PAL double-update timeout counter
		or	a								; Is it zero?
		jr	nz, .pal_timer					; Branch if not
		ld	a, 5							; Set it back to 5...
		ld	(zPalDblUpdCounter), a			; ... and save it
		jp	.doupdate						; Go again

.pal_timer:
		dec	a								; Decrease PAL double-update timeout counter
		ld	(zPalDblUpdCounter), a			; Store it

.not_pal:
		ld	a, (zDACIndex)					; Get index of playing DAC sample
		and	7Fh								; Strip 'DAC playing' bit
		ld	c, a							; c = a
		ld	b, 0							; Sign extend c to bc
		ld	hl, DAC_Banks					; Make hl point to DAC bank table
		add	hl, bc							; Offset into entry for current sample
		ld	a, (hl)							; Get bank index
		bankswitch1							; Switch to current DAC sample's bank
		exx									; Restore bc,de,hl
		pop	iy								; Restore iy
		ld	a, 2Ah							; DAC channel register
		ld	(zYM2612_A0), a					; Send to YM2612
		pop	af								; Restore af
		ex	af, af'							; Swap to shadow registers
		pop	af								; Restore af
		ld	b, 1							; b = 1
		ei
		ret
; ---------------------------------------------------------------------------
		; Requires af', bc' to also be saved and restored v-int
		ld	d, (DecTable>>8)&0FFh			; d = high byte of JMan2050 decode table
		; ...
		ld	a, 80h							; a is an accumulator below; this initializes it to 80h
		ex	af, af'							; Save to shadow
		ld	c, (hl)							; c = DAC rate
		inc	hl								; hl = pointer to low byte of DAC sample's length
		ld	a, (hl)							; a = low byte of DAC sample's length
		ld	iyl, a							; iyl = low byte of DAC sample's length
		inc	hl								; hl = pointer to high byte of DAC sample's length
		ld	a, (hl)							; a = high byte of DAC sample's length
		ld	iyu, a							; iy = DAC sample's length
		inc	hl								; hl = pointer to low byte of DAC sample's in-bank location
		ld	a, (hl)							; a = low byte of DAC sample's in-bank location
		inc	hl								; hl = pointer to high byte of DAC sample's in-bank location
		ld	h, (hl)							; h = high byte of DAC sample's in-bank location
		ld	l, a							; hl = DAC sample's in-bank location
		ld	a, 2Ah							; DAC channel register
		ld	(zYM2612_A0), a					; Send to YM2612
		; hl is now pointer to DAC data, while de is the DAC sample's length
		ld	b, c							; b = DAC rate

.dac_playback_loop:
		djnz	$							; Loop in this instruction, decrementing b each iteration, until b = 0
		ld	b, c							; b = DAC rate
		xor	a								; Clear a
		rld									; low 4-bits of a = high 4 bits of (hl)
		ld	e, a							; de = index of delta for sample
		ld	a, (zDACIndex)					; a = DAC index/flag
		ex	af, af'							; Save to shadow and fetch sample accumulator
		ex	hl, de							; de = pointer to sample data; hl = pointer to sample delta
		add	a, (hl)							; Accumulate delta into sample
		ld	(zYM2612_D0), a					; Send byte to DAC
		; 79 + rate*13 cycles
		djnz	$							; Loop in this instruction, decrementing b each iteration, until b = 0
		ld	b, c							; b = DAC rate
		ex	af, af'							; Save sample accumulator to shadow and fetch DAC index/flag
		rla									; Shift sign bit to carry
		jr	nc, .dac_idle_loop				; Branch if sign bit was clear (we have a new sample to play)
		ld	a,(de)							; a = next byte of DAC sample
		and	0Fh								; Want only the low nibble
		ld	l, a							; hl = index of delta for sample
		inc	de								; Advance to next sample byte
		dec	iy								; Mark one byte as being done
		ld	a, iyl							; Get low byte of byte count
		ex	af, af'							; Save to shadow and fetch sample accumulator
		add	a, (hl)							; Accumulate delta into sample
		ex	hl, de							; de = pointer to sample delta; hl = pointer to sample data
		ld	(zYM2612_D0), a					; Send byte to DAC
		; 97 cycles if continues, less if not
		ex	af, af'							; Save sample accumulator to shadow and fetch low byte of byte count
		or	iyu								; Is byte count zero?
		jp	nz, .dac_playback_loop			; Loop if not
		; 22 cycles
		xor	a								; a = 0
		ld	(zDACIndex),a					; Mark DAC as being idle
		jp	zPlayDigitalAudio				; Loop
; ===========================================================================
zVInt:	rsttarget
		di									; Disable interrupts
		push	af							; Save af
		ex	af, af'							; Swap to shadow registers
		push	af							; Save af
		push	bc
		push	de
		push	hl
		;push	iy							; Save iy
		;exx									; Save bc,de,hl

.doupdate:
		call	zUpdateEverything			; Update all tracks
		ld	a, (zPalFlag)					; Get PAL flag
		or	a								; Is it set?
		jr	z, .not_pal						; Branch if not (NTSC)
		ld	a, (zPalDblUpdCounter)			; Get PAL double-update timeout counter
		or	a								; Is it zero?
		jr	nz, .pal_timer					; Branch if not
		ld	a, 5							; Set it back to 5...
		ld	(zPalDblUpdCounter), a			; ... and save it
		jp	.doupdate						; Go again

.pal_timer:
		dec	a								; Decrease PAL double-update timeout counter
		ld	(zPalDblUpdCounter), a			; Store it

.not_pal:
		ld	a, (zDACIndex)					; Get index of playing DAC sample
		and	7Fh								; Strip 'DAC playing' bit
		ld	c, a							; c = a
		ld	b, 0							; Sign extend c to bc
		ld	hl, DAC_Banks					; Make hl point to DAC bank table
		add	hl, bc							; Offset into entry for current sample
		ld	a, (hl)							; Get bank index
		bankswitch1							; Switch to current DAC sample's bank
		;exx									; Restore bc,de,hl
		;pop	iy								; Restore iy
		pop	hl
		pop	de
		pop	bc
		ld	a, (DecTable>>8)&0FFh
		cp	h
		jr	z, .breakloop
		exx
		ld	b, 1							; b = 1
		exx
		jr	.finish_vint

.breakloop:
		ld	b, 1							; b = 1

.finish_vint:
		ld	a, 2Ah							; DAC channel register
		ld	(zYM2612_A0), a					; Send to YM2612
		pop	af								; Restore af
		ex	af, af'							; Swap to shadow registers
		pop	af								; Restore af
		;ld	b, 1							; b = 1
		ei
		ret
; ---------------------------------------------------------------------------
;	bc	DAC sample's length
;	de	zDACIndex
;	hl	DAC sample's in-bank location
;
;	bc'	counter<<8|rate
;	de'	zYM2612_D0
;	hl'	((DecTable>>8)&0FFh)<<8|xx
		; Requires af', bc', de', hl' to also be saved and restored v-int
		; ...
		ld	a, 80h							;  7
		ex	af, af'							;  4
		ld	c, (hl)							;  7
		push	bc							; 11
		inc	hl								;  6
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	b, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	de, zDACIndex					; 10
		exx									;  4		; Select shadow set
		pop	bc								; 10
		ld	de, zYM2612_D0					; 10
		ld	h, (DecTable>>8)&0FFh			;  7
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
		ld	b, c							;  4
		exx									;  4		; Select normal set
.dac_playback_loop:
		xor	a								;  4
		rld									; 18
		exx									;  4		; Select shadow set
		ld	l, a							;  4
		ex	af, af'							;  4
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		add	a, (hl)							;  7
		ld	(de), a							;  7
		; 60 + rate*13 cycles
		exx									;  4		; Select normal set
		ex	af, af'							;  4
		ld	a, (de)							;  7
		rla									;  4
		jr	nc, .dac_idle_loop				; T: 12; N: 7
		ld	a,(hl)							;  7
		and	0Fh								;  7
		cpi									; 16
		exx									;  4		; Select shadow set
		ld	l, a							;  4
		ex	af, af'							;  4
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		add	a, (hl)							;  7
		ld	(de), a							;  7
		; 94 + rate*13 cycles cycles if continues, less if not
		exx									;  4		; Select normal set
		ex	af, af'							;  4
		jp	pe, .dac_playback_loop			; 10
		; 18 cycles
		; Automatic bank-switching goes here
		xor	a								;  4
		ld	(de),a							;  7
		jp	zPlayDigitalAudio				; 10
; ===========================================================================




; ===========================================================================
;	bc	DAC sample's length
;	de	zYM2612_D0
;	hl	DAC sample's in-bank location
;
;	bc'	counter<<8|rate
;	de	zDACIndex
;	hl'	((DecTable>>8)&0FFh)<<8|xx
		; ...
		ld	c, (hl)							;  7
		push	bc							; 11
		inc	hl								;  6
		ld	c, (hl)							;  7
		inc	hl								;  6
		ld	b, (hl)							;  7
		inc	hl								;  6
		ld	a, (hl)							;  7
		inc	hl								;  6
		ld	h, (hl)							;  7
		ld	l, a							;  4
		ld	de, zYM2612_D0					; 10
		exx									;  4		; Select shadow set
		pop	bc								; 10
		ld	de, zDACIndex					; 10
		ld	h, (DecTable>>8)&0FFh			;  7
		ld	a, 2Ah							;  7
		ld	(zYM2612_A0), a					; 13
		ld	b, c							;  4
		exx									;  4		; Select normal set
.pcm_playback_loop:
		exx									;  4		; Select shadow set
		ld	a, (de)							;  7
		rla									;  4
		jr	nc, .dac_idle_loop				; T: 12; N: 7
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		exx									;  4		; Select normal set
		ldi									; 16
		; dec e is 2 cycles faster, but alters flags
		dec	de								;  6
		jp	pe, .pcm_playback_loop			; 10
		; 70 cycles
		exx									;  4		; Select shadow set
		xor	a								;  4
		ld	(de),a							;  7
		jp	zPlayDigitalAudio				; 10
; ===========================================================================








; ===========================================================================
; function to turn a 68k address into a z80 bank byte
k68z80Bank function addr,(((addr&$3F8000)/zROMWindow))
dpcm := 0
pcm := 1
wav := 2
; Special BINCLUDE wrapper function
DACBINCLUDE macro file,type,path,{INTLABEL}
	if k68z80Bank(*)<>k68z80Bank(*+6)
		align	$8000
	endif
__LABEL__ label *
__LABEL___Bank  := k68z80Bank(__LABEL__)
LastBank  := k68z80Bank(__LABEL___End-1)
bankSpace := (__LABEL__|$7FFF)-__LABEL___Data+1
__LABEL___Len  := __LABEL___End-__LABEL___Data
__LABEL___Ptr  := k68z80Pointer(__LABEL__-soundBankStart)
	if MOMPASS=1
InitLen   := __LABEL___Len
LastLen   := 0
	else
	if __LABEL___Len>bankSpace
InitLen   := bankSpace
LastLen   := (__LABEL___Len-bankSpace)&$7FFF
	else
InitLen   := __LABEL___Len
LastLen   := 0
	endif
	endif
	dc.b	type,LastBank-__LABEL___Bank	; Type, Bank count-1
	dc.w	little_endian(InitLen)			; Length to end of first bank
	dc.w	little_endian(LastLen)			; Length in last bank
__LABEL___Data:
	if "path"<>""
		if "type"=="wav"
			BINCLUDE "Sound/DAC/path/file",$3A
		else
			BINCLUDE "Sound/DAC/path/file"
		endif
	else
		if "type"=="wav"
			BINCLUDE "Sound/DAC/file",$3A
		else
			BINCLUDE "Sound/DAC/file"
		endif
	endif
__LABEL___End:
    endm
; Setup macro for DAC samples.
DAC_Setup macro dacptr,rate
	dc.b	dacptr_Bank,rate
	dc.w	dacptr_Ptr
    endm
; ---------------------------------------------------------------------------
zVInt:	rsttarget
		di									; Disable interrupts
		push	af							; Save af
		ex	af, af'							; Swap to shadow registers
		push	af							; Save af
		push	bc
		push	de
		push	hl

.doupdate:
		call	zUpdateEverything			; Update all tracks
		ld	a, (zPalFlag)					; Get PAL flag
		or	a								; Is it set?
		jr	z, .not_pal						; Branch if not (NTSC)
		ld	a, (zPalDblUpdCounter)			; Get PAL double-update timeout counter
		or	a								; Is it zero?
		jr	nz, .pal_timer					; Branch if not
		ld	a, 5							; Set it back to 5...
		ld	(zPalDblUpdCounter), a			; ... and save it
		jp	.doupdate						; Go again

.pal_timer:
		dec	a								; Decrease PAL double-update timeout counter
		ld	(zPalDblUpdCounter), a			; Store it

.not_pal:
		ld	a, (DACBank)					; Get bank index
		bankswitch							; Switch to current DAC sample's bank
		ld	a, (zDACIndex)					; Get index of playing DAC sample
		or	a								; Is it negative?
		jp	m, .keep_playing				; Branch if yes (keep playing sample)
		ld	sp, z80_stack					; set the stack pointer to 0x2000 (end of z80 RAM)
		ei
		jp	zPlayDigitalAudio.dac_idle_loop	; Branch to play new DAC
; ---------------------------------------------------------------------------
.keep_playing:
		pop	hl
		pop	de
		pop	bc
		ld	a, (DecTable>>8)&0FFh			; a = high byte of pointer to DecTable
		cp	h								; Is h equal to this?
		jr	nz, .breakloop					; Branch if not
		ld	b, 1							; Set remaining delay to 1
		jr	.finish_vint
; ---------------------------------------------------------------------------
.breakloop:
		exx									; Swap to shadow set
		ld	b, 1							; Set remaining delay to 1
		exx									; Swap back to normal set

.finish_vint:
		ld	a, 2Ah							; DAC channel register
		ld	(zYM2612_A0), a					; Send to YM2612
		pop	af								; Restore af
		ex	af, af'							; Swap to shadow registers
		pop	af								; Restore af
		ei
		ret
; ---------------------------------------------------------------------------
;	a	Last sample
;	bc	DAC sample's length
;	de	zYM2612_D0
;	hl	DAC sample's in-bank location
;
;	a'	Scratch
;	bc'	counter<<8|rate
;	de'	(bank count<<8)|(bank index)
;	hl'	((DecTable>>8)&0FFh)<<8|xx
		; Requires af', bc', de', hl' to also be saved and restored v-int
		; ...
		ld	a, 2Bh							; DAC enable/disable register
		ld	c, 80h							; Value to enable DAC
		di									; Disable interrupts
		call	zWriteFMI					; Send YM2612 command
		ld	iy, DecTable					; iy = pointer to jman2050 decode lookup table
		ld	hl, zDACIndex					; hl = pointer to DAC index/flag
		ld	a, (hl)							; a = DAC index
		dec	a								; a -= 1
		set	7, (hl)							; Set bit 7 to indicate that DAC sample is being played
		ld	hl, zDACMasterTable				; hl = pointer to DAC Master table
		rst	PointerTableOffset				; hl = pointer to DAC data
		ld	e, (hl)							; e = DAC sample's first bank index
		inc	hl								; hl = pointer to DAC sample's playback rate
		ld	c, (hl)							; c = DAC sample's playback rate
		ld	b, c							; Copy it over to b
		inc	hl								; hl = pointer to low byte of DAC sample's in-bank location
		ld	a, (hl)							; a = low byte of DAC sample's in-bank location
		inc	hl								; hl = pointer to high byte of DAC sample's in-bank location
		ld	h, (hl)							; h = high byte of DAC sample's in-bank location
		ld	l, a							; hl = pointer to DAC sample's in-bank location
		ld	a, (hl)							; a = DAC type (zero = DPCM, nonzero = PCM)
		ex	af, af'							; Save DAC type for later
		inc	hl								; hl = pointer to DAC sample's bank count
		ld	d, (hl)							; d = DAC sample's bank count
		inc	hl								; hl = pointer to low byte of DAC sample's first-bank size
		push	hl							; Save hl
		ld	h, (DecTable>>8)&0FFh			; h = high byte of JMan2050 decode table
		exx									; Select normal set
		pop	hl								; Restore to hl
		ld	c, (hl)							; c = low byte of DAC sample's first-bank size
		inc	hl								; hl = pointer to high byte of DAC sample's first-bank size
		ld	b, (hl)							; b = high byte of DAC sample's first-bank size
		inc	hl								; hl = pointer to low byte of DAC sample's last-bank size
		ld	e, (hl)							; c = low byte of DAC sample's last-bank size
		inc	hl								; hl = pointer to high byte of DAC sample's last-bank size
		ld	d, (hl)							; b = high byte of DAC sample's last-bank size
		inc	hl								; hl = pointer to DAC sample's data
		ld	(DACLastLen), de				; Save to RAM
		ld	de, zYM2612_D0					; de = pointer to data port
		ld	a, 2Ah							; DAC channel register
		ld	(zYM2612_A0), a					; Send to YM2612
		ld	a, 80h							; a is a DPCM accumulator below; this initializes it to 80h
		ei									; Re-enable interrupts
		ex	af, af'							; Save accumulator and fetch type flag
		or	a								; Are we playing DPCM?
		jp	nz, PlayPCM						; Branch if not
		xor	a								; Clear a for below
		ld	i, a							; Make sure i = 0
.dpcm_playback_loop:
		ld	a, i							;  9		; Waste time, slow clear
		rld									; 18
		exx									;  4		; Select shadow set
		ld	l, a							;  4
		ex	af, af'							;  4
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		add	a, (hl)							;  7
		exx									;  4		; Select normal set
		ld	(de), a							;  7
		; 69 + rate*13 cycles
		ex	af, af'							;  4
		nop									;  4		; Waste time
		nop									;  4		; Waste time
		ld	a, (hl)							;  7
		and	0Fh								;  7
		cpi									; 16
		exx									;  4		; Select shadow set
		ld	l, a							;  4
		ex	af, af'							;  4
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		add	a, (hl)							;  7
		exx									;  4		; Select normal set
		ld	(de), a							;  7
		; 84 + rate*13 cycles
		ex	af, af'							;  4
		jp	pe, .dpcm_playback_loop			; 10
		; 14 cycles
		call	zPCMBankSwitch				; 17
		jp	.dpcm_playback_loop				; 10
; ---------------------------------------------------------------------------
PlayPCM:
.pcm_playback_loop:
		exx									;  4		; Select shadow set
		djnz	$							; 13*(b-1)+8
		ld	b, c							;  4
		exx									;  4		; Select normal set
		ldi									; 16
		ex	af, af'							;  4		; Save flags / waste time
		dec	e								;  4
		ex	af, af'							;  4		; Restore flags / waste time
		jp	pe, .pcm_playback_loop			; 10
		; 58 cycles
		call	zPCMBankSwitch				; 17
		jp	.pcm_playback_loop				; 10
; ---------------------------------------------------------------------------
zPCMBankSwitch:
		; Normal set, a is scratch register
		exx									;  4			; Select shadow set
		inc	e								;  4			; Increment next bank
		ld	a, e							;  4			; Copy to a
		dec	d								;  4			; As fast as copying a to d
		exx									;  4			; Select normal set
		jp	m, .done						; 10			; If nonzero, we are not yet on the last bank
		jp	nz, .notlast					; 10			; If nonzero, we are not yet on the last bank
		ld	bc, (DACLastLen)				; 20			; Load length for last bank
		jp	.do_bankswitch					; 10
.notlast:
		inc	ix								; 10			; Waste time
		dec	ix								; 10			; Waste time
		ld	bc, 0							; 10			; Waste time

.do_bankswitch:
		di									;  4			; For safety
		ld	(DACBank), a					; 13			; Save for V-Int
		bankswitch							; 105
		ld	h, (zROMWindow>>8)&0FFh			;  7			; Point to start of next bank
		ei									;  4
		ret									; 10
		; NT: 208; NN: 208
; ---------------------------------------------------------------------------
.done:
		pop	hl								; Remove return address from stack
		xor	a								; a = 0
		ld	(zDACIndex), a					; Mark DAC as being idle
		jp	zPlayDigitalAudio				; Loop
; ===========================================================================




; For the loops that use it:
; ===========================================================================
; JMan2050's DAC decode lookup table for use with high nibble
; ===========================================================================
	align 100h
DecTableHigh:
		db	16 dup (   0)
		db	16 dup (   1)
		db	16 dup (   2)
		db	16 dup (   4)
		db	16 dup (   8)
		db	16 dup ( 10h)
		db	16 dup ( 20h)
		db	16 dup ( 40h)
		db	16 dup ( 80h)
		db	16 dup (  -1)
		db	16 dup (  -2)
		db	16 dup (  -4)
		db	16 dup (  -8)
		db	16 dup (-10h)
		db	16 dup (-20h)
		db	16 dup (-40h)
; ===========================================================================
; JMan2050's DAC decode lookup table
; ===========================================================================
DecTable:
		db	   0,  1,   2,   4,   8,  10h,  20h,  40h
		db	 80h, -1,  -2,  -4,  -8, -10h, -20h, -40h
; ===========================================================================


Snd_LevSel_Header:
	smpsHeaderStartSong 3
	smpsHeaderVoice     Snd_LevSel_Voices
	smpsHeaderChan      $06, $03
	smpsHeaderTempo     $01, $58

	smpsHeaderDAC       Snd_LevSel_DAC
	smpsHeaderFM        Snd_LevSel_FM1,	$18, $12
	smpsHeaderFM        Snd_LevSel_FM2,	$18, $10
	smpsHeaderFM        Snd_LevSel_FM3,	$0C, $14
	smpsHeaderFM        Snd_LevSel_FM4,	$0C, $0E
	smpsHeaderFM        Snd_LevSel_FM5,	$0C, $0E
	smpsHeaderPSG       Snd_LevSel_PSG1,	$F4, $04, $00, sTone_0C
	smpsHeaderPSG       Snd_LevSel_PSG2,	$F4, $04, $00, sTone_0C
	smpsHeaderPSG       Snd_LevSel_PSG3,	$00, $03, $00, sTone_0C

; DAC Data
Snd_LevSel_DAC:
	dc.b	dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, dSnareS3, nRst, $08, dSnareS3, $02, dSnareS3
	dc.b	dSnareS3, $04, dSnareS3, dSnareS3

Snd_LevSel_Jump00:
	dc.b	dKickS3, nRst, dKickS3, dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst
	dc.b	dKickS3, nRst, $08, dKickS3, $04, dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3
	dc.b	dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, $08, dKickS3, $04
	dc.b	nRst, dKickS3, dSnareS3, nRst, dKickS3, nRst, $08, dKickS3, $04, dSnareS3, nRst, $08
	dc.b	dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3
	dc.b	nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, dKickS3, nRst, $08, dKickS3
	dc.b	$04, dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, $08, dKickS3
	dc.b	$04, nRst, dKickS3, dSnareS3, nRst, $08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst
	dc.b	$08, dKickS3, $04, nRst, dKickS3, dSnareS3, nRst, dSnareS3, nRst, $08, dSnareS3, $02
	dc.b	dSnareS3, dSnareS3, $04, dSnareS3, dSnareS3
	smpsJump            Snd_LevSel_Jump00

; FM1 Data
Snd_LevSel_FM1:
	smpsSetvoice        $03
	smpsAlterNote       $FE
	smpsModSet          $0F, $01, $06, $06
	smpsAlterNote       $01
	smpsPan             panRight, $00
	smpsCall            Snd_LevSel_Call00

Snd_LevSel_Call00:
	dc.b	nRst, $08, nEb4, $04, nE4, $08, nC4, $04, nD4, $08, nC4, $04
	dc.b	nA3, $08, nC4, $04

Snd_LevSel_Jump04:
	dc.b	nRst, $14, nBb3, $02, nC4, $0E, nA3, $04, nRst, $08, nG3, $0C
	dc.b	nA3, $08, nEb3, $02, nE3, nG3, $08, nA3, $04, nRst, $20, nBb3
	dc.b	$02, nC4, $0E, nA3, $04, nRst, $08, nEb3, $0C, nD3, $08, nC3
	dc.b	$04, nRst, $24, nA2, $0C, nC3, nD3, $08, nEb3, $0C, nD3, $04
	dc.b	nEb3, $08, nD3, $04, nEb3, $08, nD3, $04, nC3, $08, nRst, $0C
	dc.b	nEb4, $04, nE4, $08, nC4, $04, nD4, $08, nC4, $04, nRst, $08
	dc.b	nEb4, $04, nRst, $08, nEb4, $04, nE4, $08, nC4, $04, nD4, $08
	dc.b	nC4, $04, nA3, $08, nC4, $04
	smpsJump            Snd_LevSel_Jump04

; FM2 Data
Snd_LevSel_FM2:
	smpsSetvoice        $14
	smpsAlterNote       $00
	smpsModSet          $02, $01, $01, $02
	dc.b	nF1, $0B, nRst, $01, nFs1, $07, nRst, $01, nG1, $03, nRst, $09
	dc.b	nG0, $03, nRst, $01, nG0, $0B, nRst, $01

Snd_LevSel_Jump03:
	dc.b	nC1, $0B, nRst, $01, nE1, $0B, nRst, $01, nF1, $0B, nRst, $01
	dc.b	nFs1, $07, nRst, $01, nG1, $03, nRst, $09, nG1, $03, nRst, $01
	dc.b	nC1, $0B, nRst, $01, nE1, $0B, nRst, $01, nC1, $0B, nRst, $01
	dc.b	nA0, $0B, nRst, $01, nC1, $0B, nRst, $01, nD1, $0B, nRst, $01
	dc.b	nEb1, $07, nRst, $01, nE1, $03, nRst, $09, nE1, $03, nRst, $01
	dc.b	nA0, $0B, nRst, $01, nC1, $0B, nRst, $01, nA0, $0B, nRst, $01
	dc.b	nF0, $0B, nRst, $01, nA0, $0B, nRst, $01, nC1, $0B, nRst, $01
	dc.b	nD1, $07, nRst, $01, nEb1, $03, nRst, $09, nEb1, $03, nRst, $01
	dc.b	nC1, $0B, nRst, $01, nA0, $0B, nRst, $01, nF0, $0B, nRst, $01
	dc.b	nD1, $07, nRst, $01, nD1, $03, nRst, $01, nD1, $0B, nRst, $01
	dc.b	nE1, $07, nRst, $01, nE1, $03, nRst, $01, nE1, $0B, nRst, $01
	dc.b	nF1, $0B, nRst, $01, nFs1, $07, nRst, $01, nG1, $03, nRst, $09
	dc.b	nG0, $03, nRst, $01, nG0, $0B, nRst, $01
	smpsJump            Snd_LevSel_Jump03

; FM3 Data
Snd_LevSel_FM3:
	smpsSetvoice        $08
	smpsAlterNote       $01
	smpsModSet          $0F, $01, $06, $06
	smpsAlterNote       $FF
	smpsPan             panLeft, $00
	dc.b	nRst, $01
	smpsCall            Snd_LevSel_Call00
	smpsStop

; FM4 Data
Snd_LevSel_FM4:
	smpsSetvoice        $06
	smpsAlterNote       $01
	smpsModSet          $0A, $01, $03, $06
	dc.b	nRst, $2C, nG3, $03, nRst, $01

Snd_LevSel_Jump02:
	dc.b	nRst, $08, nG3, $0A, nF3, $01, nE3, nD3, nC3, nBb2, nA2, nG2
	dc.b	nF2, nE2, nD2, nRst, $38, nG3, $08, nE3, $03, nRst, $09, nE3
	dc.b	$0A, nD3, $01, nC3, nBb2, nA2, nG2, nF2, nE2, nD2, nC2, nBb1
	dc.b	nRst, $38, nE3, $08, nC3, $03, nRst, $09, nC3, $0A, nBb2, $01
	dc.b	nA2, nG2, nF2, nE2, nD2, nC2, nBb1, nA1, nG1, nRst, $38, nA3
	dc.b	$0C, nF3, $18, nG3, nA3, $0C, nA3, $08, nB3, $04, nRst, $14
	dc.b	nG3, $04
	smpsJump            Snd_LevSel_Jump02

; FM5 Data
Snd_LevSel_FM5:
	smpsSetvoice        $06
	smpsAlterNote       $FF
	smpsModSet          $0A, $01, $03, $06
	dc.b	nRst, $2C, nC4, $03, nRst, $01

Snd_LevSel_Jump01:
	dc.b	nRst, $08, nC4, $0A, nBb3, $01, nA3, nG3, nF3, nE3, nD3, nC3
	dc.b	nBb2, nA2, nG2, nRst, $38, nC4, $08, nA3, $03, nRst, $09, nA3
	dc.b	$0A, nG3, $01, nF3, nE3, nD3, nC3, nBb2, nA2, nG2, nF2, nE2
	dc.b	nRst, $38, nA3, $08, nF3, $03, nRst, $09, nF3, $0A, nEb3, $01
	dc.b	nD3, nC3, nBb2, nA2, nG2, nF2, nEb2, nD2, nC2, nRst, $38, nC4
	dc.b	$0C, nA3, $18, nB3, nC4, $0C, nC4, $08, nD4, $04, nRst, $14
	dc.b	nC4, $04
	smpsJump            Snd_LevSel_Jump01

; PSG1 Data
Snd_LevSel_PSG1:
	smpsPSGvoice        sTone_04
	dc.b	nRst, $30

Snd_LevSel_Jump07:
	dc.b	nRst, $08, nC4, $02, nRst, nC5, nRst, $06, nC4, $02, nRst, nC5
	dc.b	nRst, $0A, nC4, $02, nRst, $06, nC5, $02, nRst, $16, nC4, $02
	dc.b	nRst, nC5, nRst, $12, nC5, $02, nRst, $0A, nA3, $02, nRst, nA4
	dc.b	nRst, $06, nA3, $02, nRst, nA4, nRst, $0A, nA3, $02, nRst, $06
	dc.b	nA4, $02, nRst, $0A, nEb4, $02, nRst, nE4, nRst, $06, nG4, $02
	dc.b	nRst, nA4, nRst, $06, nE4, $02, nRst, $0A, nE4, $02, nRst, $0A
	dc.b	nF3, $02, nRst, nF4, nRst, $06, nF3, $02, nRst, nF4, nRst, $0A
	dc.b	nF3, $02, nRst, $06, nF4, $02, nRst, $16, nF3, $02, nRst, nF4
	dc.b	nRst, $12, nF4, $02, nRst, $0E, nF4, $02, nRst, $06, nE4, $02
	dc.b	nRst, $1A, nF4, $02, nRst, $0A, nFs4, $02, nRst, $06, nG4, $02
	dc.b	nRst, $1A
	smpsJump            Snd_LevSel_Jump07

; PSG2 Data
Snd_LevSel_PSG2:
	smpsPSGvoice        sTone_04
	dc.b	nRst, $30

Snd_LevSel_Jump06:
	dc.b	nRst, $08, nE3, $02, nRst, nE4, nRst, $06, nE3, $02, nRst, nE4
	dc.b	nRst, $0A, nE3, $02, nRst, $06, nE4, $02, nRst, $16, nE3, $02
	dc.b	nRst, nE4, nRst, $12, nE4, $02, nRst, $0A, nC3, $02, nRst, nC4
	dc.b	nRst, $06, nC3, $02, nRst, nC4, nRst, $0A, nC3, $02, nRst, $06
	dc.b	nC4, $02, nRst, $0A, nC3, $02, nRst, nC4, nRst, $06, nC3, $02
	dc.b	nRst, nC4, nRst, $0A, nC3, $02, nRst, $06, nC4, $02, nRst, $0A
	dc.b	nA2, $02, nRst, nA3, nRst, $06, nA2, $02, nRst, nA3, nRst, $0A
	dc.b	nA2, $02, nRst, $06, nA3, $02, nRst, $16, nA2, $02, nRst, nA3
	dc.b	nRst, $12, nA3, $02, nRst, $0E, nA3, $02, nRst, $06, nG3, $02
	dc.b	nRst, $1A, nA3, $02, nRst, $0A, nBb3, $02, nRst, $06, nB3, $02
	dc.b	nRst, $1A
	smpsJump            Snd_LevSel_Jump06

; PSG3 Data
Snd_LevSel_PSG3:
	smpsPSGform         $E7

Snd_LevSel_Jump05:
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $10
	smpsPSGvoice        sTone_01
	dc.b	nMaxPSG2, $08
	smpsPSGvoice        sTone_04
	dc.b	nMaxPSG2, $18
	smpsJump            Snd_LevSel_Jump05

Snd_LevSel_Voices:
;	Voice $00
;	$3C
;	$01, $00, $00, $00, 	$1F, $1F, $15, $1F, 	$11, $0D, $12, $05
;	$07, $04, $09, $02, 	$55, $3A, $25, $1A, 	$1A, $80, $07, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $15, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $12, $0D, $11
	smpsVcDecayRate2    $02, $09, $04, $07
	smpsVcDecayLevel    $01, $02, $03, $05
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $00, $07, $00, $1A

;	Voice $01
;	$3D
;	$01, $01, $01, $01, 	$94, $19, $19, $19, 	$0F, $0D, $0D, $0D
;	$07, $04, $04, $04, 	$25, $1A, $1A, $1A, 	$15, $80, $80, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $02
	smpsVcAttackRate    $19, $19, $19, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $0D, $0D, $0F
	smpsVcDecayRate2    $04, $04, $04, $07
	smpsVcDecayLevel    $01, $01, $01, $02
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $00, $00, $00, $15

;	Voice $02
;	$03
;	$00, $D7, $33, $02, 	$5F, $9F, $5F, $1F, 	$13, $0F, $0A, $0A
;	$10, $0F, $02, $09, 	$35, $15, $25, $1A, 	$13, $16, $15, $80
	smpsVcAlgorithm     $03
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $03, $0D, $00
	smpsVcCoarseFreq    $02, $03, $07, $00
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0F, $13
	smpsVcDecayRate2    $09, $02, $0F, $10
	smpsVcDecayLevel    $01, $02, $01, $03
	smpsVcReleaseRate   $0A, $05, $05, $05
	smpsVcTotalLevel    $00, $15, $16, $13

;	Voice $03
;	$34
;	$70, $72, $31, $31, 	$1F, $1F, $1F, $1F, 	$10, $06, $06, $06
;	$01, $06, $06, $06, 	$35, $1A, $15, $1A, 	$10, $83, $18, $83
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $01, $02, $00
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $06, $06, $06, $10
	smpsVcDecayRate2    $06, $06, $06, $01
	smpsVcDecayLevel    $01, $01, $01, $03
	smpsVcReleaseRate   $0A, $05, $0A, $05
	smpsVcTotalLevel    $03, $18, $03, $10

;	Voice $04
;	$3E
;	$77, $71, $32, $31, 	$1F, $1F, $1F, $1F, 	$0D, $06, $00, $00
;	$08, $06, $00, $00, 	$15, $0A, $0A, $0A, 	$1B, $80, $80, $80
	smpsVcAlgorithm     $06
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $01, $02, $01, $07
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $06, $0D
	smpsVcDecayRate2    $00, $00, $06, $08
	smpsVcDecayLevel    $00, $00, $00, $01
	smpsVcReleaseRate   $0A, $0A, $0A, $05
	smpsVcTotalLevel    $00, $00, $00, $1B

;	Voice $05
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $80, $29, $87
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $04, $03
	smpsVcCoarseFreq    $04, $0E, $01, $03
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0E, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $07, $29, $00, $23

;	Voice $06
;	$3A
;	$01, $07, $31, $71, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
;	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $00, $00
	smpsVcCoarseFreq    $01, $01, $07, $01
	smpsVcRateScale     $01, $02, $02, $02
	smpsVcAttackRate    $13, $0D, $0E, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $0E, $0E
	smpsVcDecayRate2    $07, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $0F, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $27, $28, $18

;	Voice $07
;	$3C
;	$32, $32, $71, $42, 	$1F, $18, $1F, $1E, 	$07, $1F, $07, $1F
;	$00, $00, $00, $00, 	$1F, $0F, $1F, $0F, 	$1E, $80, $0C, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $03, $03
	smpsVcCoarseFreq    $02, $01, $02, $02
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1E, $1F, $18, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $1F, $07, $1F, $07
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $01, $00, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $0C, $00, $1E

;	Voice $08
;	$3C
;	$71, $72, $3F, $34, 	$8D, $52, $9F, $1F, 	$09, $00, $00, $0D
;	$00, $00, $00, $00, 	$23, $08, $02, $F7, 	$15, $80, $1D, $87
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $04, $0F, $02, $01
	smpsVcRateScale     $00, $02, $01, $02
	smpsVcAttackRate    $1F, $1F, $12, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0D, $00, $00, $09
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $00, $00, $02
	smpsVcReleaseRate   $07, $02, $08, $03
	smpsVcTotalLevel    $07, $1D, $00, $15

;	Voice $09
;	$3D
;	$01, $01, $00, $00, 	$8E, $52, $14, $4C, 	$08, $08, $0E, $03
;	$00, $00, $00, $00, 	$1F, $1F, $1F, $1F, 	$1B, $80, $80, $9B
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $00, $00, $01, $01
	smpsVcRateScale     $01, $00, $01, $02
	smpsVcAttackRate    $0C, $14, $12, $0E
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $0E, $08, $08
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $01, $01, $01, $01
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $1B, $00, $00, $1B

;	Voice $0A
;	$3A
;	$01, $01, $01, $02, 	$8D, $07, $07, $52, 	$09, $00, $00, $03
;	$01, $02, $02, $00, 	$52, $02, $02, $28, 	$18, $22, $18, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $01, $01
	smpsVcRateScale     $01, $00, $00, $02
	smpsVcAttackRate    $12, $07, $07, $0D
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $03, $00, $00, $09
	smpsVcDecayRate2    $00, $02, $02, $01
	smpsVcDecayLevel    $02, $00, $00, $05
	smpsVcReleaseRate   $08, $02, $02, $02
	smpsVcTotalLevel    $00, $18, $22, $18

;	Voice $0B
;	$3C
;	$36, $31, $76, $71, 	$94, $9F, $96, $9F, 	$12, $00, $14, $0F
;	$04, $0A, $04, $0D, 	$2F, $0F, $4F, $2F, 	$33, $80, $1A, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $03, $03
	smpsVcCoarseFreq    $01, $06, $01, $06
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $1F, $16, $1F, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0F, $14, $00, $12
	smpsVcDecayRate2    $0D, $04, $0A, $04
	smpsVcDecayLevel    $02, $04, $00, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1A, $00, $33

;	Voice $0C
;	$34
;	$33, $41, $7E, $74, 	$5B, $9F, $5F, $1F, 	$04, $07, $07, $08
;	$00, $00, $00, $00, 	$FF, $FF, $EF, $FF, 	$23, $90, $29, $97
	smpsVcAlgorithm     $04
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $07, $04, $03
	smpsVcCoarseFreq    $04, $0E, $01, $03
	smpsVcRateScale     $00, $01, $02, $01
	smpsVcAttackRate    $1F, $1F, $1F, $1B
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $08, $07, $07, $04
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $0F, $0E, $0F, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $17, $29, $10, $23

;	Voice $0D
;	$38
;	$63, $31, $31, $31, 	$10, $13, $1A, $1B, 	$0E, $00, $00, $00
;	$00, $00, $00, $00, 	$3F, $0F, $0F, $0F, 	$1A, $19, $1A, $80
	smpsVcAlgorithm     $00
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $03, $06
	smpsVcCoarseFreq    $01, $01, $01, $03
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $1B, $1A, $13, $10
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $0E
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1A, $19, $1A

;	Voice $0E
;	$3A
;	$31, $25, $73, $41, 	$5F, $1F, $1F, $9C, 	$08, $05, $04, $05
;	$03, $04, $02, $02, 	$2F, $2F, $1F, $2F, 	$29, $27, $1F, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $04, $07, $02, $03
	smpsVcCoarseFreq    $01, $03, $05, $01
	smpsVcRateScale     $02, $00, $00, $01
	smpsVcAttackRate    $1C, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $05, $04, $05, $08
	smpsVcDecayRate2    $02, $02, $04, $03
	smpsVcDecayLevel    $02, $01, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1F, $27, $29

;	Voice $0F
;	$04
;	$71, $41, $31, $31, 	$12, $12, $12, $12, 	$00, $00, $00, $00
;	$00, $00, $00, $00, 	$0F, $0F, $0F, $0F, 	$23, $80, $23, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $00
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $04, $07
	smpsVcCoarseFreq    $01, $01, $01, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $12, $12, $12, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $00, $00, $00, $00
	smpsVcDecayRate2    $00, $00, $00, $00
	smpsVcDecayLevel    $00, $00, $00, $00
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $23, $00, $23

;	Voice $10
;	$14
;	$75, $72, $35, $32, 	$9F, $9F, $9F, $9F, 	$05, $05, $00, $0A
;	$05, $05, $07, $05, 	$2F, $FF, $0F, $2F, 	$1E, $80, $14, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $02
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $05, $02, $05
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $00, $05, $05
	smpsVcDecayRate2    $05, $07, $05, $05
	smpsVcDecayLevel    $02, $00, $0F, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $14, $00, $1E

;	Voice $11
;	$3D
;	$01, $00, $01, $02, 	$12, $1F, $1F, $14, 	$07, $02, $02, $0A
;	$05, $05, $05, $05, 	$2F, $2F, $2F, $AF, 	$1C, $80, $82, $80
	smpsVcAlgorithm     $05
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $00
	smpsVcCoarseFreq    $02, $01, $00, $01
	smpsVcRateScale     $00, $00, $00, $00
	smpsVcAttackRate    $14, $1F, $1F, $12
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $02, $02, $07
	smpsVcDecayRate2    $05, $05, $05, $05
	smpsVcDecayLevel    $0A, $02, $02, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $02, $00, $1C

;	Voice $12
;	$1C
;	$73, $72, $33, $32, 	$94, $99, $94, $99, 	$08, $0A, $08, $0A
;	$00, $05, $00, $05, 	$3F, $4F, $3F, $4F, 	$1E, $80, $19, $80
	smpsVcAlgorithm     $04
	smpsVcFeedback      $03
	smpsVcUnusedBits    $00
	smpsVcDetune        $03, $03, $07, $07
	smpsVcCoarseFreq    $02, $03, $02, $03
	smpsVcRateScale     $02, $02, $02, $02
	smpsVcAttackRate    $19, $14, $19, $14
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $08, $0A, $08
	smpsVcDecayRate2    $05, $00, $05, $00
	smpsVcDecayLevel    $04, $03, $04, $03
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $19, $00, $1E

;	Voice $13
;	$31
;	$33, $01, $00, $00, 	$9F, $1F, $1F, $1F, 	$0D, $0A, $0A, $0A
;	$0A, $07, $07, $07, 	$FF, $AF, $AF, $AF, 	$1E, $1E, $1E, $80
	smpsVcAlgorithm     $01
	smpsVcFeedback      $06
	smpsVcUnusedBits    $00
	smpsVcDetune        $00, $00, $00, $03
	smpsVcCoarseFreq    $00, $00, $01, $03
	smpsVcRateScale     $00, $00, $00, $02
	smpsVcAttackRate    $1F, $1F, $1F, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0A, $0A, $0A, $0D
	smpsVcDecayRate2    $07, $07, $07, $0A
	smpsVcDecayLevel    $0A, $0A, $0A, $0F
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $1E, $1E, $1E

;	Voice $14
;	$3A
;	$70, $76, $30, $71, 	$1F, $95, $1F, $1F, 	$0E, $0F, $05, $0C
;	$07, $06, $06, $07, 	$2F, $4F, $1F, $5F, 	$21, $12, $28, $80
	smpsVcAlgorithm     $02
	smpsVcFeedback      $07
	smpsVcUnusedBits    $00
	smpsVcDetune        $07, $03, $07, $07
	smpsVcCoarseFreq    $01, $00, $06, $00
	smpsVcRateScale     $00, $00, $02, $00
	smpsVcAttackRate    $1F, $1F, $15, $1F
	smpsVcAmpMod        $00, $00, $00, $00
	smpsVcDecayRate1    $0C, $05, $0F, $0E
	smpsVcDecayRate2    $07, $06, $06, $07
	smpsVcDecayLevel    $05, $01, $04, $02
	smpsVcReleaseRate   $0F, $0F, $0F, $0F
	smpsVcTotalLevel    $00, $28, $12, $21


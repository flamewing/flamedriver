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
; DAC Banks
; ===========================================================================

	if (use_s3_samples<>0)||(use_sk_samples<>0)||(use_s3d_samples<>0)
; ---------------------------------------------------------------------------
; DAC Bank 1
; ---------------------------------------------------------------------------
DacBank1:			startBank
	DAC_Master_Table

DAC_86_Data:			DACBINCLUDE "Sound/DAC/86.bin"
DAC_81_Data:			DACBINCLUDE "Sound/DAC/81.bin"
DAC_82_83_84_85_Data:	DACBINCLUDE "Sound/DAC/82-85.bin"
DAC_94_95_96_97_Data:	DACBINCLUDE "Sound/DAC/94-97.bin"
DAC_90_91_92_93_Data:	DACBINCLUDE "Sound/DAC/90-93.bin"
DAC_88_Data:			DACBINCLUDE "Sound/DAC/88.bin"
DAC_8A_8B_Data:			DACBINCLUDE "Sound/DAC/8A-8B.bin"
DAC_8C_Data:			DACBINCLUDE "Sound/DAC/8C.bin"
DAC_8D_8E_Data:			DACBINCLUDE "Sound/DAC/8D-8E.bin"
DAC_87_Data:			DACBINCLUDE "Sound/DAC/87.bin"
DAC_8F_Data:			DACBINCLUDE "Sound/DAC/8F.bin"
DAC_89_Data:			DACBINCLUDE "Sound/DAC/89.bin"
DAC_98_99_9A_Data:		DACBINCLUDE "Sound/DAC/98-9A.bin"
DAC_9B_Data:			DACBINCLUDE "Sound/DAC/9B.bin"
	endif

	if (use_s3_samples<>0)||(use_sk_samples<>0)
DAC_B2_B3_Data:			DACBINCLUDE "Sound/DAC/B2-B3.bin"

	if (use_s3_samples<>0)
DAC_D8_D9_Data:			DACBINCLUDE "Sound/DAC/D8-D9.bin"
	endif

	finishBank

; ---------------------------------------------------------------------------
; Dac Bank 2
; ---------------------------------------------------------------------------
DacBank2:			startBank
	DAC_Master_Table
	endif

	if (use_s3_samples<>0)||(use_sk_samples<>0)||(use_s3d_samples<>0)
DAC_9C_Data:			DACBINCLUDE "Sound/DAC/9C.bin"
DAC_9D_Data:			DACBINCLUDE "Sound/DAC/9D.bin"
DAC_9E_Data:			DACBINCLUDE "Sound/DAC/9E.bin"
	endif

	if (use_s3_samples<>0)||(use_sk_samples<>0)
DAC_9F_Data:			DACBINCLUDE "Sound/DAC/9F.bin"
DAC_A0_Data:			DACBINCLUDE "Sound/DAC/A0.bin"
DAC_A1_Data:			DACBINCLUDE "Sound/DAC/A1.bin"
DAC_A2_Data:			DACBINCLUDE "Sound/DAC/A2.bin"
DAC_A3_Data:			DACBINCLUDE "Sound/DAC/A3.bin"
DAC_A4_Data:			DACBINCLUDE "Sound/DAC/A4.bin"
DAC_A5_Data:			DACBINCLUDE "Sound/DAC/A5.bin"
DAC_A6_Data:			DACBINCLUDE "Sound/DAC/A6.bin"
DAC_A7_Data:			DACBINCLUDE "Sound/DAC/A7.bin"
DAC_A8_Data:			DACBINCLUDE "Sound/DAC/A8.bin"
DAC_A9_Data:			DACBINCLUDE "Sound/DAC/A9.bin"
DAC_AA_Data:			DACBINCLUDE "Sound/DAC/AA.bin"

	finishBank

; ---------------------------------------------------------------------------
; Dac Bank 3
; ---------------------------------------------------------------------------
DacBank3:			startBank
	DAC_Master_Table

DAC_AB_Data:			DACBINCLUDE "Sound/DAC/AB.bin"
DAC_AC_Data:			DACBINCLUDE "Sound/DAC/AC.bin"
DAC_AD_AE_Data:			DACBINCLUDE "Sound/DAC/AD-AE.bin"
DAC_AF_B0_Data:			DACBINCLUDE "Sound/DAC/AF-B0.bin"
DAC_B1_Data:			DACBINCLUDE "Sound/DAC/B1.bin"
DAC_B4_C1_C2_C3_C4_Data:DACBINCLUDE "Sound/DAC/B4C1-C4.bin"
DAC_B5_Data:			DACBINCLUDE "Sound/DAC/B5.bin"
DAC_B6_Data:			DACBINCLUDE "Sound/DAC/B6.bin"
DAC_B7_Data:			DACBINCLUDE "Sound/DAC/B7.bin"
DAC_B8_B9_Data:			DACBINCLUDE "Sound/DAC/B8-B9.bin"
DAC_BA_Data:			DACBINCLUDE "Sound/DAC/BA.bin"
DAC_BB_Data:			DACBINCLUDE "Sound/DAC/BB.bin"
DAC_BC_Data:			DACBINCLUDE "Sound/DAC/BC.bin"
DAC_BD_Data:			DACBINCLUDE "Sound/DAC/BD.bin"
DAC_BE_Data:			DACBINCLUDE "Sound/DAC/BE.bin"
DAC_BF_Data:			DACBINCLUDE "Sound/DAC/BF.bin"
DAC_C0_Data:			DACBINCLUDE "Sound/DAC/C0.bin"

	finishBank
	endif

	if (use_s2_samples<>0)||(use_s3d_samples<>0)
; ---------------------------------------------------------------------------
; Dac Bank 4
; ---------------------------------------------------------------------------
DacBank4:			startBank
	DAC_Master_Table
	if (use_s2_samples<>0)
DAC_C5_Data:			DACBINCLUDE "Sound/DAC/C5.bin"
DAC_C6_Data:			DACBINCLUDE "Sound/DAC/C6.bin"
DAC_C7_Data:			DACBINCLUDE "Sound/DAC/C7.bin"
DAC_C8_Data:			DACBINCLUDE "Sound/DAC/C8.bin"
DAC_C9_CC_CD_CE_CF_Data:DACBINCLUDE "Sound/DAC/C9CC-CF.bin"
DAC_CA_D0_D1_D2_Data:	DACBINCLUDE "Sound/DAC/CAD0-D2.bin"
DAC_CB_D3_D4_D5_Data:	DACBINCLUDE "Sound/DAC/CBD3-D5.bin"
	endif

	if (use_s3d_samples<>0)
DAC_D6_Data:			DACBINCLUDE "Sound/DAC/D6.bin"
DAC_D7_Data:			DACBINCLUDE "Sound/DAC/D7.bin"
	endif

	finishBank
	endif
; ---------------------------------------------------------------------------

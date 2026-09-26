# Driver conversions in `_smps2asm_inc.asm`

This is a reference for the **assembly-time** conversions performed by [`_smps2asm_inc.asm`](_smps2asm_inc.asm). A song's `smpsHeaderStartSong source[, smps2asm_version]` sets `SourceDriver` and `SourceSMPS2ASM`; `SonicDriverVer` is the target selected in `Config.asm`. The current configuration sets `SonicDriverVer = 5` for Flamedriver.

| Version | Format family used by this include |
| --- | --- |
| `1` | Sonic 1 |
| `2` | Sonic 2 |
| `3` and `4` | Sonic 3 / Sonic & Knuckles style |
| `5` or higher | Flamedriver, with the Sonic 3 style base format and extra commands |

Most conditions deliberately group `SourceDriver >= 3` and/or `SonicDriverVer >= 3`. The macros **emit bytes for the selected target**; they do not parse or rewrite an existing binary. Unless a conversion is listed below, a macro writes its arguments unchanged. The song author must still supply appropriate notes, sample and envelope symbols, channel IDs, and commands for the target. A source format number does not automatically convert every raw `dc.b` in a song.

## Song setup and pointers

`smpsHeaderStartSong` records the source version and current assembly position (`songStart`). Its optional second argument defaults to zero. It warns on assembler pass 1 if that version exceeds this include's `SMPS2ASMVer = 1`.

| Site | Sonic 1 target | Other targets |
| --- | --- | --- |
| `smpsHeaderVoice loc`, `CheckedChannelPointer loc` used by DAC, FM, PSG, and SFX channel headers | `loc - songStart` | `z80_ptr(loc)` |
| `smpsJump`, `smpsLoop`, `smpsCall` | `loc - * - 1`, calculated where the pointer word is emitted | `z80_ptr(loc)` |
| `smpsHeaderVoiceUVB` | Fatal error | Versions 3–4: `little_endian(z80_UniVoiceBank)`; version 5+: `z80_ptr(z80_UniVoiceBank)` |

`smpsHeaderVoice` and `smpsHeaderVoiceNull` require `smpsHeaderStartSong` immediately before the voice pointer (`songStart == *` at that point). For a Sonic 1 target, `smpsHeaderVoice` and `CheckedChannelPointer` also issue a fatal error on pass 1 for an already defined voice or channel label. This enforces their forward placement. `smpsHeaderVoiceNull` emits a zero word.

The jump, loop, and call macros each emit their opcode first, then the pointer word. Sonic 1's expression is relative to the word's current location, not to `songStart`.

The `z80_ptr` helper is supplied by the surrounding assembly environment; this include calls it but does not define it. `smpsConditionalJump` and `smpsContinuousLoop` exist only for version 3+ targets and also use `z80_ptr(loc)`; they have no Sonic 1 relative-pointer branch.

## Main tempo modifier

Both `smpsHeaderTempo div,mod` and `smpsSetTempoMod mod` call `convertMainTempoMod`. The header writes `div` unchanged before the converted `mod`. The in-track command uses `$EA` for targets 1–2 or `$FF,$00` for targets 3+, followed by the converted value. Only the main tempo **modifier** is numerically converted; the header divider and `smpsSetTempoDiv` argument are not.

The include defines `conv0To256(n) = 256` for zero and `n` otherwise. Expressions below are assembler integer expressions; `& $FF` keeps the low byte.

| Source → target | Emitted modifier |
| --- | --- |
| Same version, or any 3+ → any 3+ | `mod` |
| 1 → 2 | `s1TempotoS2(mod) = (((conv0To256(mod)-1)<<8) + (conv0To256(mod)>>1)) / conv0To256(mod) & $FF` |
| 1 → 3+ | `s2TempotoS3(s1TempotoS2(mod))` |
| 2 → 1 | `s2TempotoS1(mod) = (((768-mod)>>1) / (256-mod)) & $FF` |
| 2 → 3+ | `s2TempotoS3(mod) = (256 - ((mod==0) \| mod)) & $FF` |
| 3+ → 1 | `s2TempotoS1(s2TempotoS3(mod))` |
| 3+ → 2 | `s2TempotoS3(mod)` |

The `\|` in the expression is bitwise OR. `s2TempotoS3` therefore gives `$FF` for zero, and `256 - mod` for nonzero byte values; the same function is used in reverse between Sonic 3 style and Sonic 2. The 1 ↔ 2 conversion uses integer division and can be approximate. A Sonic 1 source modifier of `1` and a Sonic 2 source modifier of `0` cause fatal errors. A Sonic 3 style source modifier of `0` converted to a version 1 or 2 target produces an "approximate conversion" message.

## Pitch, headers, and note symbols

`PSGPitchConvert` changes a PSG header's signed pitch offset by one octave (`psgdelta = 12` semitones), then keeps its low byte:

| Source → target | PSG header pitch |
| --- | --- |
| 1–2 → 3+ | `(pitch + 12) & $FF` |
| 3+ → 1–2 | `(pitch - 12) & $FF` |
| Same family | `pitch` |

It is called by `smpsHeaderPSG` and for a PSG `smpsHeaderSFXChannel` (channel ID bit 7 set). FM SFX pitch and FM/DAC music header pitch are written unchanged. Stream note bytes are **not** transposed. The common `nRst`/`nC0`… note equates merely name note numbers. `nMaxPSG`, `nMaxPSG1`, and `nMaxPSG2` are target-dependent constants; the `nMaxPSG` definitions compensate for the octave shift so the source-specific end notes retain their intended maximum frequency:

| Target | `nMaxPSG` | `nMaxPSG1` | `nMaxPSG2` |
| --- | --- | --- | --- |
| 1–2 | `nA5` | `nA5 + 12` | `nA5 + 12` |
| 3+ | `nBb6 - 12` | `nBb6` | `nB6` |

The PSG frequency-envelope byte in `smpsHeaderPSG` is forced to zero when converting a version 1–2 song to a 3+ target. Older headers could contain unused garbage in this position. In the reverse direction, a nonzero `mod` is emitted unchanged but triggers a message because the older target does not support that envelope. The PSG volume-envelope byte (`voice`) is always emitted unchanged.

An SFX channel ID of `cNoise` (`$E0`) is rejected on 3+ targets; `cFM6` (`$06`) is rejected on 1–2 targets. These are fatal compatibility checks, not channel-ID remappings. Other header fields and channel counts pass through unchanged. For `smpsHeaderDAC`, omitted `pitch` writes two zero bytes; a supplied `pitch` with omitted `vol` writes a zero volume byte.

## Envelope and DAC sample symbols

The include declares target-specific PSG envelope names and DAC sample IDs; these are **assembly symbols**, not a runtime translation table. Version 1 defines `fTone_01`–`fTone_09`, version 2 defines through `fTone_0D`, and version 3+ defines `sTone_01`–`sTone_27`. Version 5+ also appends `fTone_01`–`fTone_0D` after the Sonic 3 envelopes for older-song conversion. A literal envelope number is never renumbered by `smpsHeaderPSG` or `smpsPSGvoice`; use the target's named equates or an explicitly verified number.

DAC equates are omitted entirely when `skip_sample_equates` is defined (as in this repository's `Config.asm`), so the DAC table supplies them. Otherwise, versions 1 and 2 enumerate their respective original sample lists from `$81`; versions 3 and 4 enumerate the Sonic 3 style lists from `$81`. Version 5+ builds a list from the enabled
`use_s3_samples`/`use_sk_samples`/`use_s3d_samples` flags, then appends Sonic 2 sample names when `use_s2_samples` is nonzero. It additionally appends the two S3D-specific samples when enabled and the two S3-specific echoed-clap names when enabled. `dKick` starts at `$81` only if the Sonic 3 style block was absent; otherwise it follows that block. `smpsPlayDACSample` (available on 3+ targets) emits `$EA` and `sample & $7F`. The sample name's **target value** matters; no original numeric sample ID is automatically mapped to a new one.

## Coordination flags and stream commands

The table lists macros whose emitted command or behavior depends on the target or source driver. Hex bytes are shown in stream order; parameters follow each opcode unless shown explicitly. Other command macros simply emit the bytes written in the include.

| Macro | Target 1–2 | Target 3–4 | Target 5+ / source-specific detail |
| --- | --- | --- | --- |
| `smpsReturn` | `$E3` | `$F9` | `$F9` |
| `smpsFade val` | `$E4` (no operand) | Empty or literal `$FF`: `$E2,$FF`; otherwise `smpsSetCommByte val` | Empty or literal `$FF`: `$E2,$FF`; otherwise `$E2,val` with a warning that the parameter is ignored as a Flamedriver fade. For source 1–2, the empty/`$FF` case additionally appends `smpsStop` (`$F2`). |
| `smpsSetCommByte val` | `$E2,val` | `$E2,val`, with a warning about S3/S&K's reuse of this byte for 1-Up state | `$FF,$0E,val`, Flamedriver's separate communication byte |
| `smpsChanTempoDiv val` | `$E5,val` | Version 3: fatal unsupported-command error; version 4: `$E5,val` by the macro's conditions | `$FF,$08,val` |
| `smpsNoteFill val` | `$E8,val` | `$E8,val` | For source 1–2, `$FF,$0A,val`; otherwise `$E8,val`. When converting across the 1–2 / 3+ boundary without this Flamedriver command, the assembler reports that the fill value needs tempo-divider scaling. |
| `smpsChangeTransposition val` | `$E9,val` | `$FB,val` | `$FB,val` |
| `smpsSetTempoMod mod` | `$EA,converted_mod` | `$FF,$00,converted_mod` | Same as 3–4; see tempo table |
| `smpsSetTempoDiv val` | `$EB,val` | `$FF,$04,val` | Same as 3–4 |
| `smpsSetVol val` | Fatal unsupported-command error | `$E4,val` | `$E4,val` |
| `smpsPSGAlterVolS2 vol` | Version 2: `$E6,vol`; version 1: `$EC,vol` | `$EC,vol` | `$EC,vol` |
| `smpsFMAlterVol val1[,val2]` | One argument: `$E6,val1`; two: `$E6,val2` | One: `$E6,val1`; two: `$E5,val1,val2` | Same as 3–4; in the two-argument form the first value is unused for FM tracks |
| `smpsFMvoice voice[,songID]` | `$EF,voice` | With `songID`: `$EF,voice\|$80,songID+$81`; otherwise `$EF,voice` | Same as 3–4 |
| `smpsModOn [type]` | `$F1` | `$F4,type`, or `$F4,$80` if omitted | Same as 3–4 |
| `smpsModOff` | `$F4` | `$FA` | `$FA` |
| `smpsMaxRelRate` | `$F9` | Two `smpsFMICommand` writes: `$EE,$88,$0F` and `$EE,$8C,$0F` | Same as 3–4 |

`smpsNop` is a deprecated alias for `smpsSetCommByte` and warns. `smpsAlterNote`, `smpsAlterPitch`, `smpsFMFlutter`, `smpsWeirdD1LRR`, and `smpsSetvoice` are compatibility aliases for `smpsDetune`, `smpsChangeTransposition`, `smpsFMVolEnv`, `smpsMaxRelRate`, and `smpsFMvoice`, respectively.

`smpsPlaySound index` always emits `$FF,$01,index`, but warns on Flamedriver targets because it plays SFX there; `smpsPlayMusic` is the separate version 5+ music command. `smpsSSGEG op1,op2,op3,op4` always emits `$FF,$05,op1,op3,op2,op4`, swapping the middle arguments in the byte stream. `smpsResetSpindashRev` accepts a `val` argument but emits only `$FF,$07`. These are fixed macro behaviors, independent of the source version.

`smpsClearPush` works only on target 1 (`$ED`) and is fatal elsewhere. `smpsStopSpecial` works as `$EE` on target 1; elsewhere it reports a message and emits `smpsStop` (`$F2`) as a fallback. Several 3+ only macros have no older-target definition, including the Sonic 3 extended commands; the Flamedriver-specific extended commands are defined only for target 5+. `smpsCopyData` always raises a fatal error even though bytes follow its `fatal` directive in the macro definition.

### Modulation (`smpsModSet`)

The command is `$F0,wait',speed,change,step'`. The wait conversion is:

| Source → target | `wait'` |
| --- | --- |
| 2 → 1 | `clampByte(wait-1)` |
| 3+ → 1 | `clampByte(wait-2)` |
| 1 → 2 | `wait+1` |
| 3+ → 2 | `wait-1` |
| 1 → 3+ | `wait+2` |
| 2 → 3+ | `wait+1` |
| Same version/family | `wait` |

`clampByte` limits the Sonic 1-bound subtraction to `$00`…`$FF`. `speed` and `change` are emitted unchanged. The final field converts as follows:

| Source → target | `step'` |
| --- | --- |
| 1–2 → 3+ | `((step+1) * speed) & $FF` |
| 3+ → 1–2 | `conv0To256(step) / conv0To256(speed) - 1` |
| Same family | `step` |

Here zero represents 256 for the reverse conversion. These are integer calculations; an inverse conversion can lose information through division or byte truncation. The macro does not report that loss.

## FM voice serialization

The `smpsVc*` macros collect one instrument's operator fields. Only `smpsVcTotalLevel` emits the complete voice: one feedback/algorithm byte followed by six four-byte operator groups, for **25 bytes** total. `smpsDcb` chooses `dc.b` for the 68000 assembler or `db` for Z80 CPU modes; it does not change field values.

| Group | Per-operator expression |
| --- | --- |
| Detune/multiple | `(DT << 4) + CF` |
| Rate scale/attack | `(RS << 6) + AR` |
| Amplitude modulation/first decay | `AM \| D1R \| D1RUnk` |
| Second decay | `D2R` |
| Decay level/release | `(DL << 4) + RR` |
| Total level | `TL \| TLMask` |

The first byte is `(vcUnusedBits << 6) + (vcFeedback << 3) + vcAlgorithm`. For **target version 2**, every operator group is ordered `4,2,3,1`; for all other targets it is `4,3,2,1`. This is the voice-layout conversion. Optional `smpsVcUnusedBits` decay arguments set each `D1RUnk` to the supplied value shifted left five bits; if any of the four arguments is missing, all four are zero.

`smpsVcAmpMod` handles a source SMPS2ASM syntax difference: `SourceSMPS2ASM = 0` shifts each amplitude-modulation argument by five; nonzero versions shift by seven. The include says old SMPS2ASM placed the AM bit incorrectly. `SourceSMPS2ASM` also controls initial total-level carrier masks: version 0 derives the bit from the algorithm; newer versions initially leave the masks zero and take supplied TL high bits.

The carrier mask is `$80` for operator 1 on every algorithm, operator 2 for algorithms 5–7, operator 3 for algorithms 4–7, and operator 4 only for algorithm 7. When converting a **source 1–2 voice to target 3+**, the macro discards each input TL high bit (`TL & $7F`) and regenerates all four high bits from this mask, regardless of `SourceSMPS2ASM`. When converting **source 3+ to target 1–2**, it cannot make the older driver honor arbitrary TL high bits: on assembler pass 1 it emits a message if the effective bits (input TL OR initial mask) do not match the algorithm's carrier mask. It still emits the voice. This is a compatibility warning, not an automatic repair.

## Practical limits

The include has deliberate compatibility checks and messages, but many transformations are conditional and some are approximate. In particular, it does not rescale note-fill values in the warning cases, translate arbitrary PSG envelope or DAC sample numbers, change stream note bytes, or invent commands absent from a target driver. Check the assembled bytes and listen to converted songs where timing, envelopes, or voice TL bits matter.

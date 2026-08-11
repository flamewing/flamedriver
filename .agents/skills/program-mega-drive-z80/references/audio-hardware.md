# Mega Drive audio hardware

## YM2612 ports

| Z80 address | Role |
|---|---|
| `$4000` | Part I register-address write; status read |
| `$4001` | Part I data write |
| `$4002` | Part II register-address write |
| `$4003` | Part II data write |

Write a register number to the selected address port, then write its data to the matching data port. Do not mix Part I address with Part II data or interleave another writer between the two operations.

When polling status, read `$4000`. Sega documents a hardware problem when software reads the busy flag through `$4001`; do not assume every mirrored port is safe even if an emulator accepts it.

Respect the existing driver's proven spacing or busy-wait routine. YM2612/YM3438 implementations and console revisions differ in observed timing behavior. Do not shorten delays based only on emulator success, and do not insert a busy read between address and data without verifying the intended protocol. Keep address/data writes byte-sized.

Most programmed values cannot be reconstructed by reading the chip. Keep software shadows for values later needed by fades, pitch changes, key state, panning, or restoration.

## Parts and channels

Part I normally addresses FM channels 1-3 and global registers; Part II addresses FM channels 4-6. The low channel encoding is not a linear 0-5 number everywhere:

- Per-channel Part I/II registers use low channel values 0-2 in their respective part; low value 3 is unused.
- Key on/off register `$28` is in Part I and encodes channels as `0,1,2,4,5,6`; bit pattern 3 is skipped.
- Channel 6 supplies the DAC path when DAC mode is enabled through register `$2B`; sample bytes go to `$2A`.
- Channel 3 special mode and timers share global control register `$27`. Preserve unrelated timer/mode bits when updating it.

Verify operator order and bitfield packing against a register reference or the project's established tables. Human-facing operator numbering and register-slot order are frequently presented differently.

## PCM/DAC

The YM2612 DAC has no sample queue. Software must write each sample byte at the intended cadence. Audit:

- worst-case loop cycles, not only the average;
- interrupt latency and disabled-interrupt spans;
- ROM-window bank changes and boundary crossings;
- bus-request stalls from the 68000;
- simultaneous FM/PSG update cost;
- PAL/NTSC clock and scheduling assumptions;
- signed/unsigned sample conversion and silence midpoint used by the data.

Keep the ROM-window bank and sample pointer as one logical state. A pointer increment across `$FFFF` requires selecting the next 32 KiB bank and continuing at `$8000`.

## PSG command stream

Write PSG bytes to `$7F11`. The Mega Drive PSG uses the SN76489-style latch/data protocol:

- A latch byte has bit 7 set, channel in bits 6-5, register type in bit 4, and four low data bits.
- A following data byte has bit 7 clear and supplies six more bits for a tone period.
- Volume uses four attenuation bits: `0` is loudest and `$F` is silent.
- Noise control uses its defined low control bits; one noise-rate selection is tied to tone channel 3's period.

The latch is shared hardware state. Keep paired tone bytes adjacent and serialize all PSG writers. Interrupting between them is safe only if the interrupt handler cannot write PSG or deliberately restores the latch selection.

To silence the four channels, latch maximum attenuation for each channel (commonly `$9F`, `$BF`, `$DF`, `$FF`). Preserve project abstractions when they encode channel or envelope policy.

## Review rules

- Do not read a write-only register to “preserve” its previous value.
- Do not assume address mirrors, word writes, or back-to-back writes that work in an emulator are hardware-safe.
- Do not change an FM or PSG helper without auditing every caller's register, flag, timing, and interrupt assumptions.
- Keep separate logical shadows for chip state and queued musical intent; a pending note is not necessarily the value currently programmed.

## Sources

- [Sega Genesis Software Manual](https://segaretro.org/images/a/a2/Genesis_Software_Manual.pdf), FM audio and PSG supplements plus the documented YM2612 status-read precaution.
- [Sega Genesis Technical Overview](https://segaretro.org/images/9/95/GenesisSoftwareManual.pdf), Genesis Sound and Z80 mapping sections.

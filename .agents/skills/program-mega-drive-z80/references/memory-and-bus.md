# Mega Drive Z80 memory and bus

All addresses in the first table are as seen by the Z80. Use established project equates instead of scattering literals.

## Z80-visible map

| Address | Function | Rule |
|---|---|---|
| `$0000-$1FFF` | 8 KiB Z80 sound RAM | Place code, data, stack, and shared command bytes here. Budget all four explicitly. |
| `$2000-$3FFF` | Reserved/prohibited in Sega's programming model | Do not depend on mirrors or open-bus behavior. |
| `$4000-$4003` | YM2612 address/data ports | Use byte accesses and an established timing helper. |
| `$6000` | Serial 68000-bank selector | Write nine selection bits, least-significant bit first. |
| `$7F11` | PSG write port | Treat as write-only command data. |
| `$8000-$FFFF` | 32 KiB window into the 68000 address space | Meaning depends on the current bank latch. |

Other addresses in the holes are reserved, prohibited, incompletely decoded, or hardware-dependent. Do not generalize a single observed mirror into a portable map.

The `$8000-$FFFF` region is often called the ROM window because sound drivers normally read cartridge data through it. It is actually a banked view of the 68000 address space, not a ROM-only device. Whether a selected target is meaningful and safe for Z80 access depends on the target hardware and bus conditions.

## Derive the banked address

For a 24-bit 68000 target `T`:

```text
bank = (T >> 15) & $1FF
z80_pointer = $8000 | (T & $7FFF)
physical_target = (bank << 15) | (z80_pointer & $7FFF)
```

Program the nine bank bits at `$6000` in this order: `T.A15`, `T.A16`, ... `T.A23`; each byte write supplies its bit 0. Do not replace the nine writes with one wider store.

A common 8-bit bank helper writes `A15-A22` from an 8-bit value and then writes zero for `A23`. That helper can only select the lower 8 MiB. Preserve that limitation intentionally or extend both the stored bank representation and writer.

The latch is global Z80 subsystem state. After changing it, every pointer in `$8000-$FFFF` refers to the new 32 KiB bank. Keep data accesses within the selected window; split reads that cross a 32 KiB boundary.

Do not select the 68000's mapping of the Z80 area and recurse through it. Sega's manual explicitly prohibits Z80 bank-window access to the Z80 area.

## 68000 ownership controls

As seen by the 68000:

| Address | Function | Normal word values |
|---|---|---|
| `$A00000-$A01FFF` | Z80 RAM | Access only after bus grant; use byte accesses for RAM data. |
| `$A04000-$A04003` | YM2612 ports in the Z80 area | Coordinate ownership and use correct byte lanes/access helpers. |
| `$A06000` | Z80 bank register in the Z80 area | Normally let Z80-side code own this latch. |
| `$A11100` | Z80 bus request | Write `$0100` to request; wait for acknowledgement; write `$0000` to release. |
| `$A11200` | Z80 reset | Write `$0000` to assert; write `$0100` to release. |

Follow the project's known-good macros because byte-lane and polling expressions differ across assemblers. The required sequence is:

1. Prevent code paths, including interrupts, from violating ownership.
2. Request the Z80 bus.
3. Poll until the Z80 acknowledges the request.
4. Access Z80 RAM/devices with the required width and ordering.
5. Release the bus on every exit path.

Bus request stops Z80 execution; it is not a general mutual-exclusion variable. A long hold can stall music or PCM playback. Reset and bus request are separate controls.

Asserting Z80 reset also resets the FM sound source according to Sega's hardware sequence. Do not use it as a CPU-only recovery mechanism when preserving audio-chip state matters.

## Interrupt connection

In Mega Drive mode, the Z80 receives the VDP vertical interrupt as its console interrupt source. Design around these consequences:

- Expect one interrupt opportunity per video frame, with PAL/NTSC cadence differences.
- Establish the driver's interrupt mode and vector before enabling interrupts; many drivers use IM 1 and the `$0038` entry.
- Keep the handler within the register, alternate-bank, flag, stack, bank-latch, and chip-port ownership convention.
- Do not assume the 68000's horizontal or external interrupt handlers also interrupt the Z80.
- Treat interrupt masking as part of PCM jitter and command-latency analysis.

## Shared-memory protocol

For a one-byte command mailbox, define which CPU may write and when the receiver clears or acknowledges it. For multi-byte state, use one of these patterns:

- Write payload first and a one-byte command/commit flag last; receiver clears it after copying.
- Use a sequence byte written before and after the payload; retry if the two reads disagree.
- Hold the Z80 bus while the 68000 performs an atomic snapshot/update, accepting the audio stall cost.

Do not assume a 16-bit 68000 write is an atomic or valid way to update two bytes of Z80 RAM.

## Sources

- [Sega Genesis Software Manual](https://segaretro.org/images/9/95/GenesisSoftwareManual.pdf), Z80 area, bank register, bus request, reset, and sound-control sections.
- [Sega Genesis Software Manual, alternate scan with supplementary index](https://segaretro.org/images/a/a2/Genesis_Software_Manual.pdf).

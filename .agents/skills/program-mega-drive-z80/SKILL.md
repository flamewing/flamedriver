---
name: program-mega-drive-z80
description: Implement, debug, and review Z80-side code for the Sega Mega Drive or Genesis, including the 8 KiB sound RAM, 68000 bank window and serial bank register, Z80 bus request/reset handshakes, shared-memory protocols, YM2612 FM and DAC access, PSG writes, interrupts, timing, and real-hardware compatibility. Use for Mega Drive sound drivers, PCM playback, bank switching, 68000-to-Z80 communication, audio-chip initialization, or any code that accesses the Z80 subsystem from either CPU.
---

# Program Mega Drive Z80

Use `$write-z80-assembly` alongside this skill for CPU register, flag, stack, or instruction reasoning. If it is unavailable, perform the same alias-expanded audit: `AF=A:F`, `BC=B:C`, `DE=D:E`, and `HL=H:L`.

## Load the needed references

- Read [references/memory-and-bus.md](references/memory-and-bus.md) for the Z80 memory map, the `$8000-$FFFF` 68000 window, bank selection, bus arbitration, reset, and communication.
- Read [references/audio-hardware.md](references/audio-hardware.md) before touching YM2612, DAC, or PSG access.

## Establish the target

Before editing:

1. Inspect the repository's assembler dialect, memory equates, bank macros, sound-driver conventions, initialization order, and actual hardware support policy.
2. Determine which CPU executes every changed line. Do not mix the Z80 address map with 68000 addresses.
3. Determine ownership of each RAM byte and hardware port, including interrupt/main-loop sharing.
4. Determine whether timing is cycle-sensitive because of YM2612 writes, PCM cadence, bus contention, or interrupt latency.
5. Preserve existing proven access helpers unless the task specifically requires changing them.

## Model addresses explicitly

For every external access, annotate or reason through:

```text
executing CPU | CPU-visible address | selected bank | physical target | access width | owner
```

Never treat a Z80 pointer in `$8000-$FFFF` as a complete 68000 address. Its target depends on the bank latch. Never change the bank while code still has live pointers or assumptions tied to the previous window.

Also remember that the underlying Z80 can expose undocumented hidden state. In practice, the Mega Drive Z80 is still a Z80-class CPU, so MEMPTR-like behaviors can appear in emulators and debugging tools; the hidden pointer can be updated by block-transfer and port-transfer instructions, and flag bits can reflect internal pointer bits after `BIT n,(HL)`. Use this for emulator fidelity and diagnosis, not as a project-wide contract unless the target hardware and code path are explicitly validated.

## Design shared-state changes

- Make the 68000 request the Z80 bus and wait for acknowledgement before accessing Z80 RAM or Z80-side devices through the Z80 area.
- Prevent an interrupt or nested path from releasing or changing bus ownership during the protected operation.
- Use the access widths and ordering required by the hardware and the established project helpers.
- Define a command protocol with an ownership rule. Avoid multi-byte structures that one CPU can observe half-updated unless the protocol supplies a commit byte, sequence value, or equivalent handshake.
- Keep reset assertion/release and driver upload ordering explicit.

## Design audio changes

- Treat YM2612 address selection plus data write as an ordered transaction. Respect the project's proven busy/delay policy and hardware-revision target.
- Keep YM2612 part/port selection separate from channel numbering; register `$28` uses its own channel encoding.
- Treat most sound-chip state as write-only and maintain software shadows when later calculations need prior values.
- Treat the PSG as a latched serial command interface, not ordinary readable RAM.
- For DAC playback, budget worst-case cycles and account for bank switches, interrupts, and bus stalls. A correct average sample rate is insufficient if individual writes jitter or starve.

## Verify on the right surfaces

1. Build and inspect the resulting Z80 bytes/listing.
2. Test bank-boundary and window-boundary cases, including `$7FFF/$8000`, `$FFFF`, and targets whose low 15 bits wrap.
3. Test command races, bus requests, reset/reload, music plus SFX load, PCM plus FM writes, pause/resume, and PAL/NTSC timing where relevant.
4. Test in at least one accurate emulator, but do not call timing-sensitive behavior hardware-safe from emulator results alone.
5. Prefer real-hardware validation for YM2612 timing, bus arbitration, PCM cadence, and any undocumented instruction side effects that affect flags or pointers.
6. State explicitly when a behavior was not validated on hardware or when it depends on emulator-specific Z80 quirks.

Reject changes that write plausible bytes to an incorrectly derived address, rely on an unstated bank, touch Z80 RAM without ownership, silently replace a known-good chip-write delay, or treat undocumented Z80 flags as if they were part of the public contract.

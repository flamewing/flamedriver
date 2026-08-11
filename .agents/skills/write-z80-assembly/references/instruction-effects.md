# Z80 side-effect traps

Use the official instruction table for exact flags and timings. This page highlights effects that are commonly omitted during code review.

## Counters, arithmetic, and flags

| Instruction family | Non-obvious state change |
|---|---|
| `DJNZ target` | Decrements `B`, therefore changes `BC`; does not change flags. Initial `B=0` produces 256 iterations. |
| `INC r` / `DEC r` | Changes the selected 8-bit register and `F` except carry is preserved. |
| `INC rr` / `DEC rr` | Changes the full 16-bit pair and preserves all flags. |
| `ADD HL,rr` | Changes `HL`; writes `H`, `N`, and `C` while preserving `S`, `Z`, and `P/V`. |
| `ADC HL,rr` / `SBC HL,rr` | Changes `HL` and all documented arithmetic flags. |
| `ADD/ADC/SUB/SBC/AND/XOR/OR/CP` | Uses or compares `A` and replaces documented flags; `CP` leaves `A` unchanged but still changes `F`. |
| `BIT n,r` | Changes flags while preserving carry; memory/indexed forms have additional undocumented flag behavior. |
| `SCF`, `CCF`, `CPL`, rotates | Change flags even when their primary result appears unrelated to a later branch. |

Do not move flag-changing work between a compare/test and its conditional branch unless the branch is intentionally retargeted to the new flags.

## Block instructions

- `LDI`/`LDD` transfer one byte, advance/retreat both `HL` and `DE`, decrement `BC`, and change flags.
- `LDIR`/`LDDR` repeat that state transition until `BC=0`. Entering with `BC=0` causes 65,536 transfers, not zero transfers.
- `CPI`/`CPD` change `HL`, decrement `BC`, compare memory against `A`, and change flags while preserving `A`.
- `CPIR`/`CPDR` repeat until the comparison matches or `BC=0`.
- Block I/O instructions also change the counter/pointer and have complex flags. Consult the target CPU manual rather than deriving flags from intuition.

## Stack and control flow

- `PUSH rr` decrements `SP` twice and writes two bytes. `POP rr` reads two bytes and increments `SP` twice.
- `CALL`, accepted interrupts, and restart instructions push a return address. `RET`, `RETI`, and `RETN` pop one.
- `POP AF` changes `A` and `F`; `POP BC/DE/HL/IX/IY` changes the pair and both visible halves.
- `EX (SP),HL/IX/IY` exchanges memory with the register and does not merely peek at the stack.
- An interrupt can consume stack space and clobber registers according to the handler convention at any interruptible instruction boundary.

Audit stack delta on every control-flow path. Include maximum call depth and interrupt nesting, not only balanced source-level pairs.

## Exchanges and interrupt state

- `EX DE,HL` swaps the physical values; both pairs are changed.
- `EXX` changes which `BC/DE/HL` bank ordinary instructions see.
- `EX AF,AF'` changes which `A/F` bank ordinary instructions see.
- `DI` masks maskable interrupts; it does not disable NMI.
- `EI` has delayed maskable-interrupt acceptance. Preserve the project's established return/enable sequence.
- `RETN` restores `IFF1` from `IFF2`; do not substitute return mnemonics solely because they assemble to similar bytes.

## Addressing and assembler traps

- Z80 multi-byte immediates and stack words are little-endian in memory.
- Relative branches have a signed 8-bit displacement measured from the following instruction. Confirm range in the listing.
- Parentheses can mean memory indirection or expression grouping depending on assembler grammar. Inspect existing code and emitted bytes.
- Pseudo-instructions, automatic short forms, and undocumented opcodes vary by assembler. Verify the actual opcode stream.

## Source

- [Zilog Z80 CPU User Manual](https://www.zilog.com/docs/z80/z80cpu_um.pdf), instruction descriptions and opcode tables.

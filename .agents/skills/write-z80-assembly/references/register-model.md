# Z80 physical register model

Use this model before allocating or preserving registers.

## Main bank

| Pair name | High byte | Low byte | Consequence |
|---|---|---|---|
| `AF` | `A` | `F` | Any flag change changes `AF`; any `AF` load changes `A` and all flags. |
| `BC` | `B` | `C` | `DJNZ`, `INC B`, or `LD B,x` changes `BC`. |
| `DE` | `D` | `E` | A byte write to either half invalidates the corresponding part of `DE`. |
| `HL` | `H` | `L` | Pointer arithmetic on `HL` changes both the pair value and possibly either half. |

The two names are views of the same storage. For example, after `LD BC,$1234`, `B=$12` and `C=$34`; after `LD B,$56`, `BC=$5634`, not `$1234` plus an independent `B`.

`SP`, `PC`, `IX`, and `IY` are separate 16-bit registers. Do not infer that all 16-bit registers have official byte-addressable halves. `IXH/IXL/IYH/IYL` name undocumented instruction forms on the original Z80 and are assembler-dependent.

`I` is the interrupt-vector-page register. `R` is the refresh register and also changes as opcodes are fetched; it is not a stable general-purpose byte.

## Alternate bank

The CPU has alternate `AF'`, `BC'`, `DE'`, and `HL'` storage, but ordinary instructions address the currently selected bank:

- `EX AF,AF'` swaps main and alternate `AF` only.
- `EXX` swaps main and alternate `BC`, `DE`, and `HL` together; it does not affect `AF`.
- There are no ordinary operands spelled `B'`, `C'`, and so on. Swap banks to access those values.
- Nested code or interrupts must follow one convention. An `EXX` in an interrupt can expose and overwrite values the interrupted code believed hidden.

Treat bank selection as CPU state in the routine contract. Use alternate registers only when their ownership is established across calls and interrupts.

## Flags are the low byte of AF

`F` contains `S Z 5 H 3 P/V N C`. Bits 5 and 3 have instruction-specific or undocumented behavior and should not store application state.

Flag meanings vary by instruction:

- `P/V` can mean signed overflow or parity for arithmetic/logic, but indicates `BC != 0` after block-transfer operations.
- `C` is often preserved by `INC`/`DEC` on 8-bit operands, but other flags are not.
- A conditional branch reads existing flags; it does not recompute the condition from the register named in a comment.

When preserving `AF`, preserve both the accumulator and flags deliberately. When only flags matter, verify whether the chosen save/restore mechanism also changes `A`, `SP`, memory, or interrupt latency.

## Source

- [Zilog Z80 CPU User Manual](https://www.zilog.com/docs/z80/z80cpu_um.pdf), especially the CPU register description and instruction tables.

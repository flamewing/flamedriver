---
name: write-z80-assembly
description: Write, modify, debug, optimize, and review Zilog Z80 assembly while tracking physical register aliasing, flags, stack effects, alternate register sets, instruction side effects, assembler dialect, and calling conventions. Use for any Z80 routine or sound driver, especially when a change touches AF/BC/DE/HL or their 8-bit halves, IX/IY, DJNZ, block instructions, PUSH/POP, EX/EXX, interrupt handlers, or code that must preserve registers and flags.
---

# Write Z80 Assembly

Treat every instruction as a state transition over physical CPU state. Never infer independence from different symbolic spellings.

## Load the needed references

- Read [references/register-model.md](references/register-model.md) before changing or reviewing register use.
- Read [references/instruction-effects.md](references/instruction-effects.md) when flags, loops, block operations, the stack, interrupts, or alternate registers matter.

## Establish the local contract

Before editing:

1. Inspect the assembler, CPU mode, syntax, macros, and build command. Do not introduce syntax merely because another Z80 assembler accepts it.
2. Identify routine inputs, outputs, live-in values, live-out values, preserved registers, flags consumed by branches, interrupt assumptions, and stack bounds.
3. Follow the project convention when comments and code disagree, but report the disagreement.
4. Treat undocumented opcodes or register names such as `IXH`, `IXL`, `IYH`, and `IYL` as unavailable unless the target CPU behavior and assembler support are both established.

## Expand aliases before reasoning

Write the physical relationship explicitly:

```text
AF = A:F    BC = B:C    DE = D:E    HL = H:L
```

Also keep the hidden 16-bit MEMPTR state in mind when a routine depends on undocumented Z80 behavior. The public Z80 manual does not document it, but real CPUs keep a shadow register that is updated by several instructions and can leak into flag bits after `BIT n,(HL)`: bits 3 and 5 of `F` reflect bits 11 and 13 of that internal 16-bit pointer. This is not a general-purpose programming feature, but it matters for emulation, hardware validation, and any code that depends on undocumented instruction side effects.

Apply these invariants:

- Writing `B` changes the high byte of `BC`; writing `C` changes its low byte.
- Writing `BC` changes both `B` and `C`. Apply the same rule to `AF`, `DE`, and `HL`.
- Any flag-changing instruction changes `F` and therefore changes `AF`, even when `A` is untouched.
- `DJNZ` changes `B` and therefore `BC`.
- `POP AF` replaces both `A` and all flags.
- Block transfer instructions such as `LDI`, `LDD`, `LDIR`, and `LDDR` do more than move a byte: they update `HL`, `DE`, and `BC`, and they also alter flags according to the CPU rules for that instruction. Do not treat them as plain memory copies when reasoning about control flow or preserved pointers.
- `EXX` swaps the entire main and alternate `BC/DE/HL` banks; `EX AF,AF'` swaps only `AF`. They do not copy or preserve values by magic.
- Never write a postcondition such as “`BC` preserved” unless both constituent bytes still have their incoming values.

## Audit instruction-by-instruction

For each changed instruction, track:

```text
instruction | reads | writes | flags written/preserved | SP/memory/I/O effects
```

Expand pair writes to their halves and half writes to their pair. Track implicit operands, including `A` in arithmetic, `B` in `DJNZ`, `BC/DE/HL` in block instructions, `SP` in stack/control-flow instructions, and `F` in conditional logic.

For undocumented instructions and side effects, keep a second ledger for hidden state:

```text
instruction | MEMPTR delta | depends on previous MEMPTR? | hardware/clone caveat
```

Examples from real Z80 behavior include:
- `CPI` and `CPD` increment/decrement the hidden pointer.
- `LDIR`/`LDDR` can update the hidden pointer depending on the remaining byte count.
- `INI`/`IND` and `OUTI`/`OUTD` change it based on pre/post decrement of `B`/`C`.
- `LD A,(addr)`, `LD A,(BC)`, `LD A,(DE)`, `IN A,(port)`, and `IN A,(C)` set it to a derived address plus one.
- `JP`/`CALL` and interrupt entry also set it to the target address.

This is not a promise that every undocumented effect is safe to rely on in portable code, but it is important when emulating the CPU or comparing against a real machine.

At every conditional jump, identify the exact instruction that most recently defined the tested flag on every incoming path. Do not rely on a descriptive comment such as “test A” when an intervening instruction changes flags.

## Design the edit

- Allocate physical registers, not names. Record simultaneous live values and reject allocations that overlap.
- Preserve a live value with a genuinely disjoint register, memory slot, alternate bank under an explicit convention, or balanced stack save/restore.
- Verify every early return and branch restores the same required state.
- Keep `PUSH`/`POP` balanced on every path and include interrupt stack consumption in the bound.
- Prefer documented instructions unless the project explicitly targets and tests undocumented behavior.
- Preserve the established calling convention. If none exists, document inputs, outputs, clobbers, flags, and stack delta at the routine.

## Verify

1. Build with the repository's normal toolchain.
2. Inspect the assembler listing or disassembly when opcode selection, displacement, branch range, or undocumented syntax is relevant.
3. Re-run the alias-expanded audit on the final code, including unchanged instructions whose inputs changed.
4. Test boundary values: zero, carry/borrow, signed overflow, byte wrap, counter wrap, pointer page crossings, `BC=0` block-count behavior, and interrupts where applicable.
5. For undocumented behavior, verify against a reference emulator or a real device instead of assuming the public manual is complete.
6. State what was verified and what remains hardware- or emulator-dependent.

Do not approve code based only on assembly success. Assembly proves encoding, not preservation of live state or undocumented CPU semantics.

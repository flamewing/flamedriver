# flamedriver

Upgraded S3&amp;K sound driver

## How to use

Step 1: Create a `Sounds` directory in your disassembly
Step 2: Copy all `asm` files into this directory:

- `_smps2asm_inc.asm`
- `Config.asm`
- `Constants.asm`
- `DACBanks.asm`
- `Definitions.asm`
- `Envelopes.a80`
- `Flamedriver.asm`
- `Helper.asm`
- `Macros.asm`
- `MusicBanks.asm`
- `SFXBanks.asm`
- `Structs.asm`
- `UniBank.asm`
- `Z80Driver.a80`

Step 3: In your assembly's constants file, delete all stuff that generate music or SFX IDs.
Step 4: Edit `Config.asm` to your needs, specifically:

- `mus_prefix`
- `sfx_prefix`
- `fade_prefix`
- `cmd_prefix`

Step 5: In `Macros.asm`, edit `Gen_Sample_Table`, `Gen_Music_Table`, `Gen_Sound_Table`, and/or `Gen_ContinuousSound_Table` to your needs.

Step 6: Include `Config.asm` very early in your disassembly, preferably right after any constants but before any code.

Step 7: Include `Helper.asm` somewhere in your disassembly and delete the similarly-named functions it has. You should also make sure that all caller sites consistently use PlayMusic for music, and PlaySound/PlaySoundLocal for SFX; some call sites in the original games don't do this consistently. Flamedriver splits SFX and music queues to allow for more music/SFX IDs, and these will fail.

Step 8: Include `Flamedriver.asm` and remove the old definition of `SoundDriverLoad` / `SndDrvInit` in favor of Flamedriver's.

A reference integration to S3&K can be found at [this repository](https://github.com/flamewing/flamedriver-skdisasm). Please note I only looked into S3Complete mode, and it fails to build for S&K alone.

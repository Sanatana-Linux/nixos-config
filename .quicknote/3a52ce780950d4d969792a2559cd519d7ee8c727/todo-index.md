# TODO Items

These are to-do items for this repository, which may have additional notes on each item linked from here if such notes are necessary or desirable. When the to-do is finished, I intend to add the date that I finished it next to the checkbox (but may forget, this serves to remind me hopefully).

## TODOs

- [ ] TODO A mostly to all modules that are configured for user and system in their `default.nix` as lines of options being enabled instead of the current mess
  - possible because I like a lot of consistency across implementations personally
  - not so much about others being able to re-use them as it is about being able to craft new systems out of modular components wrapping my preferences overall.
- [ ] TODO custom built ISO
  - last version had this worked in but had structural problems requiring I rebase it, will look to old version for purposes of bringing this back
- [ ] TODO [Firefox Items](firefox.md)
- [ ] TODO Work in immutable library and mark directories I need as immutable
  - see that awfully corny article "Erase Your Darlings"

## DONE

- [x] DONE add in personal grub theme (turned out this is not as hard to do as it seemed at first)
- [x] DONE add in external nvim configuration
  - [x] DONE remove tooling to theme nvim here
- [x] DONE create script wrapper for git command (recreate _gita_)
- [x] DONE **2023-03-15** GIMP + GMIC - while GMIC package doesn't work, gimp-with-plugins comes with GMIC installed, solving this issue finally.
- [x] DONE **2023-03-16** User Fonts Added Reliably, Refactored `home-manager` fonts
- [x] DONE fix cursor issue, as such `home.file ={".icons/default".source ="${pkgs.phinger-cursors}/share/icons/phinger-cursors";};`
- [x] DONE include AwesomeWM's luajit fork
  - same Lua version that NeoVim uses, making life slightly easier
  - runs faster (at least for development restarts)
  - can use nix to bundle in lua modules I want or need included (always really want here, I don't like being tied to lua modules unless a fork is included in my configuration to mitigate suddenly breaking changes same as awesome components from third parties or libraries thereof. It's not that I like duplicating work, its that updates to these things only seem to make for more work for me, never any less, due to the size and specific nature of the configurations)
- [x] DONE convert submodules to flake inputs

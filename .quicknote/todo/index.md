# TODOs

These are to-do items for this repository, which may have additional notes on each item linked from here if such notes are necessary or desirable. When the to-do is finished, I intend to add the date that I finished it next to the checkbox (but may forget, this serves to remind me hopefully).

## NixOS Configuration TODOs

- [ ] [Firefox Items](firefox.md)
- [ ] Work in immutable library and mark directories I need as immutable 
  - see that awfully corny article "Erase Your Darlings" 
- [x] add in the templates from nixos-community/templates 
  - [ ] find additional templates as further examples and add them in as well.
- [ ] convert submodules to flake inputs 
- [x] add in personal grub theme (turned out this is not as hard to do as it seemed at first)
- [x] add in external nvim configuration
  - [ ] remove tooling to theme nvim here 
- [x] create script wrapper for git command (recreate _gita_)
- [x] **2023-03-15** GIMP + GMIC - while GMIC package doesn't work, gimp-with-plugins comes with GMIC installed, solving this issue finally.
- [x] **2023-03-16** User Fonts Added Reliably, Refactored `home-manager` fonts
- [x] fix cursor issue, as such `home.file ={".icons/default".source ="${pkgs.phinger-cursors}/share/icons/phinger-cursors";};`

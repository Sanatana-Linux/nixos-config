# TODOs

These are to-do items for this repository, which may have additional notes on each item linked from here if such notes are necessary or desirable. When the to-do is finished, I intend to add the date that I finished it next to the checkbox (but may forget, this serves to remind me hopefully).

## NixOS Configuration TODOs

- [ ] add in external nvim configuration

  - [ ] decide if it would be necessary or desirable to transfer ownership of repository to organization
  - [ ] remove tooling to theme nvim

- [ ] [Firefox Items](firefox.md)

- [x] **2023-03-15** GIMP + GMIC - while GMIC package doesn't work, gimp-with-plugins comes with GMIC installed, solving this issue finally.

- [x] **2023-03-16** User Fonts Added Reliably, Refactored `home-manager` fonts

- [x] fix cursor issue, see below: 

```nix
home.file ={
        ".icons/default".source =
           "${pkgs.phinger-cursors}/share/icons/phinger-cursors";};
```

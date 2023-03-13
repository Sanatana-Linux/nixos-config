# Systemd VConsole Setup Not Finding Font

- **Date:** 2023/03/12
- **Error or Issue Name:** Systemd VConsole Setup Not Finding Font
- **Notes on Mitigation Efforts**
  - Explored potential graphical driver issues
  - Rearranged importation of system 'profile' modules such that fonts are before console configurations 
  - Innumerable failures and issue persisted 
  - freshly installed OS from scratch including drive formatting
  - reset configuration several commits backwards 
  - finally discovered console.packages could be configured separately from fonts, thus included terminal fonts in it 
  - problem solved
- **Solution or Verdict:** Partially an issue arising from sparse documentation, mostly from my ignorance but rooted in the sort of obvious and annoyingly minor need to specify console packages so the console could find the terminus font. 

Credit the solution to my having put on the Trashmen's "*Surfin Bird*" when I finally came across some NixOS forum post that illuminated the need to specify console.packages. 
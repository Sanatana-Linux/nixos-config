{ colors }:

with colors;

''
  Xft.antialias: true
  Xft.hinting: true
  Xft.rgba: rgba
  Xft.autohint: false
  Xft.hintstyle: hintslight
  Xft.lcdfilter: lcddefault

  ! special
  *.foreground:       ${fg}
  *.background:       ${bg-darker}
  URxvt.cursorColor:  ${white}

  ! black
  *.color0:           ${bg-lighter}
  *.color8:           ${grey-lighter}

  ! red
  *.color1:           ${red}
  *.color9:           ${red-darker}

  ! green
  *.color2:           ${green}
  *.color10:          ${green-darker}

  ! yellow
  *.color3:           ${yellow}
  *.color11:          ${yellow-darker}

  ! blue
  *.color4:           ${blue}
  *.color12:          ${blue-darker}

  ! magenta
  *.color5:           ${magenta}
  *.color13:          ${magenta-darker}

  ! cyan
  *.color6:           ${cyan}
  *.color14:          ${cyan-darker}

  ! white
  *.color7:           ${fg}
  *.color15:          ${white}
''
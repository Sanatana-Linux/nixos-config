{pkgs}:
with pkgs;
  writeScriptBin "shrooms" ''
    #made by toru
    #irc.unixhub.net
    bkf=$'\e[30m';   rf=$'\e[31m';    gf=$'\e[32m'
    yf=$'\e[33m'   bf=$'\e[34m';   mf=$'\e[35m'
    cf=$'\e[36m';    wf=$'\e[37m'

    bkb=$'\e[40m';   rb=$'\e[41m';    gb=$'\e[42m'
    yb=$'\e[43m'   bb=$'\e[44m';   mb=$'\e[45m'
    cb=$'\e[46m';    wb=$'\e[47m'; rst=$'\e[0m'

    ibkf=$'\e[90m';   irf=$'\e[91m';    igf=$'\e[92m'
    iyf=$'\e[93m'   ibf=$'\e[94m';   imf=$'\e[95m'
    icf=$'\e[96m';    iwf=$'\e[97m'

    ibkb=$'\e[100m';   irb=$'\e[101m';    igb=$'\e[102m'
    iyb=$'\e[103m'   ibb=$'\e[104m';   imb=$'\e[105m'
    icb=$'\e[106m';    iwb=$'\e[107m';
    #over all length of mushrooms = 64

    # width of terminal
    width=$(tput cols)

    for ((v=0; v < ($width-64)/3; v++))
    do
        spaces="$spaces "
    done

    cat << EOF
    $ibkf   ▄▄█$wb▀$rb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$igb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$yb▀▀$wb▀█$rst$ibkf▄$rst$break$spaces    $ibkf   ▄▄█$wb▀$bb▀▀$wb▀█$rst$ibkf▄$rst
    $ibkf ▄█$rb▀$wf██▀$rf██$wf$rb▀██$ibkf▀█$rst$ibkf▄$rst$break$spaces $ibkf ▄█$igb▀$wf██▀$igf██$wf$igb▀██$ibkf▀█$rst$ibkf▄$rst$break$spaces $ibkf ▄█$yb▀$wf██▀$yf██$wf$yb▀██$ibkf▀█$rst$ibkf▄$rst$break$spaces $ibkf ▄█$bb▀$wf██▀$bf██$wf$bb▀██$ibkf▀█$rst$ibkf▄$rst
    $ibkf▄█$wf█$rb▄$rf██$wb▀▀▀▀██▀$wf█$rst$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$igb▄$igf██$wb▀▀▀▀██▀$wf█$rst$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$yb▄$yf██$wb▀▀▀▀██▀$wf█$rst$ibkf█▄$rst$break$spaces$ibkf▄█$wf█$bb▄$bf██$wb▀▀▀▀██▀$wf█$rst$ibkf█▄$rst
    $ibkf█$wf███$rf█$wf██████$rf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$igf█$wf██████$igf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$yf█$wf██████$yf█$wf███$ibkf█$rst$break$spaces$ibkf█$wf███$bf█$wf██████$bf█$wf███$ibkf█$rst
    $ibkf█$rf$wb▄▄██▄$wf████$rf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$igf$wb▄▄██▄$wf████$igf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$yf$wb▄▄██▄$wf████$yf$wb▄██▄▄$ibkf█$rst$break$spaces$ibkf█$bf$wb▄▄██▄$wf████$bf$wb▄██▄▄$ibkf█$rst
    $ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst$break$spaces$ibkf█$wb▄▄█▀▀█▀▀█▀▀█▄▄█$rst
    $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst$break$spaces $ibkf ▀█$wf███$ibkb▄██▄███$rst$ibkf█▀$rst
    $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$break$spaces  $ibkf  ▀█$wb▄▄▄▄▄▄▄▄█$rst$ibkf▀$rst$endofline
    $break
    EOF
  ''

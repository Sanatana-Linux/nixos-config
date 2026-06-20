- TODO in the kernel module lenovo_wmi_other/paramters is "expose_all_fans" which is set to N, could setting this to Y help ease the use of fan-control?


- TODO Keyboard light still not setting on boot, have to open the executible legion-kb-rgb from my downloads folder (not ideal FIX THIS SYSTEM WIDE)

- TODO Copilot key still not functioning as right control key

- TODO there is a firewall module with its own options as well as a firewall option in networking, removing the networkng suboption for firewall since it is redundant

- TODO with fail2ban and firewall module options enabled, the services themselves (using sysz to browse them) were always missing or otherwise not present, meaning not working. While I have disabled them now, make them functional for when I enable them next time.

- TODO there is a packages.nix file in modules/nixos/security but those packages should be within a nested option with the other packages.

- TODO in the custom fan control module adjust the curves so there are only three, the extreme curve becomes the performance curve, the current performance becomes the balanced and the current balanced becomes the quiet thus shifting all three that correspond to actual power modes. 

- TODO for upower in the laptop module is there a "warn on critical battery" option, if so enable it

- TODO rearrange some of the nixos modules subdirectories and thus options and suboptions as they are nested when enabled such as: 
    - in hardware create a lenovo subdirectory, move hardware/lenovo.nix to be hardware/lenovo/default.nix 
    - move power/laptop.nix to be hardware/lenovo/power.nix and eliminate the power/ directory afterwards
    - performance/ should be nested within system/
    - performance/cooling.nix moved and nested within hardware/lenovo/cooling.nix
    - printer/ should be moved to within hardware/devices/printer/ 
    - hardware/android.nix, hardware/iphone.nix, hardware/logitech.nix should be moved to hardware/devices/ 
    - hardware/networking.nix should be moved  to system/
    - security should be moved to system/ 
    - ai/ moved to be a subdirectory of apps/ 
    - apps/ should be a subdirectory of system/ 
    - desktop should be a subdirectory of system/
    - there is a tpm.nix in hardware/ when it makes more sense in security/


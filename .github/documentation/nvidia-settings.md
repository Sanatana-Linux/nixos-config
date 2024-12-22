```nix
         reverseSync ={
           enable = true;
           setupCommands.enable = true;
         };
        
        # ----------------------------
        
        sync.enable = true;
        allowExternalGpu = true;
        
        # ----------------------------
        
       offload = {
         enable = true;
         enableOffloadCmd = true;
       };
        
        # ----------------------------


```

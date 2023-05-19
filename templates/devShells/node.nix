let pkgs = import <nixpkgs> {};

    buildNodejs = pkgs.callPackage <nixpkgs/pkgs/development/web/nodejs/nodejs.nix> {};

# versions available
    nodejs-20= buildNodejs {
 enableNpm = true;
  version = "20.0.0";
  sha256 = "sha256-dFDnV5Vo99HLOYGFz85HLaKDeyqjbFliCyLOS5d7XLU=";
 
};

nodejs-19 = buildNodejs {
  enableNpm = true;
  version = "19.9.0";
  sha256 = "sha256-x/zp1Gymzg2JkEM8v2AbuSecDq7YcFs1cBjPUL6b7Sk=";

};

nodejs-18 = buildNodejs {
  enableNpm = true;
  version = "18.16.0";
  sha256 = "sha256-M9gaIz4jWlCa3aSk8iCQCNBFkZed5rPw9nwckGCT8Rg=";
};

nodejs-16 = buildNodejs {
enableNpm = true ;
    version = "16.20.0";
    sha256 = "sha256-4JkPmSI05ApR/hH5LDgWyTp34bCBFF0912LNECY0U0k=";
  };



nodejs-14 =   buildNodejs {
    enableNpm = true;
    version = "14.21.3";
    sha256 = "sha256-RY7AkuYK1wDdzwectj1DXBXaTHuz0/mbmo5YqZ5UB14=";
  };


    nodejs-12 = buildNodejs {
      enableNpm = true;
      version = "12.13.0";
      sha256 = "1xmy73q3qjmy68glqxmfrk6baqk655py0cic22h1h0v7rx0iaax8";
    };

    nodejs-10 = buildNodejs {
      enableNpm = true;
      version = "10.19.0";
      sha256 = "0sginvcsf7lrlzsnpahj4bj1f673wfvby8kaxgvzlrbb7sy229v2";
    };

    nodejs-8 = buildNodejs {
      enableNpm = true;
      version = "8.17.0";
      sha256 = "1zzn7s9wpz1cr4vzrr8n6l1mvg6gdvcfm6f24h1ky9rb93drc3av";
    };

# set to the needed version here
    nodejs-current = nodejs-12;

in pkgs.mkShell rec {
  name = "webdev";
  
  buildInputs = with pkgs; [
    nodejs-current
    (yarn.override { nodejs = nodejs-current; })
    
  ];
}
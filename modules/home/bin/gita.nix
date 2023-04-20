{ pkgs }:

with pkgs;

writeScriptBin "gita" ''
#!/usr/bin/env bash

git add --all .

git commit $1 || git commit

git push \

''

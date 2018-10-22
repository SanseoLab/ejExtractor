# ejExtractor
Integrated tool for extracting scripts and binaries of AutoIt, AutoHotKey, InnoSetup, NSIS executables.


## Description
There are a lot of tools for each executables like AutoIt, AutoHK, InnoSetup, NSIS etc. So i just simply integrated these tools into command line script. I think it can be used to automate some jobs too.

- Autoit : using exe2aut
- AutoHK : using simple python script for version L and tool [ https://github.com/Kalamity/Exe2AhkPatched ] for version B
- InnoSetup : using innounp47.exe. It can extract everything include installation script(.iss).
- NSIS : using 7z version 15.05. This version can extract everything include installation script(.NSS).


## Usage
- > ejExtractor.py -[Option] [Path]


## Options
-h : Help
-l : AutoHotKey version L
-b : AutoHotKey version B
-A : AutoIt Simple Way ( +AutoHK )
-a : AutoIt Another Way ( +AutoHK )
-i : InnoSetup
-n : NSIS


## TODO
Finding what to add.


# ejExtractor
Integrated tool for extracting scripts and binaries of AutoIt, AutoHotKey, InnoSetup, NSIS executables, MSI and powershell Encoding/Decoding.


## Description
There are a lot of tools for each executables like AutoIt, AutoHK, InnoSetup, NSIS etc. So i just simply integrated these tools into command line script. I think it can be used to automate some jobs too. (+ powrshell encoding routines)

- Autoit : using exe2aut
- AutoHK : using simple python script for version L and tool [ https://github.com/Kalamity/Exe2AhkPatched ] for version B
- InnoSetup : using innounp47.exe. It can extract everything include installation script(.iss).
- NSIS : using 7z version 15.05. This version can extract everything include installation script(.NSS).
- MSI : using jsMSIx.exe. It can extract files with path, and we can check registry configuration too with "MSI Unpack.log" which generated in same folder.
- Powershell : There are some encoding mechanisms used in malwares like deflate, gzip, secure string. It can decode / encode base64 string which encrypted with these algorithms, So you should make txt file for input with extracted from powershell command lines. If it use secure string, then you also need key and you should add -key option and give a key with command line.


## Usage
> ejExtractor.py -[Option] [Path]
- ex)
> ejExtractor.py -n C:\test.exe

for Secure String of Powershell
> ejExtractor.py -[Option] [Path] -key [key]
- ex) 
> ejExtractor.py -psd C:\test.txt -key 35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50


## Options
- -h : Help
- -l : AutoHotKey version L
- -b : AutoHotKey version B
- -A : AutoIt Simple Way ( +AutoHK )
- -a : AutoIt Another Way ( +AutoHK )
- -i : InnoSetup
- -n : NSIS
- -m : MSI
- -pdd : Powershell Deflate Decode
- -pde : Powershell Deflate Encode
- -pgd : Powershell GZip Decode
- -pge : Powershell GZip Encode
- -psd : Powershell Secure String Decode
- -pse : Powershell Secure String Encode


## TODO
Finding what to add.


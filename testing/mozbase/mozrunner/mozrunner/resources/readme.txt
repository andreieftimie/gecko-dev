For building the firefoxdefault.au3 script please download the kit from:
http://www.autoitscript.com/site/autoit-script-editor/downloads/

We need 2 executables for both 32b and 64b architecture. For this we need to
set a flag when compiling the au3 script:
> Aut2exe.exe /in firefoxdefault.au3 /out firefoxdefault_32.exe /x86
> Aut2exe.exe /in firefoxdefault.au3 /out firefoxdefault_64.exe /x64

@echo off
title dopatch.bat by Yoti
if "%1"=="" (
	echo Error: no TITLE_ID
	goto thisistheend
)
for %%i in (PSV_GAMES.*) do del /q %%i
del /q *.PKL
del /q *.XFL
del /q *.xml
if not exist wget.exe (
	echo Error: no wget
	echo https://eternallybored.org/misc/wget/
	goto thisistheend
)
if not exist pkg2zip.exe (
	echo Error: no pkg2zip
	echo https://github.com/mmozeiko/pkg2zip/releases
	goto thisistheend
)
if not exist psvpfsparser.exe (
	echo Error: no psvpfsparser
	echo https://github.com/motoharu-gosuto/psvpfstools/releases
	goto thisistheend
)

echo Step 1 of 3 (wget)
start /wait getpatch %1
if not exist %1.XFL (
	echo Error: no XFL [XML File Link]
	goto thisistheend
)
set /p xfl=<%1.XFL
wget -q --no-check-certificate --show-progress -O %1.xml %xfl%
for %%i in (%1.xml) do (
	if %%~zi equ 0 (
		echo Error: no PKG [Patches Found]
		goto thisistheend
	)
)
xmlparse %1.xml quite
set /p pkg=<%1.PKL
wget -q --show-progress -O %1.pkg %pkg%

echo Step 2 of 3 (pkg2zip)
pkg2zip -x %1.pkg
move %1.pkg patch

echo Step 3 of 3 (psvpfstools)
wget -q --show-progress https://nopaystation.com/tsv/PSV_GAMES.tsv
findstr /I %1 PSV_GAMES.tsv > PSV_GAMES.txt
tsvparse PSV_GAMES.txt quite
if not exist PSV_GAMES.ZRF (
	echo Error: no ZRF [zRIF String]
	goto thisistheend
)
set /p rif=<PSV_GAMES.ZRF
psvpfsparser.exe -i patch\%1 -o patch\%1_dec -z %rif% -f cma.henkaku.xyz

:thisistheend
pause

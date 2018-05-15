@echo off
rem pkgtool.bat by Yoti
if "%1"=="" (
	echo Error: no TITLE_ID
	goto thisistheend
)
for %%i in (PSV_GAMES.*) do del /q %%i
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
wget -q --show-progress https://nopaystation.com/tsv/PSV_GAMES.tsv
findstr /I %1 PSV_GAMES.tsv > PSV_GAMES.txt
tsvparse PSV_GAMES.txt quite
if not exist PSV_GAMES.PKL (
	echo Error: no PKL [PKG Link]
	goto thisistheend
)
set /p pkg=<PSV_GAMES.PKL
if not exist PSV_GAMES.ZRF (
	echo Error: no ZRF [zRIF String]
	goto thisistheend
)
set /p rif=<PSV_GAMES.ZRF
wget -q --show-progress -O %1.pkg %pkg%

echo Step 2 of 3 (pkg2zip)
pkg2zip -x %1.pkg %rif%
move %1.pkg app

echo Step 3 of 3 (psvpfstools)
psvpfsparser.exe -i app\%1 -o app\%1_dec -z %rif% -f cma.henkaku.xyz

:thisistheend
pause

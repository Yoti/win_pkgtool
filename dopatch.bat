@echo off
title dopatch.bat by Yoti
if "%1"=="" (
	echo Error: no TITLE_ID
	goto thisistheend
)
rd /s /q !temp
mkdir !temp
if not exist !bin\wget.exe (
	echo Error: no wget
	echo https://eternallybored.org/misc/wget/
	goto thisistheend
)
if not exist !bin\pkg2zip.exe (
	echo Error: no pkg2zip
	echo https://github.com/mmozeiko/pkg2zip/releases
	goto thisistheend
)
if not exist !bin\psvpfsparser.exe (
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
move %1.XFL !temp
set /p xfl=<!temp\%1.XFL
!bin\wget -q --no-check-certificate --show-progress -O !temp\%1.xml %xfl%
for %%i in (!temp\%1.xml) do (
	if %%~zi equ 0 (
		echo Error: no PKG [Patches Found]
		goto thisistheend
	)
)
xmlparse !temp\%1.xml quite
set /p pkg=<!temp\%1.PKL
!bin\wget -q --show-progress -O %1.pkg %pkg%

echo Step 2 of 3 (pkg2zip)
!bin\pkg2zip -x %1.pkg
move %1.pkg patch

echo Step 3 of 3 (psvpfstools)
!bin\wget -q --show-progress -O !temp\PSV_GAMES.tsv https://nopaystation.com/tsv/PSV_GAMES.tsv
findstr /I %1 !temp\PSV_GAMES.tsv > !temp\PSV_GAMES.txt
tsvparse !temp\PSV_GAMES.txt quite
if not exist !temp\PSV_GAMES.ZRF (
	echo Error: no ZRF [zRIF String]
	goto thisistheend
)
set /p rif=<!temp\PSV_GAMES.ZRF
!bin\psvpfsparser.exe -i patch\%1 -o patch\%1_dec -z %rif% -f cma.henkaku.xyz

:thisistheend
pause

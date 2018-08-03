@echo off
title dopatch.bat by Yoti
if "%1"=="" (
	echo Error: no TITLE_ID
	goto thisistheend
)
if not exist !temp mkdir !temp
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
start /wait !bin\getpatch %1
ren %1.XFL %1-PATCH.XFL
if not exist %1-PATCH.XFL (
	echo Error: no XFL [XML File Link]
	goto thisistheend
)
move %1-PATCH.XFL !temp
set /p xfl=<!temp\%1-PATCH.XFL
!bin\wget -q --no-check-certificate --show-progress -O !temp\%1-PATCH.XML %xfl%
for %%i in (!temp\%1-PATCH.XML) do (
	if %%~zi equ 0 (
		echo Error: no PKG [Patches Found]
		goto thisistheend
	)
)
findstr /I http !temp\%1-PATCH.XML > !temp\%1-PATCH.STR
!bin\myparser !temp\%1-PATCH.STR http \34 .PKL
set /p pkg=<!temp\%1-PATCH.PKL
!bin\wget -q --show-progress -O %1.pkg %pkg%

echo Step 2 of 3 (pkg2zip)
!bin\pkg2zip -x %1.pkg
move %1.pkg patch

echo Step 3 of 3 (psvpfstools)
!bin\wget -q --show-progress -O !temp\%1-PATCH.TSV https://nopaystation.com/tsv/PSV_GAMES.tsv
findstr /I %1 !temp\%1-PATCH.TSV > !temp\%1-PATCH.STR
!bin\myparser !temp\%1-PATCH.STR KO5i \9 .ZRF
if not exist !temp\%1-PATCH.ZRF (
	echo Error: no ZRF [zRIF String]
	goto thisistheend
)
set /p rif=<!temp\%1-PATCH.ZRF
!bin\psvpfsparser.exe -i patch\%1 -o patch\%1_dec -z %rif% -f cma.henkaku.xyz

:thisistheend
cd !temp
for %%i in (%1-PATCH.*) do del /q %%i
cd ..

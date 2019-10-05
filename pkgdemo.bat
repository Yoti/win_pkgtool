@echo off
title pkgdemo.bat by Yoti
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
	echo https://github.com/lusid1/pkg2zip/releases
	goto thisistheend
)
if not exist !bin\psvpfsparser.exe (
	echo Error: no psvpfsparser
	echo https://github.com/motoharu-gosuto/psvpfstools/releases
	goto thisistheend
)

echo Step 1 of 3 (wget)
!bin\wget -q --show-progress -O !temp\%1-DEMO.TSV http://proxy.nopaystation.com/http://beta.nopaystation.com/tsv/PSV_DEMOS.tsv
findstr /I %1 !temp\%1-DEMO.TSV > !temp\%1-DEMO.STR
!bin\myparser !temp\%1-DEMO.STR http .pkg .PKL >NUL
if not exist !temp\%1-DEMO.PKL (
	echo Error: no PKL [PKG Link]
	goto thisistheend
)
set /p pkg=<!temp\%1-DEMO.PKL
!bin\myparser !temp\%1-DEMO.STR KO5i \9 .ZRF >NUL
if not exist !temp\%1-DEMO.ZRF (
	echo Error: no ZRF [zRIF String]
	goto thisistheend
)
set /p rif=<!temp\%1-DEMO.ZRF
!bin\wget -q --show-progress -O %1.pkg %pkg%

echo Step 2 of 3 (pkg2zip)
!bin\pkg2zip -x %1.pkg %rif%
move %1.pkg app

echo Step 3 of 3 (psvpfstools)
!bin\psvpfsparser.exe -i app\%1 -o app\%1_dec -z %rif% -f cma.henkaku.xyz

:thisistheend
cd !temp
for %%i in (%1-DEMO.*) do del /q %%i
cd ..

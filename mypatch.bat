@echo off
title mypatch.bat by Yoti

if exist app (
	if not exist mypatch mkdir mypatch
	cd app
	for /D %%i in (*) do (
		if exist %%i\sce_pfs (
			mkdir ..\mypatch\%%i
			mkdir ..\mypatch\%%i\sce_sys
			if exist ..\patch\%%i\sce_sys\param.sfo (
				copy /b ..\patch\%%i\sce_sys\param.sfo ..\mypatch\%%i\sce_sys
			) else (
				copy /b %%i\sce_sys\param.sfo ..\mypatch\%%i\sce_sys
			)
		)
	)
)

pause

del *.ppu /s
del *.o /s
del *.~* /s
del *.cfg /s
del *.dsk /s
del *.s /s
del *.a /s
del *.exe /s
del *.log /s
del *.dbg /s
del *.lps /s
del *.res /s
echo --------------------------------------------------------
echo delete directories with subdirectories and files 
echo---------------------------------------------------------
for /r %1 %%R in (backup) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (lib) do if exist "%%R" (rd /s /q "%%R")
for /r %1 %%R in (bin) do if exist "%%R" (rd /s /q "%%R")
pause

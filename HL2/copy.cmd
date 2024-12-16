@echo off

set "source=%~dp0"
set "dest=E:\Program Files\Steam\steamapps\common\Half-Life 2"

xcopy "%source%" "%dest%" /B /E /Y /EXCLUDE:%~dp0\xcopy_exclude.txt

pause

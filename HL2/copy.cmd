@echo off

@REM Copy SourceConfig
set "source=%~dp0"
set "dest=E:\Program Files\Steam\steamapps\common\Half-Life 2"
xcopy "%source%" "%dest%" /B /E /Y /EXCLUDE:%~dp0\xcopy_exclude.txt

@REM Copy Workshop (custom halflife2.ttf)
@rem set "source=E:\Program Files\Steam\steamapps\workshop\content\220\3385514681"
@rem
@rem set "dest=ep2\custom hl2\custom hl2_complete\custom lostcoast\custom workshop\custom"
@rem
@rem for %%d in (%dest%) do (
@rem   set "dest_t=E:\Program Files\Steam\steamapps\common\Half-Life 2\%%d"
@rem   mkdir "%dest_t%" 1>nul 2>nul
@rem   xcopy "%source%\*.vpk" "%dest_t%\" /E /Q /Y
@rem )

pause

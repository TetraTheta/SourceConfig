@echo off

set "target=E:\Program Files\Steam\steamapps\workshop\content"

echo Cleaning sound.cache
for /r "%target%" %%f in (*.sound.cache) do (
  echo Deleting %%f
  del "%%f"
)

echo Removing empty directories
red -y "%target%"

pause

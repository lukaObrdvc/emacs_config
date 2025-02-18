@echo off

pushd ..\exe
REM cl -Zi ..\code\cardcrafter.cpp /link /DLL /EXPORT:update_and_render
cl -Zi ..\code\win32_cardcrafter.cpp /link user32.lib gdi32.lib kernel32.lib winmm.lib
popd

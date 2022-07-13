@echo off
set BLSLMAKETOOLS=C:\BLSLTools\make\cygwin_v2\bin
cd ..\..
echo moving to directory: %cd%
C:\BLSLTools\make\cygwin_v2\bin\make -Otarget --file=./util/make/Makefile_HighTec.mk clean
pause
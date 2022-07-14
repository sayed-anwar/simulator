@echo off
set BLSLMAKETOOLS=C:\cygwin_v2\bin
set UserBuildConfigFile=./srcECU1/BuildConfig.mk
cd ..\..
echo moving to directory: %cd%
C:\cygwin_v2\bin\make -Otarget --file=./util/make/Makefile.mk clean
cd ./util/make
pause
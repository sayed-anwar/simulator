@echo off
set BLSLMAKETOOLS=C:\cygwin_v2\bin
set UserBuildConfigFile=./srcBase/BuildConfig.mk
cd ..\..
echo moving to directory: %cd%
C:\cygwin_v2\bin\make -Otarget --file=./util/make/Makefile.mk build debug=all


cd ./util/make
REM pause
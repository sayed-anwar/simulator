@echo off


set arg1=%1
set arg2=%2
set arg3=%3

echo batch: Start of script execution.
cp %arg1% %arg2% 
cp %arg1% %arg3%
echo batch: End of script execution.
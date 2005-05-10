@echo off
setlocal
set ICE_HOME=c:\Src\vc60\stage\Ice-2.1.1

set BERKELEY_HOME=c:\Src\vc60\db-4.2.52
set BZIP2_HOME=c:\Src\vc60\bzip2-1.0.2
set EXPAT_HOME=c:\Src\vc60\Expat-1.95.8
set OPENSSL_HOME=c:\Src\vc60\openssl-0.9.7e
set STLPORT_HOME=c:\Src\vc60\STLport-4.6.2
set PHP_BIN_HOME=c:\php-5.0.3
set PHP_SRC_HOME=c:\Src\php-5.0.3

set ANT_HOME=C:\apache-ant-1.6.2
set INSTALLSHIELD_HOME=C:\Program Files\InstallShield\DevStudio 9\System
set PYTHON_HOME=C:\Python24

REM XXX You shouldn't need to edit below this line. XXX

set PATH=%ANT_HOME%\bin;%INSTALLSHIELD_HOME%;%PYTHON_HOME%;%PATH%
set LIB=
set INCLUDE=
call "%SystemDrive%\VC98\Bin\vcvars32.bat"
python ..\common\makewindist.py %1 %2 %3 %4 %5 %6 %7 %8 %9
endlocal

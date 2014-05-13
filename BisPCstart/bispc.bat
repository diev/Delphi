@echo off
rem
rem
rem Переменные SharedFolder и SharedFolder_setting путь где находится программа и настройки
rem


IF /I %ComputerName%==S6600-TS01 exit;
IF /I %ComputerName%==S6600-TS02 exit;
IF /I %ComputerName%==S6600-FS01 exit;
IF /I %ComputerName%==S6600-FS02 exit;

set folder_BP="C:\Program Files\BIS\BisPC"
set SharedFolder=\\S6600-FS01\Script\BisPC\Pr\
set SharedFolder_setting=\\S6600-FS01\Script\BisPC\Setting\
rem set Logi=\\s6600-fs01\AdminsLogs\memory\Logi.txt

echo %COMPUTERNAME% | find "W6600" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6600.txt
echo %COMPUTERNAME% | find "W6601" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6601.txt
echo %COMPUTERNAME% | find "W6602" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6602.txt
echo %COMPUTERNAME% | find "W6603" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6603.txt
echo %COMPUTERNAME% | find "W6604" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6604.txt
echo %COMPUTERNAME% | find "W6605" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6605.txt
echo %COMPUTERNAME% | find "W6606" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6606.txt
echo %COMPUTERNAME% | find "W6607" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6607.txt
echo %COMPUTERNAME% | find "W6608" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6608.txt
echo %COMPUTERNAME% | find "W6609" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6609.txt
echo %COMPUTERNAME% | find "W6610" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6610.txt
echo %COMPUTERNAME% | find "W6611" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6611.txt
echo %COMPUTERNAME% | find "W6612" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6612.txt
echo %COMPUTERNAME% | find "W6613" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6613.txt
echo %COMPUTERNAME% | find "W6614" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6614.txt
echo %COMPUTERNAME% | find "W6615" 
if not errorlevel 1 set Logi=\\s6600-fs01\AdminsLogs\memory\6615.txt

echo "---------------------------------------------------------------" >> %Logi%

rem cacls "C:\Program Files\IBM" /E /C /G "6600-SG-GPF-USR-ALL":C >> %Logi%
rem cacls "C:\Program Files\Lotus" /E /C /G "6600-SG-GPF-USR-ALL":C >> %Logi%
echo "------------ CacheHttpHeaders ---------------------" >> %Logi%
regedit /s %SharedFolder_setting%CacheHttpHeaders.reg >> %Logi%
echo "---------------------------------------------------------------" >> %Logi%

echo "------------ SignCrypt.ocx ---------------------" >> %Logi%
rem regsvr32 /u "C:\Windows\Downloaded Program Files\SignCrypt.ocx" >> %Logi%
rem regsvr32 "C:\Windows\Downloaded Program Files\SignCrypt.ocx" >> %Logi%
echo "---------------------------------------------------" >> %Logi%

rem Windows XP
ver | find "5.1." >> %Logi%
if not errorlevel 1 set AutoLoad="%ALLUSERSPROFILE%\Главное меню\Программы\Автозагрузка\"
rem Windows 7 Seven
ver | find "6.1." >> %Logi%
if not errorlevel 1 set AutoLoad="%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\Startup"

if not exist %folder_BP% (
        echo %date% %time% %COMPUTERNAME% Setup >> %Logi%
	mkdir %folder_BP% >> %Logi%
	cacls %folder_BP% /E /C /G "Все":F >> %Logi%
        cacls %folder_BP% /E /C /G "Domain Users":F >> %Logi%
	copy %SharedFolder%* %folder_BP% >> %Logi%
        copy %SharedFolder_setting%\BisPCstart.lnk %AutoLoad% >> %Logi%
        %folder_BP%\BisPCstart.exe >> %Logi%
) else (
        echo "Обновление..."
        echo %date% %time% %COMPUTERNAME% Update >> %Logi%
        xcopy %SharedFolder%* %folder_BP% /f /r /y /d /c  >> %Logi%
) 

echo %COMPUTERNAME% | find "W6600" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6600.reg

echo %COMPUTERNAME% | find "W6615" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6600.reg


echo %COMPUTERNAME% | find "W6601" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6601.reg >> %Logi%
echo %COMPUTERNAME% | find "W6602" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6602.reg >> %Logi%
echo %COMPUTERNAME% | find "W6603" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6603.reg >> %Logi%
echo %COMPUTERNAME% | find "W6604" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6604.reg >> %Logi%
echo %COMPUTERNAME% | find "W6605" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6605.reg >> %Logi%
echo %COMPUTERNAME% | find "W6606" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6606.reg >> %Logi%
echo %COMPUTERNAME% | find "W6607" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6607.reg >> %Logi%
echo %COMPUTERNAME% | find "W6608" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6608.reg >> %Logi%
echo %COMPUTERNAME% | find "W6609" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6609.reg >> %Logi%
echo %COMPUTERNAME% | find "W6610" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6610.reg >> %Logi%
echo %COMPUTERNAME% | find "W6611" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6611.reg >> %Logi%
echo %COMPUTERNAME% | find "W6612" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6612.reg >> %Logi%
echo %COMPUTERNAME% | find "W6613" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6613.reg >> %Logi%
echo %COMPUTERNAME% | find "W6614" 
if not errorlevel 1 regedit /s %SharedFolder_setting%6614.reg >> %Logi%


if exist c:\BisPC\ rd /S /Q c:\BisPC\


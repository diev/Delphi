@echo off

set SharedFolder=\\s6600-fs01\Script\Templates\
echo 6601 усть-орда
xcopy %SharedFolder%* \\10.194.129.2\Public\Templates\ /f /r /y /d /c
echo 6602 Куйтун
xcopy %SharedFolder%* \\10.194.130.2\Public\Templates\ /f /r /y /d /c
echo 6603 усть-уда
xcopy %SharedFolder%* \\10.194.131.2\Public\Templates\ /f /r /y /d /c
echo 6604 Кутулик
xcopy %SharedFolder%* \\10.194.132.2\Public\Templates\ /f /r /y /d /c
echo 6605 тайшет
xcopy %SharedFolder%* \\10.194.133.2\Public\Templates\ /f /r /y /d /c
echo 6606 еланцы 
xcopy %SharedFolder%* \\10.194.134.2\Public\Templates\ /f /r /y /d /c
echo 6607 Оса
xcopy %SharedFolder%* \\10.194.135.2\Public\Templates\ /f /r /y /d /c
echo 6608 черемхово
xcopy %SharedFolder%* \\10.194.136.2\Public\Templates\ /f /r /y /d /c
echo 6609 чуна
xcopy %SharedFolder%* \\10.194.137.2\Public\Templates\ /f /r /y /d /c
echo 6610 Братск
xcopy %SharedFolder%* \\10.194.138.2\Public\Templates\ /f /r /y /d /c
echo 6611 Нижнеудинск
xcopy %SharedFolder%* \\10.194.139.2\Public\Templates\ /f /r /y /d /c
echo 6612 Тулун
xcopy %SharedFolder%* \\10.194.140.2\Public\Templates\ /f /r /y /d /c
echo 6613 Залари
xcopy %SharedFolder%* \\10.194.141.2\Public\Templates\ /f /r /y /d /c
echo 6614 усолье
xcopy %SharedFolder%* \\10.194.142.2\Public\Templates  /f /r /y /d /c

pause  


@echo off

set SharedFolder=\\s6600-fs01\Script\Templates\
echo 6601 ����-�ठ
xcopy %SharedFolder%* \\10.194.129.2\Public\Templates\ /f /r /y /d /c
echo 6602 ����
xcopy %SharedFolder%* \\10.194.130.2\Public\Templates\ /f /r /y /d /c
echo 6603 ����-㤠
xcopy %SharedFolder%* \\10.194.131.2\Public\Templates\ /f /r /y /d /c
echo 6604 ���㫨�
xcopy %SharedFolder%* \\10.194.132.2\Public\Templates\ /f /r /y /d /c
echo 6605 ⠩��
xcopy %SharedFolder%* \\10.194.133.2\Public\Templates\ /f /r /y /d /c
echo 6606 ������ 
xcopy %SharedFolder%* \\10.194.134.2\Public\Templates\ /f /r /y /d /c
echo 6607 ��
xcopy %SharedFolder%* \\10.194.135.2\Public\Templates\ /f /r /y /d /c
echo 6608 �६客�
xcopy %SharedFolder%* \\10.194.136.2\Public\Templates\ /f /r /y /d /c
echo 6609 �㭠
xcopy %SharedFolder%* \\10.194.137.2\Public\Templates\ /f /r /y /d /c
echo 6610 ����
xcopy %SharedFolder%* \\10.194.138.2\Public\Templates\ /f /r /y /d /c
echo 6611 �����㤨��
xcopy %SharedFolder%* \\10.194.139.2\Public\Templates\ /f /r /y /d /c
echo 6612 ���
xcopy %SharedFolder%* \\10.194.140.2\Public\Templates\ /f /r /y /d /c
echo 6613 �����
xcopy %SharedFolder%* \\10.194.141.2\Public\Templates\ /f /r /y /d /c
echo 6614 �᮫�
xcopy %SharedFolder%* \\10.194.142.2\Public\Templates  /f /r /y /d /c

pause  


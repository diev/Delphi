unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

{
 @echo off
 rem ������ ��������� ������ �� ���
 cls
 set inc=C:\uarm\exg\chk\
 set arhiv=D:\Archive\
 set in=Q:\in\
 set d=%date:~9,4%%date:~6,2%%date:~3,2%\
 echo ===================================================================
 echo ������ ��������� %date% %time%
 echo ===================================================================
 if not exist %arhiv%%d% mkdir %arhiv%%d%
 if not exist %in% (
	net use Q: /del
	net use Q: \\rsb\imp-exp\mci
 )
:begin
 for  %%o in (%inc%*.*) do (
	copy %%o %arhiv%%d%
 	move %%o %in%
	echo %date% %time% ���� %%o ��������� �� ��� � ����� � �� ���������  
	echo >> c:\temp\logfromSVK.txt %date% %time% ���� %%o ��������� �� ��� � ����� � �� ���������  
	echo ===================================================================
        ping -n 10 -w 1000 127.0.0.1>nul
 )
ping -n 30 -w 1000 127.0.0.1>nul 
goto begin

 @echo off
 rem ������ ������� ������ � ���
 set arhiv=D:\Archive\
 set inc=C:\uarm\exg\val\
 set out=Q:\out\
 set d=%date:~9,4%%date:~6,2%%date:~3,2%\
 cls
 echo ===================================================================
 echo ������ ��������� %date% %time%
 echo ===================================================================
 if not exist %arhiv%%d% mkdir %arhiv%%d%
 if not exist %out% (
	net use Q: /del
	net use Q: \\rsb\imp-exp\mci
 )
 for  %%o in (%out%*.xml) do (
	copy %%o %arhiv%%d%
 	move %%o %inc%
	echo %date% %time% ���� %%o ��������� � ����� � � ���
	echo >> c:\temp\loginsvk.txt %date% %time% ���� %%o ��������� � ����� � � ���
 )
 echo ===================================================================
 echo ����� ��������� %date% %time%
 echo ===================================================================
 pause

}








end.

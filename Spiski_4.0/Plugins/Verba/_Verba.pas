{************************************************************}
{                                                            }
{       ������ ��� ������ �� ��������� �  API �����          }
{       Copyright (�) 2010 ����                              }
{               �����/������                                 }
{                                                            }
{  �����������: ������ �.�.                                  }
{  �������������: 15 ���� 2011                               }
{                                                            }
{************************************************************}

unit Verba;

interface

uses
  Windows, SysUtils, Forms, Dialogs, ShellApi, classes;

type

  T16Bit = integer;

  TVerba = class
    procedure Clear;
    procedure Load_key;
    procedure DeCrypt(f:string);
    procedure EnCrypt;
    procedure EnCryptAnswer(f:string);
    constructor Create;
    destructor  Destroy; override;
    private
    fKEY:integer;
    EMAIL,OTD:String;
    function CheckEnCrypt(f:string):boolean;
  end;

var
  Vrb:TVerba;

implementation

uses Main, Tools,  form_spk;
{******************************************************************************
  ��������: �����������
  ���: ����������
*******************************************************************************}
constructor TVerba.Create;
begin
  fKEY:=0;
  EMAIL:='';
  OTD :='';
  CryptoInit(pAnsiChar(MainForm.sec),pAnsiChar(MainForm.Pub));
  SignInit(pAnsiChar(MainForm.sec),pAnsiChar(MainForm.Pub));
end;
{******************************************************************************
  ��������: ���������� ���������� �� ����
  ���: ����������
*******************************************************************************}
function TVerba.CheckEnCrypt(f: string): boolean;
var
  ff:TextFile;
  ss1:string;
begin
   AssignFile(ff,f);
   Reset(ff);
   ReadLn(ff,ss1);
   CloseFile(ff);

   ss1:=trim(DosToWin(ss1));
   if copy(ss1,1,4)<>'����' then Result:=true else Result:=false;

end;
{******************************************************************************
  ��������: ��������� �����
  ���: �������      � dll
*******************************************************************************}
procedure TVerba.Load_key;
begin
try
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\AsrKeyC.exe', 'R','S:\RSHB\Spiski\scripts\', SW_show); //   key_dev:='A:\\';   InitKey(@key_dev,pAnsiChar(''));
except
  MessageDlg('������ �������� ������', mtError,[mbOk], 0);
end;
end;
{******************************************************************************
  ��������: ������������� � ��������,������ ���
  ���: �������
  �����������:
*******************************************************************************}
procedure TVerba.DeCrypt(f: string);
  procedure SignInfo(f: string);
  var
    tf:TextFile;
    st:string;
    count:T32bit;
    info:Psign_info;
  begin
            count:=0;
            GetFileSignInfo(pAnsiChar(f),@info,@count);
            if count>0 then begin   // ���� ��� 
              fKEY:=strtoint(copy(info[0].key_id,1,4));
              DelSign(pAnsiChar(f),-1);

              AssignFile(tf,MainForm.Abonents_list);
              Reset(tf);
              while not EOF(tf) do begin
                Readln(tf,st);
                if strtoint(Copy(st,Pos(';',st)+1,4))= fKEY then begin
                  OTD:=copy(st,1,pos(';',st)-1);Delete(st,1,pos(';',st));
                  EMAIL:=copy(st,pos(';',st)+1,Length(st));
                  Break;
                end
              end;
              CloseFile(tf);
              MainForm.Label5.Caption:='���������: '+OTD;
              MainForm.Label6.Caption:='����: '+inttostr(fKEY);
              MainForm.Label7.Caption:='����������� �����: '+ EMAIL;

            end else if count=0 then begin
              MessageDlg('�� ���� ����������� ���!', mtError,[mbOk], 0);
              fKEY:=0;
              EMAIL:='';
              OTD :='';
              mainform.label5.caption:='���������: ���������� ';
              mainform.label6.caption:='�� ��������';
              mainform.label7.caption:='����������� �����: ���������� ';
              end;
  end;
begin
   if CheckEnCrypt(f) then begin 
      if DeCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank)<>0 then 
	      begin
	        MessageDlg('���� �� �����������, ��������� ����� � ������ !', mtError,[mbOk], 0);
	        exit;
        end
   end
   else MessageDlg('���� ����� ����������', mtInformation,[mbOk], 0);

   SignInfo(f);

end;
{******************************************************************************
   ��������: ���������� �������
   ���: �������
*******************************************************************************}
procedure TVerba.EnCryptAnswer(f: string);
begin
if fKEY<>0 then begin    // ���
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\UtilKeyC.exe',pAnsiChar('P '+f+' '+f+' '+MainForm.sec+' '+MainForm.Pub),'S:\RSHB\Spiski\scripts\',SW_show);
  Sleep(1000);   // ������� ����
  EnCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank,@fKEY,pAnsiChar(MainForm.Seria));
  MessageDlg('���� '+f+' �������� ��� � ����������', mtInformation,[mbOk], 0);
end else MessageDlg('���� �� ��� ����������, ������ �� �������', mtInformation,[mbOk], 0);
end;
{******************************************************************************
   ��������: ���������� ������������ � ������� ����������
   ���: �������
*******************************************************************************}
procedure TVerba.EnCrypt;
var
 e1,subject,email1:string;
 abon:integer;
 od : TOpenDialog;
 f: string;
begin
  od := TOpenDialog.Create(nil);
  od.Execute;
  f:=od.FileName;
  spk.ShowModal;
  if spk.ModalResult=1 then begin
  e1:=spk.ListBox1.Items[spk.ListBox1.ItemIndex];
  abon:=strtoint(copy(e1,pos(';',e1)+1,4));Delete(e1,1,pos(';',e1));
  email1:=copy(e1,pos(';',e1)+1,Length(e1));
  subject:='����� ��������� ������';    // ���
//  asd:=SignFile(pAnsiChar(f),pAnsiChar(f),pAnsiChar('8686900928'));
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\UtilKeyC.exe',pAnsiChar('P '+f+' '+f+' '+MainForm.sec+' '+MainForm.Pub),'S:\RSHB\Spiski\scripts\',SW_show);
  Sleep(1000);   // ������� ����
  EnCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank,@abon,pAnsiChar(MainForm.Seria));
  Shellexecute(MainForm.handle,'Open',pchar('mailto:'+email1+'?subject='+subject),nil, nil, sw_restore);
end;

end;
{******************************************************************************
   ��������: ����������
   ���: ����������
*******************************************************************************}
destructor TVerba.Destroy;
begin
  inherited;
end;

{******************************************************************************
   ��������: �������
   ���: �������
*******************************************************************************}
procedure TVerba.Clear;
begin
  fKEY:=0;
  EMAIL:='';
  OTD :='';
  MainForm.Label5.Caption:='';
  MainForm.Label6.Caption:='';
  MainForm.Label7.Caption:='';
end;


end.


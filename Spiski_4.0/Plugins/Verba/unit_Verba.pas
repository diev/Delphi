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

unit unit_Verba;

interface

uses
   SysUtils, Forms, Dialogs, ShellApi, classes;

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
    errcode:integer;
    EMAIL,OTD:String;
    procedure error(err_cod:integer);
  end;

var
  Vrb:TVerba;

implementation

uses WBoth, form_spk, form_info;
{******************************************************************************
  ��������: �����������
  ���: ����������
*******************************************************************************}
constructor TVerba.Create;
begin
  fKEY:=0;
  EMAIL:='';
  OTD :='';
  CryptoInit(pAnsiChar(sec),pAnsiChar(Pub));
  SignInit(pAnsiChar(sec),pAnsiChar(Pub));
end;
{******************************************************************************
  ��������: ��������� �����
  ���: �������
*******************************************************************************}
procedure TVerba.Load_key;
begin
  try
    errcode:=InitKey(pointer(key_dev),PChar(''));
      if errcode=NO_ERROR then MessageDlg('����� � ��������� �������� ��������� � ������� Asyncr', mtInformation,[mbOk], 0)
      else error(errcode);
  except on E: Exception do
    MessageDlg('������ �������� ������ �������� InitKey(pointer(key_dev),pAnsiChar(''))'+#10#13+E.Message, mtError,[mbOk], 0);
  end;

form_info.info.Label8.Caption:=  GetIdFromDev(key_dev,'S');
form_info.info.Label9.Caption:=  GetIdFromDev(key_dev,'E');
form_info.info.Label10.Caption:= GetIdFromDriver('S');
form_info.info.Label11.Caption:= GetIdFromDriver('E');
form_info.info.ShowModal;
end;
{******************************************************************************
  ��������: �������� ���, ����������� � ������ ���
  ���: �������
  �����������:
*******************************************************************************}
procedure TVerba.DeCrypt(f: string);
var
  s : array[0..PUB_ID_LENGTH] of Char;
  tf:TextFile;
  st:string;
begin
     fKEY:=0;
     errcode:=GetFileSenderID(pAnsiChar(f),PChar(@s));
     if  errcode<>NO_ERROR then error(errcode)
     else fKEY:=strtoint(GetCryptoNumberStr(s));

     errcode:=DeCryptFile(pAnsiChar(f), pAnsiChar(f),bank);
     if  errcode<>NO_ERROR then error(errcode);

    errcode:=DelSign(pAnsiChar(f),-1);
    if  errcode<>NO_ERROR then error(errcode);

            if fKEY<>0 then begin   // ���� ����
              AssignFile(tf,Abonents_list);
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

              form_info.info.Label1.Caption:='���������: '+OTD;
              form_info.info.Label2.Caption:='����: '+inttostr(fKEY);
              form_info.info.Label3.Caption:='����������� �����: '+ EMAIL;

            end else begin
              fKEY:=0;
              EMAIL:='';
              OTD :='';
              form_info.info.Label1.caption:='���������: ���������� ';
              form_info.info.Label2.caption:='�� ��������';
              form_info.info.Label3.caption:='����������� �����: ���������� ';
              end;

   form_info.info.ShowModal;

end;
{******************************************************************************
   ��������: ���������� �������
   ���: �������
*******************************************************************************}
procedure TVerba.EnCryptAnswer(f: string);
var
  ecp: string;
begin
if fKEY<>0 then begin    // ���
  ecp:=inttostr(bank)+Seria+'01';
  try
    SignFile(pAnsiChar(f),pAnsiChar(f),pAnsiChar(ecp));
  except     ShowMessage('������ ��������� ���');   end;
  Sleep(1000);   // ������� ����
  EnCryptFile(pAnsiChar(f), pAnsiChar(f),bank,@fKEY,pAnsiChar(Seria));
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
 f,ecp: string;
begin
  od := TOpenDialog.Create(nil);
  od.Execute;
  f:=od.FileName;
  od.Free;

  spk:= Tspk.Create(nil);
  spk.ShowModal;
  if spk.ModalResult=1 then begin
    e1:=spk.ListBox1.Items[spk.ListBox1.ItemIndex];
    abon:=strtoint(copy(e1,pos(';',e1)+1,4));Delete(e1,1,pos(';',e1));
    email1:=copy(e1,pos(';',e1)+1,Length(e1));
    subject:='����� ��������� ������';
    // ���
    ecp:=inttostr(bank)+Seria+'01';
    try
      SignFile(pAnsiChar(f),pAnsiChar(f),pAnsiChar(ecp));
    except     ShowMessage('������ ��������� ���');   end;
    Sleep(1000);   // ������� ����
    EnCryptFile(pAnsiChar(f), pAnsiChar(f),bank,@abon,pAnsiChar(Seria));
//    Shellexecute(0,'Open',pchar('mailto:'+email1+'?subject='+subject),nil, nil, sw_restore);
  end;

end;
{******************************************************************************
   ��������: ����������
   ���: ����������
*******************************************************************************}
destructor TVerba.Destroy;
begin
//CryptoDone;
//SignDone;
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
  form_info.info.Label1.Caption:='';
  form_info.info.Label2.Caption:='';
  form_info.info.Label3.Caption:='';
end;


procedure TVerba.error(err_cod: integer);
begin
  case err_cod of
    E_DEVICE:      MessageDlg('������ ��� ��������� � �������� ��������� ����������', mtError,[mbOk], 0);
    E_REDEFINE:    MessageDlg('������� ���������� ����� � ������� ASYNCR', mtError,[mbOk], 0);
    E_KEY_NOT_SET: MessageDlg('������ ��� �������� ����� � ������� ASYNCR', mtError,[mbOk], 0);
    else MessageDlg(GetVerbaErrorStr(err_cod), mtError,[mbOk], 0);
  end;
end;

end.


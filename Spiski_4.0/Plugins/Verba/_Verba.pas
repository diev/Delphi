{************************************************************}
{                                                            }
{       Модуль для работы со скриптами и  API вербы          }
{       Copyright (с) 2010 РСХБ                              }
{               отдел/сектор                                 }
{                                                            }
{  Разработчик: Акулов Е.В.                                  }
{  Модифицирован: 15 июля 2011                               }
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
  Описание: Конструктор
  Тип: Внутренняя
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
  Описание: Определяем зашифрован ли файл
  Тип: Внутренняя
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
   if copy(ss1,1,4)<>'РСХБ' then Result:=true else Result:=false;

end;
{******************************************************************************
  Описание: Загружаем ключи
  Тип: Внешняя      в dll
*******************************************************************************}
procedure TVerba.Load_key;
begin
try
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\AsrKeyC.exe', 'R','S:\RSHB\Spiski\scripts\', SW_show); //   key_dev:='A:\\';   InitKey(@key_dev,pAnsiChar(''));
except
  MessageDlg('Ошибка загрузки ключей', mtError,[mbOk], 0);
end;
end;
{******************************************************************************
  Описание: Расшифрование и проверка,снятие ЭЦП
  Тип: Внешняя
  Комментарий:
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
            if count>0 then begin   // есть ЭЦП 
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
              MainForm.Label5.Caption:='Отделение: '+OTD;
              MainForm.Label6.Caption:='Ключ: '+inttostr(fKEY);
              MainForm.Label7.Caption:='Электронный адрес: '+ EMAIL;

            end else if count=0 then begin
              MessageDlg('Не было проставлено ЭЦП!', mtError,[mbOk], 0);
              fKEY:=0;
              EMAIL:='';
              OTD :='';
              mainform.label5.caption:='отделение: неизвестно ';
              mainform.label6.caption:='не шифрован';
              mainform.label7.caption:='электронный адрес: неизвестно ';
              end;
  end;
begin
   if CheckEnCrypt(f) then begin 
      if DeCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank)<>0 then 
	      begin
	        MessageDlg('Файл не расшифрован, загрузите ключи в память !', mtError,[mbOk], 0);
	        exit;
        end
   end
   else MessageDlg('Файл небыл зашифрован', mtInformation,[mbOk], 0);

   SignInfo(f);

end;
{******************************************************************************
   Описание: Шифрование ответов
   Тип: Внешняя
*******************************************************************************}
procedure TVerba.EnCryptAnswer(f: string);
begin
if fKEY<>0 then begin    // ЭЦП
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\UtilKeyC.exe',pAnsiChar('P '+f+' '+f+' '+MainForm.sec+' '+MainForm.Pub),'S:\RSHB\Spiski\scripts\',SW_show);
  Sleep(1000);   // шифруем файл
  EnCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank,@fKEY,pAnsiChar(MainForm.Seria));
  MessageDlg('Файл '+f+' подписан ЭЦП и зашифрован', mtInformation,[mbOk], 0);
end else MessageDlg('файл не был зашифрован, ответы не шифруем', mtInformation,[mbOk], 0);
end;
{******************************************************************************
   Описание: Шифрование произвольное с выбором получателя
   Тип: Внешняя
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
  subject:='Файлы обратного потока';    // ЭЦП
//  asd:=SignFile(pAnsiChar(f),pAnsiChar(f),pAnsiChar('8686900928'));
  ShellExecute(0,'open','S:\RSHB\Spiski\scripts\UtilKeyC.exe',pAnsiChar('P '+f+' '+f+' '+MainForm.sec+' '+MainForm.Pub),'S:\RSHB\Spiski\scripts\',SW_show);
  Sleep(1000);   // шифруем файл
  EnCryptFile(pAnsiChar(f), pAnsiChar(f),MainForm.bank,@abon,pAnsiChar(MainForm.Seria));
  Shellexecute(MainForm.handle,'Open',pchar('mailto:'+email1+'?subject='+subject),nil, nil, sw_restore);
end;

end;
{******************************************************************************
   Описание: Деструктор
   Тип: Внутренняя
*******************************************************************************}
destructor TVerba.Destroy;
begin
  inherited;
end;

{******************************************************************************
   Описание: Очистка
   Тип: Внешняя
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


unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls, Buttons, Menus,   shellApi,
  IdTelnet,inifiles,IdFTP, Grids,EncdDecd, jpeg, IdComponent,
  IdBaseComponent, IdTCPConnection, IdTCPClient;

const
  mes_in:string=' перенесен из АРМ КБР в архив и в АБС';
  mes_out:string=' перенесен из АБС в архив и в АРМ КБР';
  Pass_ed:string='Дата изменения пароля ЦБ изменена на ';
  error_ftpin:string='Ошибка при загрузке на ftp:FTPupLoad() ';
  error_ftpout:string='Ошибка при скачивании с ftp';

type

  StrTD = record
    path,maska,IP,mes:string;
    command:string;
  end;

  TForm1 = class(TForm)
    TimerKBR_In: TTimer;
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    Button1: TButton;
    Animate1: TAnimate;
    Label4: TLabel;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label3: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    ButtonAutoHand: TButton;
    CheckBox1: TCheckBox;
    TabSheet4: TTabSheet;
    GroupBox4: TGroupBox;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Edit12: TEdit;
    Label17: TLabel;
    TimerShowmessage: TTimer;
    SGIN: TStringGrid;
    SGL: TStringGrid;
    Edit22: TEdit;
    Label28: TLabel;
    IdTelnet1: TIdTelnet;
    Image1: TImage;
    TabSheet5: TTabSheet;
    SGPL: TStringGrid;
    Timer_auto: TTimer;
    GroupBox5: TGroupBox;
    Label16: TLabel;
    Edit17: TEdit;
    Label11: TLabel;
    Edit14: TDateTimePicker;
    Label22: TLabel;
    Edit15: TEdit;
    Edit18: TEdit;
    Label23: TLabel;
    Label24: TLabel;
    Button3: TButton;
    Label26: TLabel;
    Edit23: TEdit;
    Label27: TLabel;
    Edit24: TEdit;
    TabSheet6: TTabSheet;
    Button2: TButton;
    Button4: TButton;
    OpenDialog1: TOpenDialog;
    Edit8: TEdit;
    CheckBox2: TCheckBox;
    procedure TimerKBR_InTimer(Sender: TObject);
    procedure TimerShowmessageTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Log(mes:string);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure IdTelnet1DataAvailable(Sender: TIdTelnet; const Buffer: string);
    function  Loging(v:integer):integer;
    procedure IntellectualLoging(i:integer);
    procedure ButtonAutoHandClick(Sender: TObject);
    procedure SGINClick(Sender: TObject);
    procedure TimerProc(Sender: TObject);
    procedure Timer_autoTimer(Sender: TObject);
    procedure Edit14Change(Sender: TObject);
    procedure message_grid(ms:string);
    procedure message_grid_a(ms:string; i:integer);
    procedure Button3Click(Sender: TObject);
    function Base64(file_name:string):string;
    procedure Button4Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    HOST_CB,LOGIN_CB,
    PASSWORD_CB,PATHINSVK,
    PATHOUTSVK,OBRIN,OBROUT,ARHIV,
    WORKTIME_BEGIN,WORKTIME_END,DATE_END,PATH_LOGI,DEN:String;
    LOGI:Boolean;
    ind_SG,ind_SGL,EN_CONNECT:integer;
    winda,list,DIR:string;
    TimerPool:array of TTimer;
    TimerData:array of StrTD;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Unit2, Unit4, StrUtils;
{$R *.dfm}
{***************************************************************************
   Инициализация
************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
  { преобразование времени, с округлением}
  function  Human_Time(i:integer):string;
    var
      sval,sval_o:string;
      begin
          case i of
            1..59      :begin
                          sval:= inttostr(i);
                          case i of
                            1:    sval_o:='Секунда';
                            2..4: sval_o:='Секунды';
                            else  sval_o:='Секунд';
                          end;
                        end;
            60..3599   :begin
                         sval:= inttostr(i div 60);
                         case i div 60 of
                           1:    sval_o:='Минута';
                           2..4: sval_o:='Минуты';
                           else  sval_o:='Минут';
                         end;
                        end;
            3600..43200:begin
                          sval:= inttostr(i div 3600);
                          case i div 3600 of
                            1:    sval_o:='Час';
                            2..4: sval_o:='Часа';
                            else  sval_o:='Часов';
                          end;
                        end;
            0          :begin
                          sval:='Таймер отключен';
                          sval_o:='';
                        end;
          end;
          Result:=sval+' '+sval_o;
      end;

function cut(var s_in:string;delims:string):string;
begin
try
  Result:=copy(s_in,1,pos(delims,s_in)-1);
  delete(s_in,1,pos(delims,s_in));
except
end;

end;


var
 INF:TIniFile;
 s_:string;kt:integer;
 WindirP: PChar;
 Res: Cardinal;

begin
  Label22.Caption:=Label22.Caption+' 2.1.1 от '+DateTimeToStr(now);

  INF             :=TIniFile.Create(ExtractFilePath(Application.ExeName)+'svk.ini');
  PATHINSVK       :=inf.ReadString('DIRECTORY','PATHINSVK',''); Edit1.Text :=PATHINSVK;
  PATHOUTSVK      :=inf.ReadString('DIRECTORY','PATHOUTSVK','');Edit2.Text :=PATHOUTSVK;
  ARHIV           :=inf.ReadString('DIRECTORY','ARHIV','');     Edit5.Text :=ARHIV;

  PATH_LOGI       :=inf.ReadString('DIRECTORY','PATH_LOGI',''); Edit22.Text:=PATH_LOGI;
  OBRIN           :=inf.ReadString('DIRECTORY','OBRIN','');     Edit3.Text :=OBRIN;
  OBROUT          :=inf.ReadString('DIRECTORY','OBROUT','');    Edit4.Text :=OBROUT;

  HOST_CB         :=inf.ReadString('TELNET','HOST_CB','');  Edit15.Text:=HOST_CB;
  LOGIN_CB        :=inf.ReadString('TELNET','LOGIN_CB',''); Edit18.Text:=LOGIN_CB;
  PASSWORD_CB     :=inf.ReadString('TELNET','PASSWORD_CB','');
  EN_CONNECT      :=inf.ReadInteger('TELNET','EN_CONNECT',0); if EN_CONNECT=1 then CheckBox2.Checked:=true;

  LOGI            :=inf.ReadBool('COMMON','LOGI',false);  CheckBox1.Checked:=LOGI;
  DIR             :=inf.ReadString('DIRECTORY','DIR','');

  TimerKBR_In.Interval:=inf.ReadInteger('COMMON','TIME_IN',30)*1000;{по умолчанию 30 сек.}
  Edit12.Text         :=Human_Time(inf.ReadInteger('COMMON','TIME_IN',30));

  Timer_auto.Interval:=inf.ReadInteger('COMMON','TIME_AUTOLOGIN',0)*1000;
  Edit17.Text        :=Human_Time(inf.ReadInteger('COMMON','TIME_AUTOLOGIN',0));
  WORKTIME_BEGIN     :=inf.ReadString('COMMON','WORKTIME_BEGIN','07:00:00');Edit23.Text:=WORKTIME_BEGIN;
  WORKTIME_END       :=inf.ReadString('COMMON','WORKTIME_END','22:00:00');Edit24.Text:=WORKTIME_END;
  DATE_END           :=inf.ReadString('COMMON','DATE_END','01.01.2099');if DATE_END<>'' then Edit14.Date:=strtodate(DATE_END);

  INF.Free;

  WinDirP := StrAlloc(MAX_PATH);
  Res := GetWindowsDirectory(WinDirP, MAX_PATH);
  if Res > 0 then winda := StrPas(WinDirP)+'\system32\';
//{$Define Debug}
 {глобальная проверка}

 if (PATHINSVK='') or (PATHOUTSVK='') or (ARHIV='') or (OBRIN='') or (OBROUT='') then
  begin
   MessageDlg('Заданы не все обязательные параметры :'+#10#13#10#13+
   'PATHINSVK='+PATHINSVK+#10#13+
   'PATHOUTSVK='+PATHOUTSVK+#10#13+
   'ARHIV='+ARHIV+#10#13+
   'OBRIN='+OBRIN+#10#13+
   'OBROUT='+OBROUT,
   mtError,[mbOk], 0);
   Halt(0);
 end;

 if not DirectoryExists(ARHIV) then CreateDir(ARHIV);
 {переинициализируется при каждом копировании}
 DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
 {также создается новый день при каждом копировании файлов}
 if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);

  {$IFDEF Debug}
  {$ELSE}
 if not DirectoryExists(OBRIN) then begin
    MessageDlg('Не подключен диск, ресурс Бисквита '+OBRIN+#10#13+'программа  завершает свою работу !', mtError,[mbOk], 0);
    Halt(0);
 end;
  {$ENDIF}

  TimerKBR_In.Enabled:=true;
  Animate1.Active:=true;
  Label4.Caption:='Мониторинг запущен';

  SGIN.Rows[0].Add('Дата');
  SGIN.Rows[0].Add('Время');
  SGIN.Rows[0].Add('Информация');
  ind_SG:=1;
  message_grid('Начало обработки');

  SGL.Rows[0].Add('Дата время');
  SGL.Rows[0].Add('действие');
  SGL.Rows[0].Add('Режим');
  ind_SGL:=1;
  
  SGPL.Rows[0].Add('Путь');
  SGPL.Rows[0].Add('Маска');
  SGPL.Rows[0].Add('Интервал,сек.');
  SGPL.Rows[0].Add('Адрес');
  SGPL.Rows[0].Add('Сообщение');
  SGPL.Rows[0].Add('Команда');


  IdTelnet1.host:= HOST_CB;

{ разбор шаблонов }
  kt:=0;
  if DIR<>'' then
    while Pos('#',DIR)<>0 do begin
      s_:=cut(DIR,'#');
      SetLength(TimerData, kt+1);
      TimerData[kt].path :=cut(s_,';');
      TimerData[kt].maska:=cut(s_,';');
      TimerData[kt].IP   :=cut(s_,';');
      TimerData[kt].mes  :=cut(s_,';');

      SetLength(TimerPool, kt+1);
      TimerPool[kt]:= TTimer.Create(Self); // массив изб. от именования таймеров, много таймеров запускалок лучше
      TimerPool[kt].tag:=kt;
      TimerPool[kt].Interval:=strtoint(cut(s_,';'))*1000;
      TimerPool[kt].OnTimer:= TimerProc;
      TimerPool[kt].enabled:=true;

      TimerData[kt].command:=cut(s_,';');

      // добавляем на форму
      SGPL.RowCount:=SGPL.RowCount+1;
      SGPL.Rows[kt+1].Add(TimerData[kt].path);
      SGPL.Rows[kt+1].Add(TimerData[kt].maska);
      SGPL.Rows[kt+1].Add(inttostr(TimerPool[kt].Interval div 1000));
      SGPL.Rows[kt+1].Add(TimerData[kt].IP);
      SGPL.Rows[kt+1].Add(TimerData[kt].mes);
      SGPL.Rows[kt+1].Add(TimerData[kt].command);
      inc(kt);
    end;

end;
{***********************************************************************
   Авторизация в РКЦ ЦБ
   параметр: номер обертки
   Результат:
   1 - успешно
   2 - нет связи
   3 - Logout
   4- Пароль истёк
************************************************************************}
function TForm1.Loging(v:integer):integer;
var
  i :Integer;
begin
  { Очень важная проверка, по дате окончания действия пароля, чтобы не заблокироваться в ЦБ
    сравнение дат, а не строк }
  if (now<StrToDate(DATE_END)) and (PASSWORD_CB<>'') then begin

  list:='';

  if IdTelnet1.Connected then IdTelnet1.Disconnect;
  if not IdTelnet1.Connected then IdTelnet1.Connect;
  Sleep(2000);

  if IdTelnet1.Connected then begin

      for i:= 1 to Length(LOGIN_CB) do IdTelnet1.SendCh(LOGIN_CB[i]);
      IdTelnet1.SendCh(#13);
      sleep(1000);
      for i := 1 to Length(PASSWORD_CB) do IdTelnet1.SendCh(PASSWORD_CB[i]);
      IdTelnet1.SendCh(#13);

     TimerShowmessage.Enabled:=true;
     ShowMessage('Выполняется авторизация');

      if pos('Authentication Successful',list)<>0 then begin
          Result:=1;//результат
          message_grid_a('LOGIN Authentication Authentication Successful',v);
      end else begin
          Result:=3;
          message_grid_a('LOGOUT Authentication Logout Successful',v);
      end;
  end else begin {if IdTelnet1.Connected}
      Result:=2;
      message_grid_a('Authentication Нет связи с ЦБ',v);
  end;{if IdTelnet1.Connected}

 end else begin
  Result:=4;
  message_grid_a('Authentication Дата пароля истекла!',v);
 end;{if now<StrToDate(DATE_END)}
end;
{******************************************************************************
   телнет
******************************************************************************}
procedure TForm1.IdTelnet1DataAvailable(Sender: TIdTelnet;
  const Buffer: string);
const
  CR = #13;
  LF = #10;
var
  Start, Stop: Integer;
begin
  list:=list+' ' ;
  Start := 1;
  Stop := Pos(CR, Buffer);
  if Stop = 0 then
    Stop := Length(Buffer) + 1;
  while Start <= Length(Buffer) do
  begin
    list:=list+' ' +Copy(Buffer, Start, Stop - Start);
    if Buffer[Stop] = CR then
    begin
      list:=list+' '
    end;
    Start := Stop + 1;
    if Start > Length(Buffer) then
      Break;
    if Buffer[Start] = LF then
      Start := Start + 1;
    Stop := Start;
    while (Buffer[Stop] <> CR) and (Stop <= Length(Buffer)) do
      Stop := Stop + 1;
  end;

end;
{****************************************************************************
  закрываем программу
*****************************************************************************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if Dialogs.MessageDlg('Закрыть программу ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then CanClose:=false else begin
    Log('Конец обработки');
    if IdTelnet1.Connected then IdTelnet1.Disconnect;
    TimerPool:=Nil;
    TimerData:=Nil;
 end;

end;
{****************************************************************************
  Логи пишем по принципу открыли файл, записали, закрыли
  не держим файл постоянно открытым, т.к. записи буферизуются
*****************************************************************************}
procedure TForm1.Log(mes: string);
var
  Stream: TFileStream;
begin
  if LOGI then begin
    if not FileExists(PATH_LOGI) then Stream := TFileStream.Create(PATH_LOGI,fmCreate)
    else Stream := TFileStream.Create(PATH_LOGI,fmOpenWrite);
    try
      Stream.Seek(0, soFromEnd);
      mes:=DateTimeToStr(now)+' '+mes+#10;
      Stream.WriteBuffer(Pointer(mes)^, Length(mes));
    finally
      Stream.Free;
    end;
  end;
end;
{**********************************************************************
    Показываем содержимое входящих файлов
    расшифровывая их из Base64
************************************************************************}
procedure TForm1.SGINClick(Sender: TObject);
var
  beg_,en_:integer;
  STR_GR, FILENAME:string;
begin
 STR_GR:=SGIN.Cells[2,SGIN.Row];
if Pos('Файл',STR_GR)<>0 then begin
  // получаем имя файла
  beg_:=Pos('Файл',STR_GR)+5;
  en_ :=Pos('перенесен',STR_GR)-7;
  FILENAME:=ARHIV+DEN+ExtractFileName(Copy(STR_GR,beg_,en_));
  Base64(FILENAME);
end;
end;

{**********************************************************************
    Обработка входящих
************************************************************************}
procedure TForm1.TimerKBR_InTimer(Sender: TObject);
var
    sr: TSearchRec;
    f:TextFile;
    s:string;
    id:integer;
    fl:boolean;
begin
{$IFDEF Debug}
{$ELSE}

if EN_CONNECT=1 then begin
    try
      if not IdTelnet1.Connected then begin 
	IdTelnet1.Connect;
        Log('Telnet upper');
      end;	
      Sleep(2000);
    except;
        Log('Telnet NOT upper');
	Button2Click(self);
    end;

//    if IdTelnet1.Connected then Log('Есть Connect');
    if not IdTelnet1.Connected then begin
        Log('Not Connect');
      //  Button2Click(self);
    end;
end;
{$ENDIF}

if SysUtils.FindFirst(PATHINSVK+'*.*', faAnyFile, sr) = 0 then
     repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
          //определяем 205 201 ли это
          fl:=false;
          id:=0;
          AssignFile(f,PATHINSVK+sr.Name);
          Reset(f);
          while not eof(f) do begin
            inc(id);
            Readln(f,s);
            if id=6 then begin
                if (pos('ED205',DecodeString(copy(s,15,70)))<>0) or (pos('ED201',DecodeString(copy(s,15,70)))<>0)  then fl:=true;
              Break;
              end;
          end;
          CloseFile(f);

          // сначала мы копируем в архив
          DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
          if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);
          CopyFile(Pchar(PATHINSVK+sr.Name),Pchar(ARHIV+DEN+sr.Name),true);

          {в АБС}
          if fl=false then begin
                // загружаем на обработку
            MoveFile(Pchar(PATHINSVK+sr.Name),Pchar(OBRIN+sr.Name));
            message_grid('Файл '+PATHINSVK+sr.Name+mes_in);
          end;   {удаляем исходный файл}
         if FileExists(PATHINSVK+sr.Name) then DeleteFile(PATHINSVK+sr.Name);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
end;


{***************************************************************************
   Обработка исходящих
****************************************************************************}
procedure TForm1.Button1Click(Sender: TObject);
var
    sr: TSearchRec;
    f:TextFile;
    s:string;
begin
form2.Memo1.Lines.Clear;
if SysUtils.FindFirst(OBROUT+'*.xml', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
          AssignFile(f,OBROUT+sr.Name);
          reset(f);
          if not eof(f) then readln(f,s);form2.Memo1.Lines.Add(s);
          if not eof(f) then readln(f,s);form2.Memo1.Lines.Add(s);
          s:=copy(s,pos('EDQuantity',s)+12,length(s));
          form2.Label1.Caption:=copy(s,1,pos('"',s)-1);
          s:=copy(s,pos('Sum',s)+5,length(s));
          form2.Label2.Caption:=copy(s,1,pos('"',s)-1);
          CloseFile(f);

          Form2.ShowModal;
          if form2.ModalResult=mrOk then begin

            DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
            if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);

            CopyFile(Pchar(OBROUT+sr.Name),Pchar(ARHIV+DEN+sr.Name),true);
            MoveFile(Pchar(OBROUT+sr.Name),Pchar(PATHOUTSVK+sr.Name));
            ShowMessage('Файл '+OBROUT+sr.Name+' перенесен в АРМ КБР');
            message_grid('Файл '+OBROUT+sr.Name+mes_out);
          end;
        end;
      until FindNext(sr) <> 0
else ShowMessage('Файлов нет');
FindClose(sr);

end;
{******************************************************************************
  доделать
******************************************************************************}
{  AssignFile(f, 'P:\Операционный отдел\t');
  {$I-
  Rewrite(f); // открыть файл
  {$I+
  FindFirst(OBRIN+'*.*', faAnyFile, sr)}

{******************************************************************************
 системная процедура - не трогать !
******************************************************************************}
procedure TForm1.TimerShowmessageTimer(Sender: TObject);
var h:HWND;
begin
TimerShowmessage.Enabled := false;
h := FindWindow('TMessageForm', PChar(Application.Title));
if H <> 0 then SendMessage(H, WM_SYSCOMMAND, SC_Close, 0);
end;
{******************************************************************************
   Авторизация интеллектуальная, с анализом результата
   параметр:номер обертки
******************************************************************************}
procedure TForm1.IntellectualLoging(i:integer);
begin
    if (StrToTime(WORKTIME_BEGIN)<Time) and (Time<StrToTime(WORKTIME_END)) then begin
        if Loging(i)=3 then begin
          Sleep(3000);
          Loging(i);
        end;
end;

end;
{******************************************************************************
   Ручная авторизация
******************************************************************************}
procedure TForm1.ButtonAutoHandClick(Sender: TObject);
begin
    Loging(1);
end;
{******************************************************************************
   меняем дату пароля
******************************************************************************}
procedure TForm1.Edit14Change(Sender: TObject);
var
  inf:TIniFile;
begin
   inf:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'svk.ini');
   inf.WriteString('COMMON','DATE_END',datetostr(Edit14.Date));
   inf.Free;
   DATE_END:=datetostr(Edit14.Date);
   log(Pass_ed+datetostr(Edit14.Date));
end;
{******************************************************************************
   Авторизация (по таймеру)
******************************************************************************}
procedure TForm1.Timer_autoTimer(Sender: TObject);
begin
    if (StrToTime(WORKTIME_BEGIN)<Time) and (Time<StrToTime(WORKTIME_END)) then
    IntellectualLoging(2);
end;
{**********************************************************************
    обработчик таймеров шедулера
************************************************************************}
procedure TForm1.TimerProc(Sender: TObject);
var
  ind:integer;
  sr: TSearchRec;
begin
if (StrToTime(WORKTIME_BEGIN)<Time) and (Time<StrToTime(WORKTIME_END)) then begin
    ind:=(Sender as TTimer).Tag;
    if SysUtils.FindFirst(TimerData[ind].PATH+TimerData[ind].Maska, faAnyFile, sr) = 0 then
      repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
              {	выполняемые действия:
	             1. отправить сообщение}
              if TimerData[ind].IP<>'' then ShellExecute(0,'open',PChar(winda+'net.exe'), pchar('send '+TimerData[ind].IP+' '+TimerData[ind].mes+' '+sr.Name),pchar(winda), SW_HIDE);
              Break;  // отправляем только одно сообщение, а не на каждый файл
              {3. выполнить команду ОС}
 	            if TimerData[ind].command<>'' then ShellExecute(0,'open',PChar(TimerData[ind].command), pchar(''),pchar(ExtractFilePath(TimerData[ind].command)), SW_SHOW);
            end;

      until FindNext(sr) <> 0;
    FindClose(sr);
end;
end;
{**********************************************************************
    вывод на грид и в лог
************************************************************************}
procedure TForm1.message_grid(ms: string);
begin
  SGIN.Rows[ind_SG].Add(Datetostr(date));
  SGIN.Rows[ind_SG].Add(timetostr(time));
  SGIN.Rows[ind_SG].Add(ms);
  inc(ind_SG);
  Log(ms);
end;
{**********************************************************************
    вывод на грид и в лог
************************************************************************}
procedure TForm1.message_grid_a(ms: string; i: integer);
begin
  SGL.Rows[ind_SGL].Add(DateTimeToStr(now));
  SGL.Rows[ind_SGL].Add(ms);
  case i of
      1:begin SGL.Rows[ind_SGL].Add('Hands');Log(ms+' Hands');end;
      2:begin SGL.Rows[ind_SGL].Add('Automatic');Log(ms+' Automatic');end;
      3:begin SGL.Rows[ind_SGL].Add('Addition');Log(ms+' Addition');end;
  end;
 inc(ind_SGL);
end;
{**********************************************************************
    Смена пароля
************************************************************************}
procedure TForm1.Button3Click(Sender: TObject);
var
  password,s,FileOut:String;
  f:TextFile;
  INF:TIniFile;
  in1:integer;
begin
  ShowMessage('Меняем пароль, для трех учетных записей');
  {$IFDEF Debug}
  {$ELSE}
  ShellExecute(0,'open',pchar('https://192.168.111.43/kbrinterface/user/changepassword.aspx'),pchar(''),pchar(''),SW_SHOW);
  {$ENDIF}
  password:=InputBox('Укажите новый пароль', 'Укажите новый пароль', '');
  if password<>'' then begin
      FileOut:='';
      if FileExists('C:\TAObmen\bin\connect.cmd') then begin
        AssignFile(f,'C:\TAObmen\bin\connect.cmd');
        reset(f);
        while not Eof(f) do begin
          readln(f,s);
          if pos('Chan_2520700000',s)<>0 then
            s:=LeftStr(s,pos('Chan_2520700000',s)+14)+' '+password;
          FileOut:=FileOut+s+#10;
        end;
        CloseFile(f);
        AssignFile(f,'C:\TAObmen\bin\connect.cmd');
        Rewrite(f);
        Write(f,FileOut);
        CloseFile(f);
        ShowMessage('Пароль изменен в файле C:\TAObmen\bin\connect.cmd, канальный дозвон по диалапу модемом старым');
      end else ShowMessage('Нет файла C:\TAObmen\bin\connect.cmd');

      FileOut:='';
      if FileExists('c:\TAObmen\bin\svk.tsc') then begin
        AssignFile(f,'c:\TAObmen\bin\svk.tsc');
        reset(f);
        in1:=0;
        while not Eof(f) do begin
          readln(f,s);
          if pos('Send',s)<>0 then begin
             inc(in1);
             if (in1=2) or (in1=3) then
             s:=LeftStr(s,pos('Send',s)+3)+' "'+password+'^M"';
          end;
          FileOut:=FileOut+s+#10;
        end;
        CloseFile(f);
        AssignFile(f,'c:\TAObmen\bin\svk.tsc');
        Rewrite(f);
        Write(f,FileOut);
        CloseFile(f);
        ShowMessage('Пароль изменен в файле c:\TAObmen\bin\svk.tsc, сетевая авторизация вручную которая делается');
      end else ShowMessage('Нет файла c:\TAObmen\bin\svk.tsc');

      inf:=TIniFile.Create(ExtractFilePath(Application.ExeName)+'svk.ini');
      inf.WriteString('TELNET','PASSWORD_CB',password);
      inf.Free;
      ShowMessage('Пароль изменен в файле '+ExtractFilePath(Application.ExeName)+'svk.ini');
      ShowMessage('А теперь сами поменяйте пароль в УТА и перезапустите службу Уты');
      ShowMessage('Дата следующей смены пароля: '+DateToStr(Now + 28));
  end else ShowMessage('Укажите пароль !!!');      
end;
{***************************************************************************
   БЭСП
****************************************************************************
procedure TForm1.Button2Click(Sender: TObject);
var
    sr: TSearchRec;
    f:TextFile;
    s:string;
begin
if SysUtils.FindFirst(OBROUT+'A*.rrr', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
          AssignFile(f,OBROUT+sr.Name);
          reset(f);
          if not eof(f) then readln(f,s);form2.Memo1.Lines.Add(s);
          if not eof(f) then readln(f,s);form2.Memo1.Lines.Add(s);
          s:=copy(s,pos('EDQuantity',s)+12,length(s));
          form2.Label1.Caption:=copy(s,1,pos('"',s)-1);
          s:=copy(s,pos('Sum',s)+5,length(s));
          form2.Label2.Caption:=copy(s,1,pos('"',s)-1);
          CloseFile(f);

          Form2.ShowModal;
          if form2.ModalResult=mrOk then begin

            DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
            if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);

            CopyFile(Pchar(OBROUT+sr.Name),Pchar(ARHIV+DEN+sr.Name),true);
            MoveFile(Pchar(OBROUT+sr.Name),Pchar(PATHOUTSVK+sr.Name));
            ShowMessage('БЭСП Файл '+OBROUT+sr.Name+' перенесен в АРМ КБР');
            message_grid('БЭСП Файл '+OBROUT+sr.Name+mes_out);
          end;
        end;
      until FindNext(sr) <> 0
else ShowMessage('Файлов нет');
FindClose(sr);
end;}

function TForm1.Base64(file_name: string): string;
var
  id:integer;
  s:string;
  f:TextFile;
begin
  DecodeForm.Memo1.Clear;
  if FileExists(file_name) then begin
       AssignFile(f,file_name);
       Reset(f);
            id:=0;
            while not eof(f) do begin
              inc(id);
              Readln(f,s);
              { входящий}
              if ExtractFileExt(file_name)<>'.xml' then if id=6 then begin
                s:=copy(s,15,length(s));
                s:=DecodeString(s);
                while Pos('>',s)<>0 do begin
                    DecodeForm.Memo1.Lines.Add(Copy(s,1,Pos('>',s)));
                    Delete(s,1,Pos('>',s));
                  end;
              end;
              { исходящий рейс}
              if ExtractFileExt(file_name)='.xml' then DecodeForm.Memo1.Lines.Add(s);
            end;
        CloseFile(f);
    end;
  DecodeForm.ShowModal;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Base64(OpenDialog1.FileName);
end;
      //  дозвон по модему
procedure TForm1.Button2Click(Sender: TObject);
begin
 ShellExecute(0,'open',pchar('C:\TAObmen\bin\connect.cmd'),pchar(''),pchar('C:\TAObmen\bin\'),SW_SHOW);
end;

end.








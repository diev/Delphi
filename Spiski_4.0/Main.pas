unit Main;

interface

uses
  Dialogs, Menus, Mask, ComCtrls, StdCtrls, Controls, jpeg,
  ExtCtrls, Classes, Windows, Messages, SysUtils, Graphics, Forms, DBGrids,
  StrUtils, IdBaseComponent, inifiles,Registry, IdComponent,
  IdTCPConnection, IdTCPClient, IdFTP;

type

  StrDataPlugin = packed record
    Name:ShortString;
    Comment:ShortString;
    DllName:ShortString;

    Debet:ShortString;
    Text:ShortString;
    PATH_IN:ShortString;
    PATH_OUT:ShortString;
    Flt:ShortString;
  end;

  type_ExportProc = array of record
                                  Name:ShortString;
                                  Menu:ShortString;
                                 end;
  

  TPlugins = class
    AboutPlugin:string;
    ArrayDataPlugin:array of StrDataPlugin;
    procedure LoadPlugins;
    procedure Menu(Sender: TObject);

  end;

  TDLL = class
    AboutDLL:string;
    procedure LoadDll;
  end;

  TMainForm = class(TForm)
    Edit2: TEdit;    dtp1: TDateTimePicker;    Label1: TLabel;    Label3: TLabel;    Label4: TLabel;
    Edit1: TMaskEdit;    N14: TMenuItem;    OpenDialog1: TOpenDialog;
    procedure lv2Click(Sender: TObject);
  private
    FFZstatus: string;
    procedure SetFZstatus(const Value: string);
  published
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;    N3: TMenuItem;    N4: TMenuItem;    N7: TMenuItem;
    N8: TMenuItem;    PopupMenu1: TPopupMenu;    N9: TMenuItem;    Panel2: TPanel;
    Label9: TLabel;    Label10: TLabel;    Label11: TLabel;
    GroupBox1: TGroupBox;    lv2: TListView;    lv1: TListView;    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure lv1CustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure dtp1KeyPress(Sender: TObject; var Key: Char);
    procedure clear;
    property  FZstatus:string read FFZstatus write SetFZstatus;
  public
  PATH_IN,PATH_OUT:ShortString;
  FileBIS:ShortString;
  dir:ShortString;
  end;

  TCallback_func = array[1..15] of Pointer;

//  procedure net1(filwin, FTPkatalogIN, FTPkatalogOUT, katalogWin: ShortString); external 'p:\IT\PROGI\старое\Spiski v4.0\dll\net\net.dll';
//  procedure Get_DllProc(var Spis_proc:type_ExportProc); external 'p:\IT\PROGI\старое\Spiski v4.0\dll\net\net.dll';

	function DosToWin(St: ShortString):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
 	function WinToDos(Src: ShortString):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
	function Digit(s:ShortString):boolean; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
	function StrToFloat(S: ShortString): Extended; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
	function getdatestr(dtp:tdate):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
  function Hstr(st: ShortString): ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
  function Human_Itog(itog:ShortString):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
  function H_acca(st:ShortString):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';
  function H_sum(st:ShortString):ShortString; external 'p:\IT\PROGI\старое\Spiski v4.0\dll\tools\tools.dll';

  procedure CreateFileBis(FileBIS: ShortString;a:TCallback_func); external 'p:\IT\PROGI\старое\Spiski v4.0\dll\cfb\cfb.dll';


var
  MainForm: TMainForm;
  Plugins: TPlugins;
  Dll:TDLL;
  array_Callback:TCallback_func;

implementation
uses form_AboutBox;

{$R *.dfm}
{*******************************************************************************
  СТАРТ
*******************************************************************************}
procedure TMainForm.FormCreate(Sender: TObject);
var
  INF:TIniFile;
  Registry: TRegistry;
begin

  INF :=TIniFile.Create(ExtractFilePath(Application.ExeName)+'sp.ini');
  OpenDialog1.InitialDir:=inf.ReadString('Settings','InitialDir','');
  INF.Free;

  dtp1.Date:=date;// дата операционного дня

  Registry:=TRegistry.Create;
  Registry.RootKey:=HKEY_CURRENT_USER;
  Registry.OpenKey('Control Panel\International',False);
  if Registry.ReadString('sDecimal')<>',' then begin
    MessageDlg('Разделитель целой и дробной части не запятая, изменяем на запятую', mtInformation,[mbOk], 0);
    Registry.WriteString('sDecimal',',');
  end;
  Registry.Free;

  Plugins:=TPlugins.Create;
  Plugins.LoadPlugins;

  Dll:=TDLL.Create;
  Dll.LoadDll;

end;
{ ***************************************************************************
  Вывод статистики  возможно сделать экспорт
 ****************************************************************************}
procedure Statistics(kount, sum: ShortString);
begin
	with Mainform.lv2.items.add do begin
		  caption:='';
		  SubItems.Add(kount);
      SubItems.Add(Human_Itog(H_sum(sum)));
		  SubItems.Add('');SubItems.Add('');SubItems.Add('');SubItems.Add('');
	end;
end;
{*******************************************************************************
   Вопрос
*******************************************************************************}
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Закрыть программу ?', mtConfirmation, [mbYes, mbNo], 0) <> mrYes then CanClose:=false;
end;
procedure TMainForm.N8Click(Sender: TObject);
begin
  AboutBox.ShowModal;
end;
{*******************************************************************************
  Статистика
*******************************************************************************}
procedure TMainForm.N9Click(Sender: TObject);
var
i,col:integer;
sum:Extended;
begin
  sum:=0;col:=0;
  for i:=0 to lv1.items.count-1 do if lv1.Items[i].Checked then begin
      sum:=sum+strtofloat(lv1.Items[i].SubItems[7]);
      inc(col);
  end;
  Mainform.lv2.Items.Clear;
  Statistics(inttostr(col),floattostr(sum));
end;
{*******************************************************************************
  Фоно проверки
*******************************************************************************}
procedure TMainForm.lv1CustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if ((SubItem=8) and ((Item.SubItems.Strings[SubItem-1]='') or (Item.SubItems.Strings[SubItem-1]='0') or (Item.SubItems.Strings[SubItem-1]='0.00')))
     or ((SubItem=7) and (Length(Item.SubItems.Strings[SubItem-1])<>20))
     or ((SubItem=18) and (Item.SubItems.Strings[SubItem-1]='НЕ зачислено'))
    then TListView(sender).Canvas.Brush.Color:=clRed
    else TListView(sender).Canvas.Brush.Color:=clWindow;
end;
{*******************************************************************************
  Чтобы дату операционного дня можно было только выбрать из календаря
*******************************************************************************}
procedure TMainForm.dtp1KeyPress(Sender: TObject; var Key: Char);
begin
  KEY:=#0;
end;
{*******************************************************************************
  Помечаем все записи списка галочками
*******************************************************************************}
procedure TMainForm.lv2Click(Sender: TObject);
var
  n2:integer;
begin
     for n2:=0 to lv1.items.count-1 do lv1.items[n2].Checked:=lv2.Items[0].Checked;
end;

procedure TMainForm.SetFZstatus(const Value: string);
begin
  FFZstatus := Value;
  StatusBar1.Panels[0].Text:=Value;
end;


{ ***************************************************************************
   Добавление на форму  проверить входящие   Экспорт
 ****************************************************************************}
procedure Addform(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11,
  v12, v13, v14, v15, v16, v17, v18, v19, v20: ShortString);
begin
  with Mainform.lv1.items.add do begin
    caption:=v1;
    SubItems.Add(v2);SubItems.Add(v3);SubItems.Add(v4);SubItems.Add(v5); //фио
    SubItems.Add(v6); SubItems.Add(v7);SubItems.Add(v8);//счет
    SubItems.Add(v9);//сумма
    SubItems.Add(v10);SubItems.Add(v11);SubItems.Add(v12);SubItems.Add(v13);
    SubItems.Add(v14);SubItems.Add(v15);//сумма ИТОГ
    SubItems.Add(v16);SubItems.Add(v17);SubItems.Add(v18);SubItems.Add(v19);SubItems.Add(v20);
  end;
end;
//  calbac - function read form

function lv1_items_Count:integer;
begin
  Result:=Mainform.lv1.items.Count;
end;

function Lv1_Items_SubItems_read(x,y:integer):ShortString;
begin
  Result:=Mainform.Lv1.Items[x].SubItems[y];
end;

procedure Lv1_Items_SubItems_write(x,y:integer;n:ShortString);
begin
  Mainform.Lv1.Items[x].SubItems[y]:=n;
end;

procedure Lv2_Items_SubItems_write(x,y:integer;n:ShortString);
begin
  Mainform.Lv2.Items[x].SubItems[y]:=n;
end;


function Get_date:TDateTime;
begin
  Result:=Mainform.dtp1.Date;
end;

function lv1_items_Checked(n1:integer):Boolean;
begin
  Result:=Mainform.lv1.items[n1].Checked;
end;

function Get_details:ShortString;
begin
   Result:=mainform.edit2.text; // назначение
end;

function Get_debet:ShortString;
begin
   Result:=mainform.edit1.text; // дебет
end;


procedure Lv1_Items_ImageIndex(n1,i:integer);
begin
    Mainform.LV1.Items[n1].ImageIndex:=i;
end;


procedure Label3_font_Color(i:integer);
begin
    MainForm.Label3.font.Color:=TColor(i);
end;

{ ***************************************************************************
  Очистка
 ****************************************************************************}
procedure TMainForm.clear;
begin
   Mainform.FZstatus:='';
   MainForm.Label3.Color:=clBtnFace;
   Mainform.edit1.Clear;   // ?
   Mainform.edit2.Clear;
   Mainform.lv2.Items.Clear;
   Mainform.lv1.Items.BeginUpdate;
   Mainform.lv1.Items.Clear;
   Mainform.lv1.Items.EndUpdate;

        PATH_IN:='';
        PATH_OUT:='';
        OpenDialog1.Filter:='';

end;
{*******************************************************************************
   Зачислить
*******************************************************************************}
procedure TMainForm.N4Click(Sender: TObject);
var
  ss2,ss3,ss4:string;
  w1,w2,w3,w4:word;
begin
if (trim(Edit1.Text)<>'') and (trim(Edit2.Text)<>'') then begin
    decodetime(time,w1,w2,w3,w4);
    ss2:=inttostr(w1); if length(ss2)=1 then ss2:='0'+ss2;
    ss3:=inttostr(w2); if length(ss3)=1 then ss3:='0'+ss3;
    ss4:=inttostr(w3); if length(ss4)=1 then ss4:='0'+ss4;
    FileBIS:=lv2.Items[0].SubItems[1]+ss2+ss3+ss4+'.txt';
    dir:=ExtractFilePath(Mainform.OpenDialog1.FileName);

    array_Callback[1]:=@lv1_items_Count;
    array_Callback[2]:=@Lv1_Items_SubItems_read;
    array_Callback[3]:=@Lv1_Items_SubItems_write;
    array_Callback[4]:=@Get_date;
    array_Callback[5]:=@lv1_items_Checked;
    array_Callback[6]:=@Get_details;
    array_Callback[7]:=@Get_debet;
    array_Callback[8]:=@WinToDos;
    array_Callback[9]:=@GetDateStr;
    CreateFileBis(FileBIS,array_Callback);
    MessageDlg('OK! Файл создали. Начинаем загрузку в Бисквит', mtInformation,[mbOk], 0);

//      net1(FileBIS,PATH_IN,PATH_OUT,dir); // pointer на obrres
    Mainform.N4.Enabled:=false;//отключаем повторную загрузку
  end else   MessageDlg('Не заполнены счет дебета или назначение', mtError,[mbOk], 0);
end;


{                     4   version 16/01/2013                     }

{ TPlugins }
{*******************************************************************************
   Загрузка плагинов                 
*******************************************************************************}
procedure TPlugins.LoadPlugins;
var
  Directory,srFile: TSearchRec;
  item : TMenuItem;
  kt,i:integer;
  PluginsProc: type_ExportProc;
  Plugdata : procedure(var data_pl:StrDataPlugin);
  Plugproc : procedure(var Spis_proc:type_ExportProc);
  LibHandle : THandle;
  dll_name,t_str:string;
begin
kt:=0;
if SysUtils.FindFirst(ExtractFilePath(Application.ExeName)+'Plugins\*', faDirectory, Directory) = 0 then
repeat
        if (Directory.Name<>'.') and (Directory.Name <>'..') and (Directory.Attr=faDirectory) then
              if SysUtils.FindFirst(ExtractFilePath(Application.ExeName)+'Plugins\'+Directory.Name+'\*.dll', faAnyFile and not faDirectory, srFile) = 0 then begin
                          dll_name:=ExtractFilePath(Application.ExeName)+'Plugins\'+Directory.Name+'\'+srFile.Name;
                          LibHandle := LoadLibrary(Pchar(dll_name));
                          if LibHandle <> 0 then begin
                            // Получаем структуру данных плагина
                            @Plugdata := GetProcAddress(LibHandle,'GetPluginData');
                            if @Plugdata <> nil then begin
                                SetLength(ArrayDataPlugin, kt+1);
                                Plugdata(ArrayDataPlugin[kt]);
                                ArrayDataPlugin[kt].DllName:=dll_name;
                                AboutPlugin:=AboutPlugin + '  ' +ArrayDataPlugin[kt].Name+'   -  ' + ArrayDataPlugin[kt].Comment+#10#13;
                                inc(kt);
                            end;
                            // Получаем список процедур плагина
                            @Plugproc := GetProcAddress(LibHandle,'GetPluginProc');
                            if @Plugproc <> nil then begin
                                Plugproc(PluginsProc);
                                for i:=0 to Length(PluginsProc)-1 do if PluginsProc[i].Menu <> '' then begin                             // Добавляем в меню
                                        item := TMenuItem.create(MainForm.MainMenu1);
                                        item.caption := PluginsProc[i].Menu;
                                        item.Hint:=dll_name+'|'+PluginsProc[i].Name;
                                        item.onClick:=Menu;
                                        t_str:=RightStr(LeftStr(PluginsProc[i].Name,pos('(',PluginsProc[i].Name)-1),1);
                                        if t_str ='1' then
                                            MainForm.Mainmenu1.Items[0].add(item)
                                            else
                                            MainForm.Mainmenu1.Items[1].add(item);

                                end;
                                FillChar(PluginsProc, SizeOf(PluginsProc), #0);    // веделяем память в Dll а чистим в программе
                            end; {@Plugproc <> nil then}
                          end; {LibHandle <> 0}
                          FreeLibrary(LibHandle);
                          FindClose(srFile);
              end;     {FindFirst}

until FindNext(Directory) <> 0;
FindClose(Directory);

end;

{*******************************************************************************
   Меню  плагинов
*******************************************************************************}
procedure TPlugins.Menu(Sender: TObject);
var
  Proc_parser: procedure (n:ShortString;a:TCallback_func);
  Procparam: procedure (a:TListView);
  Proc: procedure;
  dll,proc1:string;
  i:integer;
  LibHandle : THandle;
begin
try
MainForm.clear;
proc1:=(sender as TMenuItem).Hint;
dll:=LeftStr(proc1,pos('|',proc1)-1);
Delete(proc1,1,pos('|',proc1));

LibHandle := LoadLibrary(Pchar(dll));
if pos('1(',proc1)<>0 then begin    // парсеры
  @Proc_parser := GetProcAddress(LibHandle,PAnsiChar(LeftStr(proc1,pos('(',proc1)-1)));
  if @Proc_parser <> nil then begin

  // Вытаскивание структуры
            for i:=0 to length(ArrayDataPlugin)-1 do if ArrayDataPlugin[i].DllName=dll then begin
            MainForm.Edit1.Text:=ArrayDataPlugin[i].Debet;
            MainForm.Edit2.Text:=ArrayDataPlugin[i].Text;
            MainForm.PATH_IN:=ArrayDataPlugin[i].PATH_IN;
            MainForm.PATH_OUT:=ArrayDataPlugin[i].PATH_OUT;
            MainForm.OpenDialog1.Filter:=ArrayDataPlugin[i].Flt;
            Break;
          end;

      if MainForm.OpenDialog1.Execute then begin
        Proc_parser(MainForm.OpenDialog1.FileName,array_Callback);
        MainForm.N4.Enabled:=true;
     end;
  end;  {if @Proc parser <> nil }
end else if pos('(',proc1)<>0 then begin     // процедуры с параметром
  @Procparam := GetProcAddress((sender as TMenuItem).Tag,PAnsiChar(LeftStr(proc1,pos('(',proc1)-1)));
  if @Procparam <> nil then begin
       Procparam(Mainform.lv1);
  end;
end
else begin
  @Proc := GetProcAddress((sender as TMenuItem).Tag,PAnsiChar(proc1));
  if @Proc <> nil then Proc;
  end;
FreeLibrary(LibHandle);
except
    MessageDlg('Ошибка в парсере dll', mtError,[mbOk], 0);
end;

end;

{ TDLL }
{*******************************************************************************
   Загрузка DLL
*******************************************************************************}
procedure TDLL.LoadDll;
{var
  Directory,srFile: TSearchRec;
  item : TMenuItem;
  kt,i:integer;
  DllsProc: type_ExportProc;
  Plugdata : procedure(var data_pl:StrDataPlugin);
  DllProc : procedure(var Spis_proc:type_ExportProc);
  LibHandle : THandle;
  dll_name:string;}
begin
// Mainmenu1.Items[2].add(item);

  array_Callback[1]:=@Addform;array_Callback[2]:=@Statistics;array_Callback[3]:=@DosToWin;
  array_Callback[4]:=@WinToDos;array_Callback[5]:=@Digit;array_Callback[6]:=@StrToFloat;array_Callback[7]:=@getdatestr;array_Callback[8]:=@Hstr;
  array_Callback[9]:=@Human_Itog;array_Callback[10]:=@H_acca;array_Callback[11]:=@H_sum;array_Callback[12]:=nil;array_Callback[13]:=nil;array_Callback[14]:=nil;array_Callback[15]:=nil;

  // информацию прописывать в самой dll чтобы без ини обойтись

  AboutDLL:=AboutDLL + '  ' +'net.dll'+'   -  ' + 'загрузка файлов для работы с сетью'+#10#13;
  AboutDLL:=AboutDLL + '  ' +'tools.dll'+'   -  ' + 'библиотека инструментов'+#10#13;
  AboutDLL:=AboutDLL + '  ' +'cfb.dll'+'   -  ' + 'создание файла по формату фронтофиса'+#10#13;

end;
//  if FileExists(dir+'ans'+FileBIS) then Bismark.ObrabResBismark(dir+'ans'+FileBIS);

end.






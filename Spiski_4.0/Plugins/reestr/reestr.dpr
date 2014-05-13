library reestr;

uses
  SysUtils,
  inifiles,
  dialogs,windows,ActiveX, oleserver, ExcelXP,ComObj;

{$R *.res}
type

StrDataPlugin = packed record
	Name:ShortString;
  Comment:ShortString;
  LibHandle:ShortString;

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

  Tfun = function(St: ShortString): ShortString;
  Tfun1 = function(S: ShortString): Extended;
  TCallback_func = array[1..15] of Pointer;


var
  Acct:ShortString;
  i_file:string;

procedure GetPluginData(var plug_data:StrDataPlugin);
var
 inf:TIniFile;

begin
  inf:=TIniFile.Create(i_file);
  plug_data.Name:=inf.ReadString('Settings_General','Name','');
  plug_data.Comment:=inf.ReadString('Settings_General','Comment','');
  plug_data.LibHandle:='';

  plug_data.Debet:=trim(inf.ReadString('Settings_General','Debet',''));
  plug_data.Text:=inf.ReadString('Settings_General','Text','');
  plug_data.PATH_IN:=inf.ReadString('Settings_General','PATH_IN','');
  plug_data.PATH_OUT:=inf.ReadString('Settings_General','PATH_OUT','');
  plug_data.Flt:=inf.ReadString('Settings_General','Filter','');
  inf.Free;
end;
                                                                      
// пункты добавлять в меню Плагины
// menu 1   menu 2

procedure GetPluginProc(var Spis_proc:type_ExportProc);
begin
 SetLength(Spis_proc,1);
 Spis_proc[0].Name:='Parser1(n:ShortString;?????????)';
 Spis_proc[0].Menu:='Реестры';
end;

{ ***************************************************************************
    Парсер
 ****************************************************************************}
procedure Parser1(n:ShortString;a:TCallback_func);
var
  ExcelApplication1: variant;
  WorkSheet:ExcelWorksheet;
  BegStr,ENStr,index1,koun1:integer;
  s1,s2,s3,TEXT_Ss,dog,reestr,daata,vidpl,period:string;
  sum:Extended;
  EmptyParam: OleVariant;
  NeedToUninitialize: Boolean;
begin
  NeedToUninitialize := Succeeded(CoInitialize(nil));
//http://www.delphisources.ru/pages/faq/base/ole_excel_example.html
   try

  try
  ExcelApplication1:=CreateOleObject('Excel.Application');
  ExcelApplication1.WorkBooks.Open(n);
  ExcelApplication1.visible:=true;
//  WorkSheet:=ExcelApplication1.WorkBooks.Item[1].WorkSheets.Item[1] as ExcelWorksheet;
  ExcelApplication1.WorkBooks.Item[1].WorkSheets.Item[1].Cells.SpecialCells(xlCellTypeLastCell,EmptyParam).Activate;

  WorkSheet.Cells.SpecialCells(xlCellTypeLastCell,EmptyParam).Activate;
  ENStr:=Mainform.ExcelApplication1.ActiveCell.Row;
  BegStr:=1;
  for index1:=1 to ENStr do begin
    if Pos('перечислении юридическ',WorkSheet.Cells.Item[index1,3].value)>0 then dog:=WorkSheet.Cells.Item[index1+3,3].value;
    if Pos('еестр',WorkSheet.Cells.Item[index1,3].value)>0 then reestr:=WorkSheet.Cells.Item[index1,3].value;
    if pos('ид платежа',worksheet.cells.item[index1,2].value)>0 then begin vidpl:=Trim(worksheet.cells.item[index1,2].value);delete(vidpl,1,12); while pos(':',vidpl)>0 do vidpl[pos(':',vidpl)]:=' ';vidpl:=trim(vidpl);end;
    // ищем  первую строку
    if pos('№',WorkSheet.Cells.Item[index1,1].value)<>0 then begin
      BegStr:=index1+1;
      Break;
    end;
  end;
 koun1:=0;sum:=0;
 Mainform.lv1.items.BeginUpdate;
 for index1:=BegStr to ENStr do if string(WorkSheet.Cells.Item[index1,1].value)<>''  then begin
    Application.ProcessMessages;
    s1:=trim(WorkSheet.Cells.Item[index1,2].value);//фио
    s2:=trim(WorkSheet.Cells.Item[index1,3].value);//счет
    if string(WorkSheet.Cells.Item[index1,4].value)<>'' then s3:=trim(WorkSheet.Cells.Item[index1,4].value) else s3:='0';//сумма
    s3:=H_sum(s3);
    if (s1<>'') and (s2<>'') and (s3<>'') then begin
      inc(koun1);
      sum:=sum+strtofloat(s3);
      MainForm.Addform(inttostr(koun1),'','','',trim(s1),'','',trim(H_acca(s2)),trim(s3),'','','','','',trim(s3),'','','не выгружен','не выгружен','не выгружен');
    end;
end;
Mainform.lv1.items.EndUpdate;
// Назначение
    TEXT_Ss:=vidpl;
    if period<>'' then text_ss:=text_ss+' период '+period;
    if daata<>'' then  text_ss:=text_ss+' по '+reestr+' от '+daata else text_ss:=text_ss+' по '+reestr;
    if dog<>'' then text_ss:=text_ss+', дог. '+dog;
//назначение
Mainform.Edit2.Text:=Hstr(text_ss)+', #5  #6  #7';
// Выводим статистику
Statistics(inttostr(koun1),floattostr(sum));





  finally
//  ExcelApplication1.Workbooks.Close;
//  ExcelApplication1.Quit;
  end;

   finally
     if NeedToUninitialize then CoUninitialize;
   end;


end;


exports GetPluginData,GetPluginProc,Parser1;

var
 inf:TIniFile;
 TheFileName : array[0..255] of char;
begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  i_file:=TheFileName;
  i_file:=Copy(i_file,1,length(i_file)-3)+'ini';

  inf:=TIniFile.Create(i_file);
  Acct:=inf.ReadString('Settings_Plugin','Acct','');
  inf.Free;
end.

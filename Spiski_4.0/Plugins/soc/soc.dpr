library soc;

uses
  SysUtils,
  inifiles,windows,dialogs;

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
 Spis_proc[0].Menu:='Соцзащита';
end;

{ ***************************************************************************
    Парсер
 ****************************************************************************}
procedure Parser1(n:ShortString;a:TCallback_func);
type
Taform = procedure(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11,  v12, v13, v14, v15, v16, v17, v18, v19, v20: ShortString);
TStatistics = procedure(kount, sum: ShortString);
Tfun = function(St: ShortString): ShortString;
Tfun1 = function(S: ShortString): Extended;
var
f1:textfile;
s1,ac,su,fam:ShortString;
kount:integer;
sum:Single;
aform:Taform;
Statistics:TStatistics;
DosToWin,H_acca,H_sum:Tfun;
strtofloat:Tfun1;
begin

  aform:=taform(a[1]);
  Statistics:=TStatistics(a[2]);
  DosToWin:=Tfun(a[3]);
  strtofloat:=Tfun1(a[6]);
  H_acca  :=Tfun(a[10]);
  H_sum   :=Tfun(a[11]);
  AssignFile(f1,n);
  Reset(f1);
  kount:=0;
  sum:=0;
  while not eof(f1) do
  begin
     ReadLn(f1,s1);
     s1:=DosToWin(s1);

     //fam:=H_acca(copy(s1,37,30))+' '+H_acca(copy(s1,67,30))+' '+H_acca(copy(s1,97,30));//фио
     fam:=trim(copy(s1,39,30))+' '+trim(copy(s1,69,30))+' '+trim(copy(s1,99,30));
     //ac:=copy(s1,strtoint(copy(acct,1,pos(',',acct)-1)),strtoint(copy(acct,pos(',',acct)+1,length(acct)))); //счет
     ac:=trim(H_acca(copy(s1,129,20)));
     su:=ShortString(trim(copy(s1,150,27))); //сумма
     sum:=sum+strtofloat(H_sum(su));
     
     //aform(inttostr(kount+1),copy(s1,9,4),copy(s1,13,5),copy(s1,18,19),fam,'','',trim(H_acca(ac)),trim(H_sum(su)),copy(s1,164,12),copy(s1,176,12),copy(s1,188,12),
     //copy(s1,200,12),copy(s1,212,12),trim(copy(s1,224,12)),copy(s1,236,3),copy(s1,239,6),'не выгружен','не выгружен','не выгружен');
     
     aform(inttostr(kount+1),copy(s1,11,4),copy(s1,15,4),copy(s1,23,1),fam ,'','',trim(H_acca(ac)),trim(H_sum(su)),'','','','','',trim(H_sum(copy(s1,150,27))),copy(s1,177,3),'нет','не выгружен','не выгружен','не выгружен');      
     inc(kount);
  end;{while}
  CloseFile(f1);

  Statistics(inttostr(kount),FormatFloat('0.00',sum));
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

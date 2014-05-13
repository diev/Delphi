library pfr;

uses
  SysUtils,
  inifiles,
  windows,
  dialogs,
  forms,
  comctrls;

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
  Acct,PREFIX:ShortString;
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
 Spis_proc[0].Menu:='ПФР';

 SetLength(Spis_proc,2);
 Spis_proc[1].Name:='CreateFileAnswerPFR2(file1:ShortString)';
 Spis_proc[1].Menu:='ПФР - ответы';

 SetLength(Spis_proc,3);
 Spis_proc[2].Name:='CreateFileAnswerPFR2';
 Spis_proc[2].Menu:='ПФР - ответы (без зачисления)';

 SetLength(Spis_proc,4);
 Spis_proc[3].Name:='CreateFileAnswerPFR2(a:TForm)';
 Spis_proc[3].Menu:='test';

end;

{ ***************************************************************************
    Парсер
 ****************************************************************************}
procedure Parser1(n:ShortString;a:TCallback_func);
type
Taform = procedure(v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11,  v12, v13, v14, v15, v16, v17, v18, v19, v20: ShortString);
TStatistics = procedure(kount, sum: ShortString);
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
//http://www.compress.ru/article.aspx?id=10329&iid=425
//  if MainForm.verba=1 then vrb.DeCrypt(n);
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
     PREFIX:='РСХБ/0'+copy(s1,13,4); // пфр нужно указывать
     fam:=H_acca(copy(s1,37,30))+' '+H_acca(copy(s1,67,30))+' '+H_acca(copy(s1,97,30));//фио
     ac:=copy(s1,strtoint(copy(acct,1,pos(',',acct)-1)),strtoint(copy(acct,pos(',',acct)+1,length(acct)))); //счет
     su:=ShortString(trim(copy(s1,152,12))); //сумма
     sum:=sum+strtofloat(H_sum(su));
     aform(inttostr(kount+1),copy(s1,9,4),copy(s1,13,5),copy(s1,18,19),fam,'','',
     trim(H_acca(ac)),trim(H_sum(su)),copy(s1,164,12),copy(s1,176,12),copy(s1,188,12),
     copy(s1,200,12),copy(s1,212,12),trim(copy(s1,224,12)),copy(s1,236,3),copy(s1,239,6),'не выгружен','не выгружен','не выгружен');
     inc(kount);
  end;{while}
  CloseFile(f1);

  Statistics(inttostr(kount),FormatFloat('0.00',sum));

end;

{
{ ***************************************************************************
   Парсер пенсии и соц
 ****************************************************************************
procedure TParserSpiski.txt(n:ShortString);
begin
 sum:=sum+strtofloat(H_sum(copy(s1,150,27)));
 MainForm.Addform(inttostr(kount),copy(s1,11,4),copy(s1,15,4),copy(s1,23,1),trim(copy(s1,39,30))+' '+trim(copy(s1,69,30))+' '+trim(copy(s1,99,30)),'','',trim(H_acca(copy(s1,129,20))),trim(H_sum(copy(s1,150,27))),'','','','','',trim(H_sum(copy(s1,150,27))),copy(s1,177,3),'нет','не выгружен','не выгружен','не выгружен');
  //назначение
  Mainform.edit2.text:='Зачисление по списку на счет #8 , клиент #5  #6  #7 , отд.филиала #3 , сумма #9';
}

procedure CreateFileAnswerPFR4(a:TListView);
begin
  ShowMessage(a.Items[1].SubItems[16]);
end;



{ ***************************************************************************
  Формирование ответного файла (только для пенсий)
 ****************************************************************************}
procedure CreateFileAnswerPFR1(file1:ShortString);
var
s1,s2,s3,data1,s11,s12,s13,s14,s15,s17,s18,s19:ShortString;
f1:textfile;
sss2,s_dir,stroka:ShortString;
begin
 ShowMessage('CreateFileAnswerPFR2');

s1:=file1;
s1[length(s1)-2]:='d';
s_dir:=ExtractFileDir(s1)+'\ответы\';
if not DirectoryExists(s_dir) then CreateDir(s_dir);

  AssignFile(f1,s_dir+ExtractFileName(s1));
  Rewrite(f1);
  //  s2:='РСХБ/0'+Mainform.lv2.items[0].SubItems[0]; старое
//  s3:=Mainform.lv2.Items[0].SubItems[0]; WHILE Length(s3)<7 DO s3:='0'+s3; //количесво
//  s4:=Mainform.lv2.Items[0].SubItems[1]; while pos('.',s4)>0 do delete(s4,pos('.',s4),1);while pos(' ',s4)>0 do delete(s4,pos(' ',s4),1);while Length(s4)<15 do s4:='0'+s4;// сумма
//  data1:=FormatDateTime('DDMMYY',Mainform.dtp1.date);
  sss2:=data1;
//  stroka:=MainForm.PREFIX+s3+s4+data1;

//  WriteLn(f1,WinToDos(stroka));
  CloseFile(f1);

if Length(stroka)<38 then MessageDlg('Файл ответов меньшей длины проверияйте !!!', mtError,[mbOk], 0);
//if MainForm.verba=1 then vrb.EnCryptAnswer(s_dir+ExtractFileName(s1));
{--------------------SECOND_FILE---------}
//s1:=MainForm.OpenDialog1.FileName;
s1[length(s1)-2]:='f';

  AssignFile(f1,s_dir+ExtractFileName(s1));
  Rewrite(f1);
//  FOR n1:=0 TO Mainform.lv1.items.count-1 DO IF Mainform.lv1.items[n1].ImageIndex=3 THEN BEGIN
          {------------------------------}
          s2:='        '; ////Служебная информация о клиенте A8
          s3:='РСХБ0';
{          s4:=Mainform.lv1.Items[n1].SubItems[1]; ////НОМЕР ФИЛИАЛА A5
          s5:=Mainform.lv1.Items[n1].SubItems[2]; WHILE Length(s5)<19 DO s5:=' '+s5; ////КАРТОЧКА A19
          s6:=Mainform.lv1.Items[n1].SubItems[3]; WHILE Length(s6)<30 DO s6:=s6+' '; ////Ф A30
          s7:=Mainform.lv1.Items[n1].SubItems[4]; WHILE Length(s7)<30 DO s7:=s7+' '; ////И A30
          s8:=Mainform.lv1.Items[n1].SubItems[5]; WHILE Length(s8)<30 DO s8:=s8+' '; ////О A30
          s9:=Mainform.lv1.Items[n1].SubItems[6]; WHILE Length(s9)<25 DO s9:=s9+' '; ////СЧЕТ A25
          s10:=Mainform.lv1.Items[n1].SubItems[7]; WHILE POS('.',s10)>1 DO delete(s10,pos('.',s10),1); WHILE POS(',',s10)>1 DO delete(s10,pos(',',s10),1);  WHILE Length(s10)<11 DO s10:=' '+s10; ////СУММА A11}
          s11:='          0';
          s12:='          0';
          s13:='          0';
          s14:='          0';
          s15:='          0';
//          s16:=Mainform.lv1.Items[n1].SubItems[13]; WHILE POS('.',s16)>1 DO delete(s16,pos('.',s16),1); WHILE POS('.',s16)>1 DO delete(s16,pos('.',s16),1);  WHILE Length(s16)<11 DO s16:=' '+s16; ////СУММА A11
          s17:='   ';
          s18:=sss2;
          s19:='4';
//          WriteLn(f1,WinToDos(s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13+s14+s15+s16+s17+s18+s19));
          {------------------------------}
//          END;
CloseFile(f1);
// шифрование если был шифрован
//if MainForm.verba=1 then vrb.EnCryptAnswer(s_dir+ExtractFileName(s1));

end;


exports GetPluginData,GetPluginProc,Parser1,CreateFileAnswerPFR1,CreateFileAnswerPFR4;

var
 inf:TIniFile;
 TheFileName : array[0..255] of char;
{ TPlugin }


begin
  FillChar(TheFileName, sizeof(TheFileName), #0);
  GetModuleFileName(hInstance, TheFileName, sizeof(TheFileName));
  i_file:=TheFileName;
  i_file:=Copy(i_file,1,length(i_file)-3)+'ini';

  inf:=TIniFile.Create(i_file);
  Acct:=inf.ReadString('Settings_Plugin','Acct','');
  PREFIX:=inf.ReadString('Settings_Plugin','Prefix','');
  inf.Free;


end.

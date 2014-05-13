library cfb;

uses
  SysUtils,
  Classes;

{$R *.res}
type

  Tproc1 = procedure(x,y:integer;n:ShortString);
  Tproc2 = procedure(n1,i:integer);
  Tproc3 = procedure(i:integer);
  Tfun1  = function(x,y:integer):ShortString;
  Tfun2  = function:integer;
  Tfun3  = function:TDateTime;
  TFun4  = function(d:TDateTime):ShortString;
  Tfun5  = function(n1:integer):Boolean;
  Tfun7  = function:ShortString;

  Tfun = function(St:ShortString):ShortString;

  TCallback_func = array[1..15] of Pointer;

var
  lv1_items_Count:Tfun2;
  Lv1_Items_SubItems_read:Tfun1;
  Lv1_Items_SubItems_write:Tproc1;
  Lv2_Items_SubItems_write:Tproc1;
  Lv1_Items_ImageIndex:Tproc2;
  Label3_font_Color:Tproc3;



{ ***************************************************************************
   создание файла для Bismark
 ****************************************************************************}
procedure CreateFileBis(FileBIS: ShortString;a:TCallback_func);
var
s1:string;
n1:integer;
f1:textfile;
ss1,ss2,ss3,ss4:string;
w1,w2,w3,w4:word;
s_s1,s_s2,s_s3,s_s4,s_s5,s_s6:string;
Number_doc:string;
nn1:integer;
TEST_S:String;
sss1,sss2:string;
debet:string;

Get_date:Tfun3;
lv1_items_Checked:Tfun5;
Get_details:Tfun7;
Get_debet:Tfun7;

GetDateStr:TFun4;
WinToDos:Tfun;
//Count_str:integer;
begin

  lv1_items_Count:=Tfun2(a[1]);
  Lv1_Items_SubItems_read:=Tfun1(a[2]);
  Lv1_Items_SubItems_write:=Tproc1(a[3]);
  Get_date:=tfun3(a[4]);
  lv1_items_Checked:=tfun5(a[5]);
  Get_details:=Tfun7(a[6]);
  Get_debet:=Tfun7(a[7]);

  WinToDos:=Tfun(a[8]);
  GetDateStr:=Tfun4(a[9]);

  AssignFile(f1,FileBIS);
  rewrite(f1);

  decodedate(Get_date,w1,w2,w3);
  ss1:=inttostr(w2); if length(ss1)=1 then ss1:='0'+ss1;
  ss2:=inttostr(w3); if length(ss2)=1 then ss2:='0'+ss2;
  ss1:=ss2+'.'+ss1+'.'+inttostr(w1);
  decodetime(time,w1,w2,w3,w4);
  ss2:=inttostr(w1); if length(ss2)=1 then ss2:='0'+ss2;
  ss3:=inttostr(w2); if length(ss3)=1 then ss3:='0'+ss3;
  ss4:=inttostr(w3); if length(ss4)=1 then ss4:='0'+ss4;
  {---------write_head-------}
  WriteLn(f1,ss1+' '+ss2+':'+ss3+':'+ss4);
  WriteLn(f1,'DOCUMENTS');
  {--------------------------}
  number_doc:='00';
  nn1:=0;
  for n1:=0 to lv1_items_Count-1 do if lv1_items_Checked(n1) then begin
      inc(nn1);
      {----generate_id---------}
      ss3:=inttostr(nn1);
      decodedate(Get_date,w1,w2,w3);
      s_s1:=inttostr(w2); if length(s_s1)=1 then s_s1:='0'+s_s1; //28
      s_s2:=inttostr(w3); if length(s_s2)=1 then s_s2:='0'+s_s2; //04
      decodetime(time,w1,w2,w3,w4);
      s_s3:=inttostr(w1); if length(s_s3)=1 then s_s3:='0'+s_s3; //14
      s_s4:=inttostr(w2); if length(s_s4)=1 then s_s4:='0'+s_s4; //05
      s_s5:=inttostr(w3); if length(s_s5)=1 then s_s5:='0'+s_s5; //32
      s_s6:=s_s1+s_s2+s_s3+s_s4+s_s5+ss3; delete(s_s6,1,1);
      {---------document_number--------------}
      number_doc:=inttostr(strtoint(number_doc)+1);
      if length(number_doc)=1 then number_doc:='00'+number_doc;
      if length(number_doc)=2 then number_doc:='0'+number_doc;
      {-----------creatr_text-----------------}
      test_s:=Get_details; // назначение
      while pos('"',test_s)>0 do delete(test_s,pos('"',test_s),1);// Очищаем поле от разделителей        Hstr !
      while pos('#',test_s)>0 do
        begin
         sss1:=copy(test_s,1,pos('#',test_s)-1);
         delete(test_s,1,pos('#',test_s));
         if pos(' ',test_s)<>0 then sss2:=copy(test_s,pos(' ',test_s)+1,length(test_s)) else sss2:='';
         if pos(' ',test_s)<>0 then delete(test_s,pos(' ',test_s),length(test_s));
         test_s:=sss1+ Lv1_Items_SubItems_read(n1,strtoint(test_s)-2)+sss2;

        end;
        debet:=Get_debet;
	// формируем строку и записываем в файл
      s1:=WinToDos('"" '+ss1+' "'+s_s6+'"  ""  2 "06"  '+Number_doc+'  "09"  ')+
      WinToDos(GetDateStr(Get_date)+' '+GetDateStr(Get_date)+' ""  ')+
      WinToDos(Lv1_Items_SubItems_read(n1,13)+'  "'+ debet +'"  ""  "Текст" "042520700" "30101810700000000700"')+
      WinToDos('  "ИРКУТСКИЙ РФ ОАО ""РОССЕЛЬХОЗБАНК""" ""  ""  ""  ""  ""  ""  ""  ""  ""  "042520700" "30101810700000000700"  "ИРКУТСКИЙ РФ ОАО ""РОССЕЛЬХОЗБАНК""" ""  "')+
      WinToDos(Lv1_Items_SubItems_read(n1,6)+'" "text2" ""  "')+WinToDos(TEST_S)+
      WinToDos('"  "6" ""  ? No  ""  ""  0 ""  '+ss1+' ""  '+ Lv1_Items_SubItems_read(n1,13)+'  ""  0 '+GetDateStr(Get_date)+' '+GetDateStr(Get_date)+' "810" 0 ""');

      WriteLn(f1,s1);
      Lv1_Items_SubItems_write(n1,16,s_s6);
      Lv1_Items_SubItems_write(n1,17,'на обработке');
      Lv1_Items_SubItems_write(n1,18,'на обработке');
  end;{forif}
  closefile(f1);
end;

{ ***************************************************************************
  Обработать результат
 ****************************************************************************}
procedure ObrabResBismark(fil:ShortString;a:TCallback_func);
var
  s1:string;
  n1,n2:integer;
  f1:textfile;
  ID_S,RESULT_S,RESULT_CODE:string;
  LS_TMP:tstringlist;
  SumZach,SumNotZach:Extended;
  KolZach,KolNotZach:integer;
  DosToWin:Tfun;
begin
  DosToWin:=Tfun(a[1]);

   LS_TMP:=tstringlist.create;
   AssignFile(f1,fil);
   reset(f1);
   ReadLn(f1,s1);
   ReadLn(f1,s1);
   while not EOF(f1) do begin
      ReadLn(f1,s1);
      s1:=DosToWin(s1);
      // Кавычки убираем   и строки
      RESULT_S:=copy(s1,2,pos(#9,s1)-3);delete(s1,1,pos(#9,s1));delete(s1,1,pos(#9,s1));
      ID_S:=copy(s1,2,pos(#9,s1)-3);delete(s1,1,pos(#9,s1));delete(s1,1,pos(#9,s1));
      RESULT_CODE:=Copy(s1,1,pos(#9,s1)-1);
      {-----------------------------------------}
      LS_TMP.add(ID_S);
      LS_TMP.add(RESULT_S);
      LS_TMP.add(RESULT_CODE);
    end;
   CloseFile(f1);

      SumNotZach:=0;SumZach:=0;Kolzach:=0;Kolnotzach:=0;
      for n1:=0 to lv1_items_Count-1 do begin
          n2:=LS_TMP.IndexOf(Lv1_Items_SubItems_read(n1,16));
          if n2>-1 then if LS_TMP[n2+2]='8' then begin
                        Lv1_Items_SubItems_write(n1,17,'Зачислено');
                        Lv1_Items_SubItems_write(n1,18,'Зачислено');
                        SumZach:=SumZach+strtofloat(Lv1_Items_SubItems_read(n1,13));
                        Inc(Kolzach);
                        Lv1_Items_ImageIndex(n1,2);
                     end else begin
                          Lv1_Items_SubItems_write(n1,17,'НЕ зачислено');
                          Lv1_Items_SubItems_write(n1,18,LS_TMP[n2+1]);
                          SumNotZach:=SumNotZach+strtofloat(Lv1_Items_SubItems_read(n1,13));
                          Inc(Kolnotzach);
                        Lv1_Items_ImageIndex(n1,3);
                        end
          else if n2=-1 then begin
                           Lv1_Items_SubItems_write(n1,17,'Не найдено');
                           Lv1_Items_SubItems_write(n1,18,'Не найдено');
						end;
     end;{for}
   LS_TMP.free;

    Lv2_Items_SubItems_write(0,2,inttostr(Kolzach));
    Lv2_Items_SubItems_write(0,3,{Human_Itog(}FloatToStr(SumZach));
    Lv2_Items_SubItems_write(0,4,inttostr(Kolnotzach));
    Lv2_Items_SubItems_write(0,5,{Human_Itog(}FloatToStr(SumNotZach));

   if Kolnotzach>0 then Label3_font_Color($0000FF);

end;



exports CreateFileBis, ObrabResBismark;

begin
end.

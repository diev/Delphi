library tools;
{ ***************************************************************************
  Библиотека инструментов
  2010
 ***************************************************************************}
uses
  SysUtils, Classes, Windows, Controls, StrUtils;

{$R *.res}

{*******************************************************************************
  Ковентирование DosToWin
*******************************************************************************}
function DosToWin(St: ShortString): ShortString;
var
  Ch: PChar;
  s:string;
begin
  s:=st;
  Ch := StrAlloc(Length(St) + 1);
  OemToAnsi(PAnsiChar(S), Ch);
  Result := Ch;
  StrDispose(Ch)
end;

{*******************************************************************************
  Ковентирование WinToDos
*******************************************************************************}
function WinToDos(Src:ShortString): ShortString;
var
  s,s1:string;
begin
  if src <> '' then begin
    s:=src;
    SetLength(s1, Length(s));
    CharToOem(PAnsiChar(s),PAnsiChar(s1));
  end;
  Result:=s1;
         // можно и так: CharToOemBuff(PAnsiChar(S),PAnsiChar(Result),length(s));
end;
{*******************************************************************************
  Проверка цифры ли это
*******************************************************************************}
function Digit(s:ShortString):boolean;
var
i:integer;
begin
  Result:=true;
  for i:=1 to Length(s) do
    if not(s[i] in ['0'..'9',',','.']) then begin result:=false;Break;end;
end;
{*******************************************************************************
  Ковентирование StrToFloat
*******************************************************************************}
function StrToFloat(S: ShortString): Extended;
var
s1:string;
begin
  if pos('.',s)>0 then s[pos('.',s)]:=',';
  if s='' then begin Result:=0;exit;end;
  if not Digit(S) then begin Result:=0;exit;end;
  s1:=s;
  TextToFloat(PChar(S1), Result, fvExtended);
end;
{*******************************************************************************
  Дата
*******************************************************************************}
function getdatestr(dtp:tdate):ShortString;
var
s2,s3:string;
n1,n2,n3:word;
begin
  decodedate(dtp,n1,n2,n3);
  s2:=inttostr(n2); if length(s2)=1 then s2:='0'+s2;
  s3:=inttostr(n3); if length(s3)=1 then s3:='0'+s3;
  result:=s3+'.'+s2+'.'+inttostr(n1);
end;
{ ***************************************************************************
  Сумма с раделением разрядов
 ****************************************************************************}
function Human_Itog(itog: ShortString): ShortString;
var
  i,koun:integer;
  str:string;
begin
 koun:=0;
 str:=copy(itog,1,Length(itog)-3);
 for i:=Length(str) downto 0 do begin
  inc(koun);
  if (koun mod 3)=0 then Insert(' ',str,i);
 end;
 Result:=trim(str)+RightStr(itog,3);
end;
{ ***************************************************************************
  Строка
 ****************************************************************************}
function Hstr(st: ShortString): ShortString;
begin
    while pos('"',st)>0 do delete(st,pos('"',st),1);
    while pos('№',st)>0 do st[pos('№',st)]:='N';
    Result:=st;
end;
{ ***************************************************************************
  счет
 ****************************************************************************}
function H_acca(st: ShortString): ShortString;
begin
    while pos('"',st)>0 do delete(st,pos('"',st),1);
    while pos(' ',st)>0 do delete(st,pos(' ',st),1);
    while pos('.',st)>0 do delete(st,pos('.',st),1);
    while pos('-',st)>0 do delete(st,pos('-',st),1);
    while pos(',',st)>0 do delete(st,pos(',',st),1);
    Result:=st;
end;
{ ***************************************************************************
  Сумма
 ****************************************************************************}
function H_sum(st: ShortString): ShortString;
begin
   if pos(',',st)>0 then st[pos(',',st)]:='.';
   Result:=trim(st);
end;




exports DosToWin, WinToDos, Digit, StrToFloat, getdatestr, Human_Itog, Hstr, H_acca, H_sum;

begin



end.
 
program BisPCstart;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  ShellApi,
  Windows,Registry;

var
Regist:TRegistry;
wd:ShortString;

begin
  Regist:=TRegistry.Create;
  Regist.RootKey:=HKEY_LOCAL_MACHINE;
  if Regist.OpenKey('SOFTWARE\BisPC',False) then
    wd:=Regist.ReadString('WorkingDir');
  Regist.Free;

  if wd='' then wd:='c:\Program Files\BIS\BisPC';

  ShellExecute(0,'open',PChar(wd+'\bispc.exe'), pchar('--port 516'),PChar(wd+'\'), SW_HIDE);
end.
 
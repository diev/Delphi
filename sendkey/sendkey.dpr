program sendkey;

{$APPTYPE CONSOLE}

uses
  SysUtils,Windows;

var
  Handle:HWND;
//  log:textfile;
begin
//AssignFile(log,'D:\work\bik.log');
//Rewrite(log);

Handle:=FindWindow('ConsoleWindowClass',PAnsichar('S:\CB\N_RKC\01RKC#.EXE'));
if Handle<>0 then begin
//    Writeln(log,DatetimeToStr(now)+ ' нашли прогу '+IntToStr(Handle)+' заголовок '+ParamStr(1));
    SetForegroundWindow(Handle);
    sleep(1000);
    keybd_event(VK_ESCAPE, 1, 0, 0);
    keybd_event(VK_ESCAPE, 1, 2, 0);
    sleep(1000);
    keybd_event(VK_ESCAPE, 1, 0, 0);
    keybd_event(VK_ESCAPE, 1, 2, 0);
  end;
//else Writeln(log,DatetimeToStr(now)+' не найдена');

//CloseFile(log);

end.

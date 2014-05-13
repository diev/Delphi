{*******************************************************************************

  (c) 2010

*******************************************************************************}
unit Main;
interface
uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs,   ExtCtrls, Buttons, inifiles,EncdDecd, StdCtrls;
type
  TForm1 = class(TForm)
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Label4: TLabel;
    Button4: TButton;
    CheckBox1: TCheckBox;
    Label22: TLabel;
    ListBox1: TListBox;
    procedure TimerKBR_InTimer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Log(mes:string);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure message_list(ms:string);
    function Base64(file_name:string):string;
    procedure Button4Click(Sender: TObject);
  private
    PATHINSVK,PATHOUTSVK,OBRIN,OBROUT,ARHIV,PATH_LOGI,DEN,EXCLUDE:string;
    LOGI:Boolean;
    excl:set of char;
  public
    { Public declarations }
  end;


var
  Form1: TForm1;

implementation

uses StrUtils, Unit2, Unit3;
{$R *.dfm}
{***************************************************************************
   �������������
************************************************************************}
procedure TForm1.FormCreate(Sender: TObject);
var
 INF:TIniFile;
 TimerKBR_In:TTimer;
begin
  Label22.Caption:=Label22.Caption+' 2.3 �� 19/09/2013 ';
  TimerKBR_In:=TTimer.Create(self);
  TimerKBR_In.OnTimer:=TimerKBR_InTimer;

  INF             :=TIniFile.Create(ExtractFilePath(Application.ExeName)+'svk.ini');
  PATHINSVK       :=inf.ReadString('DIRECTORY','PATHINSVK','');
  PATHOUTSVK      :=inf.ReadString('DIRECTORY','PATHOUTSVK','');
  OBRIN           :=inf.ReadString('DIRECTORY','OBRIN','');
  OBROUT          :=inf.ReadString('DIRECTORY','OBROUT','');
  ARHIV           :=inf.ReadString('DIRECTORY','ARHIV','');
  PATH_LOGI       :=inf.ReadString('DIRECTORY','PATH_LOGI','');
  LOGI            :=inf.ReadBool('COMMON','LOGI',false);  CheckBox1.Checked:=LOGI;
  TimerKBR_In.Interval:=inf.ReadInteger('COMMON','TIME_IN',30)*1000;{�� ��������� 30 ���.}
  EXCLUDE         :=inf.ReadString('COMMON','EXCLUDE','');
  INF.Free;

//{$Define Debug}
 {���������� ��������}

  {$IFDEF Debug}
  {$ELSE}
 if (PATHINSVK='') or (PATHOUTSVK='') or (ARHIV='') or (OBRIN='') or (OBROUT='') then
  begin
   MessageDlg('������ �� ��� ������������ ��������� :'+#10#13#10#13+
   'PATHINSVK='+PATHINSVK+#10#13+'PATHOUTSVK='+PATHOUTSVK+#10#13+ 'ARHIV='+ARHIV+#10#13+'OBRIN='+OBRIN+#10#13+'OBROUT='+OBROUT, mtError,[mbOk], 0);
   Halt(0);
 end;

 if not DirectoryExists(OBRIN) then begin
    MessageDlg('�� ��������� ����, ������ ��� '+OBRIN, mtError,[mbOk], 0);
//    Halt(0);
 end;
 if not DirectoryExists(ARHIV) then CreateDir(ARHIV);
 {�������������������� ��� ������ �����������}
 DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
 {����� ��������� ����� ���� ��� ������ ����������� ������}
 if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);

  {$ENDIF}

  TimerKBR_In.Enabled:=true;
  Label4.Caption:='���������� �������';
  message_list('������ ���������');
//  excl:=EXCLUDE;
end;
{****************************************************************************
  ��������� ���������
*****************************************************************************}
procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
 if Dialogs.MessageDlg('������� ��������� ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then CanClose:=false else begin
    Log('����� ���������');
 end;

end;
{****************************************************************************
  ���� ����� �� �������� ������� ����, ��������, �������
  �� ������ ���� ��������� ��������, �.�. ������ ������������
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
    ��������� ��������
************************************************************************}
procedure TForm1.TimerKBR_InTimer(Sender: TObject);
var
    sr: TSearchRec;
    f:TextFile;
    s:string;
    id:integer;
    fl:boolean;
begin
if SysUtils.FindFirst(PATHINSVK+'*.*', faAnyFile, sr) = 0 then
     repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
          //���������� 205 201 �� ���
          fl:=false;
          id:=0;
          AssignFile(f,PATHINSVK+sr.Name);
          Reset(f);
          while not eof(f) do begin
            inc(id);
            Readln(f,s);
            if id=6 then begin
                if (pos('ED205',DecodeString(copy(s,15,200)))<>0)
                or (pos('ED201',DecodeString(copy(s,15,200)))<>0)
                or (pos('ED374',DecodeString(copy(s,15,200)))<>0)
                or (pos('ED209',DecodeString(copy(s,15,200)))<>0)  then
                fl:=true;
                Break;
            end;
          end;
          CloseFile(f);

          // ������� �� �������� � �����
          DEN:=copy(DateToStr(Now),7,4)+copy(DateToStr(Now),4,2)+copy(DateToStr(Now),1,2)+'\';
          if not DirectoryExists(ARHIV+DEN) then CreateDir(ARHIV+DEN);
          CopyFile(Pchar(PATHINSVK+sr.Name),Pchar(ARHIV+DEN+sr.Name),true);

          {� ���}
          if fl=false then begin
                // ��������� �� ���������
            MoveFile(Pchar(PATHINSVK+sr.Name),Pchar(OBRIN+sr.Name));
            message_list('���� '+PATHINSVK+sr.Name+' ��������� �� ��� ��� � ���');
          end;   {������� �������� ����}
         if FileExists(PATHINSVK+sr.Name) then DeleteFile(PATHINSVK+sr.Name);
        end;
      until FindNext(sr) <> 0;
      FindClose(sr);
end;


{***************************************************************************
   ��������� ���������
****************************************************************************}
procedure TForm1.Button1Click(Sender: TObject);
var
    sr: TSearchRec;
    f:TextFile;
    s:string;
begin
if SysUtils.FindFirst(OBROUT+'*.xml', faAnyFile, sr) = 0 then
      repeat
        if (sr.Name<>'.') and (sr.Name <>'..') and (sr.Attr<>faDirectory) then begin
          AssignFile(f,OBROUT+sr.Name);
          reset(f);
          if not eof(f) then readln(f,s);
          if not eof(f) then readln(f,s);
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
            ShowMessage('���� '+OBROUT+sr.Name+' ��������� � ��� ���');
            message_list('���� '+OBROUT+sr.Name+' ��������� �� ��� � ��� ���');
          end;
        end;
      until FindNext(sr) <> 0
else ShowMessage('������ ���');
FindClose(sr);

end;
{**********************************************************************
    ����� �� ���� � � ���
************************************************************************}
procedure TForm1.message_list(ms: string);
begin
  ListBox1.Items.Add(DateTimeToStr(now)+' '+ms);
  Log(ms);
end;

function TForm1.Base64(file_name: string): string;
var
  id:integer;
  s:string;
  f:TextFile;
begin
Form3.Memo1.Align:=alClient;
Form3.Memo1.Clear;
  if FileExists(file_name) then begin
       AssignFile(f,file_name);
       Reset(f);
            id:=0;
            while not eof(f) do begin
              inc(id);
              Readln(f,s);
              { �������� }
              if ExtractFileExt(file_name)<>'.xml' then if id=6 then begin
                s:=copy(s,15,length(s));
                s:=DecodeString(s);
                while Pos('>',s)<>0 do begin
                    Form3.Memo1.Lines.Add(Copy(s,1,Pos('>',s)));
                    Delete(s,1,Pos('>',s));
                  end;
              end;
              { ��������� ���� }
              if ExtractFileExt(file_name)='.xml' then Form3.Memo1.Lines.Add(s);
            end;
        CloseFile(f);
    end;
Form3.ShowModal;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  if OpenDialog1.Execute then Base64(OpenDialog1.FileName);
end;


end.









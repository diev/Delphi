unit form_spk;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  Tspk = class(TForm)
    ListBox1: TListBox;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  spk: Tspk;
  Abonents_list:String;
  Pub:String;
  Sec:String;
  Bank:integer;
  Seria:String;
  txt_verba_o_dll:String;
  key_dev:String;

implementation

{$R *.dfm}

procedure Tspk.FormShow(Sender: TObject);
var
 tf:TextFile;
 s1,s2:string;
begin
   ListBox1.Clear;

   s1:=Abonents_list;
   if not FileExists(s1) then begin MessageDlg('Отсутствует файл со cписком ключей', mtError,[mbOk], 0);exit;end;
   AssignFile(tf, s1);
   reset(tf);
   while not eof(tf) do begin
     Readln(tf, s2);
     ListBox1.Items.Add(trim(s2));
   end;
   closefile(tf);

end;

procedure Tspk.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure Tspk.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    Action := caFree;
end;


end.

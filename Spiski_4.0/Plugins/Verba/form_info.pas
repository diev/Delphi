unit form_info;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,shellAPI;

type
  Tinfo = class(TForm)
    GroupBox1: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  info: Tinfo;

implementation

{$R *.dfm}

procedure Tinfo.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//    Action := caFree;
end;

procedure Tinfo.Label3Click(Sender: TObject);
begin
  Shellexecute(handle,'Open',pchar('mailto:'+Copy(Label3.Caption,20,length(Label3.Caption))),nil, nil, sw_restore);
end;

end.

unit form_XLS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, OleCtnrs;

type
  TXLSForm = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Button1: TButton;
    Label6: TLabel;
    Edit6: TEdit;
    Label7: TLabel;
    Edit7: TEdit;
    OleContainer1: TOleContainer;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  XLSForm: TXLSForm;

implementation

{$R *.dfm}

end.

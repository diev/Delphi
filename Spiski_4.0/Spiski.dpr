program Spiski;

uses
  Forms,
  Main in 'Main.pas' {MainForm},
  form_AboutBox in 'form_AboutBox.pas' {AboutBox};

{$R *.res}
begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.




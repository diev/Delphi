program SVK;
uses
  Forms,
  windows,
  dialogs,
  Main in 'Main.pas' {Form1},
  Unit2 in 'Unit2.pas' {Form2},
  Unit4 in 'Unit4.pas' {DecodeForm};

{$R *.res}

begin
  Application.Initialize;
{  if FindWindow('TForm1','Обработка файлов')<>0 then begin
    showmessage('Программа уже запущена');
    Application.Terminate;
  end;}
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TForm2, Form2);
  Application.CreateForm(TDecodeForm, DecodeForm);
  Application.Run;
end.

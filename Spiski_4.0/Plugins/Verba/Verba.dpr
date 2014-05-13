library Verba;

uses
  SysUtils,
  Classes,
  inifiles,
  WBoth in 'wboth.pas',
  form_spk in 'form_spk.pas' {spk},
  unit_Verba in 'unit_Verba.pas',
  form_info in 'form_info.pas' {info};

type

StrDataPlugin = packed record
	Name:ShortString;
  Comment:ShortString;

	Debet:ShortString;
	Text:ShortString;
	FTP_PATH_IN:ShortString;
	FTP_PATH_OUT:ShortString;
  Flt:ShortString;
end;


type_ExportProc = array of record
                                  Name:ShortString;
                                  Menu:ShortString;
                                 end;
var
   vrb:TVerba;

{$R *.res}
{******************************************************************************
  Описание: Загружаем ключи
  Тип: Внешняя
*******************************************************************************}
procedure Load_key2;
begin
  Vrb.Load_key;
end;

{******************************************************************************
   Описание: Шифрование произвольное с выбором получателя
   Тип: Внешняя
*******************************************************************************}
procedure EnCrypt2;
begin
  Vrb.EnCrypt;
end;
{*******************************************************************************
  Описание: Верба - Расшифровать и снять ЭЦП
*******************************************************************************}
procedure DeCrypt2(f: string);
begin
  vrb.DeCrypt(f);
end;

procedure GetPluginData(var plug_data:StrDataPlugin);
var
 inf:TIniFile;
begin
  inf:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Plugins\Verba\Verba.ini');
  plug_data.Name:=inf.ReadString('Settings_General','Name','');
  plug_data.Comment:=inf.ReadString('Settings_General','Comment','');

  plug_data.Debet:='';
  plug_data.Text:='';
  plug_data.FTP_PATH_IN:='';
  plug_data.FTP_PATH_OUT:='';
  plug_data.Flt:='';
  inf.Free;
end;

// пункты добавлять в меню Плагины
// menu 1   menu 2

procedure GetPluginProc(var Spis_proc:type_ExportProc);
begin
 SetLength(Spis_proc,1);
 Spis_proc[0].Name:='Load_key2';
 Spis_proc[0].Menu:='Верба - Загрузить ключи';
 SetLength(Spis_proc,2);
 Spis_proc[1].Name:='EnCrypt2';
 Spis_proc[1].Menu:='Верба - Наложить ЭЦП и зашифровать';
 SetLength(Spis_proc,3);
 Spis_proc[2].Name:='DeCrypt2(f: string)';
 Spis_proc[2].Menu:='Верба - Расшифровать и снять ЭЦП';
end;



exports GetPluginData,GetPluginProc,Load_key2,EnCrypt2,DeCrypt2;

{ ======================= =====================================================}
var
 inf:TIniFile;

begin
  inf:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Plugins\Verba\Verba.ini');
  bank                  :=inf.ReadInteger('Settings_Plugin','bank',0);//NUM_KEY
  Pub                   :=inf.ReadString('Settings_Plugin','Pub','');
  sec                   :=inf.ReadString('Settings_Plugin','sec','');
  txt_verba_o_dll       :=inf.ReadString('Settings_Plugin','txt_verba_o_dll','');
  Seria                 :=inf.ReadString('Settings_Plugin','Seria','');
  Abonents_list         :=inf.ReadString('Settings_Plugin','Abonents_list','');
  key_dev               :=inf.ReadString('Settings_Plugin','key_dev','');

  inf.Free;

  vrb:=TVerba.Create;
  form_info.info:= Tinfo.Create(nil);

end.

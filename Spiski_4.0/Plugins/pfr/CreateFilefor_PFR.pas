{************************************************************}
{                                                            }
{       ������ ��� ����������� ������ ������� ��� ���        }
{       Copyright (�) 2010 ����                              }
{               �����/������                                 }
{                                                            }
{  �����������: ������ �.�.                                  }
{  �������������: 15 ���� 2011                               }
{                                                            }
{************************************************************}

unit CreateFilefor_PFR;
interface
uses
  SysUtils,Dialogs;

procedure CreateFileAnswerPFR(file1:string);

implementation
uses Main, Tools;
{ ***************************************************************************
  ������������ ��������� ����� (������ ��� ������)
 ****************************************************************************}
procedure CreateFileAnswerPFR(file1:string);
var
s1,s2,s3,s4,data1,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19:string;
n1:integer;
f1:textfile;
sss2,s_dir,stroka:string;
begin
s1:=file1;
s1[length(s1)-2]:='d';
s_dir:=ExtractFileDir(s1)+'\������\';
if not DirectoryExists(s_dir) then CreateDir(s_dir);

  AssignFile(f1,s_dir+ExtractFileName(s1));
  Rewrite(f1);
  //  s2:='����/0'+Mainform.lv2.items[0].SubItems[0]; ������
  s3:=Mainform.lv2.Items[0].SubItems[0]; WHILE Length(s3)<7 DO s3:='0'+s3; //���������
  s4:=Mainform.lv2.Items[0].SubItems[1]; while pos('.',s4)>0 do delete(s4,pos('.',s4),1);while pos(' ',s4)>0 do delete(s4,pos(' ',s4),1);while Length(s4)<15 do s4:='0'+s4;// �����
  data1:=FormatDateTime('DDMMYY',Mainform.dtp1.date);
  sss2:=data1;
  stroka:=MainForm.PREFIX+s3+s4+data1;

  WriteLn(f1,WinToDos(stroka));
  CloseFile(f1);

if Length(stroka)<38 then MessageDlg('���� ������� ������� ����� ����������� !!!', mtError,[mbOk], 0);
//if MainForm.verba=1 then vrb.EnCryptAnswer(s_dir+ExtractFileName(s1));
{--------------------SECOND_FILE---------}
s1:=MainForm.OpenDialog1.FileName;
s1[length(s1)-2]:='f';

  AssignFile(f1,s_dir+ExtractFileName(s1));
  Rewrite(f1);
  FOR n1:=0 TO Mainform.lv1.items.count-1 DO IF Mainform.lv1.items[n1].ImageIndex=3 THEN BEGIN
          {------------------------------}
          s2:='        '; ////��������� ���������� � ������� A8
          s3:='����0';
          s4:=Mainform.lv1.Items[n1].SubItems[1]; ////����� ������� A5
          s5:=Mainform.lv1.Items[n1].SubItems[2]; WHILE Length(s5)<19 DO s5:=' '+s5; ////�������� A19
          s6:=Mainform.lv1.Items[n1].SubItems[3]; WHILE Length(s6)<30 DO s6:=s6+' '; ////� A30
          s7:=Mainform.lv1.Items[n1].SubItems[4]; WHILE Length(s7)<30 DO s7:=s7+' '; ////� A30
          s8:=Mainform.lv1.Items[n1].SubItems[5]; WHILE Length(s8)<30 DO s8:=s8+' '; ////� A30
          s9:=Mainform.lv1.Items[n1].SubItems[6]; WHILE Length(s9)<25 DO s9:=s9+' '; ////���� A25
          s10:=Mainform.lv1.Items[n1].SubItems[7]; WHILE POS('.',s10)>1 DO delete(s10,pos('.',s10),1); WHILE POS(',',s10)>1 DO delete(s10,pos(',',s10),1);  WHILE Length(s10)<11 DO s10:=' '+s10; ////����� A11
          s11:='          0';
          s12:='          0';
          s13:='          0';
          s14:='          0';
          s15:='          0';
          s16:=Mainform.lv1.Items[n1].SubItems[13]; WHILE POS('.',s16)>1 DO delete(s16,pos('.',s16),1); WHILE POS('.',s16)>1 DO delete(s16,pos('.',s16),1);  WHILE Length(s16)<11 DO s16:=' '+s16; ////����� A11
          s17:='   ';
          s18:=sss2;
          s19:='4';
          WriteLn(f1,WinToDos(s2+s3+s4+s5+s6+s7+s8+s9+s10+s11+s12+s13+s14+s15+s16+s17+s18+s19));
          {------------------------------}
          END;
CloseFile(f1);
// ���������� ���� ��� ��������
//if MainForm.verba=1 then vrb.EnCryptAnswer(s_dir+ExtractFileName(s1));
end;


end.

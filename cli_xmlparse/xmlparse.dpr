program xmlparse;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  SysUtils,
  StrUtils, // PosEx
  Windows;  // SetConsoleTitle

var
  InFile: TextFile;
  InString: String;
  OutFile: TextFile;
  OutString: String;

function ExtractSubString(SrcStr, FromStr, ToStr: String): String;
var
  RetStr: String;
  StrPos: Integer;
  StrEnd: Integer;
begin
  RetStr:='';
  StrPos:=Pos(FromStr, SrcStr);
  if StrPos <> 0 then begin
    StrEnd:=PosEx(ToStr, SrcStr, StrPos);
    RetStr:=Copy(SrcStr, StrPos, StrEnd-StrPos);
  end;
  Result:=RetStr;
end;

begin
  SetConsoleTitle(PChar(ExtractFileName(ParamStr(0))));
  if ParamStr(2) <> 'quite'
  then WriteLn('XmlParse by Yoti');

  if (ParamCount < 1) then begin
    if ParamStr(2) <> 'quite'
    then WriteLn('Error -1');
    Halt(1);
  end;
  if (FileExists(ParamStr(1)) = False) then begin
    if ParamStr(2) <> 'quite'
    then WriteLn('Error -2');
    Halt(2);
  end;

  AssignFile(InFile, ParamStr(1));
  Reset(InFile);
  ReadLn(InFile, InString);
  ReadLn(InFile, InString);
  CloseFile(InFile);

  OutString:='';
  OutString:=ExtractSubString(InString, 'http', '"');
  if OutString <> '' then begin
    if ParamStr(2) <> 'quite'
    then WriteLn('PKG: ' + OutString);
    AssignFile(OutFile, ChangeFileExt(ParamStr(1), '.PKL'));
    Rewrite(OutFile);
    Write(OutFile, OutString);
    CloseFile(OutFile);
  end;

  if ParamStr(2) <> 'quite'
  then WriteLn('Success!');
  Halt(0);
end.

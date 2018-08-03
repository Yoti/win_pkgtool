program myparser;

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

//function StrToByte(SrcStr: String): Byte;
//begin
//  Result:=StrToInt(Copy(SrcStr, 1, Length(SrcStr)-1));
//end;

function StrToChar(SrcStr: String): Char;
begin
  Result:=Chr(StrToInt(Copy(SrcStr, 2, Length(SrcStr)-1)));
end;

function ExtractSubString(SrcStr, FromStr, ToStr: String): String;
var
  RetStr: String;
  StrPos: Integer;
  StrEnd: Integer;
begin
  RetStr:='';
  StrPos:=Pos(FromStr, SrcStr);
  if StrPos <> 0 then begin
    if ToStr[1] = '\' then begin
      StrEnd:=PosEx(StrToChar(ToStr), SrcStr, StrPos);
      RetStr:=Copy(SrcStr, StrPos, StrEnd-StrPos);
    end else begin
      StrEnd:=PosEx(ToStr, SrcStr, StrPos);
      RetStr:=Copy(SrcStr, StrPos, StrEnd-StrPos+Length(ToStr));
    end;
  end;
  Result:=RetStr;
end;

begin
  SetConsoleTitle(PChar(ExtractFileName(ParamStr(0))));
  WriteLn('MyParser by Yoti');

  if (ParamCount <> 4) then begin
    WriteLn('Error -1');
    Halt(1);
  end;
  if (FileExists(ParamStr(1)) = False) then begin
    WriteLn('Error -2');
    Halt(2);
  end;

  AssignFile(InFile, ParamStr(1));
  Reset(InFile);
  ReadLn(InFile, InString);
  CloseFile(InFile);

  OutString:='';
  OutString:=ExtractSubString(InString, ParamStr(2), ParamStr(3));
  if OutString <> '' then begin
    WriteLn(OutString);

    AssignFile(OutFile, ChangeFileExt(ParamStr(1), ParamStr(4)));
      Rewrite(OutFile);
      Write(OutFile, OutString);
    CloseFile(OutFile);

    WriteLn('Success!');
    Halt(0);
  end;

  WriteLn('Error -3');
  Halt(3);
end.

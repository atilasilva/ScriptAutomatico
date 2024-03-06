unit LibAtualizaCliente;

interface

uses Classes, Inifiles;

const
  CAMINHOPADRAOATUALIZA = 'C:\Renal-Manager\Src';

type
  TConfiguracoesRenalManager = class
    class function GetPathDatabaseName(IDDatabaseName: string): string; overload;
    class function GetIP(IDDatabaseName: string): string; overload;
    class procedure GetDatabaseList(var IniSections: TStringList);
  end;

var
  IniRegLocal: TIniFile;

implementation

uses LibSAuto;

{ TConfiguracoesRenalManager }

class procedure TConfiguracoesRenalManager.GetDatabaseList(
  var IniSections: TStringList);
begin
  IniRegLocal.ReadSections(IniSections);
end;

class function TConfiguracoesRenalManager.GetIP(
  IDDatabaseName: string): string;
begin
  Result := IniRegLocal.ReadString(IDDatabaseName, 'Server', NO_STRING)
end;

class function TConfiguracoesRenalManager.GetPathDatabaseName(
  IDDatabaseName: string): string;
begin
  Result := IniRegLocal.ReadString(IDDatabaseName, 'Path', NO_STRING)
end;

initialization
  IniRegLocal := TIniFile.Create(CAMINHOPADRAOATUALIZA + '\Config.ini');

finalization
  IniRegLocal.Free

end.

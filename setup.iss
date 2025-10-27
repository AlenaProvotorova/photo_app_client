[Setup]
; Номе приложения и версия
AppName=Photo App
AppVersion=1.0.0
AppPublisher=Photo App
AppPublisherURL=https://github.com
DefaultDirName={pf}\PhotoApp
DefaultGroupName=Photo App
OutputBaseFilename=PhotoApp_Setup
Compression=lzma
SolidCompression=yes
SetupIconFile=
PrivilegesRequired=admin

[Languages]
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: checkedonce
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
; Копируем все файлы включая подпапки
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\Photo App"; Filename: "{app}\runner.exe"
Name: "{group}\{cm:UninstallProgram,Photo App}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\Photo App"; Filename: "{app}\runner.exe"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\Photo App"; Filename: "{app}\runner.exe"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\runner.exe"; Description: "{cm:LaunchProgram,Photo App}"; Flags: nowait postinstall skipifsilent

[Code]
function InitializeSetup(): Boolean;
begin
  Result := True;
end;


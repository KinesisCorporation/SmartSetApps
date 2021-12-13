program player;

uses
  Forms,
  uMain in 'umain.pas' {fMain},
  uPlaylist in 'uplaylist.pas' {fPlaylist},
  uvis in 'uvis.pas' {fVizu};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfMain, fMain);
  Application.CreateForm(TfPlaylist, fPlaylist);
  Application.CreateForm(TfVizu, fVizu);
  Application.Run;
end.

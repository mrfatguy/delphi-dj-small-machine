program DJSmallMachineME;

uses
  Forms,
  frmMyInputDialog in 'frmMyInputDialog.pas' {InputDialogForm},
  MPGTools in 'MPGTools.pas',
  pasProcs in 'pasProcs.pas',
  frmMainForm in 'frmMainForm.pas' {MainForm},
  frmInfo in 'frmInfo.pas' {InfoForm},
  frmEndMarker in 'frmEndMarker.pas' {MarkerForm},
  frmScreenS in 'frmScreenS.pas' {ScreenForm},
  frmAutoModeSettings in 'frmAutoModeSettings.pas' {AutoModeSettingsForm},
  frmMove in 'frmMove.pas' {MoveForm};



begin
  Application.Initialize;
  Application.Title := 'DJ''s Small Machine ME';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TInputDialogForm, InputDialogForm);
  Application.CreateForm(TInfoForm, InfoForm);
  Application.CreateForm(TMarkerForm, MarkerForm);
  Application.CreateForm(TScreenForm, ScreenForm);
  Application.CreateForm(TAutoModeSettingsForm, AutoModeSettingsForm);
  Application.CreateForm(TMoveForm, MoveForm);
  Application.Run;
end.

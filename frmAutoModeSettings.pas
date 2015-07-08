unit frmAutoModeSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, Buttons, ExtCtrls, RogerColorComboBox;

type
  TAutoModeSettingsForm = class(TForm)
    Label1: TLabel;
    gbStartPosition: TGroupBox;
    rvspStartPosition: TSpinEdit;
    Label2: TLabel;
    btnFirstSong: TButton;
    btnActualSong: TButton;
    btnRandomSong: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    gbSongs: TGroupBox;
    chbShowCurrent: TCheckBox;
    chbShowNext: TCheckBox;
    rgPassThrough: TRadioGroup;
    gbClocks: TGroupBox;
    chbShowPartyClock: TCheckBox;
    chbShowMidnightClock: TCheckBox;
    rgMidnightClockMode: TRadioGroup;
    Label3: TLabel;
    chbRunSSAlso: TCheckBox;
    gbColors: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    rccbTitles: TRogerColorComboBox;
    rccbBackground: TRogerColorComboBox;
    rccbTexts: TRogerColorComboBox;
    procedure btnFirstSongClick(Sender: TObject);
    procedure btnActualSongClick(Sender: TObject);
    procedure btnRandomSongClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoModeSettingsForm: TAutoModeSettingsForm;

implementation

{$R *.DFM}

procedure TAutoModeSettingsForm.btnFirstSongClick(Sender: TObject);
begin
        rvspStartPosition.Value:=1;
end;

procedure TAutoModeSettingsForm.btnActualSongClick(Sender: TObject);
begin
        rvspStartPosition.Value:=btnActualSong.Tag;
end;

procedure TAutoModeSettingsForm.btnRandomSongClick(Sender: TObject);
begin
        rvspStartPosition.Value:=Random(btnRandomSong.Tag-1)+1;
end;

procedure TAutoModeSettingsForm.FormShow(Sender: TObject);
begin
        Randomize;
end;

end.

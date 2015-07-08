unit frmScreenS;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TScreenForm = class(TForm)
    sep1: TLabel;
    lbl2: TLabel;
    lbl4: TLabel;
    lbl3: TLabel;
    lbl1: TLabel;
    pnlBottomContainter: TPanel;
    pnlRightContainer: TPanel;
    lblPartyTitle: TLabel;
    lblPartyCount: TLabel;
    pnlLeftContainer: TPanel;
    lblMidnightTitle: TLabel;
    lblMidnightCount: TLabel;
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ScreenForm: TScreenForm;

implementation

{$R *.DFM}

uses frmMainForm, frmAutoModeSettings;

procedure TScreenForm.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if Key=VK_ESCAPE then
        begin
                Screen.Cursor:=crDefault;
                ScreenSaverIsOn:=False;
                SystemParametersInfo(SPI_SETSCREENSAVEACTIVE,1,nil,0);
                Hide;
        end;
end;

procedure TScreenForm.FormCreate(Sender: TObject);
begin
        ScreenForm.DoubleBuffered:=True;
end;

procedure TScreenForm.FormShow(Sender: TObject);
begin
        pnlLeftContainer.Width:=(Screen.Width div 2);
        pnlRightContainer.Width:=(Screen.Width div 2);
        pnlRightContainer.Left:=pnlLeftContainer.Width;

        lbl2.Visible:=AutoModeSettingsForm.chbShowCurrent.Checked;
        lbl1.Visible:=AutoModeSettingsForm.chbShowCurrent.Checked;
        lbl3.Visible:=AutoModeSettingsForm.chbShowNext.Checked;
        lbl4.Visible:=AutoModeSettingsForm.chbShowNext.Checked;

        pnlLeftContainer.Visible:=AutoModeSettingsForm.chbShowMidnightClock.Checked;
        pnlRightContainer.Visible:=AutoModeSettingsForm.chbShowPartyClock.Checked;

        lbl1.Font.Color:=AutoModeSettingsForm.rccbTitles.ColorValue;
        lbl3.Font.Color:=AutoModeSettingsForm.rccbTitles.ColorValue;
        lblMidnightTitle.Font.Color:=AutoModeSettingsForm.rccbTitles.ColorValue;
        lblPartyTitle.Font.Color:=AutoModeSettingsForm.rccbTitles.ColorValue;

        lbl2.Font.Color:=AutoModeSettingsForm.rccbTexts.ColorValue;
        lbl4.Font.Color:=AutoModeSettingsForm.rccbTexts.ColorValue;
        lblMidnightCount.Font.Color:=AutoModeSettingsForm.rccbTexts.ColorValue;
        lblPartyCount.Font.Color:=AutoModeSettingsForm.rccbTexts.ColorValue;

        ScreenForm.Color:=AutoModeSettingsForm.rccbBackground.ColorValue;
        pnlLeftContainer.Color:=AutoModeSettingsForm.rccbBackground.ColorValue;
        pnlRightContainer.Color:=AutoModeSettingsForm.rccbBackground.ColorValue;
end;

end.

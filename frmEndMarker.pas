unit frmEndMarker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Spin, ExtCtrls;

type
  TMarkerForm = class(TForm)
    Label1: TLabel;
    eValue: TSpinEdit;
    GroupBox1: TGroupBox;
    rbSelected: TRadioButton;
    rbAll: TRadioButton;
    btnOK: TButton;
    btnCancel: TButton;
    Label2: TLabel;
    pnlOK: TPanel;
    procedure eValueKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MarkerForm: TMarkerForm;

implementation

{$R *.DFM}

procedure TMarkerForm.eValueKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
        if eValue.Value>eValue.MaxValue then eValue.Value:=eValue.MaxValue;
        if Key=VK_ESCAPE then btnCancelClick(self);
        if Key=VK_RETURN then btnOKClick(self);
end;

procedure TMarkerForm.btnOKClick(Sender: TObject);
begin
        pnlOK.Caption:='OK';
        Close;
end;

procedure TMarkerForm.btnCancelClick(Sender: TObject);
begin
        pnlOK.Caption:='Cancel';
        Close;
end;

end.

unit frmMove;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Spin;

type
  TMoveForm = class(TForm)
    Label1: TLabel;
    lblSongNum: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    gbMove: TRadioGroup;
    lblPosText: TLabel;
    rvspPosition: TSpinEdit;
    procedure gbMoveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MoveForm: TMoveForm;

implementation

{$R *.DFM}

procedure TMoveForm.gbMoveClick(Sender: TObject);
begin
        if gbMove.ItemIndex<2 then
        begin
                rvspPosition.Enabled:=False;
                lblPosText.Enabled:=False;
        end
        else
        begin
                rvspPosition.Enabled:=True;
                lblPosText.Enabled:=True;
        end;
end;

end.

object MarkerForm: TMarkerForm
  Left = 192
  Top = 103
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Passage point'
  ClientHeight = 150
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 64
    Width = 113
    Height = 13
    Alignment = taRightJustify
    AutoSize = False
    Caption = 'New value:'
  end
  object Label2: TLabel
    Left = 8
    Top = 4
    Width = 241
    Height = 53
    AutoSize = False
    Caption = 
      'Set "passage point", that is -- a point in song (in seconds, cou' +
      'tnig back from the end), after reaching which next song will sta' +
      'rt to play automatically and current song will be slowly silence' +
      'd.'
    WordWrap = True
  end
  object eValue: TSpinEdit
    Left = 124
    Top = 60
    Width = 114
    Height = 22
    MaxLength = 2
    MaxValue = 21
    MinValue = 1
    TabOrder = 0
    Value = 1
    OnKeyUp = eValueKeyUp
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 88
    Width = 230
    Height = 57
    Caption = 'Set for:'
    TabOrder = 1
    object rbSelected: TRadioButton
      Left = 8
      Top = 32
      Width = 113
      Height = 17
      Caption = 'current song'
      TabOrder = 0
    end
    object rbAll: TRadioButton
      Left = 8
      Top = 16
      Width = 217
      Height = 17
      Caption = 'all songs on the list'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
  end
  object btnOK: TButton
    Left = 254
    Top = 4
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 254
    Top = 32
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object pnlOK: TPanel
    Left = 256
    Top = 64
    Width = 20
    Height = 20
    Caption = 'OK'
    TabOrder = 4
    Visible = False
  end
end

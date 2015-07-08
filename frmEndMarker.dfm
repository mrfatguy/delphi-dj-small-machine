object MarkerForm: TMarkerForm
  Left = 192
  Top = 103
  BorderIcons = []
  BorderStyle = bsDialog
  Caption = 'Punkt przejœcia'
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
    Caption = 'Nowa wartoœæ:'
  end
  object Label2: TLabel
    Left = 8
    Top = 4
    Width = 241
    Height = 53
    AutoSize = False
    Caption = 
      'Okreœl "punkt przejœcia" - czyli miejsce (w sekun- dach, licz¹c ' +
      'od koñca utworu), bo osi¹gniêciu któ- rego, rozpocznie siê autom' +
      'atyczne odtwarzanie na- stêpnego utworu oraz wyciszanie obecnego' +
      '.'
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
    Caption = 'Zastosuj dla:'
    TabOrder = 1
    object rbSelected: TRadioButton
      Left = 8
      Top = 32
      Width = 113
      Height = 17
      Caption = 'wybranej pozycji'
      TabOrder = 0
    end
    object rbAll: TRadioButton
      Left = 8
      Top = 16
      Width = 217
      Height = 17
      Caption = 'wszystkich utworów na liœcie'
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
    Caption = 'Anuluj'
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

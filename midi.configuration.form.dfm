object MIDIConfigurationForm: TMIDIConfigurationForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'MIDI Configuration'
  ClientHeight = 427
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 74
    Height = 13
    Caption = 'Output Devices'
  end
  object Label2: TLabel
    Left = 8
    Top = 200
    Width = 66
    Height = 13
    Caption = 'Input Devices'
  end
  object OutputDeviceList: TListBox
    Left = 8
    Top = 27
    Width = 369
    Height = 158
    ItemHeight = 13
    TabOrder = 0
  end
  object InputDeviceList: TListBox
    Left = 8
    Top = 219
    Width = 369
    Height = 158
    ItemHeight = 13
    TabOrder = 1
  end
  object OKBtn: TButton
    Left = 8
    Top = 391
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 2
    OnClick = OKBtnClick
  end
  object CancelBtn: TButton
    Left = 89
    Top = 391
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 3
  end
end

object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MIDI Tool'
  ClientHeight = 296
  ClientWidth = 492
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    492
    296)
  PixelsPerInch = 96
  TextHeight = 13
  object InputDeviceLabel: TLabel
    Left = 8
    Top = 44
    Width = 100
    Height = 13
    Caption = 'No device connected'
  end
  object OutputDeviceLabel: TLabel
    Left = 264
    Top = 44
    Width = 100
    Height = 13
    Caption = 'No device connected'
  end
  object MIDIButton: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'MIDI...'
    TabOrder = 0
    OnClick = MIDIButtonClick
  end
  object StatusBox: TListBox
    Left = 8
    Top = 63
    Width = 473
    Height = 194
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Lucida Console'
    Font.Style = []
    ItemHeight = 13
    ParentFont = False
    TabOrder = 1
  end
  object StatusEdit: TEdit
    Left = 8
    Top = 263
    Width = 41
    Height = 21
    TabOrder = 2
    Text = '0x90'
  end
  object Param1Edit: TEdit
    Left = 55
    Top = 263
    Width = 41
    Height = 21
    TabOrder = 3
    Text = '0'
  end
  object Param2Edit: TEdit
    Left = 102
    Top = 263
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '0'
  end
  object Send: TButton
    Left = 149
    Top = 263
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 5
    OnClick = SendClick
  end
  object InputMessageTick: TTimer
    Interval = 30
    OnTimer = OnInputTick
    Left = 264
    Top = 88
  end
end

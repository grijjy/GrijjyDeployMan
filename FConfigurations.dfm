object FormConfigurations: TFormConfigurations
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsNone
  ClientHeight = 132
  ClientWidth = 147
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PopupMode = pmExplicit
  PixelsPerInch = 96
  TextHeight = 13
  object PanelContainer: TPanel
    Left = 0
    Top = 0
    Width = 147
    Height = 132
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsSingle
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
    ExplicitWidth = 174
    object ToolBar: TToolBar
      Left = 0
      Top = 0
      Width = 145
      Height = 19
      AutoSize = True
      ButtonHeight = 19
      ButtonWidth = 38
      Caption = 'ToolBar'
      List = True
      ShowCaptions = True
      TabOrder = 0
      ExplicitTop = -1
      ExplicitWidth = 172
      object ToolButtonClose: TToolButton
        Left = 0
        Top = 0
        Caption = 'Close'
        ImageIndex = 2
        OnClick = ToolButtonCloseClick
      end
      object ToolButton1: TToolButton
        Left = 38
        Top = 0
        Width = 8
        Caption = 'ToolButton1'
        ImageIndex = 2
        Style = tbsSeparator
      end
      object ToolButtonAll: TToolButton
        Left = 46
        Top = 0
        Caption = 'All'
        ImageIndex = 0
        OnClick = ToolButtonAllClick
      end
      object ToolButtonNone: TToolButton
        Left = 84
        Top = 0
        Caption = 'None'
        ImageIndex = 1
        OnClick = ToolButtonNoneClick
      end
    end
    object ListConfigurations: TCheckListBox
      Left = 0
      Top = 19
      Width = 145
      Height = 111
      Align = alClient
      BorderStyle = bsNone
      ItemHeight = 13
      TabOrder = 1
    end
  end
end

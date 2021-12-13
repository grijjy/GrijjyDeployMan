object ViewMain: TViewMain
  Left = 0
  Top = 0
  Caption = 'Grijjy Deployment Manager'
  ClientHeight = 624
  ClientWidth = 781
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object TabControl: TTabControl
    Left = 0
    Top = 0
    Width = 781
    Height = 605
    Align = alClient
    TabOrder = 0
    Tabs.Strings = (
      'iOS'
      'Android'
      'MacOS')
    TabIndex = 0
    OnChange = TabControlChange
    object ListViewEntries: TListView
      Left = 4
      Top = 46
      Width = 773
      Height = 555
      Align = alClient
      Columns = <
        item
          Caption = 'Source Path'
          Width = 200
        end
        item
          Caption = 'Target Directory'
          Width = 200
        end
        item
          Caption = 'SubDirs?'
          Width = 75
        end
        item
          AutoSize = True
          Caption = 'Configurations'
        end>
      ColumnClick = False
      MultiSelect = True
      ReadOnly = True
      RowSelect = True
      PopupMenu = PopupMenuList
      SmallImages = ImageList
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = ListViewEntriesClick
    end
    object PanelTools: TPanel
      Left = 4
      Top = 24
      Width = 773
      Height = 22
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object LabelTargetDir: TLabel
        Left = 230
        Top = 0
        Width = 83
        Height = 13
        Align = alLeft
        Caption = 'Target Directory:'
        Layout = tlCenter
      end
      object ToolBar: TToolBar
        Left = 0
        Top = 0
        Width = 230
        Height = 22
        Align = alLeft
        AutoSize = True
        ButtonWidth = 79
        Images = ImageList
        List = True
        ShowCaptions = True
        TabOrder = 0
        Transparent = True
        object ButtonAddFile: TToolButton
          Left = 0
          Top = 0
          Action = ActionAddFile
          AutoSize = True
        end
        object ButtonAddFolder: TToolButton
          Left = 69
          Top = 0
          Action = ActionAddFolder
          AutoSize = True
        end
        object ToolButton1: TToolButton
          Left = 152
          Top = 0
          Width = 8
          Caption = 'ToolButton1'
          ImageIndex = 7
          Style = tbsSeparator
        end
        object ButtonDelete: TToolButton
          Left = 160
          Top = 0
          Action = ActionDelete
          AutoSize = True
        end
        object ToolButton2: TToolButton
          Left = 222
          Top = 0
          Width = 8
          Caption = 'ToolButton2'
          ImageIndex = 7
          Style = tbsSeparator
        end
      end
      object ComboBoxTargetDir: TComboBox
        AlignWithMargins = True
        Left = 316
        Top = 0
        Width = 200
        Height = 21
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        TabOrder = 1
        OnChange = ComboBoxTargetDirChange
      end
      object CheckBoxSubDirs: TCheckBox
        AlignWithMargins = True
        Left = 522
        Top = 0
        Width = 141
        Height = 22
        Margins.Top = 0
        Margins.Bottom = 0
        Align = alLeft
        Caption = 'Include subdirectories?'
        TabOrder = 2
        OnClick = CheckBoxSubDirsClick
      end
      object ToolBarConfigurations: TToolBar
        Left = 666
        Top = 0
        Width = 101
        Height = 22
        Align = alLeft
        AutoSize = True
        ButtonWidth = 97
        Caption = 'ToolBarConfigurations'
        Images = ImageList
        List = True
        ShowCaptions = True
        TabOrder = 3
        object ButtonConfigurations: TToolButton
          Left = 0
          Top = 0
          AutoSize = True
          Caption = 'Configurations'
          ImageIndex = 7
          OnClick = ButtonConfigurationsClick
        end
      end
    end
  end
  object StatusBar: TStatusBar
    Left = 0
    Top = 605
    Width = 781
    Height = 19
    Panels = <>
  end
  object MainMenu: TMainMenu
    Images = ImageList
    Left = 288
    Top = 132
    object MenuFile: TMenuItem
      Caption = '&File'
      object MenuOpen: TMenuItem
        Action = ActionOpen
      end
      object MenuSave: TMenuItem
        Action = ActionSave
      end
      object MenuImport: TMenuItem
        Action = ActionImport
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object MenuExit: TMenuItem
        Action = ActionExit
      end
    end
  end
  object OpenDialogDproj: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Delphi Project Files'
        FileMask = '*.dproj'
      end>
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Open .dproj file'
    Left = 376
    Top = 132
  end
  object OpenDialogGrdeploy: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'Grijjy DeployMan files'
        FileMask = '*.grdeploy'
      end>
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Open .grdeploy file'
    Left = 476
    Top = 132
  end
  object ImageList: TImageList
    ColorDepth = cd32Bit
    Left = 580
    Top = 132
    Bitmap = {
      494C010108004C00040010001000FFFFFFFF2110FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000003000000001002000000000000030
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FF0000000000000000000C114D068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF000C114D000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000669821FFEFEFEFFF0000
      0000000000000000000000000000000000000000000000000000C2A6A4FFFEFC
      FBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFC
      FBFFFEFCFBFFC2A6A4FF0000000000000000068DBEFF62CBF8FF068DBEFFA3E1
      FBFF65CDF9FF64CDF8FF64CDF9FF64CDF9FF64CDF8FF64CDF9FF64CDF8FF65CD
      F8FF39ADD8FFACE7F5FF068DBEFF000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000010031769AF0631E0FF000000000000000000000000000000000000
      00000000000000000000000000000000000065991DFF65991DFF65991DFF0000
      0000000000000000000000000000000000000000000000000000C2A6A4FFFEFC
      FBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFC
      FBFFFEFCFBFFC2A6A4FF0000000000000000068DBEFF69D1F9FF068DBEFFA8E5
      FCFF6ED4FAFF6ED4F9FF6DD4FAFF6ED4F9FF6ED4FAFF6ED4FAFF6ED4FAFF6DD4
      F9FF3DB1D9FFB1EAF5FF068DBEFF0000000000000000042192CF062BC3EF0001
      0730000000000000000000000000000000000000000000000000000000000000
      0010042195CF0631E2FF0213579F00000000666666FF666666FF666666FF6666
      66FF676767FFA5A5A5FF0000000065991DFF65991DFF65991DFF65991DFF6599
      1DFF00000000BEBEBEFF686868FF000000000000000000000000C2A6A4FFFEFB
      F7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFB
      F7FFFEFBF7FFC2A6A4FF0000000000000000068DBEFF71D6FAFF068DBEFFAEEA
      FCFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF79DCFBFF78DCFAFF78DC
      FAFF43B5D9FFB6EEF6FF068DBEFF0000000000000000042192CF0631DEFF062B
      C3EF01071F600000000000000000000000000000000000000000000108300421
      97CF0532E4FF0213589F0000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFFBABABAFF0000000065991DFF65991DFF65991DFF000000006A942EFF6599
      1DFF65991DFF00000000B8B8B8FF000000000000000000000000C2A6A4FFFEF9
      F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9
      F4FFFEF9F4FFC2A6A4FF0000000000000000068DBEFF78DDFBFF068DBEFFB5EE
      FDFF83E4FBFF84E4FBFF83E4FCFF83E4FCFF84E4FCFF83E4FCFF83E4FBFF84E5
      FCFF47B9DAFFBBF2F6FF068DBEFF000000000000000000000010031B7CBF0631
      E0FF0531E2FF0007206000000000000000000000000000010830052CCBEF0532
      E6FF0213589F000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFFBDBDBDFF0000000065991DFF65991DFF00000000D7D7D7FF000000006796
      26FF65991DFF65991DFF00000000000000000000000000000000C2A6A4FFFEF7
      F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7
      F0FFFEF7F0FFC2A6A4FF0000000000000000068DBEFF82E3FCFF068DBEFFBAF3
      FDFF8DEBFCFF8DEBFCFF8DEBFCFF8DEBFDFF8DEBFDFF8DEBFCFF8DEBFDFF8DEB
      FCFF4BBBDAFFBEF4F7FF068DBEFF00000000000000000000000000000000010F
      468F0532E4FF0532E6FF000720600000000000051750042CCCEF0532E8FF0007
      206000000000000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFF696969FFACACACFF00000000E5E5E5FFB8B8B8FF8D8D8DFFA1A1A1FF0000
      0000679722FF65991DFF65991DFF000000000000000000000000C2A6A4FFFEF5
      ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5
      ECFFFEF5ECFFC2A6A4FF0000000000000000068DBEFF8AEAFCFF068DBEFFFFFF
      FFFFC9F7FEFFC8F7FEFFC9F7FEFFC9F7FEFFC9F7FEFFC8F7FEFFC9F7FEFFC8F7
      FEFF9BD5E7FFDEF9FBFF068DBEFF000000000000000000000000000000000000
      000000072060052CCBEF0432EAFF01135C9F0432ECFF0432EAFF000720600000
      000000000000000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFF8D8D8DFF656565FF888888FF919191FF686868FF646464FFB5B5B5FFB9B9
      B9FF0000000065991FFF65991DFF669821FF0000000000000000C2A6A4FFFEF3
      E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3
      E9FFFEF3E9FFC2A6A4FF0000000000000000068DBEFF93F0FEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF000000000000000000000000000000000000
      000000000000000108300432EDFF0433EEFF0433EEFF00072160000000000000
      000000000000000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFF989898FF666666FF6C6C6CFF999999FF6C6C6CFF666666FF919191FFFDFD
      FDFFBABABAFF0000000065991DFFE8E8E8FF0000000000000000C2A6A4FFFFF1
      E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1
      E5FFFFF1E5FFC2A6A4FF0000000000000000068DBEFF9BF5FEFF9AF6FEFF9AF6
      FEFF9BF5FDFF9BF6FEFF9AF6FEFF9BF5FEFF9AF6FDFF9BF5FEFF9AF6FEFF9AF6
      FEFF0889BAFF0000000000000000000000000000000000000000000000000000
      00000000000001135E9F0433F0FF0433F0FF0333F2FF01135F9F000000000000
      000000000000000000000000000000000000676767FFFEFEFEFFFFFFFFFF6262
      62FF636363FF636363FF989898FFFFFFFFFF989898FF636363FF636363FF6262
      62FFFCFCFCFFBABABAFF00000000000000000000000000000000C2A6A4FFFFF0
      E2FFFFF0E2FFFFF0E2FFFFF0E2FFFFF0E2FFFFF0E2FFDDCFC2FFDDCFC2FFDDCF
      C2FFDDCFC2FFC2A6A4FF0000000000000000068DBEFFFEFEFEFFA0FBFFFFA0FB
      FEFFA0FBFEFFA1FAFEFFA1FBFEFFA0FAFEFFA1FBFEFFA1FBFFFFA0FBFFFFA1FB
      FFFF0889BAFF0000000000000000000000000000000000000000000000000000
      001001135F9F0333F2FF0433F0FF0007216001104D8F0333F6FF0114609F0000
      000000000000000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFF939393FF646464FF6B6B6BFF989898FF6B6B6BFF646464FFA1A1A1FFFFFF
      FFFFFFFFFFFFFEFEFEFF717171FF000000000000000000000000C2A6A4FFFFEE
      DEFFFFEEDEFFFFEEDEFFFFEEDEFFFFEEDEFFFFEEDEFFC5B5A9FFC3B4A8FFC2B3
      A7FFC1B2A6FFC2A6A4FF0000000000000000000C114D068DBEFFFEFEFEFFA5FE
      FFFFA5FEFFFFA5FEFFFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF000C114D0000000000000000000000000000000000000000000000100221
      A2CF0333F4FF032DD4EF00072260000000000000000000051850022EDBEF011D
      8DBF00000110000000000000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFFBABABAFF646464FF646464FF636363FF646464FF646464FF8D8D8DFFFFFF
      FFFFFFFFFFFFFFFFFFFF676767FF000000000000000000000000C2A6A4FFFFEC
      DAFFFFECDAFFFFECDAFFFFECDAFFFFECDAFFFFECDAFFB0A296FFB0A296FFB0A2
      96FFB0A296FFC2A6A4FF000000000000000000000000000C114D068DBEFF068D
      BEFF068DBEFF068DBEFF00000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000003200122A3CF0334
      F6FF032DD6EF0001083000000000000000000000000000000000000108300122
      A5CF0122A5CF000001100000000000000000676767FFFEFEFEFFFFFFFFFFFFFF
      FFFF686868FF8C8C8CFFA4A4A4FF636363FF989898FFB9B9B9FF676767FFFFFF
      FFFFFFFFFFFFFFFFFFFF676767FF000000000000000000000000C2A6A4FFFFEA
      D7FFFFEAD7FFFFEAD7FFFFEAD7FFFFEAD7FFC9B9ACFFFBF8F4FFFBF8F4FFE6DA
      D9FFC2A6A4FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000022EDBEF0234F8FF032E
      D8EF000108300000000000000000000000000000000000000000000000000000
      0110011876AF010D3F800000000000000000676767FFFDFDFDFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFF676767FF000000000000000000000000C2A6A4FFFFE8
      D3FFFFE8D3FFFFE8D3FFFFE8D3FFFFE8D3FFC9B9ACFFFBF8F4FFDFCEC7FFC2A6
      A4FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000022EDBEF022ED9EF0001
      0830000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B2763CFFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFB3763CFF000000000000000000000000C2A6A4FFFFE6
      D0FFFFE6D0FFFFE6D0FFFFE6D0FFFFE6D0FFC9B9ACFFDFCEC7FFC2A6A4FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B3763CFFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFB3763CFF000000000000000000000000C2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000AD7642FFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB3763CFFB376
      3CFFB3763CFFB3763CFFAD7641FF00000000000C114D068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FF0000000000000000000C114D068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF000C114D00000000068DBEFF24A1D1FF3DB2DFFF65CD
      F9FF65CDF9FF64CDF9FF64CDF9FF64CDF9FF64CDF8FF64CDF9FF64CDF8FF65CE
      F9FF38ADD8FF068DBEFF000C114D0000000000000000170A096697423EFF9742
      3EFFB59A9BFFB59A9BFFB59A9BFFB59A9BFFB59A9BFFB59A9BFFB59A9BFF932F
      2FFF97423EFF170A096600000000000000000000000000000000C2A6A4FFFEFC
      FBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFC
      FBFFFEFCFBFFC2A6A4FF0000000000000000068DBEFF62CBF8FF068DBEFFA3E1
      FBFF65CDF9FF64CDF8FF64CDF9FF64CDF9FF64CDF8FF64CDF9FF64CDF8FF65CD
      F8FF39ADD8FFACE7F5FF068DBEFF00000000068DBEFF4BBCE7FF1D9CCBFF6ED4
      FAFF6ED4FAFF6ED4F9FF6DD4FAFF6ED4F9FF6ED4FAFF6ED4FAFF6ED4FAFF6DD4
      F9FF3DB1D9FF84D7EBFF068DBEFF000000000000000097423EFFD66767FFC65F
      5FFFE5DEDFFF922829FF922829FFE4E7E7FFE0E3E6FFD9DFE0FFCCC9CCFF8F1F
      1EFFAF4545FF97423EFF00000000000000000000000000000000C2A6A4FFFEFC
      FBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFCFBFFFEFC
      FBFFFEFCFBFFC2A6A4FF0000000000000000068DBEFF69D1F9FF068DBEFFA8E5
      FCFF6ED4FAFF6ED4F9FF6DD4FAFF6ED4F9FF6ED4FAFF6ED4FAFF6ED4FAFF6DD4
      F9FF3DB1D9FFB1EAF5FF068DBEFF00000000068DBEFF71D6FAFF068DBEFF78DC
      FBFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF79DCFBFF78DCFAFF78DC
      FAFF43B5D9FFAEF1F9FF068DBEFF000000000000000097423EFFD06465FFC25E
      5EFFE9E2E2FF922829FF922829FFE2E1E3FFE2E6E8FFDDE2E4FFCFCCCFFF8F21
      21FFAD4545FF97423EFF00000000000000000000000000000000C2A6A4FFFEFB
      F7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFBF7FFFEFB
      F7FFFEFBF7FFC2A6A4FF0000000000000000068DBEFF71D6FAFF068DBEFFAEEA
      FCFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF78DCFBFF79DCFBFF78DCFAFF78DC
      FAFF43B5D9FFB6EEF6FF068DBEFF00000000068DBEFF78DDFBFF1799C7FF65CF
      EEFF83E4FBFF84E4FBFF83E4FCFF83E4FCFF84E4FCFF83E4FCFF83E4FBFF84E5
      FCFF47B9DAFFB3F4F9FF068DBEFF000C114D0000000097423EFFD06464FFC15C
      5CFFECE4E4FF922829FF922829FFDFDDDFFFE1E6E8FFE0E5E7FFD3D0D2FF8A1D
      1DFFAB4343FF97423EFF00000000000000000000000000000000C2A6A4FFFEF9
      F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9F4FFFEF9
      F4FFFEF9F4FFC2A6A4FF0000000000000000068DBEFF78DDFBFF068DBEFFB5EE
      FDFF83E4FBFF84E4FBFF83E4FCFF83E4FCFF84E4FCFF83E4FCFF83E4FBFF84E5
      FCFF47B9DAFFBBF2F6FF068DBEFF00000000068DBEFF82E3FCFF42B7DCFF3DB4
      D8FF8DEBFCFF8DEBFCFF8DEBFCFF8DEBFDFF8DEBFDFF8DEBFCFF59BDA2FF0D78
      18FF3EADB3FFB6F7F9FF6CCAE0FF068DBEFF0000000097423EFFD06464FFC15A
      5BFFEFE6E6FFEDE5E5FFE5DEDFFFE0DDDFFFDFE0E2FFE0E1E3FFD6D0D2FF9629
      29FFB24949FF97423EFF00000000000000000000000000000000C2A6A4FFFEF7
      F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7F0FFFEF7
      F0FFFEF7F0FFC2A6A4FF0000000000000000068DBEFF82E3FCFF068DBEFFBAF3
      FDFF8DEBFCFF8DEBFCFF8DEBFCFF8DEBFDFF8DEBFDFF8DEBFCFF8DEBFDFF8DEB
      FCFF4BBBDAFFBEF4F7FF068DBEFF00000000068DBEFF8AEAFCFF76DCF3FF1396
      C3FF93EFFDFF92F0FDFF93F0FDFF93F0FDFF93F0FEFF5CC0A2FF0D8016FF25AF
      3DFF0D7C25FFB2ECE8FFB7EFF5FF068DBEFF0000000097423EFFCD6162FFC85F
      5FFFC96666FFCC7171FFCA7170FFC66868FFC46363FFCC6C6BFFCA6566FFC55C
      5CFFCD6464FF97423EFF00000000000000000000000000000000C2A6A4FFFEF5
      ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5ECFFFEF5
      ECFFFEF5ECFFC2A6A4FF0000000000000000068DBEFF8AEAFCFF068DBEFFFFFF
      FFFFC9F7FEFFC8F7FEFFC9F7FEFFC9F7FEFFC9F7FEFFC8F7FEFFC9F7FEFFC8F7
      FEFF9BD5E7FFDEF9FBFF068DBEFF00000000068DBEFF93F0FEFF93F0FDFF1597
      C5FF068DBEFF068DBEFF068DBEFF068DBEFF058279FF0F821AFF36C255FF33C2
      51FF26AF3DFF077A2FFF068BB3FF068DBEFF0000000097423EFFB65452FFC27A
      77FFD39D9CFFD7A7A5FFD8A7A6FFD8A6A5FFD7A09FFFD5A09FFFD7A9A7FFD8AB
      ABFFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFEF3
      E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3E9FFFEF3
      E9FFFEF3E9FFC2A6A4FF0000000000000000068DBEFF93F0FEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF068DBEFF068DBEFF068DBEFF00000000068DBEFF9BF5FEFF9AF6FEFF9AF6
      FEFF9BF5FDFF9BF6FEFF9AF6FEFF62C3A2FF12841EFF42CC67FF40CD64FF3AC8
      5BFF33C352FF26B03EFF034A06CF000000100000000097423EFFCC6566FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFF1
      E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1E5FFFFF1
      E5FFFFF1E5FFC2A6A4FF0000000000000000068DBEFF9BF5FEFF9AF6FEFF9AF6
      FEFF9BF5FDFF9BF6FEFF9AF6FEFF9BF5FEFF9AF6FDFF9BF5FEFF9AF6FEFF9AF6
      FEFF0889BAFF000000000000000000000000068DBEFFFEFEFEFFA0FBFFFFA0FB
      FEFFA0FBFEFFA1FAFEFF6FD0B1FF047009FF12851EFF168A24FF3AC05AFF40CD
      65FF34BD52FF0F851BFF07750DFF034A06CF0000000097423EFFCC6566FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFF0
      E2FFFFF0E2FFFFF0E2FFFFF0E2FFFFF0E2FFFFF0E2FFDDCFC2FFDDCFC2FFDDCF
      C2FFDDCFC2FFC2A6A4FF0000000000000000068DBEFFFEFEFEFFA0FBFFFFA0FB
      FEFFA0FBFEFFA1FAFEFFA1FBFEFFA0FAFEFFA1FBFEFFA1FBFFFFA0FBFFFFA1FB
      FFFF0889BAFF000000000000000000000000000C114D068DBEFFFEFEFEFFA5FE
      FFFFA5FEFFFFA5FEFFFF068DBEFF068DBEFF068DBEFF057E63FF3ABE5BFF47D3
      6FFF2EB14AFF011C028000000000000000000000000097423EFFCC6566FFF9F9
      F9FFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFEE
      DEFFFFEEDEFFFFEEDEFFFFEEDEFFFFEEDEFFFFEEDEFFC5B5A9FFC3B4A8FFC2B3
      A7FFC1B2A6FFC2A6A4FF0000000000000000000C114D068DBEFFFEFEFEFFA5FE
      FFFFA5FEFFFFA5FEFFFF068DBEFF068DBEFF068DBEFF068DBEFF068DBEFF068D
      BEFF000C114D00000000000000000000000000000000000C114D068DBEFF068D
      BEFF068DBEFF068DBEFF000C114D0000000000000000011C02803FC263FF4ED9
      79FF1E9630FF0003003000000000000000000000000097423EFFCC6566FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFEC
      DAFFFFECDAFFFFECDAFFFFECDAFFFFECDAFFFFECDAFFB0A296FFB0A296FFB0A2
      96FFB0A296FFC2A6A4FF000000000000000000000000000C114D068DBEFF068D
      BEFF068DBEFF068DBEFF00000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000023F05BF52D97EFF4FD7
      7BFF075B0DDF0000000000000000000000000000000097423EFFCC6566FFF9F9
      F9FFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFCDCDCDFFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFEA
      D7FFFFEAD7FFFFEAD7FFFFEAD7FFFFEAD7FFC9B9ACFFFBF8F4FFFBF8F4FFE6DA
      D9FFC2A6A4FF0000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000070040239B38FF57E087FF1E94
      30FF000A00500000000000000000000000000000000097423EFFCC6566FFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9
      F9FFCC6566FF97423EFF00000000000000000000000000000000C2A6A4FFFFE8
      D3FFFFE8D3FFFFE8D3FFFFE8D3FFFFE8D3FFC9B9ACFFFBF8F4FFDFCEC7FFC2A6
      A4FF000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000030030011C0280148620FF4DD276FF239B38FF012B
      039F0000000000000000000000000000000000000000170A096697423EFFF9F9
      F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9F9FFF9F9
      F9FF97423EFF170A096600000000000000000000000000000000C2A6A4FFFFE6
      D0FFFFE6D0FFFFE6D0FFFFE6D0FFFFE6D0FFC9B9ACFFDFCEC7FFC2A6A4FF0000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000035607DF047009FF097711FF198D28FF034A06CF000A00500000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000C2A6A4FFC2A6
      A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FFC2A6A4FF000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000300000000100010000000000800100000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
  object ActionList: TActionList
    Images = ImageList
    Left = 208
    Top = 132
    object ActionOpen: TAction
      Category = 'File'
      Caption = 'Open Project...'
      ImageIndex = 0
      ShortCut = 16463
      OnExecute = ActionOpenExecute
    end
    object ActionSave: TAction
      Category = 'File'
      Caption = 'Save Project + .dproj'
      ImageIndex = 1
      ShortCut = 16467
      OnExecute = ActionSaveExecute
    end
    object ActionImport: TAction
      Category = 'File'
      Caption = 'Import .dproj file...'
      ShortCut = 16457
      OnExecute = ActionImportExecute
    end
    object ActionExit: TAction
      Category = 'File'
      Caption = 'Exit'
      ShortCut = 32883
      OnExecute = ActionExitExecute
    end
    object ActionAddFile: TAction
      Category = 'Entry'
      Caption = 'Add File'
      ImageIndex = 4
      OnExecute = ActionAddFileExecute
    end
    object ActionAddFolder: TAction
      Category = 'Entry'
      Caption = 'Add Folder'
      ImageIndex = 5
      OnExecute = ActionAddFolderExecute
    end
    object ActionDelete: TAction
      Category = 'Entry'
      Caption = 'Delete'
      ImageIndex = 6
      OnExecute = ActionDeleteExecute
    end
  end
  object PopupMenuList: TPopupMenu
    Images = ImageList
    Left = 132
    Top = 132
    object PopupMenuAddFile: TMenuItem
      Action = ActionAddFile
    end
    object PopupMenuAddFolder: TMenuItem
      Action = ActionAddFolder
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object PopupMenuDelete: TMenuItem
      Action = ActionDelete
    end
  end
  object OpenDialogFile: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <
      item
        DisplayName = 'All files'
        FileMask = '*.*'
      end>
    Options = [fdoPathMustExist, fdoFileMustExist]
    Title = 'Select file to add'
    Left = 668
    Top = 132
  end
end

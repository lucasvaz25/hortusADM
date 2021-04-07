inherited Frm_Consulta_Grupos: TFrm_Consulta_Grupos
  Caption = 'Frm_Consulta_Grupos'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  ExplicitTop = -76
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    inherited pnlRodape: TPanel
      inherited pnlNovo: TPanel
        ExplicitLeft = 93
      end
      inherited pnlAlterar: TPanel
        ExplicitLeft = 226
      end
      inherited pnlExcluir: TPanel
        ExplicitLeft = 361
      end
      inherited pnlSair: TPanel
        ExplicitLeft = 493
      end
    end
    inherited pnlCabecalho: TPanel
      ExplicitWidth = 703
    end
    inherited pnlGrid: TPanel
      ExplicitWidth = 703
      ExplicitHeight = 313
      inherited DBGrid1: TDBGrid
        DataSource = DsGrupos
        Columns = <
          item
            Expanded = False
            FieldName = 'codigo'
            Title.Alignment = taRightJustify
            Width = 50
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'grupo'
            Title.Alignment = taCenter
            Width = 400
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'datacad'
            Title.Alignment = taCenter
            Visible = True
          end>
      end
    end
  end
  object DsGrupos: TDataSource
    DataSet = TDset_Grupos
    Left = 400
    Top = 273
  end
  object TDset_Grupos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 504
    Top = 273
    object TDset_Gruposcodigo: TIntegerField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
    end
    object TDset_Gruposgrupo: TStringField
      Alignment = taCenter
      DisplayLabel = 'Grupo'
      DisplayWidth = 100
      FieldName = 'grupo'
      Size = 50
    end
    object TDset_Gruposdatacad: TDateTimeField
      Alignment = taCenter
      DisplayLabel = 'Data Cad.'
      FieldName = 'datacad'
    end
  end
end
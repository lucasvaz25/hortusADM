inherited Frm_Consulta_SubGrupos: TFrm_Consulta_SubGrupos
  Caption = 'Frm_Consulta_SubGrupos'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
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
        DataSource = DsSubGrupos
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
            FieldName = 'subgrupo'
            Title.Alignment = taCenter
            Width = 310
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'grupo'
            Title.Alignment = taCenter
            Width = 310
            Visible = True
          end>
      end
    end
  end
  object DsSubGrupos: TDataSource
    DataSet = TDset_SubGrupos
    Left = 168
    Top = 201
  end
  object TDset_SubGrupos: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 216
    Top = 201
    object TDset_SubGruposcodigo: TIntegerField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
    end
    object TDset_SubGrupossubgrupo: TStringField
      Alignment = taCenter
      DisplayLabel = 'SubGrupo'
      FieldName = 'subgrupo'
      Size = 50
    end
    object TDset_SubGruposgrupo: TStringField
      Alignment = taCenter
      DisplayLabel = 'Grupo'
      FieldName = 'grupo'
      Size = 50
    end
  end
end

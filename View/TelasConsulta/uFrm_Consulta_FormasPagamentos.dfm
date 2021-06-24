inherited Frm_Consulta_FormasPagamentos: TFrm_Consulta_FormasPagamentos
  Caption = 'Frm_Consulta_FormasPagamentos'
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  inherited pnlFundo: TPanel
    inherited pnlGrid: TPanel
      inherited DBGrid1: TDBGrid
        DataSource = DsFormaPgto
        OnDblClick = DBGrid1DblClick
        Columns = <
          item
            Expanded = False
            FieldName = 'codigo'
            Width = 36
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'formapgto'
            Width = 309
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'usercad'
            Width = 261
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'datacad'
            Visible = True
          end>
      end
    end
  end
  object DsFormaPgto: TDataSource
    DataSet = TDset_FormaPgto
    Left = 656
    Top = 289
  end
  object TDset_FormaPgto: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 576
    Top = 289
    object TDset_FormaPgtocodigo: TIntegerField
      DisplayLabel = 'C'#243'd.'
      FieldName = 'codigo'
    end
    object TDset_FormaPgtoformapgto: TStringField
      DisplayLabel = 'Forma Pgto.'
      DisplayWidth = 50
      FieldName = 'formapgto'
    end
    object TDset_FormaPgtodatacad: TDateField
      DisplayLabel = 'Data Cad.'
      FieldName = 'datacad'
    end
    object TDset_FormaPgtousercad: TStringField
      DisplayLabel = 'Usu'#225'rio Cad.'
      DisplayWidth = 40
      FieldName = 'usercad'
    end
  end
end

object DM: TDM
  OldCreateOrder = False
  Height = 316
  Width = 589
  object Conexao: TFDConnection
    Params.Strings = (
      'Database=C:\bd\PADRAO.FDB'
      'User_Name=SYSDBA'
      'Password=masterkey'
      'Port=3050'
      'DriverID=FB')
    Connected = True
    Left = 32
    Top = 16
  end
  object Trans: TFDTransaction
    Connection = Conexao
    Left = 72
    Top = 16
  end
  object QryPaises: TFDQuery
    Connection = Conexao
    Transaction = Trans
    SQL.Strings = (
      '')
    Left = 112
    Top = 16
  end
  object QryEstados: TFDQuery
    Connection = Conexao
    Transaction = Trans
    Left = 160
    Top = 16
  end
end

program Padrao;

uses
  Vcl.Forms,
  uFRM_Principal in 'View\uFRM_Principal.pas' {FRM_Principal},
  uFrm_Base in 'View\TelaHeranca\uFrm_Base.pas' {Frm_Base},
  uFrm_Cadastro in 'View\TelaHeranca\uFrm_Cadastro.pas' {Frm_Cadastro},
  uFrm_Consulta in 'View\TelaHeranca\uFrm_Consulta.pas' {Frm_Consulta},
  uFrm_Cad_Cargo in 'View\TelasCadastro\uFrm_Cad_Cargo.pas' {Frm_Cad_Cargo},
  uFrm_Cad_Cidades in 'View\TelasCadastro\uFrm_Cad_Cidades.pas' {Frm_Cad_Cidades},
  uFrm_Cad_Clientes in 'View\TelasCadastro\uFrm_Cad_Clientes.pas' {Frm_Cad_Clientes},
  uFrm_Cad_Departamento in 'View\TelasCadastro\uFrm_Cad_Departamento.pas' {Frm_Cad_Departamento},
  uFrm_Cad_Estados in 'View\TelasCadastro\uFrm_Cad_Estados.pas' {Frm_Cad_Estados},
  uFrm_Cad_Fornecedor in 'View\TelasCadastro\uFrm_Cad_Fornecedor.pas' {Frm_Cad_Fornecedor},
  uFrm_Cad_Funcionario in 'View\TelasCadastro\uFrm_Cad_Funcionario.pas' {Frm_Cad_Funcionario},
  uFrm_Cad_Grupo in 'View\TelasCadastro\uFrm_Cad_Grupo.pas' {Frm_Cad_Grupo},
  uFrm_Cad_Paises in 'View\TelasCadastro\uFrm_Cad_Paises.pas' {Frm_Cad_Paises},
  uFrm_cad_Produtos in 'View\TelasCadastro\uFrm_cad_Produtos.pas' {Frm_Cad_Produto},
  uFrm_Cad_SubGrupo in 'View\TelasCadastro\uFrm_Cad_SubGrupo.pas' {Frm_Cad_SubGrupo},
  uFrm_Consulta_Paises in 'View\TelasConsulta\uFrm_Consulta_Paises.pas' {Frm_ConsultaPaises},
  uFrm_Venda in 'View\uFrm_Venda.pas' {Frm_Venda},
  uDM in 'DataModule\uDM.pas' {DM: TDataModule},
  uCidades in 'Model\Classes\uCidades.pas',
  uEstados in 'Model\Classes\uEstados.pas',
  uFilterSearch in 'Model\Classes\uFilterSearch.pas',
  uGeral in 'Model\Classes\uGeral.pas',
  uPaises in 'Model\Classes\uPaises.pas',
  uPessoa in 'Model\Classes\uPessoa.pas',
  uDao in 'Model\DAO\uDao.pas',
  uPaisesDao in 'Model\DAO\uPaisesDao.pas',
  uController in 'Controller\uController.pas',
  uPaisesController in 'Controller\uPaisesController.pas',
  uEstadosDao in 'Model\DAO\uEstadosDao.pas',
  uEstadosController in 'Controller\uEstadosController.pas',
  uFrm_Consulta_Estados in 'View\TelasConsulta\uFrm_Consulta_Estados.pas' {Frm_Consulta_Estados},
  uChamadasInterfaces in 'View\uChamadasInterfaces.pas',
  uGrupos in 'Model\Classes\uGrupos.pas',
  uSubGrupos in 'Model\Classes\uSubGrupos.pas',
  uDepartamentos in 'Model\Classes\uDepartamentos.pas',
  uCargos in 'Model\Classes\uCargos.pas',
  uCondicaoPagamento in 'Model\Classes\uCondicaoPagamento.pas',
  uFormasPagamentos in 'Model\Classes\uFormasPagamentos.pas',
  uCidadesDao in 'Model\DAO\uCidadesDao.pas',
  uCidadesController in 'Controller\uCidadesController.pas',
  uFrm_Consulta_Cidades in 'View\TelasConsulta\uFrm_Consulta_Cidades.pas' {Frm_Consulta_Cidades},
  uGruposDao in 'Model\DAO\uGruposDao.pas',
  uGruposController in 'Controller\uGruposController.pas',
  uFrm_Consulta_Grupos in 'View\TelasConsulta\uFrm_Consulta_Grupos.pas' {Frm_Consulta_Grupos},
  uSubGruposDao in 'Model\DAO\uSubGruposDao.pas',
  uSubGruposController in 'Controller\uSubGruposController.pas',
  uFrm_Consulta_SubGrupos in 'View\TelasConsulta\uFrm_Consulta_SubGrupos.pas' {Frm_Consulta_SubGrupos},
  uDepartamentosDao in 'Model\DAO\uDepartamentosDao.pas',
  uDepartamentosController in 'Controller\uDepartamentosController.pas',
  uFrm_Consulta_Departamentos in 'View\TelasConsulta\uFrm_Consulta_Departamentos.pas' {Frm_Consulta_Departamentos},
  uFrm_Cad_Ordem_Producao in 'View\TelasCadastro\uFrm_Cad_Ordem_Producao.pas' {Frm_Cad_Ordem_Producao},
  uUnidades in 'Model\Classes\uUnidades.pas',
  uDepositos in 'Model\Classes\uDepositos.pas',
  uFuncionarios in 'Model\Classes\uFuncionarios.pas',
  uFornecedores in 'Model\Classes\uFornecedores.pas',
  uClientes in 'Model\Classes\uClientes.pas',
  uEnum in 'Model\Classes\uEnum.pas',
  uCargosDao in 'Model\DAO\uCargosDao.pas',
  uUnidadesDao in 'Model\DAO\uUnidadesDao.pas',
  uCargosController in 'Controller\uCargosController.pas',
  uUnidadesController in 'Controller\uUnidadesController.pas',
  uDepositosDao in 'Model\DAO\uDepositosDao.pas',
  uFrm_Cad_Unidades in 'View\TelasCadastro\uFrm_Cad_Unidades.pas' {Frm_Cad_Unidades},
  uFrm_Consulta_Unidades in 'View\TelasConsulta\uFrm_Consulta_Unidades.pas' {Frm_Consulta_Unidades},
  uDepositosController in 'Controller\uDepositosController.pas',
  uFrm_Cad_Depositos in 'View\TelasCadastro\uFrm_Cad_Depositos.pas' {Frm_Cad_Depositos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFRM_Principal, FRM_Principal);
  Application.CreateForm(TFrm_Cad_Ordem_Producao, Frm_Cad_Ordem_Producao);
  Application.CreateForm(TFrm_Cad_Unidades, Frm_Cad_Unidades);
  Application.CreateForm(TFrm_Consulta_Unidades, Frm_Consulta_Unidades);
  Application.CreateForm(TFrm_Cad_Depositos, Frm_Cad_Depositos);
  Application.Run;
end.

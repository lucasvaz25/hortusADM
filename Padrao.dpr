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
  uFrm_Consulta_Departamentos in 'View\TelasConsulta\uFrm_Consulta_Departamentos.pas' {Frm_Consulta_Departamentos};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFRM_Principal, FRM_Principal);
  Application.CreateForm(TFrm_Base, Frm_Base);
  Application.CreateForm(TFrm_Cadastro, Frm_Cadastro);
  Application.CreateForm(TFrm_Consulta, Frm_Consulta);
  Application.CreateForm(TFrm_Cad_Cargo, Frm_Cad_Cargo);
  Application.CreateForm(TFrm_Cad_Cidades, Frm_Cad_Cidades);
  Application.CreateForm(TFrm_Cad_Clientes, Frm_Cad_Clientes);
  Application.CreateForm(TFrm_Cad_Departamento, Frm_Cad_Departamento);
  Application.CreateForm(TFrm_Cad_Estados, Frm_Cad_Estados);
  Application.CreateForm(TFrm_Cad_Fornecedor, Frm_Cad_Fornecedor);
  Application.CreateForm(TFrm_Cad_Funcionario, Frm_Cad_Funcionario);
  Application.CreateForm(TFrm_Cad_Grupo, Frm_Cad_Grupo);
  Application.CreateForm(TFrm_Cad_Paises, Frm_Cad_Paises);
  Application.CreateForm(TFrm_Cad_Produto, Frm_Cad_Produto);
  Application.CreateForm(TFrm_Cad_SubGrupo, Frm_Cad_SubGrupo);
  Application.CreateForm(TFrm_ConsultaPaises, Frm_ConsultaPaises);
  Application.CreateForm(TFrm_Venda, Frm_Venda);
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TFrm_Consulta_Estados, Frm_Consulta_Estados);
  Application.CreateForm(TFrm_Consulta_Cidades, Frm_Consulta_Cidades);
  Application.CreateForm(TFrm_Consulta_Grupos, Frm_Consulta_Grupos);
  Application.CreateForm(TFrm_Consulta_SubGrupos, Frm_Consulta_SubGrupos);
  Application.CreateForm(TFrm_Consulta_Departamentos, Frm_Consulta_Departamentos);
  Application.Run;
end.
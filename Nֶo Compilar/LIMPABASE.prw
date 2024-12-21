#Include 'Protheus.ch'
#INCLUDE "topconn.ch"

//Fun��o para realizar limpeza de dados da base
//Para executar no programa inicial: U_LIMPAB

User Function LIMPAB() //U_LIMPAB
	
	//Cria o MsApp
    MsApp():New('SIGACOM')
    oApp:CreateEnv()
     
    //Define o programa que ser� executado ap�s o login
    oApp:cStartProg    := 'U_LIMPABASE'
     
    //Seta Atributos 
    __lInternet := .T.
     
    //Inicia a Janela 
    oApp:Activate()
    

Return


User Function LIMPABASE

	IF  RetCodUsr()=='000000'
	if MsgYesNo("Confirma limpar base?")
		MsAguarde({|| DoExecute()  },"Aguarde...","Rodando scripts de limpeza...",.T.)
	endif
	ELSE
		MsgAlert("Somente usuário administrador poderá executar está ação.", "Atenção")
	ENDIF
Return

Static Function DoExecute()

	Local nStatus := 0
	Local aQry := {}
	local nX 

	// Arquivos de cadastros adicionais opcional.
	// Só usar em casos necessários.
	

	// ARQUIVOS DO MODULO ACD
	aadd( aQry, " DELETE FROM CB7010 ") // ORDENS DE SEPARAÇÃO
	aadd( aQry, " DELETE FROM CB8010 ") // ITENS ORDENS DE SEPARAÇÃO


	/*/Limpa Planos Funerários para importação de dados *atenção cadastros e movimentações*
	
	aadd( aQry, " DELETE FROM U61010 ") // Clientes Vindi
	aadd( aQry, " DELETE FROM U62010 ") // Lista de Envio Vindi  
	aadd( aQry, " DELETE FROM U63010 ") // Lista de Recebimento Vindi
	aadd( aQry, " DELETE FROM U64010 ") // Perfil de Pagamento Vindi 
	aadd( aQry, " DELETE FROM U65010 ") // Faturas Vindi
	aadd( aQry, " DELETE FROM U66010 ") // Tentativas de Cobranca Vindi 
	aadd( aQry, " DELETE FROM U68010 ") // Cabecalho Alteracoes Contrato  
	aadd( aQry, " DELETE FROM U69010 ") // Alteracao Beneficiarios  
	aadd( aQry, " DELETE FROM U70010 ") // Alteracao Cobranca Adic  
	aadd( aQry, " DELETE FROM U71010 ") // Alteracao Produtos e Serv 
	aadd( aQry, " DELETE FROM U72010 ") // Alteracao de Mensagens
	aadd( aQry, " DELETE FROM U73010 ") // Historico de Alteracao  
	aadd( aQry, " DELETE FROM UF2010 ") // Contratos Funeraria
	aadd( aQry, " DELETE FROM UF3010 ") // Produtos Contrato
	aadd( aQry, " DELETE FROM UF4010 ") // Beneficiarios
	aadd( aQry, " DELETE FROM UF5010 ") // Historico Transf. Titularidade
	aadd( aQry, " DELETE FROM UF7010 ") // Historico de Reajuste Funeraria
	aadd( aQry, " DELETE FROM UF8010 ") // Itens de Reajuste Funeraria
	aadd( aQry, " DELETE FROM UF9010 ") // Mensagens Contrato Funerario
	aadd( aQry, " DELETE FROM UG0010 ") // Apontamento Servicos    
	aadd( aQry, " DELETE FROM UG1010 ") // Itens Apontamento Servi 
	aadd( aQry, " DELETE FROM UG8010 ") // Historico de Add Parcel  
	aadd( aQry, " DELETE FROM UG9010 ") // Itens do Adiantamento    
	aadd( aQry, " DELETE FROM UGA010 ") // Log Contratos             
	aadd( aQry, " DELETE FROM UH0010 ") // Hist Taxa Manutencao Funeraria  
	aadd( aQry, " DELETE FROM UH1010 ") // Titulos Hist Manutencao   
	aadd( aQry, " DELETE FROM UH2010 ") // Personalizacao Contratos   
	aadd( aQry, " DELETE FROM UH3010 ") // Produtos Atuais Contratos  
	aadd( aQry, " DELETE FROM UH4010 ") // Produtos Novos Contratos  
	aadd( aQry, " DELETE FROM UH5010 ") // Inclusao Produtos Contratos  
	aadd( aQry, " DELETE FROM UH6010 ") // Alteracao Produtos Contratos  
	aadd( aQry, " DELETE FROM UH7010 ") // Exclusao Produtos Contratos   
	aadd( aQry, " DELETE FROM UJ0010 ") // Apontamento Servico MOD   
	aadd( aQry, " DELETE FROM UJ1010 ") // Itens Apontamento Contratos      
	aadd( aQry, " DELETE FROM UJ2010 ") // Itens Apontamento Entregue 
	aadd( aQry, " DELETE FROM UJ4010 ") // Itens Apontamento Transferencia   
	aadd( aQry, " DELETE FROM UJH010 ") // Convalescencia            
	aadd( aQry, " DELETE FROM UJI010 ") // Itens Convalescencia        
	aadd( aQry, " DELETE FROM UJP010 ") // Historico Ciclo Convalescencia  
	aadd( aQry, " DELETE FROM UJQ010 ") // Titulos Ciclo Convalescencia  
	aadd( aQry, " DELETE FROM UJR010 ") // Regras Contrato Aplicadas     
	aadd( aQry, " DELETE FROM UJS010 ") // Pre Reagendamento Virtus Cobranca   
	aadd( aQry, " DELETE FROM UJ9010 ") //  Cobranca adicionais   
/*/

	//Raquel - Adicionadas tabelas do SIGAEIC
	aadd( aQry, " DELETE FROM SW0010 ")
	aadd( aQry, " DELETE FROM SW1010 ")
	aadd( aQry, " DELETE FROM SW2010 ")
	aadd( aQry, " DELETE FROM SW3010 ")
	aadd( aQry, " DELETE FROM SW4010 ")
	aadd( aQry, " DELETE FROM SW5010 ")
	aadd( aQry, " DELETE FROM SW6010 ")
	aadd( aQry, " DELETE FROM SW7010 ")
	aadd( aQry, " DELETE FROM SW8010 ")
	aadd( aQry, " DELETE FROM SW9010 ")
	aadd( aQry, " DELETE FROM SWA010 ")
	aadd( aQry, " DELETE FROM SWB010 ")
	aadd( aQry, " DELETE FROM SWC010 ")
	aadd( aQry, " DELETE FROM SWD010 ")
	aadd( aQry, " DELETE FROM SWE010 ")
	aadd( aQry, " DELETE FROM SWJ010 ")
	aadd( aQry, " DELETE FROM SWK010 ")
	aadd( aQry, " DELETE FROM SWL010 ")
	aadd( aQry, " DELETE FROM SWM010 ")
	aadd( aQry, " DELETE FROM SWN010 ")
	aadd( aQry, " DELETE FROM SWO010 ")
	aadd( aQry, " DELETE FROM SWP010 ")
	aadd( aQry, " DELETE FROM SWQ010 ")
	aadd( aQry, " DELETE FROM SWU010 ")
	aadd( aQry, " DELETE FROM SWV010 ")
	aadd( aQry, " DELETE FROM SWW010 ")
	aadd( aQry, " DELETE FROM EI1010 ")
	aadd( aQry, " DELETE FROM EI2010 ")
	
	aadd( aQry, " UPDATE SA1010 SET A1_NROCOM = 0, A1_MSALDO = 0, A1_PRICOM = ' ', A1_ULTCOM = ' ' ")
	aadd( aQry, " UPDATE SA2010 SET A2_NROCOM = 0, A2_MSALDO = 0, A2_PRICOM = ' ', A2_ULTCOM = ' ',A2_MATR = 0, A2_SALDUP = 0 ")
	aadd( aQry, " UPDATE SA6010 SET A6_SALATU = 0 ")
	
	
	//Limpa CTB
	
	aadd( aQry, " DELETE FROM CT2010 ")
	aadd( aQry, " DELETE FROM CT3010 ")
	aadd( aQry, " DELETE FROM CT4010 ")
	aadd( aQry, " DELETE FROM CT6010 ")
	aadd( aQry, " DELETE FROM CT7010 ")
	aadd( aQry, " DELETE FROM CTC010 ")
	aadd( aQry, " DELETE FROM CTI010 ")
	aadd( aQry, " DELETE FROM CTK010 ")
	aadd( aQry, " DELETE FROM CTU010 ")
	aadd( aQry, " DELETE FROM CTV010 ")
	aadd( aQry, " DELETE FROM CTW010 ")
	aadd( aQry, " DELETE FROM CTX010 ")
	aadd( aQry, " DELETE FROM CTY010 ")
	aadd( aQry, " DELETE FROM CV3010 ")
	aadd( aQry, " DELETE FROM CV7010 ")
	aadd( aQry, " DELETE FROM CV8010 ")
	
	//Limpa STQ/PRO/COM
	//Apaga os bloqueados
	//aadd( aQry, " DELETE FROM SB1010 WHERE B1_MSBLQL='1' ")
	aadd( aQry, " DELETE FROM SB2010 ")
	aadd( aQry, " DELETE FROM SB6010 ")
	aadd( aQry, " DELETE FROM SB7010 ")//--WHERE B7_QUANT<1;
	aadd( aQry, " DELETE FROM SB8010 ")
	aadd( aQry, " DELETE FROM SB9010 ")
	aadd( aQry, " DELETE FROM SBF010 ")
	aadd( aQry, " DELETE FROM SBK010 ")
	aadd( aQry, " DELETE FROM SBJ010 ")
	aadd( aQry, " DELETE FROM SC1010 ")
	aadd( aQry, " DELETE FROM SC2010 ")
	aadd( aQry, " DELETE FROM SC3010 ")
	aadd( aQry, " DELETE FROM SC4010 ")
	aadd( aQry, " DELETE FROM SC5010 ")
	aadd( aQry, " DELETE FROM SC6010 ")
	aadd( aQry, " DELETE FROM SC7010 ")//-- WHERE C7_DATPRF<>'20080731';
	aadd( aQry, " DELETE FROM SC8010 ")
	aadd( aQry, " DELETE FROM AB8010 ")
	aadd( aQry, " DELETE FROM AD1010 ")
	aadd( aQry, " DELETE FROM AD2010 ") // TIME DE VENDAS
	//aadd( aQry, " DELETE FROM AD5010 ")
	aadd( aQry, " DELETE FROM AD6010 ")
	//aadd( aQry, " DELETE FROM AD5010 ")
	aadd( aQry, " DELETE FROM ADB010 ")
	aadd( aQry, " DELETE FROM ADL010 ")
	aadd( aQry, " DELETE FROM SC8010 ")
	aadd( aQry, " DELETE FROM SC9010 ")
	//aadd( aQry, " DELETE FROM SCA010 ")
	aadd( aQry, " DELETE FROM SCC010 ")
	//aadd( aQry, " DELETE FROM SCE010 ")
	aadd( aQry, " DELETE FROM SCR010 ")//-- WHERE CR_EMISSAO<='20080630';
	aadd( aQry, " DELETE FROM SCS010 ")
	aadd( aQry, " DELETE FROM SCT010 ")
	aadd( aQry, " DELETE FROM SCV010 ")
	
	//OMS
	aadd( aQry, " DELETE FROM DAI010 ")
	aadd( aQry, " DELETE FROM DAK010 ")
	aadd( aQry, " DELETE FROM DCK010 ")
	aadd( aQry, " DELETE FROM DAM010 ")
	aadd( aQry, " DELETE FROM DAS010 ")
	aadd( aQry, " DELETE FROM DAT010 ")
	aadd( aQry, " DELETE FROM DCF010 ")
	aadd( aQry, " DELETE FROM DAH010 ")
	aadd( aQry, " DELETE FROM DAP010 ")
	
	//Financeiro;
	aadd( aQry, " DELETE FROM SE1010 ")
	aadd( aQry, " DELETE FROM SE2010 ")
	aadd( aQry, " DELETE FROM SE1010 ")
	aadd( aQry, " DELETE FROM SE2010 ")
	aadd( aQry, " DELETE FROM SE3010 ")
	aadd( aQry, " DELETE FROM SE5010 ")
	aadd( aQry, " DELETE FROM SE7010 ")
	aadd( aQry, " DELETE FROM SE8010 ")
	aadd( aQry, " DELETE FROM SE9010 ")
	aadd( aQry, " DELETE FROM SEA010 ")
	aadd( aQry, " DELETE FROM SEF010 ")
	aadd( aQry, " DELETE FROM SEG010 ")
	aadd( aQry, " DELETE FROM SEH010 ")
	aadd( aQry, " DELETE FROM SFQ010 ")
	aadd( aQry, " DELETE FROM SEI010 ")
	aadd( aQry, " DELETE FROM SET010 ")
	aadd( aQry, " DELETE FROM SEU010 ")
	aadd( aQry, " DELETE FROM SEV010 ")
	aadd( aQry, " DELETE FROM SEZ010 ")
	aadd( aQry, " DELETE FROM FIV010 ")
	aadd( aQry, " DELETE FROM FIW010 ")
	aadd( aQry, " DELETE FROM FI0010 ")
	aadd( aQry, " DELETE FROM FI1010 ")
	aadd( aQry, " DELETE FROM FI2010 ")
	aadd( aQry, " DELETE FROM FJV010 ")
	aadd( aQry, " DELETE FROM MDM010 ")
	aadd( aQry, " DELETE FROM MDN010 ")
	aadd( aQry, " DELETE FROM FK1010 ")
	aadd( aQry, " DELETE FROM FK2010 ")
	aadd( aQry, " DELETE FROM FK3010 ")
	aadd( aQry, " DELETE FROM FK4010 ")
	aadd( aQry, " DELETE FROM FK5010 ")
	aadd( aQry, " DELETE FROM FK6010 ")
	aadd( aQry, " DELETE FROM FK7010 ")
	aadd( aQry, " DELETE FROM FK8010 ")
	aadd( aQry, " DELETE FROM FK9010 ")
	aadd( aQry, " DELETE FROM FKA010 ")
	aadd( aQry, " DELETE FROM FKB010 ")
	aadd( aQry, " DELETE FROM FWP010 ")
	aadd( aQry, " DELETE FROM FWQ010 ")
	aadd( aQry, " DELETE FROM FWS010 ")
	aadd( aQry, " DELETE FROM FWT010 ")

	
	//FATURAMENTO
	aadd( aQry, " DELETE FROM SC5010 ")
	aadd( aQry, " DELETE FROM SC6010 ")
	aadd( aQry, " DELETE FROM SC9010 ")
	aadd( aQry, " DELETE FROM ADA010 ")
	aadd( aQry, " DELETE FROM ADB010 ")
	aadd( aQry, " DELETE FROM SFT010 ")
	aadd( aQry, " DELETE FROM SF3010 ")
	aadd( aQry, " DELETE FROM SF2010 ")
	aadd( aQry, " DELETE FROM SD2010 ")
	
	//Fiscal;
	aadd( aQry, " DELETE FROM SF1010 ")
	aadd( aQry, " DELETE FROM SF2010 ")
	aadd( aQry, " DELETE FROM SF3010 ")
	aadd( aQry, " DELETE FROM SF6010 ")
	aadd( aQry, " DELETE FROM SF8010 ")
	aadd( aQry, " DELETE FROM SF9010 ")
	aadd( aQry, " DELETE FROM SFA010 ")
	aadd( aQry, " DELETE FROM SFI010 ")
	aadd( aQry, " DELETE FROM SFT010 ")
	aadd( aQry, " DELETE FROM CD2010 ")
	aadd( aQry, " DELETE FROM CD0010 ")
	aadd( aQry, " DELETE FROM CDA010 ")
	aadd( aQry, " DELETE FROM CDT010 ")
	
	//COMPRAS e ESTOQUE;
	aadd( aQry, " DELETE FROM SD1010 ")
	aadd( aQry, " DELETE FROM SD2010 ")
	aadd( aQry, " DELETE FROM SD3010 ")
	aadd( aQry, " DELETE FROM SD4010 ")
	aadd( aQry, " DELETE FROM SD5010 ")
	aadd( aQry, " DELETE FROM SD6010 ")
	aadd( aQry, " DELETE FROM SD7010 ")
	aadd( aQry, " DELETE FROM SDA010 ")
	aadd( aQry, " DELETE FROM SDB010 ")
	aadd( aQry, " DELETE FROM SDC010 ")
	aadd( aQry, " DELETE FROM SDD010 ")
	aadd( aQry, " DELETE FROM SDF010 ")
	
	//Ativo Fixo;
	aadd( aQry, " DELETE FROM SN4010 ")
	aadd( aQry, " DELETE FROM SN5010 ")
	aadd( aQry, " DELETE FROM SN6010 ")
	aadd( aQry, " DELETE FROM SNA010 ")
	aadd( aQry, " DELETE FROM SNC010 ")
	
	
	//Manuten�ao Ativos/Frota
	aadd( aQry, " DELETE FROM STJ010 ")
	aadd( aQry, " DELETE FROM STI010 ") 
	aadd( aQry, " DELETE FROM STL010 ")
	aadd( aQry, " DELETE FROM STQ010 ")
	aadd( aQry, " DELETE FROM STN010 ")  
	aadd( aQry, " DELETE FROM STP010 ")
	aadd( aQry, " DELETE FROM STR010 ")
	aadd( aQry, " DELETE FROM STS010 ")
	aadd( aQry, " DELETE FROM STT010 ")
	aadd( aQry, " DELETE FROM STU010 ")
	aadd( aQry, " DELETE FROM STV010 ")
	aadd( aQry, " DELETE FROM STW010 ")
	aadd( aQry, " DELETE FROM STX010 ")
	aadd( aQry, " DELETE FROM STY010 ")
	aadd( aQry, " DELETE FROM STZ010 ")
	aadd( aQry, " DELETE FROM TPL010 ")
	aadd( aQry, " DELETE FROM TPP010 ")
	aadd( aQry, " DELETE FROM TPQ010 ")
	aadd( aQry, " DELETE FROM TPU010 ")
	aadd( aQry, " DELETE FROM TPV010 ")
	aadd( aQry, " DELETE FROM TPW010 ")
	aadd( aQry, " DELETE FROM TPX010 ")
	aadd( aQry, " DELETE FROM TQA010 ")
	aadd( aQry, " DELETE FROM TQB010 ")
	aadd( aQry, " DELETE FROM TQE010 ")
	aadd( aQry, " DELETE FROM TQK010 ")
	aadd( aQry, " DELETE FROM TQL010 ")
	aadd( aQry, " DELETE FROM TQN010 ")
	aadd( aQry, " DELETE FROM TQO010 ")
	aadd( aQry, " DELETE FROM TQP010 ")
	aadd( aQry, " DELETE FROM TQQ010 ")
	aadd( aQry, " DELETE FROM TQV010 ")
	aadd( aQry, " DELETE FROM TQZ010 ")
	aadd( aQry, " DELETE FROM TR1010 ")
	aadd( aQry, " DELETE FROM TR2010 ")
	aadd( aQry, " DELETE FROM TR3010 ")
	aadd( aQry, " DELETE FROM TR4010 ")
	aadd( aQry, " DELETE FROM TR5010 ")
	aadd( aQry, " DELETE FROM TR6010 ")
	aadd( aQry, " DELETE FROM TR7010 ")
	aadd( aQry, " DELETE FROM TR8010 ")
	aadd( aQry, " DELETE FROM TR9010 ")
	aadd( aQry, " DELETE FROM TRA010 ")
	aadd( aQry, " DELETE FROM TRC010 ")
	aadd( aQry, " DELETE FROM TRF010 ")
	aadd( aQry, " DELETE FROM TRG010 ")
	aadd( aQry, " DELETE FROM TRH010 ")
	aadd( aQry, " DELETE FROM TRI010 ")
	aadd( aQry, " DELETE FROM TRJ010 ")
	aadd( aQry, " DELETE FROM TRK010 ")
	aadd( aQry, " DELETE FROM TRL010 ")
	aadd( aQry, " DELETE FROM TRM010 ")
	aadd( aQry, " DELETE FROM TRO010 ")
	aadd( aQry, " DELETE FROM TRP010 ")
	aadd( aQry, " DELETE FROM TRQ010 ")
	aadd( aQry, " DELETE FROM TRR010 ")
	aadd( aQry, " DELETE FROM TRS010 ")
	aadd( aQry, " DELETE FROM TRT010 ")
	aadd( aQry, " DELETE FROM TRU010 ")
	aadd( aQry, " DELETE FROM TRV010 ")
	aadd( aQry, " DELETE FROM TRX010 ")
	aadd( aQry, " DELETE FROM TRZ010 ")
	aadd( aQry, " DELETE FROM TSA010 ")
	aadd( aQry, " DELETE FROM TSB010 ")
	aadd( aQry, " DELETE FROM TSC010 ")
	aadd( aQry, " DELETE FROM TSD010 ")
	aadd( aQry, " DELETE FROM TSE010 ")
	aadd( aQry, " DELETE FROM TSF010 ")
	aadd( aQry, " DELETE FROM TSG010 ")
	aadd( aQry, " DELETE FROM TSH010 ")
	aadd( aQry, " DELETE FROM TTO010 ")
	aadd( aQry, " DELETE FROM TTP010 ")
	aadd( aQry, " DELETE FROM TUM010 ")
		
			//DMS
	aadd( aQry, " delete from VO1010 ")// -- Ordem de Servi�o
	aadd( aQry, " delete from VO2010 ")// -- Cabe�alho da Requisi��o
	aadd( aQry, " delete from VO3010 ")// -- Pe�as da OS
	aadd( aQry, " delete from VO4010 ")// -- Servi�os da OS
	aadd( aQry, " delete from VPM010 ")// -- Servi�os cortados pelo Cliente
	aadd( aQry, " delete from VVP010 ")// -- Item Ped. Veic
	aadd( aQry, " delete from VQ0010 ")// -- Pedido de Ve�culos
	aadd( aQry, " delete from VPJ010 ")// -- Itens Cortados pelo cliente
	aadd( aQry, " delete from VOO010 ")// -- Arquivos de Numeros e Notas Fiscais
	aadd( aQry, " delete from VOZ010 ")// -- Disp/Cancelamento da OS
	aadd( aQry, " delete from VZ1010 ")// -- Negocia��o de Pagamento da OS
	aadd( aQry, " delete from VMB010 ")// -- Cabe�alho garantia
	aadd( aQry, " delete from VMC010 ")// -- Itens Garantia
	aadd( aQry, " delete from VOF010 ")// -- Situa��o dos Produtivos
	aadd( aQry, " delete from VQ1010 ")// -- Incentivos de Ped de Ve�culos
	aadd( aQry, " delete from VQ6010 ")// -- Log Integra��o JD
	aadd( aQry, " delete from VRE010 ")// -- Reserva Tempor�ria
	aadd( aQry, " delete from VV9010 ")// -- Recep��o Clientes/Visitantes
	aadd( aQry, " delete from VVA010 ")// -- Itens das sa�das de Ve�culos
	aadd( aQry, " delete from VVF010 ")// -- Entrada de Ve�culos
	aadd( aQry, " delete from VVG010 ")// -- Itens das Entradas de Ve�culos
	aadd( aQry, " delete from VMY010 ")// -- Regristro de Produto
	aadd( aQry, " delete from VIC010 ")// -- Itens Garantia
	aadd( aQry, " delete from VIE010 ")// -- Retorno Pedido de Pe�as
	aadd( aQry, " delete from VI0010 ")// -- Cab Nota Fiscal Recep
	aadd( aQry, " delete from VS1010 ")// -- Or�amento
	aadd( aQry, " delete from VS3010 ")// -- Itens do Or�amento (pe�as)
	aadd( aQry, " delete from VS4010 ")// -- Itens do Or�amento (servi�os)
	aadd( aQry, " delete from VS6010 ")// -- Cabe�alho da Libera��o de Venda
	aadd( aQry, " delete from VS7010 ")// -- Itens da Libera��o de Venda
	aadd( aQry, " delete from VS9010 ")// -- Hist�rico de negocia��es
	aadd( aQry, " delete from VSC010 ")// -- Avalia��o Venda de Servi�o
	aadd( aQry, " delete from VSJ010 ")// -- Pe�as Em Espera para Aplica��o
	aadd( aQry, " delete from VSW010 ")// -- Arq Pedido Libera��o Cr�dito
	aadd( aQry, " DELETE FROM VE6010 ")// -- Requisicao Comrpa x Venda Perd
	aadd( aQry, " DELETE FROM VPE010 ")// -- Inventario Auto Pecas
	aadd( aQry, " DELETE FROM SFJ010 ")// -- Sugestao de compra
	aadd( aQry, " DELETE FROM SBL010 ")// -- Sugest�o de compra
	aadd( aQry, " DELETE FROM VFB010 ")// -- Ocorrencias do veiculo
	aadd( aQry, " DELETE FROM VAY010 ")// -- Movimentacao de tarefas
	aadd( aQry, " DELETE FROM VDD010 ")// -- Pedido de transferencia
	aadd( aQry, " DELETE FROM VDG010 ")// -- Fila vendedor Atendimento
	aadd( aQry, " DELETE FROM VDR010 ")// -- Remessa de Peca Campo
	aadd( aQry, " DELETE FROM VDT010 ")// -- Resp Questionario motivo
	aadd( aQry, " DELETE FROM VFE010 ")// -- Relacao Sigaloja Fechamento OS
	aadd( aQry, " DELETE FROM VQ3010 ")// -- Complemento de Demanda
	aadd( aQry, " DELETE FROM VQ4010 ")// -- Historico Env/Rec Incentivo
	aadd( aQry, " DELETE FROM VQL010 ")// -- SCHEDULE
	aadd( aQry, " DELETE FROM VSG010 ")// -- Valores comiss�o do item
	aadd( aQry, " DELETE FROM VV0010 ")// -- Sa�da de ve�culos
	aadd( aQry, " DELETE FROM VVF010 ")// -- Entrada de ve�culos
	aadd( aQry, " DELETE FROM VVG010 ")// -- Itens Entrada de ve�culos
	aadd( aQry, " DELETE FROM VD3010 ")// -- Movimenta��o de ferramentas
	aadd( aQry, " DELETE FROM VQ2010 ")// -- Pedido de Compra JD
	aadd( aQry, " DELETE FROM VPF010 ")// -- Invent�rio
	aadd( aQry, " DELETE FROM VPG010 ")// -- Invent�rio
	aadd( aQry, " DELETE FROM VSY010 ")// -- Aval de vendas de pe�as
	aadd( aQry, " DELETE FROM VSO010 ")// -- Agendamento de Clientes
	aadd( aQry, " DELETE FROM VVN010 ")// -- Garantia Estendida
	
	//aadd( aQry, " delete from VDP010 ")// --
	
	//AVULSAS
	aadd( aQry, " DELETE FROM AID010 ")// -- Fluxo de Caixa Materiais
	aadd( aQry, " DELETE FROM SLT010 ")// -- Conferencia de Caixa
	aadd( aQry, " DELETE FROM SCQ010 ")// -- Pre requisicoes
	aadd( aQry, " DELETE FROM SCY010 ")// -- Historico Pedido de Compra
	aadd( aQry, " DELETE FROM SCP010 ")// -- Solicita��o Armazem
	aadd( aQry, " DELETE FROM SM2010 ")//
	
	//VENDA DIRETA
	aadd( aQry, " DELETE FROM SL1010 ") // CABEÇALHO ORÇAMENTO
	aadd( aQry, " DELETE FROM SL2010 ") // ITENS DO ORÇAMENTO
	aadd( aQry, " DELETE FROM SL3010 ") 
	aadd( aQry, " DELETE FROM SL4010 ")
	aadd( aQry, " DELETE FROM SL5010 ")
	aadd( aQry, " DELETE FROM SLW010 ")
	aadd( aQry, " DELETE FROM SB0010 ") // PREÇOS LOJA
	aadd( aQry, " DELETE FROM SB3010 ") 
	aadd( aQry, " DELETE FROM SC0010 ") // RESERVAS DE PRODUTOS

	//GESTÃO DE CONTRATOS
	aadd( aQry, " DELETE FROM SCQ010 ")// -- Documentos com alçada
	aadd( aQry, " DELETE FROM CN9010 ")// -- contratos
	aadd( aQry, " DELETE FROM CNK010 ")// -- documentos contratuais
	aadd( aQry, " DELETE FROM CNA010 ")// -- cabeçalho planilha de contratos
	aadd( aQry, " DELETE FROM CNB010 ")// -- itens planilha de contratos
	aadd( aQry, " DELETE FROM CNC010 ")// -- Amaraçao fornecedorXContrato
	aadd( aQry, " DELETE FROM CNF010 ")// -- CRONOGRAMA FINANCEIRO CONTRATO
	aadd( aQry, " DELETE FROM CND010 ")// -- CABEÇALHO MEDIÇAO CONTRATOS
	aadd( aQry, " DELETE FROM CNE010 ")// -- ITENS DE MEDICAO DE CONTRATOS
	aadd( aQry, " DELETE FROM CNS010 ")// -- CRONOGRAMA FISICO
	aadd( aQry, " DELETE FROM CNP010 ")// -- TIPOS DESCONTO
	aadd( aQry, " DELETE FROM CNQ010 ")// -- AMARRAÇAO MEDXDES
	aadd( aQry, " DELETE FROM CNX010 ")// 
	
	
	//Fieald Service
	aadd( aQry, " DELETE FROM AB1010 ")// 
	aadd( aQry, " DELETE FROM AB2010 ")// 
	aadd( aQry, " DELETE FROM AB3010 ")// 
	aadd( aQry, " DELETE FROM AB4010 ")// 
	aadd( aQry, " DELETE FROM AB5010 ")// 
	aadd( aQry, " DELETE FROM AB6010 ")// 
	aadd( aQry, " DELETE FROM AB7010 ")// 
	aadd( aQry, " DELETE FROM AB8010 ")// 
	aadd( aQry, " DELETE FROM AB9010 ")// 
	aadd( aQry, " DELETE FROM ABA010 ")// 
	aadd( aQry, " DELETE FROM ABF010 ")// 

	//SIGATEC
	aadd( aQry, " DELETE FROM ABS010 ")// LOCAIS DE ATENDIMENTO
	aadd( aQry, " DELETE FROM TFG010 ")// 
	aadd( aQry, " DELETE FROM TFH010 ")// Itens de Materiais de Consumo
	aadd( aQry, " DELETE FROM TFL010 ")// Local de Atendimento x Proposta
	aadd( aQry, " DELETE FROM TFS010 ")// Materiais de Implantação
	aadd( aQry, " DELETE FROM TFT010 ")// Materiais de Consumo
	aadd( aQry, " DELETE FROM ADY010 ")// Proposta Comercial.
	aadd( aQry, " DELETE FROM ADZ010 ")// Itens da Proposta Comercial.
	aadd( aQry, " DELETE FROM AGY010 ")// Processo ECM X Proposta.
	aadd( aQry, " DELETE FROM AAA010 ")// Contrato de Serviços.
	aadd( aQry, " DELETE FROM AAA010 ")// Contrato de Serviços.
	aadd( aQry, " DELETE FROM TFJ010 ")// ORÇAMENTO DE SERVIÇO
	aadd( aQry, " DELETE FROM TFL010 ")// ORÇAMENTO DE SERVIÇO
	aadd( aQry, " DELETE FROM TFI010 ")// ORÇAMENTO DE SERVIÇO
	aadd( aQry, " DELETE FROM TFV010 ")// ORÇAMENTO DE SERVIÇO
	aadd( aQry, " DELETE FROM TWZ010 ")// REGISTRO DE CUSTOS SIGATEC
	aadd( aQry, " DELETE FROM AA3010 ")// BASE DE ATENDIMENTO
	aadd( aQry, " DELETE FROM AAH010 ")// 	 - Contrato de Manutenção.
	aadd( aQry, " DELETE FROM AAT010 ")// Vistoria Técnica Cabeçalho.	
	

	
	for nX := 1 to len(aQry)	
		
		conout("->> Script: " + aQry[nX])
			                   
		nStatus := TCSqlExec(aQry[nX])
	   
		if (nStatus < 0)
			conout("->> ERRO NA EXECUCAO.")
		else
			conout("->> EXECUTADO COM SUCESSO.")
		endif
	
	next nX

	Alert("Processamento finalizado!")
	
Return


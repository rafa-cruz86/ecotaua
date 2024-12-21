//Bibliotecas
#Include "Protheus.ch"

/*/{Protheus.doc} PE01NFESEFAZ
Ponto de entrada no fim do NfeSefaz para manipular os arrays do XML
@author Rafael Cruz TOTVS/SP
@since 14/12/2024
@version 1.0
@type function
@see https://centraldeatendimento.totvs.com/hc/pt-br/articles/4404432005655--Cross-Segmentos-Backoffice-Protheus-Doc-Eletrônicos-Ponto-de-entrada-no-NFESEFAZ-PE01NFESEFAZ
@obs Posições do ParamIXB:
    001 - aProd       -  Produto
    002 - cMensCli    -  Mensagem da nota
    003 - cMensFis    -  Mensagem padrao
    004 - aDest       -  Destinatario
    005 - aNota       -  Numero da nota
    006 - aInfoItem   -  Informações do Item
    007 - aDupl       -  Duplicata
    008 - aTransp     -  Transporte
    009 - aEntrega    -  Entrega
    010 - aRetirada   -  Retirada
    011 - aVeiculo    -  Veiculo
    012 - aReboque    -  Placa Reboque
    013 - aNfVincRur  -  Nota Produtor Rural Referenciada
    014 - aEspVol     -  Especie Volume
    015 - aNfVinc     -  NF Vinculada
    016 - aDetPag     -  
/*/

User Function PE01NFESEFAZ()
	// Salva a área de trabalho atual para restaurá-la no final
	Local aArea      := GetArea()
	Local nAtual     := 0

	// Arrays e variáveis iniciais
	Local aDados     := ParamIXB // Dados recebidos pelo ponto de entrada
	Local aProdutos  := aDados[1] // Lista de produtos na nota fiscal
	Local cMsgCli    := aDados[2] // Mensagem personalizada para o cliente
	Local aVeiculos  := {}        // Array para armazenar informações dos veículos
	Local aReboques  := {}        // Array para armazenar informações dos reboques
	Local cNLote     := ""        // Número do lote do produto
	Local cLoteCtl   := ""        // Lote controlado
	Local cProduto   := ""        // Código do produto
	Local cTipo      := If(aDados[5, 4] = "1", "S", "E") // Tipo de nota: "S" (saída), "E" (entrada)
	Local cDoc       := ""        // Número da nota fiscal
	Local cSerie     := ""        // Série da nota fiscal
	Local cNomMotr   := ""        // Nome do motorista
	Local cVeicul1   := ""        // Placa do cavalo mecânico (veículo principal)
	Local cVeicul2   := ""        // Placa do reboque (carreta)

	// Verifica se a nota fiscal é de saída
	If cTipo == "S"

//------------------------------------------------------------------------------

		//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		//Inicio - Adicionar dados do Lote caso produto tenho rastreabilidade
		//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

		// Percorre todos os itens da lista de produtos
		For nAtual := 1 To Len(aProdutos)

			// Obtém informações de lote do produto
			cNLote   := aProdutos[nAtual, 20] // SubLote
			cLoteCtl := aProdutos[nAtual, 19] // Lote
			cProduto := aProdutos[nAtual,  2] // Codigo do Produto

			// Se o lote controlado não estiver vazio
			If !Empty(cLoteCtl)

				// Busca o lote no banco de dados (tabela SB8)
				DBSelectArea("SB8")
				SB8->( DBSetOrder(2) )
				IF SB8->( DbSeek(xFilial("SB8")+cNLote+cLoteCtl+cProduto) )
					// Adiciona informações do lote na descrição do produto
					aProdutos[nAtual, 4] += "| LOT: "+ SB8->B8_LOTECTL +"| FAB:"+ DtoC(SB8->B8_DTVALID) +"| VAL:"+ DtoC(SB8->B8_DATA)
				EndIf

			EndIf

		Next nAtual


//------------------------------------------------------------------------------

		//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
		//Inicio - Adicionar dados do veiculo, reboque e motorista
		//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||


		// Obtém informações da nota fiscal e cliente
		cDoc    := aDados[5, 2] // Número da Nota
		cSerie  := aDados[5, 1] // Série da Nota
		cCodCli := aDados[5, 7] // Código do Cliente
		cLojCli := aDados[5, 8] // Loja do Cliente

		// Busca informações adicionais na tabela SF2
		dbSelectArea("SF2")
		SF2->( dbSetOrder(1) )
		IF SF2->( dbSeek(xFilial("SF2")+cDoc+cSerie+cCodCli+cLojCli) )

			// Se houver código de carga associado
			If !Empty(SF2->F2_CARGA)
				dbSelectArea("DAK")
				dbSetOrder(1)
				If dbSeek(xFilial("DAK")+SF2->F2_CARGA+SF2->F2_SEQCAR)
					// Obtém informações do veículo e motorista
					cVeicul1:= DAK->DAK_CAMINH
					cVeicul2:= DAK->DAK_VEIC2
					cNomMotr:= GetAdvFVal("DA4","DA4_NOME",xFilial("DA4")+DAK->DAK_MOTORI,1," ")

					// Adiciona informações do cavalo mecânico
					If !Empty(DAK->DAK_CAMINH)
						dbSelectArea("DA3")
						dbSetOrder(1)
						MsSeek(xFilial("DA3")+DAK->DAK_CAMINH)

						aadd(aVeiculos,DA3->DA3_PLACA) // Placa do cavalo mecânico
						aadd(aVeiculos,DA3->DA3_ESTPLA) // Estado da placa
					EndIf

					// Adiciona informações do reboque
					If !Empty(DAK->DAK_VEIC2)
						dbSelectArea("DA3")
						dbSetOrder(1)
						MsSeek(xFilial("DA3")+DAK->DAK_VEIC2)

						aadd(aReboques,DA3->DA3_PLACA) // Placa do reboque
						aadd(aReboques,DA3->DA3_ESTPLA) // Estado da placa
					EndIf

				EndIf

				// Monta mensagem para o cliente com informações do motorista e veículos
				If !Empty(cVeicul2)
					cMsgCli +=  "MOTORISTA: "+ cNomMotr +" PLACA CAVALO:"+ cVeicul1 +" PLACA CARRETA:"+ cVeicul2
				else
					cMsgCli +=  "MOTORISTA: "+ cNomMotr +" PLACA CAVALO:"+ cVeicul1
				EndIf

			EndIf
		EndIf

	EndIf

	// Atualiza os arrays com as novas informações
	aDados[1]  := aProdutos   // Lista de produtos com lotes atualizados
	aDados[2]  := cMsgCli     // Mensagem personalizada para o cliente
	aDados[11] := aVeiculos   // Lista de veículos
	aDados[12] := aReboques   // Lista de reboques

	// Restaura a área de trabalho original
	RestArea(aArea)

Return aDados // Retorna os dados atualizados

#include "protheus.ch"
#include "topconn.ch"
#Include "TOTVS.ch"

#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)
**************************************************************************************************************************************************
User Function PE01NFESEFAZ()
	**************************************************************************************************************************************************
	Local _AreaBkp 	:= GetArea()
	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol   := PARAMIXB[14]
	Local aNfVinc   := PARAMIXB[15]
	Local AdetPag   := PARAMIXB[16]
	Local aObsCont  := PARAMIXB[17]
	Local aProcRef  := PARAMIXB[18]
	Local aMed			:= PARAMIXB[19]
	Local aLote			:= PARAMIXB[20]

	Local aRetorno  := {}
	Local nTipoDoc := 4

	Local nValPIS		:= 0
	Local nValCOF		:= 0
	Local cDoc 	:= ""
	Local cSerie 	:= ""
	Local cCliFor 	:= ""
	Local cLoja 	:= ""

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
// Variaveis - Plano de Ação PA141224R (Rafael Cruz - TOTVS/SP)
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	Local lP141224r  := GetNewPar("PA_141224R", .T.) // Ativa/Desativa Plano de Açã0
	Local nAtual     := 0
	Local cNLote     := ""        // Número do lote do produto
	Local cLoteCtl   := ""        // Lote controlado
	Local dDataFab   := CtoD(Space(8)) //Data de Fabricação co Lote
	Local cProduto   := ""        // Código do produto
	Local cItemPrd   := ""        // Item do Produto na NF
	Local _aVeic	 := {}        // Array para armazenar informações dos veículos
	Local _aRebq     := {}        // Array para armazenar informações dos reboques
	Local cNomMotr   := ""        // Nome do motorista
	Local cVeicul1   := ""        // Placa do cavalo mecânico (veículo principal)
	Local cVeicul2   := ""        // Placa do reboque (carreta)
	Local cDocNF     := ""        // Numero da Nota Fiscal
	Local cSerNF     := ""        // Serie da Nota Fiscal
	Local cCdCliNF   := ""        // Codigo do Cliente (Destinatario)
	Local cLjCliNF   := ""        // Loja do Cliente (Destinatario)
	Local _aTmpSD2   := ""        // Alias Temporario SD2
//------------------------------------------------------------------------------



	DbSelectArea("SB8")
	DbSetOrder(1)  //Filial + Produto + Local + Data Validade + Lote
// Nota Fiscal de Saida
	If aNota[nTipoDoc] == "1"

		//Poscionemanto nas tabelas
		DbSelectArea("SC5")
		DbsetOrder(1)
		IF MsSeek(xFilial("SC5") + SD2->D2_PEDIDO )
			if !empty(SC5->C5_PEDIDO)
				cMensCli += "- Ordem de Compra: "+ALLTRIM(SC5->C5_PEDIDO)
			endif

			if !empty(SC5->C5_CONDPAG)
				DbSelectArea("SE4")
				DbsetOrder(1)
				MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
				cMensCli += "- Condio de Pagamento: "+ALLTRIM(SE4->E4_DESCRI)
			endif

			DbSelectArea("SA3")
			DbsetOrder(1)
			IF MsSeek(xFilial("SA3") + SC5->C5_VEND1 )
				cMensCli += ". Repres. comercial: "+ALLTRIM(A3_NOME)
				cMensCli += ENTER
				If !empty(SC5->C5_VEND2)
					SA3->(dbgotop())
					IF MsSeek(xFilial("SA3") + SC5->C5_VEND2 )
						cMensCli += ". Repres. comercial 2: "+ALLTRIM(A3_NOME)
						cMensCli += ENTER
					Endif
				Endif
			ENDIF

			cMensCli += ENTER
			If !empty(SC5->C5_OBS)
				cMensCli += ". "+SC5->C5_OBS
			endif

		/* Tratativa para a impresso da Informao do LACRE */
			cMensCli += ENTER
			If !empty(SC5->C5_LACRE)
				cMensCli += ". "+RTrim(SC5->C5_LACRE)
			endif

		ENDIF

	/* Pega os valores do PIS e COFINS para adicionar nas Informa  es Adicionais da Nota */
		CD2->(DbSeek( xFilial("CD2") + "S" + cSerie + cDoc + cCliFor + cLoja))
		if CD2->(Found())
			While !CD2->(Eof()) .And. CD2->(CD2_FILIAL + CD2_TPMOV + CD2_SERIE + CD2_DOC + CD2_CODCLI + CD2_LOJCLI) == xFilial("CD2") + "S" + cSerie + cDoc + cCliFor + cLoja
				if "PS2" $ CD2->CD2_IMP
					nValPIS	+= CD2->CD2_VLTRIB
				Endif
				if "CF2" $ CD2->CD2_IMP
					nValCOF	+= CD2->CD2_VLTRIB
				Endif
				CD2->(DbSkip())
			Enddo
		Endif
	/* Tratativa para apresenta  o dos valores de PIS e COFINS nas informa  es adicionais */
		cMensCli += CRLF
		if nValPIS > 0 .And. nValCOF > 0
			cMensCli += "Total dos Impostos: Pis R$ " + Ltrim(Transform(nValPIS,X3Picture("CD2_VLTRIB"))) + ", Cofins R$ " + Ltrim(Transform(nValCOF,X3Picture("CD2_VLTRIB"))) + " "
		Endif

		_aAreaSD2  	:= SD2->(GetArea())

		dbSelectArea("SD2")
		dbSetOrder(3)

		MsSeek(xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)

		While !SD2->(Eof()) .And. xFilial("SD2") == SD2->D2_FILIAL .And.;
				SF2->F2_SERIE  == SD2->D2_SERIE  .And.;
				SF2->F2_DOC    == SD2->D2_DOC
			iF SD2->D2_QTSEGUM>0 .AND. !empty(SD2->D2_SEGUM)
				// _nPosProd := ASCAN(aProd,{|X|ALLTRIM(x[2])==ALLTRIM(SD2->D2_COD)})
				_nPosProd :=  AScanX(  aProd, { | x | ALLTRIM(x[2]) == ALLTRIM(SD2->D2_COD) .And. x[9] == SD2->D2_QUANT} )
				If _nPosProd > 0
					aProd[_nPosProd,25] := "Seg. Unid. "+alltrim(SD2->D2_SEGUM)+": "+cValToChar(SD2->D2_QTSEGUM)
				endif
			ENDIF
			SD2->(DbSkip())
		End
		RestArea(_aAreaSD2)

//------------------------------------------------------------------------------
		// Ativa/Desativa - Plano de Ação PA141224R
		If lP141224r

			// Obtém informações da nota fiscal e cliente
			cDocNF	  := PadR(aNota[2],TamSx3("D2_DOC")[1])     // Número da Nota
			cSerNF	  := PadR(aNota[1],TamSx3("D2_SERIE")[1])   // Série da Nota
			cCdCliNF  := PadR(aNota[7],TamSx3("D2_CLIENTE")[1]) // Código do Cliente
			cLjCliNF  := PadR(aNota[8],TamSx3("D2_LOJA")[1])    // Loja do Cliente



			//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
			//Inicio - Adicionar dados do Lote caso produto tenho rastreabilidade
			//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

			_aTmpSD2  	:= SD2->(GetArea())

			// Busca o lote no banco de dados (tabela SB8)
			DBSelectArea("SD2")
			SD2->( DBSetOrder(3) )

			// Percorre todos os itens da lista de produtos
			For nAtual := 1 To Len(aProd)

				// Obtém informações de lote do produto
				cNLote   := PadR(aProd[nAtual, 20],TamSx3("D2_NUMLOTE")[1]) // SubLote
				cLoteCtl := PadR(aProd[nAtual, 19],TamSx3("D2_LOTECTL")[1]) // Lote
				cProduto := PadR(aProd[nAtual,  2],TamSx3("D2_COD")[1]) // Codigo do Produto
				cItemPrd := PadL(aProd[nAtual,  1],TamSx3("D2_ITEM")[1],"0") // Codigo do Item do Produto

				// Se o lote controlado não estiver vazio
				If !Empty(cLoteCtl)
					IF SD2->( MsSeek(xFilial("SD2")+cDocNF+cSerNF+cCdCliNF+cLjCliNF+cProduto+cItemPrd) )

						dDataFab := GetAdvFVal("SB8","B8_DATA",xFilial("SB8")+SD2->D2_COD+SD2->D2_LOCAL+DTOS(SD2->D2_DTVALID)+SD2->D2_LOTECTL+SD2->D2_NUMLOTE,1," ")

						// Adiciona informações do lote na descrição do produto
						aProd[nAtual, 25] +=  "| LOT: "+ Alltrim(SD2->D2_LOTECTL) +"| FAB:"+ DtoC(dDataFab) +"| VAL:"+ DtoC(SD2->D2_DTVALID)
					EndIf
				EndIf

			Next nAtual

			RestArea(_aTmpSD2)


			//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
			//Inicio - Adicionar dados do veiculo, reboque e motorista
			//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

			// Busca informações adicionais na tabela SF2
			dbSelectArea("SF2")
			SF2->( dbSetOrder(1) )
			IF SF2->( dbSeek(xFilial("SF2")+cDocNF+cSerNF+cCdCliNF+cLjCliNF) )

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

							aadd(_aVeic,DA3->DA3_PLACA) // Placa do cavalo mecânico
							aadd(_aVeic,DA3->DA3_ESTPLA) // Estado da placa
							aadd(_aVeic,"") //RNTC

							//aadd(aVeiculo,_aVeic) // Lista de veículos
						EndIf

						// Adiciona informações do reboque
						If !Empty(DAK->DAK_VEIC2)
							dbSelectArea("DA3")
							dbSetOrder(1)
							MsSeek(xFilial("DA3")+DAK->DAK_VEIC2)

							aadd(_aRebq,DA3->DA3_PLACA) // Placa do reboque
							aadd(_aRebq,DA3->DA3_ESTPLA) // Estado da placa
							aadd(_aRebq,"") //RNTC

							//aadd(aReboque,_aRebq) // // Lista de reboques
						EndIf

					EndIf

					// Monta mensagem para o cliente com informações do motorista e veículos
					If !Empty(cVeicul2)
						cMensCli += CRLF
						cMensCli +=  "| MOTORISTA: "+ Alltrim(cNomMotr) +"| PLACA CAVALO:"+ cVeicul1 +"| PLACA CARRETA:"+ cVeicul2
					else
						cMensCli += CRLF
						cMensCli +=  "| MOTORISTA: "+ Alltrim(cNomMotr) +"| PLACA CAVALO:"+ cVeicul1
					EndIf

				EndIf
			EndIf

		EndIf

//------------------------------------------------------------------------------

	Endif

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,aProcRef)
	aadd(aRetorno,aMed)
	aadd(aRetorno,aLote)

	restarea(_AreaBkp)

RETURN aRetorno
	**************************************************************************************************************************************************

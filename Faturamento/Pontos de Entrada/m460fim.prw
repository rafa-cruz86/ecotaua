#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

 /*/{Protheus.doc} M460FIM
(Chamado no final do faturamento para processamentos extras do processo do cliente.)
@type  Function
@author WILK LIMA
@since 25/08/2022
@version 1.0
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
    /*/

User Function M460FIM()
	Local aArea := GetArea()
	Local oBol := NIL
	Local _cBanco	:= SuperGetMV('MV_BOLBCO', .T., '')	    //Banco de Cobranca
	Local _cAgenc	:= SuperGetMV('MV_BOLAGEN', .T., '')	//Agencia Cobranca
	Local _cConta	:= SuperGetMV('MV_BOLCONT', .T., '')	//Conta Cobranca
	Local _cSubCt	:= SuperGetMV('MV_BOLSUBC', .T., '')    //Sub-Conta Cobranca
	Local nValME    := 0
	Local nValPA    := 0
	Local _nValTot  := 0
	Local _cChaveTit := ""
	Local _cChaveFK7 := ""
	//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	// Variaveis - Plano de Ação PA141224R (Rafael Cruz - TOTVS/SP)
	//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
	Local lP141224r  := GetNewPar("PA_141224R", .T.) // Ativa/Desativa Plano de Açã0
	Local _nTam      := 0       // Tamanho de Campo
	Local infadprod  := ""        // Descrição do Lote
	Local dDataFab   := CtoD(Space(8)) //Data de Fabricação co Lote
	Local Codinfo    := ""        // Código do Memo Com detalhes do Lote
//------------------------------------------------------------------------------


	// geração de boletos
	IF AllTrim(SE4->E4_FORMA)$"BOL"

		If MsgYesNo("Deseja Gerar Boletos?")
			_cBanco := Padr(_cBanco,TamSx3("A6_COD")[1])
			_cAgenc := Padr(_cAgenc,TamSx3("A6_AGENCIA")[1])
			_cConta := Padr(_cConta,TamSx3("A6_NUMCON")[1])
			_cSubCt := Padr(_cSubCt,TamSx3("EE_SUBCTA")[1])
			// POSICIONA NO BANCO
			DbSelectArea("SA6")
			SA6->(DbSetOrder(1))
			SA6->(MSSeek(xFilial("SA6")+_cBanco+_cAgenc+_cConta))

			// POSICIONA NOS PARAMETROS DO BANCO
			DbSelectArea("SEE")
			SEE->(DbSetOrder(1))
			SEE->(MsSeek(xFilial("SEE")+_cBanco+_cAgenc+_cConta+_cSubCt))

			DbSelectArea("SE1")
			DbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
			IF DBSEEK(xFilial("SE1")+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC)
				oBol := xBolPDF():New()
				oBol:SetDadosBanco()
				oBol:SetBanco(SEE->(Recno()))
				oBol:SetTitulos(SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_TIPO, nil, nil, SE1->E1_CLIENTE, SE1->E1_CLIENTE, SE1->E1_LOJA, SE1->E1_LOJA,.F.)
				oBol:GerarBoletos()
			ENDIF
		Endif
	ENDIF

	// CRIA RATEIO MULTI NATUREZA CONTAS A RECEBER
	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	dbSeek(SF2->(F2_FILIAL+F2_DOC+F2_SERIE+F2_CLIENTE+F2_LOJA))
	while !eof() .AND. SD2->D2_FILIAL==SF2->F2_FILIAL .AND. SD2->D2_DOC==SF2->F2_DOC .AND.  SD2->D2_SERIE==SF2->F2_SERIE;
			.AND. SD2->D2_CLIENTE==SF2->F2_CLIENTE .AND. SD2->D2_LOJA==SF2->F2_LOJA

		_nValTot += SD2->D2_TOTAL
		IF SD2->D2_TP=='ME'
			nValME := SD2->D2_TOTAL
		ELSE
			nValPA := SD2->D2_TOTAL
		ENDIF

//------------------------------------------------------------------------------
		// Ativa/Desativa - Plano de Ação PA141224R
		If lP141224r

			// Se o lote controlado não estiver vazio
			If !Empty(SD2->D2_LOTECTL)

				// Busca o data de fabricação do lote no banco de dados (tabela SB8)
				dDataFab := GetAdvFVal("SB8","B8_DATA",xFilial("SB8")+SD2->D2_COD+SD2->D2_LOCAL+DTOS(SD2->D2_DTVALID)+SD2->D2_LOTECTL+SD2->D2_NUMLOTE,1," ")

				// Adiciona informações do lote na descrição do produto
				infadprod :=  "LOT: "+ SD2->D2_LOTECTL +"| FAB:"+ DtoC(dDataFab) +"| VAL:"+ DtoC(SD2->D2_DTVALID)

				_nTam     := TamSX3("C6_INFAD")[1]

				//Inclui informações do lote no campo memo
				Codinfo   := MSMM(,_nTam,,infadprod,1,,,"SC6","C6_INFAD")

				// Busca o item do pedido no banco de dados (tabela SC6)
				dbSelectArea("SC6")
				dbSetOrder(1)
				If dbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV+SD2->D2_COD)
					//Altera o registro do Pedido de Venda p/grava informacoes do lote campo Memo
					RecLock("SC6",.F.)
					SC6->C6_INFAD := Codinfo
					SC6->(MsUnLock())

				EndIf

			EndIf

		EndIf
//------------------------------------------------------------------------------




		SD2->(DBSKIP())

	enddo

	// confirma se realmente terá rateio.
	if nValME>0 .and. nValPA>0

		nPerME := nValME/_nValTot
		nPerPA := 1-nPerME

		DbSelectArea("SE1")
		SE1->(dbSetOrder(2)) // E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
		SE1->(dbSeek(SF2->F2_FILIAL+SF2->F2_CLIENTE+SF2->F2_LOJA+SF2->F2_SERIE+SF2->F2_DOC))
		while !eof() .and. SE1->E1_FILIAL == SF2->F2_FILIAL  .and. SE1->E1_CLIENTE == SF2->F2_CLIENTE .and. SE1->E1_PREFIXO == SF2->F2_SERIE .and. SE1->E1_NUM == SF2->F2_DOC
			IF 'NF'$SE1->E1_TIPO

				SE1->(RecLock("SE1", .F. ))
				SE1->E1_MULTNAT := '1'
				SE1->E1_RATFIN  := '2'
				SE1->(MsUnLock())

				_cChaveTit := xFilial("SE1",SE1->E1_FILORIG) + "|" +;
					SE1->E1_PREFIXO	+ "|" +;
					SE1->E1_NUM		+ "|" +;
					SE1->E1_PARCELA	+ "|" +;
					SE1->E1_TIPO	+ "|" +;
					SE1->E1_CLIENTE	+ "|" +;
					SE1->E1_LOJA
				_cChaveFK7 := FINGRVFK7("SE1",_cChaveTit)

				_nResto := SE1->E1_VALOR-round(SE1->E1_VALOR*nPerPA,2)

				// Grava porcentagem do valor ref. Natureza de Produto
				RecLock("SEV", .T. )
				SEV->EV_FILIAL   := SE1->E1_FILIAL
				SEV->EV_PREFIXO  := SE1->E1_PREFIXO
				SEV->EV_NUM      := SE1->E1_NUM
				SEV->EV_PARCELA  := SE1->E1_PARCELA
				SEV->EV_CLIFOR   := SE1->E1_CLIENTE
				SEV->EV_LOJA     := SE1->E1_LOJA
				SEV->EV_TIPO     := SE1->E1_TIPO
				SEV->EV_VALOR    := round(SE1->E1_VALOR*nPerPA,2)
				SEV->EV_NATUREZ  := "1101"
				SEV->EV_RECPAG   := "R"
				SEV->EV_PERC     := nPerPA
				SEV->EV_RATEICC  := '2'
				SEV->EV_IDENT    := "1"
				SEV->EV_IDDOC := _cChaveFK7
				SEV->(MsUnLock())

				// Grava porcentagem do valor ref. Natureza de Mercadoria
				RecLock("SEV", .T. )
				SEV->EV_FILIAL   := SE1->E1_FILIAL
				SEV->EV_PREFIXO  := SE1->E1_PREFIXO
				SEV->EV_NUM      := SE1->E1_NUM
				SEV->EV_PARCELA  := SE1->E1_PARCELA
				SEV->EV_CLIFOR   := SE1->E1_CLIENTE
				SEV->EV_LOJA     := SE1->E1_LOJA
				SEV->EV_TIPO     := SE1->E1_TIPO
				SEV->EV_VALOR    := _nResto
				SEV->EV_NATUREZ  := "1102"
				SEV->EV_RECPAG   := "R"
				SEV->EV_PERC     := nPerME
				SEV->EV_RATEICC  := '2'
				SEV->EV_IDENT    := "1"
				SEV->EV_IDDOC := _cChaveFK7
				SEV->(MsUnLock())

			ENDIF
			SE1->(DBSKIP())
		ENDDO

	endif
	RestArea(aArea)
Return(.T.)







/*/{Protheus.doc} MT100CLA
Tratamentos especiais para otmizacao do processo na classificacao de documentos fiscais.
@type function
@version  
@author wilks
@since 3/19/2024
@return variant, return_description
/*/
User Function MT100CLA()
	Local _cFil	:= ""
	Local _cDoc	:= ""
	Local _cSer	:= "" 
	Local _cFor	:= ""
	Local _cLoja:= ""
	Local _cNaturez := ""
	Local aAreaSF1 
	Local aAreaSD1 

	// verifica se não esta sendo executado por rotina automatica para evitar error.log
	If FunName()<>'MATA103'
		Return .T.
	ENDIF

	_cFil	:= SF1->F1_FILIAL
	_cDoc	:= SF1->F1_DOC
	_cSer	:= SF1->F1_SERIE
	_cFor	:= SF1->F1_FORNECE
	_cLoja	:= SF1->F1_LOJA
	_cNaturez := POSICIONE("SA2",1,XFILIAL("SA2")+_cFor+_cLoja,"A2_NATUREZ")
	aAreaSF1  := SF1->(GetArea())
	aAreaSD1  := SD1->(GetArea())

// Autor: Wilk Lima 21/07/2020
// Objetivo: carregar ultima TES usada na classificação para o produto e fornecedor.
// Necessário Campo de usuário A5_TE na SA5 e PE SD1100I para atualizar campo.

	// Grava codigo do usuario que está classificando o DOC
	RECLOCK("SF1",.F.)
	SF1->F1_USECLAS := UsrRetName(RetCodUsr())
	MsUnlock()

	//Preenche a TES do produto X fornecedor na classificação do documento de entrada.
	DBSelectArea("SD1")
	DBSetOrder(1) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	IF DBSeek(_cFil+_cDoc+_cSer+_cFor+_cLoja)
		WHILE !EOF() .AND. _cFil==SD1->D1_FILIAL;
				.AND. _cDoc==SD1->D1_DOC .AND. _cSer==SD1->D1_SERIE;
				.AND. _cFor==SD1->D1_FORNECE .AND. _cLoja==SD1->D1_LOJA .AND. EMPTY(SD1->D1_TES)

			RecLock("SD1",.F.)
			SD1->D1_TES= POSICIONE("SA5",2,XFILIAL("SA5")+SD1->D1_COD+_cFor+_cLoja,"A5_TE")
			SD1->D1_TEC= POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_POSIPI")
			IF EMPTY(SD1->D1_CONTA)
				SD1->D1_CONTA = POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_CONTA")
			ENDIF
			MsUnLock()
			GetDRefresh()
			SD1->(DbSkip())
		ENDDO
	ENDIF

	IF !EMPTY(_cNaturez)
		CNATUREZA := _cNaturez
	ENDIF

	RestArea(aAreaSF1)
	RestArea(aAreaSD1)

Return .T.

#include "protheus.ch"
#include "topconn.ch"
#Include "TOTVS.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³Ma103Track³ Autor ³ Rafael Cruz TOTVS/SP  ³ Data ³06/12/2024³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
**************************************************************************************************************************************************
User Function RastNFFin()
	**************************************************************************************************************************************************
	Local aAreaSE2  := SE2->(GetArea())
	Local aArea     := GetArea()
	Local cMensagem := ""
	Private _cA100For  := SE2->E2_FORNECE
	Private _cLoja	   := SE2->E2_LOJA
	Private _cNFiscal  := SE2->E2_NUM
	Private _cSerie    := SE2->E2_PREFIXO
	Private _aItmNF    := {}

	If UPPER(alltrim(SE2->E2_ORIGEM))$"MATA100/MATA103"
		dbselectarea("SD1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+_cNFiscal+_cSerie+_cA100For+_cLoja)

		while SD1->(!eof()) .and.  SD1->D1_DOC==_cNFiscal .and. SD1->D1_SERIE==_cSerie .and. ;
				SD1->D1_FORNECE==_cA100For .and. SD1->D1_LOJA==_cLoja
			aAdd(_aItmNF,{SD1->D1_ITEM,SD1->D1_COD})
			dbSkip()
		EndDo

		If Len(_aItmNF) >0
			Fn150Track()
		Else
			cMensagem := "Por Favor, selecionar <strong>FILIAL</strong> Ccorreta na janela anterior!"
			FWAlertError(cMensagem, "<strong><font color='red'>ALERTA</font></strong>")
		EndIf
	Else
		cMensagem := "Titulo selecionado <strong>NÃO</strong> teve origem de lançamento na rotina<br>"
		cMensagem += "<font color='red'>Documento de Entrada (MATA103)</font>"
		FWAlertError(cMensagem, "<strong>ALERTA</strong>")
	EndIf

	RestArea(aAreaSE2)
	RestArea(aArea)

Return (.T.)
	**************************************************************************************************************************************************
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    Fn150Track   Autor ³ Rafael Cruz TOTVS/SP  ³ Data ³06/12/2024³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Faz o tratamento da chamada do System Tracker              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T.                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao Efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
	**************************************************************************************************************************************************
Static Function Fn150Track()
	**************************************************************************************************************************************************

	Local aEnt     := {}
	Local cKey     := _cNFiscal + Substr(_cSerie,1,3) + _cA100For + _cLoja
	Local nPosItem := 1
	Local nPosCod  := 2
	Local nLoop    := 0
	Local aArea    := GetArea()
	Local aAreaSF1 := SF1->( GetArea() )

//Inicializa a funcao fiscal
	For nLoop := 1 To Len( _aItmNF )
		AAdd( aEnt, { "SD1", cKey + _aItmNF[ nLoop, nPosCod ] + _aItmNF[ nLoop, nPosItem ] } )
	Next nLoop

	MaFisSave()
	MaFisEnd()

	MaTrkShow( aEnt )

	MaFisRestore()

	RestArea(aAreaSF1)
	RestArea(aArea)

Return (.T.)
	**************************************************************************************************************************************************

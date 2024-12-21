//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA140BUT
P.E. para adicionar op��es dentro da tela de manipula��o do Pr�-Nota
@type  Function
@author Rafael Cruz TOTVS/SP
@since 11/12/2024
@version 1.00
@see https://tdn.totvs.com/pages/releaseview.action?pageId=6085354
/*/

User Function MA103BUT()
	Local aArea := GetArea()
	Local lEdit
	Local nAba
	Local oCampo
	Public __cCamNovo := CtoD(Space(8))

	//Adiciona uma nova aba no documento de entrada
	oFolder:AddItem("* Previs�o Pgto", .T.)
	nAba := Len(oFolder:aDialogs)

	//Se for inclus�o, ir� criar a vari�vel e ser� edit�vel, sen�o ir� buscar do banco e n�o ser� edit�vel
	If INCLUI
		__cCamNovo := CriaVar("F1_PVPAGTO",.F.)
		lEdit := .T.
	Else
		__cCamNovo := SF1->F1_PVPAGTO
		lEdit := .F.
	EndIf

	//Criando na janela o campo OBS
	@ 003, 003 SAY Alltrim(RetTitle("F1_PVPAGTO")) OF oFolder:aDialogs[nAba] PIXEL SIZE 050,006
	@ 001, 053 MSGET oCampo VAR __cCamNovo SIZE 100, 006 OF oFolder:aDialogs[nAba] COLORS 0, 16777215  PIXEL
	oCampo:bHelp := {|| ShowHelpCpo( "F1_PVPAGTO", {GetHlpSoluc("F1_PVPAGTO")[1]}, 5  )}

	//Se n�o houver edi��o, desabilita os gets
	If ! lEdit
		oCampo:lActive := .F.
	EndIf

	RestArea(aArea)
Return Nil

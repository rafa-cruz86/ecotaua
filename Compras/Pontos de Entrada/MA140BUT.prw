//Bibliotecas
#Include "TOTVS.ch"

/*/{Protheus.doc} User Function MA140BUT
P.E. para adicionar opções dentro da tela de manipulação do Pré-Nota
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
	oFolder:AddItem("* Previsão Pgto", .T.)
	nAba := Len(oFolder:aDialogs)

	//Se for inclusão, irá criar a variável e será editável, senão irá buscar do banco e não será editável
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

	//Se não houver edição, desabilita os gets
	If ! lEdit
		oCampo:lActive := .F.
	EndIf

	RestArea(aArea)
Return Nil

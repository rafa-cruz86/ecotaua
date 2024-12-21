#Include "PROTHEUS.CH"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SE2ATUDATA ºAutor  ³Denis Tsuchiya     º Data ³  02/27/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Atualiza datas de vencimento de Borderos                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function PVPGTONF()

	Local oDlg
	Local oButton1
	Local oDtAjuste
	Local dDtAjuste := CtoD(Space(8))
	Local oFont1 := TFont():New("MS Reference Sans Serif",,020,,.T.,,,,,.F.,.F.)
	Local oNumBor
	Local cNumBor := SF1->F1_DOC
	Local oPanel1
	Local oSay1
	Local oSay2
	Local lOK := .F.
	local cMensagem := ""

	If !EMPTY(SF1->F1_STATUS)
		cMensagem := "<strong>NÃO</strong> é possível informar previsão de pagamento para nota fiscal<br>"
		cMensagem += "que encontra-se com seus <font color='red'>status classificada</font> !"
		FWAlertError(cMensagem, "<strong>Atenção!</strong>")
		Return
	EndIf

	DEFINE MSDIALOG oDlg TITLE "Previsão de Pagamento" FROM 000, 000  TO 160, 280 COLORS 0, 16777215 PIXEL

	oDlg:lEscClose := .F.

	@ 000, 000 MSPANEL oPanel1 SIZE 140, 080 OF oDlg COLORS 0, 14215660 RAISED
	@ 018, 005 SAY oSay1 PROMPT "NOTA FISCAL" SIZE 042, 010 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 016, 067 MSGET oNumBor VAR cNumBor SIZE 060, 014 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL WHEN .F.
	@ 036, 005 SAY oSay2 PROMPT "PREV. PGTO" SIZE 058, 010 OF oPanel1 FONT oFont1 COLORS 0, 16777215 PIXEL
	@ 035, 067 MSGET oDtAjuste VAR dDtAjuste VALID !EMPTY(dDtAjuste) SIZE 060, 014 OF oPanel1 COLORS 0, 16777215 FONT oFont1 PIXEL
	@ 059, 069 BUTTON oButton1 PROMPT "Confirma" SIZE 060, 012 OF oPanel1 FONT oFont1 PIXEL Action ( lOk := .T. , oDlg:End()  )
	//@ 059, 069 BUTTON oButton2 PROMPT "Cancela" SIZE 060, 012 OF oPanel1 FONT oFont1 PIXEL Action oDlg:End()

	ACTIVATE MSDIALOG oDlg Centered VALID lOk 

	IF lOk

		//Inicio - Inclusão de Previsão de Pagamento
		//Autor: Rafael Cruz
		//Se a variável pública existir
		If Type("F1_PVPAGTO") != "U"

			//Grava o conteúdo na SF1
			RecLock("SF1", .F.)
			SF1->F1_PVPAGTO := dDtAjuste
			SF1->(MsUnlock())

			FWAlertSuccess("Previsão de pagamento incluído na Nota Fiscal", "Finalizado com sucesso")
		EndIf
		//Fim- Inclusão de Previsão de Pagamento

	End



Return


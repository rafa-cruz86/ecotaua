#Include "rwmake.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ SF1110I  ³ Autor ³  Wilk Lima   ³ Data ³23/06/2020³		   ±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Permite gravar o historico do titulo no financeiro         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para clientes Microsiga.                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SF1100I()

	_cArea := GetArea()



	@ 00,00 TO 150,620 DIALOG oDlg1 TITLE "DADOS FINANCEIRO"
	oGt      := NIL
	cTitulo  := Space(03)
	_cHist := Space(60)
//@ 010,005 Say OemToAnsi("Tipo do Titulo")
//@ 010,040 GET cTitulo VALID .t. F3 "05" Object oGt SIZE 40,30
	@ 024,005 Say OemToAnsi("Historico")
	@ 024,040 GET _cHist VALID .t. Object oGt SIZE 200,30

	@ 040,080 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
	@ 040,130 BMPBUTTON TYPE 1 ACTION Grava()
	ACTIVATE DIALOG oDlg1 CENTER


	Restarea(_cArea)

Return()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Grava historio no SF1/SE2³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Static Function Grava()

	DbSelectArea("SE2")
	DbSetOrder(6)
	DbGoTop()
	DbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
	While !EOF() .AND. SE2->E2_NUM == SF1->F1_DOC ;
			.AND. SE2->E2_PREFIXO == SF1->F1_SERIE;
			.AND. SE2->E2_FORNECE == SF1->F1_FORNECE;
			.AND. SE2->E2_LOJA == SF1->F1_LOJA

		WHILE !RECLOCK("SE2");ENDDO
			SE2->E2_HIST    := _cHist


			MsUnlock()

			DbSelectArea("SE2")
			SE2->(DbSkip())
		End


		Close(oDlg1)
		RestArea(_cArea)

		return()


/*/{Protheus.doc} SF1DOC
Ajusta numeracao com zeros a esquerda para evitar duplicidade no lançamento de documentos de entrada.
@type function
@version  
@author wilks
@since 19/03/2024
@return variant, return_description
/*/
USER FUNCTION SF1DOC()    

//completa numero da nota com zeros para nÃ£o gerar duplicidade no lanÃ§amento de notas.
// incluir na validacao de sistema do campo F1_DOC

// verifica se não esta sendo eecutado por rotina automatica para nao gerar error.log
	If !FunName()$'MATA103/MATA140'
		Return .T.
	ENDIF

If !Empty(M->F1_DOC) .Or. !Empty(cNFISCAL)
   M->F1_DOC := StrZero(Val(M->F1_DOC),9)
   CNFISCAL := M->F1_DOC
Endif   


Return(.T.)

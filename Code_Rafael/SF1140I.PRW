USER FUNCTION SF1140I ()
Local params1 := PARAMIXB[1]
//Local params1 := PARAMIXB[2]
Local _cArea := GetArea()
Local lP111224r  := GetNewPar("PA_111224R", .T.) // Ativa/Desativa Plano de Açã0

    IF params1
        RECLOCK("SF1",.F.)
        SF1->F1_USEPREN := UsrRetName(RetCodUsr())
        MsUnlock()
    ENDIF

    //Inicio - Inclusão de Previsão de Pagamento
    //------------------------------------------------------------------------------
	// Ativa/Desativa - Plano de Ação PA111224R
	If lP111224r

        //Autor: Rafael Cruz
        If Type("F1_PVPAGTO") != "U"
            U_PVPGTONF()
        EndIf
    EndIf
    //------------------------------------------------------------------------------
    //Fim- Inclusão de Previsão de Pagamento
 
Restarea(_cArea)
Return

USER FUNCTION CODSB1(_cTipo)

LOCAL _cCod := space(5)
LOCAL aAreaAnt := GETAREA()
Local cArqind := GetNextAlias()
Local cCodIni := _cTipo+'0'
Local cCodFim := _cTipo+'99999'
//Static cMayUse

    //Construindo a consulta
    BeginSql Alias cArqind
        //COLUMN CAMPO AS DATE //Deve se usar isso para transformar o campo em data
		SELECT CODIGO
		FROM (
        SELECT  
		SB1.B1_COD AS CODIGO 
        FROM
            %table:SB1% SB1 
        WHERE
            SB1.B1_FILIAL  = %xFilial:SB1%
            AND SB1.D_E_L_E_T_<>'*'
			AND SB1.B1_COD BETWEEN %exp:cCodIni% and %exp:cCodFim%
			ORDER by CODIGO DESC
		)
		WHERE ROWNUM <= 1
		
    EndSql

IF !empty((cArqind)->CODIGO) 
	_cCod:= _cTipo+StrZero(val(substr(alltrim((cArqind)->CODIGO),3,5))+1,5)
	cMay := xFilial("SB1")+padr(_cCod,TamSX3("B1_COD")[1])
	FreeUsedCode()
	SB1->(DbSetOrder(1))
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Se dois orcamentos iniciam ao mesmo tempo a MayIUseCode impede que ambos utilizem o mesmo numero.�
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	nTent := 0
	While SB1->(DbSeek(cMay)) .OR. !MayIUseCode(cMay)
		If ++nTent > 20
			Final("Impossivel gerar numero sequencial de produto correto. Informe ao administrador do sistema.")  //
		EndIf
		_cCod:= _cTipo+StrZero(val(substr(alltrim(_cCod),3,5))+1,5)
		_cCod:= padr(_cCod,TamSX3("B1_COD")[1])
		FreeUsedCode()
		cMay := xFilial("SB1")+_cCod
	End
	
	ELSE 
	_cCod:= _cTipo+'00001'
ENDIF

M->B1_COD:=_CCOD
dbCloseArea()
RESTAREA(aAreaAnt)   // Retorna o ambiente anterior
RETURN(_CCOD)

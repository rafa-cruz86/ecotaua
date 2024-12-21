

/*/{Protheus.doc} SA1VALID
(long_description)
@type user function
@author user
@since 19/02/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
/*/
User Function SA1VALID()
	Local _cRet := ""
	Local _lRet := .T.
	Local _Aprovadores := GETMV("DT_APRFINA") // INFORMAR CODIGOS DE USUARIOS QUE PODERÃO APROVAR O CADSTRO DO CLIENTE.

	if FwFldGet('A1_XFINANC')=='3'

		IF RetCodUsr()$ALLTRIM(_Aprovadores)
			_cRet := UsrRetName(RetCodUsr())
			FwFldPut('A1_XUAPROV',_cRet)
		else
			Alert("Somente usuarios autorizados no parametro ('DT_APRFINA') podem aprovar o cadastro.")
             _lRet := .F.
		ENDIF


	ENDIF

Return _lRet

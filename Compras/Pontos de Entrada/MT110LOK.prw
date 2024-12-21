
/*/{Protheus.doc} MT110LOK
Valida SC para verificar se o centro de custo foi informado.
@type function
@version  
@author wilks
@since 19/03/2024
@return variant, return_description
/*/
User Function  MT110LOK()
	Local nPosRat   := 0
	Local nPosCC    := 0
	Local nPosConta := 0
	Local _cConta   := ""
	Local _cCusto   := ""
	Local _cRateio  := ""
	Local lValido := .T.


	// verifica se não está sendo executado por rotina automática para evitar error.log
	if FunName()=="MATA110"

		nPosRat   := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_RATEIO'})
		nPosCC    := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CC'})
		nPosConta := aScan(aHeader,{|x| AllTrim(x[2]) == 'C1_CONTA'})
		_cConta   := ACOLS[N,nPosConta]
		_cCusto   := ACOLS[N,nPosCC]
		_cRateio  := ACOLS[N,nPosRat]

		IF EMPTY(_cConta) .and.  _cRateio=='2' .AND.lValido
			MsgInfo("Favor informar conta contábil para o item","Valida SC")
			lValido := .F.
		ENDIF


		IF EMPTY(_cCusto) .and. _cRateio=='2' .and. lValido
			MsgInfo("Favor informar centro de custo para o item","Valida SC")
			lValido := .F.
		ENDIF

	ENDIF


Return(lValido)


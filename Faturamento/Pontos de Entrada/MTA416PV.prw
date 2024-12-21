User Function MTA416PV()
	Local cArea := GetArea()
	Local _nX := 0

	IF FUNNAME() $ "MATA415/MATA416"
		C5_OBS := SCJ->CJ_OBS
		C5_VEND1 := SCJ->CJ_VEND1
		C5_VEND2 := SCJ->CJ_VEND2

		DbSelectArea("SA1")
		DbSetOrder(1)
		IF DBSEEK(XFILIAL("SA1")+SCJ->CJ_CLIENTE+SCJ->CJ_LOJA)
			C5_NOME := SA1->A1_NOME
		ENDIF

		if SCJ->CJ_VEND1 >' ' .AND. SCJ->CJ_VEND2 >' '

			nPosCom1 :=	ASCAN(_AHEADER,{|X|ALLTRIM(x[2])=="C6_COMIS1"})  
			nPosCom2 :=	ASCAN(_AHEADER,{|X|ALLTRIM(x[2])=="C6_COMIS2"})  

			For _nX:=1 To Len(_ACOLS)

				_nAlqAjust := _ACOLS[_nX,nPosCom1]/2
				
				_ACOLS[_nX,nPosCom1] := _nAlqAjust
				_ACOLS[_nX,nPosCom2] := _nAlqAjust

			next _nX


		ENDIF




	ENDIF



	RestArea(cArea)
Return Nil

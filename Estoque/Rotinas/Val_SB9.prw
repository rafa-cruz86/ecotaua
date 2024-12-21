 /*/{Protheus.doc} Val_SB9
(long_description)
@type  Function
@author user
@since 04/04/2023
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
    /*/
User Function Val_SB9()
	Local aArea      := GetArea()
	Local Ret := .T.
	Local _cProd := ""
	Local _cLoc := ""
	Local _cFilDes := ""
	//Local _nQtd := 0
	Local oModel2 := FwModelActive()
	//Private lMsErroAuto := .F.

	_cProd := oModel2:GetValue( 'NNTDETAIL', 'NNT_PROD')
	_cLoc  := oModel2:GetValue( 'NNTDETAIL', 'NNT_LOCLD')
	//_nQtd  := oModel2:GetValue( 'NNTDETAIL', 'NNT_QUANT')
	_cFilDes  := oModel2:GetValue( 'NNTDETAIL', 'NNT_FILDES')

	DBSELECTAREA( "SB2" )
	DBSETORDER( 1 ) // B2_FILIAL+B2_COD+B2_LOCAL                                                                                                                                       
	IF !DBSEEK(_cFilDes+_cProd+_cLoc)


		RECLOCK( "SB2", .T.)
		SB2->B2_FILIAL  := _cFilDes
		SB2->B2_COD     := _cProd
		SB2->B2_LOCAL   := _cLoc
		SB2->B2_QATU    := 0
		SB2->B2_DMOV	:= DDATABASE
		SB2->B2_HMOV	:= TIME()
		MSUNLOCK()

		RECLOCK( "SB9", .T.)
		SB9->B9_FILIAL  := _cFilDes
		SB9->B9_COD     := _cProd
		SB9->B9_LOCAL   := _cLoc
		SB9->B9_QINI    := 0
		SB9->B9_MCUSTD	:= '1'
		MSUNLOCK()

	ENDIF

RestArea(aArea)
Return Ret

#include "protheus.ch"
#include "topconn.ch"
#Include "TOTVS.ch"

    /*/{Protheus.doc} nomeFunction
(long_description)
@type user function
@author user
@since 15/12/2024
@version version
@param param_name, param_type, param_descr
@return return_var, return_type, return_description
@example
(examples)
@see (links_or_references)
    /*/
User Function SC6InfPrd(_cProd,_cLocProd,_cCtlote,_cNumLote,dDatValid)

	Local infadprod := ""
	Local Codinfo   := ""
	Local dDataFab  := CtoD(Space(8))
	Local _nTam     := 0

	If !Empty(_cCtlote)
		dDataFab  := GetAdvFVal("SB8","B8_DATA",xFilial("SB8")+_cProd+_cLocProd+DTOS(dDatValid)+_cCtlote+_cNumLote,1," ")
		infadprod := "LOT: "+ _cCtlote +"| FAB:"+ DtoC(dDataFab) +"| VAL:"+ DtoC(dDatValid)
		_nTam     := TamSX3("C6_INFAD")[1]

		If INCLUI
			Codinfo := MSMM(,_nTam,,infadprod,1,,,"SC6","C6_INFAD")
		ElseIf ALTERA
			Codinfo := MSMM(SC6->C6_INFAD,_nTam,,infadprod,1,,,"SC6","C6_INFAD")
		EndIf
	EndIf

Return(Codinfo)

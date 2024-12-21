#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} MT140ROT
Adiciona botoes na Pr�-Nota. Executado ap�s MT140ROT
@type     function
@author      Rafael Cruz TOTVS/SP
@since       11/12/2024
/*/
user function MT140ROT()
	Local aRotina    := {} as array
	Local lP111224r  := GetNewPar("PA_111224R", .T.) // Ativa/Desativa Plano de A��0

	//------------------------------------------------------------------------------
	// Ativa/Desativa - Plano de A��o PA111224R
	If lP111224r
		aAdd(aRotina,{"Previs�o Pagamento"   ,"U_PVPGTONF()", 0 , 2} )
	EndIF
	//------------------------------------------------------------------------------

Return(aRotina)

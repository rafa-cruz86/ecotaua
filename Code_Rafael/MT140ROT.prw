#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} MT140ROT
Adiciona botoes na Pré-Nota. Executado após MT140ROT
@type     function
@author      Rafael Cruz TOTVS/SP
@since       11/12/2024
/*/
user function MT140ROT()
	Local aRotina    := {} as array
	Local lP111224r  := GetNewPar("PA_111224R", .T.) // Ativa/Desativa Plano de Açã0

	//------------------------------------------------------------------------------
	// Ativa/Desativa - Plano de Ação PA111224R
	If lP111224r
		aAdd(aRotina,{"Previsão Pagamento"   ,"U_PVPGTONF()", 0 , 2} )
	EndIF
	//------------------------------------------------------------------------------

Return(aRotina)

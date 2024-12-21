#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT103LEG
Ponto de Entrada para inclusão de uma nova legenda na tela de Documento de Entrada (MATA103)
@author Elmer Farias
@since 04/04/21
@version 1.0
	@example
	u_MT103LEG()
/*/

user function MT103LEG ()
	
Local aLegenda := aclone(PARAMIXB[1]) 


    aadd(aLegenda ,{"BR_AZUL_CLARO" , "Pré-Nota devolvida, devido a erro no lançamento."  })


return aLegenda

#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT103LEG
Ponto de Entrada para inclus�o de uma nova legenda na tela de Documento de Entrada (MATA103)
@author Elmer Farias
@since 04/04/21
@version 1.0
	@example
	u_MT103LEG()
/*/

user function MT103LEG ()
	
Local aLegenda := aclone(PARAMIXB[1]) 


    aadd(aLegenda ,{"BR_AZUL_CLARO" , "Pr�-Nota devolvida, devido a erro no lan�amento."  })


return aLegenda

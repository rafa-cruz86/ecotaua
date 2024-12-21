#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT140COR
Ponto de Entrada para inclusão de novas cores de legendas na tela de Pré Doc de Entrada (MATA140)
@author Elmer Farias
@since 04/04/21
@version 1.0
	@example
	u_MT140COR()
/*/

User Function MT140COR 

Local aNewCores := aclone(PARAMIXB[1]) 


ainS(aNewCores,1)

aNewCores[1]:= {'empty(F1_STATUS)  .AND. F1_STATRET=="S" ' , 'BR_AZUL_CLARO' }


	
return aNewCores

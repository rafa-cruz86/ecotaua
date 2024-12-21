#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} MT103COR
Ponto de Entrada para inclusão de novas cores de legendas na tela de Documento de Entrada (MATA103)
@author Elmer Farias
@since 04/04/21
@version 1.0
	@example
	u_MT103COR()
/*/

User Function MT103COR 

Local aCores := aclone(PARAMIXB[1]) 

ains(aCores,1)

aCores[1]:= {'empty(F1_STATUS)  .AND. F1_STATRET=="S" ' , 'BR_AZUL_CLARO' }

	
return aCores

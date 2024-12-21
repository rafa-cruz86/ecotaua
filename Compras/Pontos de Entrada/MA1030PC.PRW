#Include 'Protheus.ch'  

/*{Protheus.doc} MA103OPC
Ponto de Entrada para inclusão de uma nova opção no menu "Outras Ações" da tela de Documento de Entrada (MATA103)
@author Elmer Farias
@since 02/04/21
@version 1.0
	@example
	u_MA103OPC()
/*/

User Function MA103OPC()

Local aRet := {}


aAdd(aRet,{'Retornar Pré-Nota', 'U_RetPren', 0, 5})


Return aRet

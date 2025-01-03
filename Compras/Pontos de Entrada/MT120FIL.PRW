#Include 'Protheus.ch'    // Inclui defini��es e fun��es padr�o do Protheus

/*/{Protheus.doc} MT120FIL
Fun��o utilizada para filtrar registros na rotina MATA121 (Pedido de Compras), restringindo os dados exibidos de acordo com o grupo de compras do usu�rio logado.
@type user function
@author Rafael
@since 10/12/2024
@version 1.0
@param FunName, character, Nome da rotina em execu��o no momento.
@return cFiltraSC7, character, Condi��o de filtro aplicada � consulta de registros na rotina.
@example
// Exemplo de retorno para o grupo de compras "GRP001":
// Retorna "SC7->C7_GRUPCOM == 'GRP001'"
@see https://centraldeatendimento.totvs.com
/*/

User Function MT120FIL()

// Declara��o de vari�veis locais
	Local cFiltraSC7 := " "          // Vari�vel que armazenar� a condi��o de filtro
	Local _cCodUsr   := RetCodUsr()  // Recupera o c�digo do usu�rio logado no Protheus
	Local _cGrpComp  := " "          // Vari�vel que armazenar� o grupo de compras associado ao usu�rio

// Verifica se a fun��o chamada � a rotina MATA121 (Pedido de Compras)
	If Alltrim(Upper(FunName())) == "MATA121"

		// Obt�m o grupo de compras associado ao usu�rio logado
		// GetAdvFVal recupera o valor do campo "Y1_GRUPCOM" na tabela SY1
		// O par�metro xFilial("SY1")+_cCodUsr � usado para localizar o registro correto na tabela SY1
		_cGrpComp := GetAdvFVal("SY1", "Y1_GRUPCOM", xFilial("SY1") + _cCodUsr, 3, "")

		// Define a condi��o de filtro para exibir apenas os registros do grupo de compras do usu�rio
		cFiltraSC7 := "SC7->C7_GRUPCOM == '" + _cGrpComp + "'"

	EndIf

// Retorna a condi��o de filtro que ser� aplicada na rotina
Return(cFiltraSC7)



#Include 'Protheus.ch'    // Inclui definições e funções padrão do Protheus

/*/{Protheus.doc} MT120FIL
Função utilizada para filtrar registros na rotina MATA121 (Pedido de Compras), restringindo os dados exibidos de acordo com o grupo de compras do usuário logado.
@type user function
@author Rafael
@since 10/12/2024
@version 1.0
@param FunName, character, Nome da rotina em execução no momento.
@return cFiltraSC7, character, Condição de filtro aplicada à consulta de registros na rotina.
@example
// Exemplo de retorno para o grupo de compras "GRP001":
// Retorna "SC7->C7_GRUPCOM == 'GRP001'"
@see https://centraldeatendimento.totvs.com
/*/

User Function MT120FIL()

// Declaração de variáveis locais
	Local cFiltraSC7 := " "          // Variável que armazenará a condição de filtro
	Local _cCodUsr   := RetCodUsr()  // Recupera o código do usuário logado no Protheus
	Local _cGrpComp  := " "          // Variável que armazenará o grupo de compras associado ao usuário

// Verifica se a função chamada é a rotina MATA121 (Pedido de Compras)
	If Alltrim(Upper(FunName())) == "MATA121"

		// Obtém o grupo de compras associado ao usuário logado
		// GetAdvFVal recupera o valor do campo "Y1_GRUPCOM" na tabela SY1
		// O parâmetro xFilial("SY1")+_cCodUsr é usado para localizar o registro correto na tabela SY1
		_cGrpComp := GetAdvFVal("SY1", "Y1_GRUPCOM", xFilial("SY1") + _cCodUsr, 3, "")

		// Define a condição de filtro para exibir apenas os registros do grupo de compras do usuário
		cFiltraSC7 := "SC7->C7_GRUPCOM == '" + _cGrpComp + "'"

	EndIf

// Retorna a condição de filtro que será aplicada na rotina
Return(cFiltraSC7)



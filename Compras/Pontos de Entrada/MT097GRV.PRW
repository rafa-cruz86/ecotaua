#Include 'Protheus.ch'

/*/{Protheus.doc} MT097GRV
No inicio da função MaAlcDoc - Após a confirmação da liberação, bloqueio ou estorno do documento de alçada pelo programa MATA097 
(Liberações) e também no final das rotinas de gravação dos processos do compras que possuem alçada.
MATA120- Pedido de Compras, Autorização de Entrega
MATA125 - Contratos de Parceria
MATA103 - Nota Fiscal de Entrada
COMXFUN função MaAvalCot evento 4 na Analise de Cotações ao gerar os pedidos de compras originado de cotações
pode ser usado para diversos fins podendo até interromper a gravação da tabela SCR através do seu retorno .F.
outra aplicação possível é a substituição da rotina de gravação, pela própria do usuário desenvolvida no PE.
@type function
@version  
@author wilks
@since 25/03/2024
@return LOGICO
/*/

User Function MT097GRV()
Local ExpA1 := PARAMIXB[1]
Local ExpD1 := PARAMIXB[2]
Local ExpN1 := PARAMIXB[3]
Local ExpC1 := PARAMIXB[4]
Local ExpL1 := PARAMIXB[5]
Local ExpC2 := PARAMIXB[6]
Local ExpC3 := PARAMIXB[7]
Local ExpC4 := PARAMIXB[8]
Local lRet:= .T.
local _cArea := GetArea()

//Rotina de gravação, se for aprovacao
IF ExpN1==4

    dbselectarea("SCR")
    DBSetOrder(3) // CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV   
    IF MSSEEK(XFILIAL("SCR")+ExpA1[2]+ExpC1+ExpC2)

        RecLock("SCR", .F.)
			SCR->CR_HORA := SUBSTR(TIME(),1,5)
		MsUnLock() //Confirma e finaliza a operação

    ENDIF


restarea(_cArea)
ENDIF





Return(lRet)

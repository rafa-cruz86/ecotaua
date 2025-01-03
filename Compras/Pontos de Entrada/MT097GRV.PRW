#Include 'Protheus.ch'

/*/{Protheus.doc} MT097GRV
No inicio da fun��o MaAlcDoc - Ap�s a confirma��o da libera��o, bloqueio ou estorno do documento de al�ada pelo programa MATA097 
(Libera��es) e tamb�m no final das rotinas de grava��o dos processos do compras que possuem al�ada.
MATA120- Pedido de Compras, Autoriza��o de Entrega
MATA125 - Contratos de Parceria
MATA103 - Nota Fiscal de Entrada
COMXFUN fun��o MaAvalCot evento 4 na Analise de Cota��es ao gerar os pedidos de compras originado de cota��es
pode ser usado para diversos fins podendo at� interromper a grava��o da tabela SCR atrav�s do seu retorno .F.
outra aplica��o poss�vel � a substitui��o da rotina de grava��o, pela pr�pria do usu�rio desenvolvida no PE.
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

//Rotina de grava��o, se for aprovacao
IF ExpN1==4

    dbselectarea("SCR")
    DBSetOrder(3) // CR_FILIAL+CR_TIPO+CR_NUM+CR_APROV   
    IF MSSEEK(XFILIAL("SCR")+ExpA1[2]+ExpC1+ExpC2)

        RecLock("SCR", .F.)
			SCR->CR_HORA := SUBSTR(TIME(),1,5)
		MsUnLock() //Confirma e finaliza a opera��o

    ENDIF


restarea(_cArea)
ENDIF





Return(lRet)

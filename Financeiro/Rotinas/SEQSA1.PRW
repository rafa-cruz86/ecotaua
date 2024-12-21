#INCLUDE "TopConn.CH"
**************************************************************************************************************
User Function SEQSA1CD(cCGC)
**************************************************************************************************************
Local cA1Alias := "TMPSA1"
Local QtdReg   := 0
Local cCod     := ""

If Select(cA1Alias) > 0
   (cA1Alias)->(DbCloseArea())
Endif

BeginSQL Alias cA1Alias
   SELECT A1_FILIAL, SUBSTR(A1_CGC,1,8) CNPJ, (A1_COD) CD, 
      RTRIM(SUBSTR('00',1,2-LENGTH((RTRIM(CAST(CAST(MAX(A1_LOJA) AS INT)+1 AS CHAR(2))))))+(RTRIM(CAST(CAST(MAX(A1_LOJA) AS INT)+1 AS CHAR(2))))) LJ 
   FROM %Table:SA1% A1 
   WHERE A1.%NotDel% AND A1_CGC NOT IN ('') AND A1_FILIAL = %xFilial:SA1%
   AND SUBSTR(A1_CGC,1,8) = SUBSTR(%Exp:cCGC%,1,8)
   GROUP BY A1_FILIAL, SUBSTR(A1_CGC,1,8), A1_COD 
EndSQL

Count to QtdReg

(cA1Alias)->(DbGotop())

if QtdReg > 0
   cCod := RTrim((cA1Alias)-> CD)
Else
   cCod  := GETSXENUM("SA1","A1_COD")
Endif

Return cCod
**************************************************************************************************************

**************************************************************************************************************
User Function SEQSA1LJ(cCGC)
**************************************************************************************************************
Local cA1Alias := "TMPSA1"
Local QtdReg := 0
Local cLoja  := "01"

If Select(cA1Alias) > 0
   (cA1Alias)->(DbCloseArea())
Endif

BeginSQL Alias cA1Alias
   SELECT A1_FILIAL, SUBSTR(A1_CGC,1,8) CNPJ, (A1_COD) CD, 
      RTRIM(SUBSTR('00',1,2-LENGTH((RTRIM(CAST(CAST(MAX(A1_LOJA) AS INT)+1 AS CHAR(2))))))+(RTRIM(CAST(CAST(MAX(A1_LOJA) AS INT)+1 AS CHAR(2))))) LJ 
   FROM %Table:SA1% A1 
   WHERE A1.%NotDel% AND A1_CGC NOT IN ('') AND A1_FILIAL = %xFilial:SA1%
   AND SUBSTR(A1_CGC,1,8) = SUBSTR(%Exp:cCGC%,1,8)
   GROUP BY A1_FILIAL, SUBSTR(A1_CGC,1,8), A1_COD 
EndSQL

Count to QtdReg

(cA1Alias)->(DbGotop())

if QtdReg > 0
   cLoja := strzero(val(alltrim((cA1Alias)->LJ)),2)
Endif

Return cLoja
**************************************************************************************************************

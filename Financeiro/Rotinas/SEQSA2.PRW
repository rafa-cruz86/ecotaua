#INCLUDE "TopConn.CH"
**************************************************************************************************************
User Function SEQSA2CD(cCGC)
**************************************************************************************************************
Local cA2Alias := "TMPSA2"
Local QtdReg   := 0
Local cCd      := ""

If Select(cA2Alias) > 0
   (cA2Alias)->(DbCloseArea())
Endif

BeginSQL Alias cA2Alias
   SELECT A2_FILIAL, SUBSTR(A2_CGC,1,8) CNPJ, (A2_COD) CD, 
      RTRIM(SUBSTR('00',1,2-LENGTH((RTRIM(CAST(CAST(MAX(A2_LOJA) AS INT)+1 AS CHAR(2))))))+(RTRIM(CAST(CAST(MAX(A2_LOJA) AS INT)+1 AS CHAR(2))))) LJ 
   FROM %Table:SA2% A2
   WHERE A2.%NotDel% AND A2_CGC NOT IN ('') AND A2_FILIAL = %xFilial:SA2%
   AND SUBSTR(A2_CGC,1,8) = SUBSTR(%Exp:cCGC%,1,8)
   GROUP BY A2_FILIAL, SUBSTR(A2_CGC,1,8), A2_COD 
EndSQL

Count to QtdReg

(cA2Alias)->(DbGotop())

if QtdReg > 0
   cCd := (cA2Alias)->CD
Else
   cCd  := GETSX8NUM("SA2","A2_COD")
Endif

Return cCd
**************************************************************************************************************

**************************************************************************************************************
User Function SEQSA2LJ(cCGC)
**************************************************************************************************************
Local cA2Alias := "TMPSA2"
Local QtdReg := 0
Local cLoja  := "01"

If Select(cA2Alias) > 0
   (cA2Alias)->(DbCloseArea())
Endif

BeginSQL Alias cA2Alias
   SELECT A2_FILIAL, SUBSTR(A2_CGC,1,8) CNPJ, (A2_COD) CD, 
      RTRIM(SUBSTR('00',1,2-LENGTH((RTRIM(CAST(CAST(MAX(A2_LOJA) AS INT)+1 AS CHAR(2))))))+(RTRIM(CAST(CAST(MAX(A2_LOJA) AS INT)+1 AS CHAR(2))))) LJ 
   FROM %Table:SA2% A2
   WHERE A2.%NotDel% AND A2_CGC NOT IN ('') AND A2_FILIAL = %xFilial:SA2%
   AND SUBSTR(A2_CGC,1,8) = SUBSTR(%Exp:cCGC%,1,8)
   GROUP BY A2_FILIAL, SUBSTR(A2_CGC,1,8), A2_COD 
EndSQL

Count to QtdReg

(cA2Alias)->(DbGotop())

if QtdReg > 0
   cLoja := strzero(val(alltrim((cA2Alias)->LJ)),2)
    
Endif

Return cLoja
**************************************************************************************************************

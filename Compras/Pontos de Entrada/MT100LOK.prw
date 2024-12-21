
/*/{Protheus.doc} MT100LOK
Valida SC para verificar se o centro de custo foi informado.

@type function
@version  
@author wilks
@since 19/03/2024
@return variant, return_description
/*/

User Function MT100LOK()
Local lExecuta  := ParamIxb[1]
LOCAL nPConta   := ASCAN(AHEADER,{|X|TRIM(x[2])=="D1_CONTA"})  
LOCAL nPcc      := ASCAN(AHEADER,{|X|TRIM(x[2])=="D1_CC"})
LOCAL nPrat     := ASCAN(AHEADER,{|X|TRIM(x[2])=="D1_RATEIO"})  
Local _cConta   := ACOLS[N,nPConta]
Local _cCusto   := ACOLS[N,nPcc]
Local _cRateio  := ACOLS[N,nPrat]


IF EMPTY(_cConta) .and.  _cRateio=='2' .AND.lExecuta
    MsgInfo("Favor informar conta contábil para o item","Valida Nf-e")
    lExecuta := .F.
ENDIF


IF EMPTY(_cCusto) .and. _cRateio=='2' .and. lExecuta
    MsgInfo("Favor informar centro de custo para o item","Valida Nf-e")
    lExecuta := .F.
ENDIF

Return (lExecuta)

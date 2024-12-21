#include 'protheus.ch'
#include 'parmtype.ch'

/*{Protheus.doc} IncluiObs
Função que faz alteração de campos na tabela SF1, no retorno da pré nota
@author Elmer Farias
@since 02/04/21
@version 1.0
	@example
	u_IncluiObs()
/*/

User Function IncluiObs (_cObservacao,_oDlg)

Local cCodUsr := RetCodUsr() 
Local cTime := TIME() 

DBSelectArea ("SF1")
dbSetOrder (1)

MSGALERT ("Pré Nota retornada !")

If (DBSEEK(xFilial("SF1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_TIPO))
   RECLOCK ("SF1",.F.)
   SF1->F1_STATRET := 'S'		
   SF1->F1_OBSRET := _cObservacao
   SF1->F1_USERRET := UsrRetName(cCodUsr)
   SF1->F1_DATARET := dToC(DATE()) + Space(1) + cTime

   MsUnLock()
   
   //Se Nota Fiscal Entrada do Tipo: Normal, Devolucao ou Beneficiamento ...
   If AllTrim(SF1->F1_TIPO) $ "N/D/B"
   
      //Encontra Numero Verdadeiro Opcao Excluir no Menu Principal / Botao ‘Acoes Relacionadas‘ ...
      nOpcSF1 := AScan( aRotina, { |x| UPPER(x[1]) == "EXCLUIR" } )   
   
      //Chama Funcao Padrao Estorno Classificacao ...   
       A103NFiscal("SF1",SF1->(RecNo()),nOpcSF1,.F.,.T.)
   
   EndIf

EndIf
 
_oDlg:end()

Return

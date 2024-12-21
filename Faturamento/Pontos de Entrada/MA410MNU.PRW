//#Include "Rwmake.ch"
#Include "Protheus.ch"
//#Include "RPTDEF.CH"
//#Include "FWPrintSetup.ch"
/*******************************************************************************************************************\
| Programa  | MA410MNU		| Autor | wiLK lIMA		                                        | Data | 25/08/2022 |
|***********|*******************************************************************************************************|
  Descricao | Ponto de entrada disparado antes da abertura do Browse, caso Browse inicial da rotina esteja          
            | habilitado, ou antes da apresentação do Menu de opções, caso Browse inicial esteja desabilitado.      
            | Para habilitar ou desabilitar o Browse, entre na rotina, clique em Configurações/Browse Inicial e     
            | selecione a opção desejada:
            | Sim - Habilitar Browse Inicial
            | Não - Desabilitar Browse Inicial 
            | Este ponto de entrada pode ser utilizado para inserir novas opções no array aRotina.
\*******************************************************************************************************************/
*********************************************************************************************************************
User Function MA410MNU()
*********************************************************************************************************************
//Local aRot2 := {}


aadd(aRotina,{"Impressão A4"  ,'U_Orcam_C5()'  , 0 , 2,0,NIL})
aadd(aRotina,{"Nf-e Sefaz"  ,'SPEDNFE()'  , 0 , 2,0,NIL})
aadd(aRotina,{"Boletos"  ,'U_VIIABOLFIN()'  , 0 , 2,0,NIL})

Return
*********************************************************************************************************************

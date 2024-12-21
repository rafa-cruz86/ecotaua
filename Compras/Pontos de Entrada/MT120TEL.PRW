//Bibliotecas
#Include "Protheus.ch"
  
 /*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MT120TEL                                                                                              |
 | Desc:  Ponto de Entrada para adicionar campos no cabeçalho do pedido de compra                               |
 | Link:  http://tdn.totvs.com/display/public/mp/MT120TEL                                                       |
 *--------------------------------------------------------------------------------------------------------------*/
 
User Function MT120TEL()
    Local aArea     := GetArea()
    Local oDlg       
    Local aPosGet   
    Local nOpcx    
    Local nRecPC    
    Local lEdit     
    Local oXObsAux
    Public cXObsAux := ""
 
    IF FunName()=="MATA121"
    oDlg      := PARAMIXB[1] 
    aPosGet   := PARAMIXB[2]
    nOpcx     := PARAMIXB[4]
    nRecPC    := PARAMIXB[5]
    lEdit := IIF(nOpcx == 3 .Or. nOpcx == 4 .Or. nOpcx ==  9, .T., .F.) //Somente será editável, na Inclusão, Alteração e Cópia

    //Define o conteúdo para os campos
    SC7->(DbGoTo(nRecPC))
    If nOpcx == 3
        cXObsAux := CriaVar("C7_CARTAO",.F.)
    Else
        cXObsAux := SC7->C7_CARTAO
    EndIf
 
    //Criando na janela o campo OBS
    @ 062, aPosGet[1,08] - 012 SAY Alltrim(RetTitle("C7_CARTAO")) OF oDlg PIXEL SIZE 050,006
    @ 061, aPosGet[1,09] - 006 MSGET oXObsAux VAR cXObsAux SIZE 50, 006 OF oDlg COLORS 0, 16777215  PIXEL F3 "SA6CAR"
    oXObsAux:bHelp := {|| ShowHelpCpo( "C7_CARTAO", {GetHlpSoluc("C7_CARTAO")[1]}, 5  )}
 
    //Se não houver edição, desabilita os gets
    If !lEdit
        oXObsAux:lActive := .F.
    EndIf
    endif
    RestArea(aArea)
Return
  
/*--------------------------------------------------------------------------------------------------------------*
 | P.E.:  MTA120G2                                                                                              |
 | Desc:  Ponto de Entrada para gravar informações no pedido de compra a cada item (usado junto com MT120TEL)   |
 | Link:  http://tdn.totvs.com/pages/releaseview.action?pageId=6085572                                          |
 *--------------------------------------------------------------------------------------------------------------*/
  
User Function MTA120G2()
    Local aArea := GetArea()
 

     IF FunName()=="MATA121"
    //Atualiza a descrição, com a variável pública criada no ponto de entrada MT120TEL
    SC7->C7_CARTAO := cXObsAux
    endif

    RestArea(aArea)
Return

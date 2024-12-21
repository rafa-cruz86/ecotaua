#Include "Protheus.ch"

//#Define STR_PULA	Chr(13)+Chr(10)

/*{Protheus.doc} RetPren
Função que inclui tela para inclusão de observação colocada no retorno da pré nota 
@author Elmer Farias
@since 02/04/21
@version 1.0
	@example
	u_RetPren()
/*/

User Function RetPren

    Local aArea := GetArea()

	Private oSayObs, oGetObs
    Private oBtnConf
    Private oFont10N := TFont():New("Arial",10,10,,.T.,,,,,.F.,.F.)

    Public cObservacao := Space(100)
    Public oDlgPvt

        DEFINE MSDIALOG oDlg TITLE "Retorno de Pré Nota" From 0,0 To 167, 500 OF oMainWnd PIXEL//128
        DEFINE FONT oFnt NAME "Arial" Size 10,15
        
        @ 08, 005 SAY "Observação" OF oDlg PIXEL Size 60,50 FONT oFont10N // OemToAnsi()
        @ 23, 005 MSGET cObservacao Picture "@!" SIZE 230,10 Of oDlg PIXEL 

        @ 50,90 BUTTON "Confirmar"  OF oDlg PIXEL Size 50,20 FONT oFont10N ACTION u_IncluiObs(cObservacao,oDlg)
      //  @ 50,60 BUTTON "Cancelar"   OF oDlg PIXEL Size 30,12 ACTION oDlg:End()      

    ACTIVATE MSDIALOG oDlg CENTERED 
    
	RestArea(aArea)
Return


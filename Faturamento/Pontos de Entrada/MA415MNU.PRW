#include "Protheus.Ch"

/*/{Protheus.doc} MA415MNU
Adicionar rotinas na rotina de orçamento.
@type function
@version  
@author Wilk Lima
@since 17/03/2022
@return variant, return_description
/*/
USER FUNCTION MA415MNU()

	aadd(aRotina,{'Aprovar Orçamento','U_BxOrcCL()', 0 , 4,0,NIL})  // Efetivar Orçamento para geração de PV.
	//aadd(aRotina,{'Gerar Contrato GCT','U_CN300AUTO()', 0 , 4,0,NIL}) // Gerar pre-contrato de venda no modulo GCT.

RETURN



// Chamar função de inclusão de baixa de orçamento.
User Function BxOrcCL()
	LOCAL nReg := Recno()
	Local cAlias   := Alias()

	PRIVATE aHeadC6:= {}
	PRIVATE aHeadD4:= {}

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader do SC6                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aHeadC6 := {}
	dbSelectArea("SX3")
	dbSetOrder(1)
	MsSeek("SC6",.T.)
	While ( !Eof() .And. (SX3->X3_ARQUIVO == "SC6") )
		If (  ((X3Uso(SX3->X3_USADO) .And. ;
				!( Trim(SX3->X3_CAMPO) == "C6_NUM" ) .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDEMP"  .And.;
				Trim(SX3->X3_CAMPO) != "C6_QTDENT") .And.;
				cNivel >= SX3->X3_NIVEL) .Or.;
				Trim(SX3->X3_CAMPO)=="C6_NUMORC" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_NUMOP"  .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_ITEMOP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OP" .Or. ;
				Trim(SX3->X3_CAMPO)=="C6_OPC" )
			Aadd(aHeadC6,{TRIM(X3Titulo()),;
				SX3->X3_CAMPO,;
				SX3->X3_PICTURE,;
				SX3->X3_TAMANHO,;
				SX3->X3_DECIMAL,;
				If(Trim(SX3->X3_CAMPO)=="C6_NUMORC",".F.",SX3->X3_VALID),;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT } )
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Monta aHeader do SD4                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SX3")
		dbSetOrder(1)
		MsSeek("SD4")
		While ( !Eof() .And. SX3->X3_ARQUIVO == "SD4" )
			If ( X3Uso(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL )
				Aadd(aHeadD4,{ Trim(X3Titulo()),;
					SX3->X3_CAMPO,;
					SX3->X3_PICTURE,;
					SX3->X3_TAMANHO,;
					SX3->X3_DECIMAL,;
					SX3->X3_VALID,;
					SX3->X3_USADO,;
					SX3->X3_TIPO,;
					SX3->X3_ARQUIVO,;
					SX3->X3_CONTEXT })
			EndIf
			dbSelectArea("SX3")
			dbSkip()
		EndDo

    INCLUI := .F. // Forcado para compatibilizacao
	A415Baixa(cAlias,nReg,1) // funcao que chama a rotina de baixa do orcamento
//RestArea(aArea)       
		Return

#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} SD1100I
Atualiza campo A5_TE com ultima TES usada na classificação
@type function
@version  
@author wilks
@since 19/03/2024
@return variant, return_description
/*/

User Function SD1100I()
	Local ExpL1	:= PARAMIXB[1]  //Conhecimento de Frete
	Local ExpL2	:= PARAMIXB[2]	//Conhecimento de Importacao.
	Local ExpN1	:= PARAMIXB[3]	//operacao


	IF ExpN1==2 .AND. ExpL1==.F. .AND. ExpL2==.F. .AND. SD1->D1_TES>''
		DbSelectArea("SA5")
		DbSetOrder(2)
//A5_FILIAL+A5_PRODUTO+A5_FORNECE+A5_LOJA 
		If DbSeek(XFILIAL("SA5")+SD1->D1_COD+SD1->D1_FORNECE+SD1->D1_LOJA)	//se já existir um registro só atualiza.
			RecLock("SA5", .F.)
			SA5->A5_TE := SD1->D1_TES // Atualiza Produto x Fornecedor com ultima TES usada na classificação.
			MsUnLock() //Confirma e finaliza a operação
		else// senao grava um novo registro
			RecLock("SA5", .T.)
			SA5->A5_FILIAL	    := XFILIAL("SD1")
			SA5->A5_FORNECE	:= SD1->D1_FORNECE
			SA5->A5_LOJA	    := SD1->D1_LOJA
			SA5->A5_NOMEFOR	:= POSICIONE("SA2",1,XFILIAL("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_NOME")
			SA5->A5_PRODUTO	:= SD1->D1_COD
			SA5->A5_NOMPROD	:= POSICIONE("SB1",1,XFILIAL("SB1")+SD1->D1_COD,"B1_DESC")
			SA5->A5_QUANT01	:= SD1->D1_QUANT
			SA5->A5_DTCOM01	:= SD1->D1_EMISSAO
			SA5->A5_TE		    := SD1->D1_TES
			MsUnLock() //Confirma e finaliza a operação
		EndIf


	ENDIF


Return Nil

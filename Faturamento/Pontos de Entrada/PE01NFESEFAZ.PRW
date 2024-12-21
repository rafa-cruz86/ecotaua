#include "protheus.ch"
#include "topconn.ch"
#Include "TOTVS.ch"

#Define ENTER  Chr(10) + Chr (13) // SALTO DE LINHA (CARRIAGE RETURN + LINE FEED)

User Function PE01NFESEFAZ()

	Local aProd     := PARAMIXB[1]
	Local cMensCli  := PARAMIXB[2]
	Local cMensFis  := PARAMIXB[3]
	Local aDest     := PARAMIXB[4]
	Local aNota     := PARAMIXB[5]
	Local aInfoItem := PARAMIXB[6]
	Local aDupl     := PARAMIXB[7]
	Local aTransp   := PARAMIXB[8]
	Local aEntrega  := PARAMIXB[9]
	Local aRetirada := PARAMIXB[10]
	Local aVeiculo  := PARAMIXB[11]
	Local aReboque  := PARAMIXB[12]
	Local aNfVincRur:= PARAMIXB[13]
	Local aEspVol   := PARAMIXB[14]
	Local aNfVinc   := PARAMIXB[15]
	Local AdetPag   := PARAMIXB[16]
	Local aObsCont  := PARAMIXB[17]
	Local aProcRef  := PARAMIXB[18]
	Local aRetorno  := {}
	Local nTipoDoc := 4

// Nota Fiscal de Saida
	If aNota[nTipoDoc] == "1"

		//Poscionemanto nas tabelas

		DbSelectArea("SC5")
		DbsetOrder(1)
		IF MsSeek(xFilial("SC5") + SD2->D2_PEDIDO )
			cMensCli += ENTER 
			cMensCli += SC5->C5_OBS
			cMensCli += ENTER 


			DbSelectArea("SA3")
			DbsetOrder(1)
			IF MsSeek(xFilial("SA3") + SC5->C5_VEND1 )
				cMensCli += "Representante comercial: "+ALLTRIM(A3_NOME)
            cMensCli += ENTER 
			ENDIF

		ENDIF
	Endif

	aadd(aRetorno,aProd)
	aadd(aRetorno,cMensCli)
	aadd(aRetorno,cMensFis)
	aadd(aRetorno,aDest)
	aadd(aRetorno,aNota)
	aadd(aRetorno,aInfoItem)
	aadd(aRetorno,aDupl)
	aadd(aRetorno,aTransp)
	aadd(aRetorno,aEntrega)
	aadd(aRetorno,aRetirada)
	aadd(aRetorno,aVeiculo)
	aadd(aRetorno,aReboque)
	aadd(aRetorno,aNfVincRur)
	aadd(aRetorno,aEspVol)
	aadd(aRetorno,aNfVinc)
	aadd(aRetorno,AdetPag)
	aadd(aRetorno,aObsCont)
	aadd(aRetorno,aProcRef)

RETURN aRetorno

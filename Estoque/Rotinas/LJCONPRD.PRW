#Include "Protheus.ch"
#include "TopConn.ch"
#INCLUDE "COLORS.CH"
#include "TOTVS.CH"
#include "rwmake.ch"
#DEFINE DS_MODALFRAME 128

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  LJCONPRD   º Autor João Felipe Costa Braga Data ³ 05.02.2021 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDescricao ³ CONSULTA DE PRODUTOS PERSONALIZADA 					    º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß

 User Function LJCONPRD(_cPesq,_nTip)
	Private _lOk
	Private oVerde	  := LoadBitMap(GetResources(), "BR_VERDE")
	Private oVermelho := LoadBitMap(GetResources(), "BR_VERMELHO")
	Private oAzul  	  := LoadBitMap(GetResources(), "BR_AZUL")
	Private _aDados := {}
	Private _aDados2 := {}
	Private	_nTotOrc := 0
	Private	_nqtd := 0
	Private oDados
	Private oDados2
	Private oProd
	Private oBitMap
	Private _cTitulo := "Consulta Produto "
	Private _aHeader := {}
	Private _aHead2 := {}
	Private _oProd
	Private cProd := SPACE(250)
	Private cProd2 := SPACE(250)
	private aSize := {}
	private cMemo := ""
	private oMemo
	private oLayout1
	private cProduto := SPACE(15)
	private _cNomFot := ""
	Private _nTabExtra := SUPERGETMV( "MV_TBEXTRA", .F., 6 )

	if empty(_cPesq) .and. FUNNAME() == "LOJA701"
		return .T.
	endif

	DEFINE FONT oFont1 NAME "Arial" SIZE 0,20 BOLD

	//OBTEM OS DADOS DA CONSULTA INICIAL, CASO VENHA DO ORÇAMENTO
	_aDados := AtualizaLista(_cPesq,_nTip)

//	IF EMPTY(_aDados[1,2]) .and.  FUNNAME() == "LOJA701"
//		return .t.
//	ENDIF
	//OBTEM AS DIMENSOES DO MONITOR DO USUARIO
	aSize := MsAdvSize()

	DEFINE MSDIALOG oProd TITLE OemToAnsi(_cTitulo)  FROM aSize[7],0 To aSize[6],aSize[5] PIXEL OF oMainWnd
	oPanel := TPanel():New(30,0,'',oProd,, .T., .T.,, ,315,20,.T.,.T. )
	@003,012 BUTTON "Selecionar" SIZE 060, 015 PIXEL OF oPanel ACTION (funcao1())
	//@003,090 BUTTON "Consultar Ultimas Vendas" SIZE 180, 015 PIXEL OF oPanel ACTION (funcao2())
	//@003,280 BUTTON "Historico de Preço" SIZE 180, 015 PIXEL OF oPanel ACTION (funcao3())
	oLayout1:= tGridLayout():New(oProd,CONTROL_ALIGN_ALLCLIENT,0,0)

	//MAXIMIZA A TELA
	oProd:lMaximized := .T.

	oFont  := TFont():New("Courier New",7,20,,.F.,,,,.T.,.F.)

	// CARREGA A GRID DE FORMA DIFERENTE DEPENDENDO DO NIVEL DE USUARIO
	if cNivel > 0
		getLBG() // cria grid 1
		getLBG2() // cria grid 2
		UpdLBG() // preenche informações dos grids 1 e 2
	endif

	//CRIA O CAMPO MEMO
	oMemo := tMultiget():new( 0, 0, {| u | if( pCount() > 0, cMemo := u, cMemo ) }, ;
		oLayout1, 0, 0, oFont, , , , , .F.,,.F.,,,.T. )
	oMemo:Disable()

	//CRIA O CAMPO IMAGEM
//	oBitMap := TBitmap():new(0,0,0,0,nil,,.f.,oLayout1,nil,nil,.f.,.f.,nil,nil,.f.,nil,.t.,nil,.f.)
	oBitMap := TBmpRep():New(0,0,0,0,"PRDPAD",.T.,oLayout1,{||visFoto()})

	oBitMap:lAutoSize := .f.
	oBitMap:lstretch :=.t.
//	oBitMap:SetEmpty()
//	oBitMap:Load(nil,"\system\lgmid.png")

	@ 0,0 MSGET _oProd VAR cProd PICTURE "@!" FONT oFont1 SIZE 0,0 Valid BscDados() OF oLayout1 PIXEL
	_oProd:setfocus()
	_oProd:SetCss("  border-style: solid; border-width: 5px; border-color: black;")

	// configura pintura da TGridLocal
	_cCss:= "QTableView{ alternate-background-color: #f7f7f7; background: #ffffff; selection-background-color: #a9d19f }"
	_cCss+= "QTableView::item:hover { background-color: #ddedd2;font-weight: 400;}"

	// configura pintura do Header da TGrid
	_cCss+= "QHeaderView::section { background-color: qlineargradient(x1:0, y1:0, x2:0, y2:1, stop:0 #ffffff, stop: 0.5 #ffffff, stop: 0.6 #ededed,  stop:1 #ededed); color: black; padding-left: 4px; border: 1px solid #6c6c6c; }"

	oDados:SetCss(_cCss)
	oDados2:SetCss(_cCss)


	oLayout1:addInLayout(_oProd , 1, 1,, 4)
	oLayout1:addInLayout(oDados , 2, 1,,4)
	oLayout1:addInLayout(oBitMap , 4, 1,,1)
	oLayout1:addInLayout(oDados2 , 4, 2,,3)
	oLayout1:addInLayout(oMemo , 4, 4,,4)

	Activate Dialog oProd CENTERED ON INIT (oPanel:Align:=CONTROL_ALIGN_TOP )
	IF FUNNAME() == "LOJA701"

		IF !EMPTY(cProduto)

			nQtd := QtdPrd(PADR(cProduto,TamSX3('LQ_PRODUTO')[01]))
			IF nQtd > 0
				M->LQ_PRODUTO := PADR(cValToChar(nQtd)+"*"+ PADR(cProduto,TamSX3('LQ_PRODUTO')[01]),TamSX3('LR_PRODUTO')[01])
			ENDIF

		ELSE
			M->LQ_PRODUTO := PADR(cProduto,TamSX3('LQ_PRODUTO')[01])
		ENDIF

		Return .T. //!EMPTY(M->LQ_PRODUTO)
	else
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3('B1_COD')[01]))

	ENDIF



RETURN .T.
//FUNCAO RESPONSAVEL POR EXIBIR A FOTO DO PRODUTO E SEU RESPECTIVO ESTOQUE
STATIC FUNCTION ExibeFoto(_cProd)
	_cNomFot := ""



//	_cNomFot :=PADR(ALLTRIM(_cProd),TamSX3('B1_BITMAP')[01])



	//OBTEM A CARACTERISTICA E MARCA DO PRODUTO
	IF !EMPTY(_cProd)

		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DbSeek(XFILIAL("SB1")+PADR(ALLTRIM(_cProd),TamSX3('B1_COD')[01]))

		_cNomFot := SB1->B1_BITMAP

		oBitMap:LoadBmp(_cNomFot)
		oBitMap:lAutoSize := .f.
		oBitMap:lstretch :=.t.

		if !oBitMap:ExistBmp(_cNomFot)

				oBitMap:LoadBmp("SEM_FOTO_IMG")

		endif

		cMemo := "Unidade: "
		cMemo += "Observações Tecnicas: "
		cMemo += ALLTRIM(SB1->B1_OBSERV)+chr(10)
	ELSE
		cMemo := ""
	ENDIF

	cQry := " SELECT B2_FILIAL AS FILIAL,B2_COD AS CODIGO,B2_LOCAL AS ARMAZEM,B2_QATU AS ESTFIS, "
	cQry += " B2_RESERVA AS RESERVA,NNR_DESCRI AS LOCALIZACAO "
	cQry += " FROM "+RetSqlName("SB2")+"  B2,"
	cQry += " "+RetSqlName("NNR")+" NNR   "
	cQry += " WHERE B2.D_E_L_E_T_ <>'*' AND NNR.D_E_L_E_T_ <>'*'   "
	cQry += "  AND B2_FILIAL=NNR_FILIAL "
	cQry += "  AND B2_LOCAL=NNR_CODIGO "
	cQry += "  AND B2_COD = '"+_cProd+"'  "
	//cQry += " AND B2_LOCAL = '01'  "
	cQry += " ORDER BY B2_FILIAL,B2_LOCAL "

	dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry), "_TMP3", .t.)

	_nLinha2 := 0
	_aDados2 := {}
	Do While _TMP3->(!EoF())
		_nLinha2++

		//CASO O ESTOQUE DO PRODUTO SEJA ZERO, ADICIONA A LEGENDA VERMELHA A LINHA
		IF _TMP3->ESTFIS <= 0
			_ret := 1
		ELSE
			_ret := 3
		ENDIF

		//PREEENCHE AS INFORMACOES 

	  //aadd(_aDados2,{1,0,0,0,"",""})
			aadd(_aDados2,{_ret,; 						// 1
			_TMP3->ESTFIS,;								// 2
			_TMP3->RESERVA,;							// 3
			_TMP3->ESTFIS-_TMP3->RESERVA,;				// 4
			FWFilName ( cEmpAnt , _TMP3->FILIAL ),;		// 5
			_TMP3->LOCALIZACAO,;						// 6
			_TMP3->ARMAZEM,;						    // 7
			_TMP3->FILIAL})						        // 8

		_TMP3->( dbSkip() )
	EndDo
	_TMP3->(DbCloseArea())



	//PREENCHE E ATUALIZA a grid

		IF _nLinha2 == 0
			aadd(_aDados2,{1,0,0,0,"","","",""})
		ENDIF
		UpdLBG() // FUNCAO RESPONSAVEL POR ATUALIZAR A GRID 1 E 2


	oBitMap:Refresh()
	oMemo:Refresh()
return()


//FUNCAO RESPONSAVEL POR PESQUISAR O PRODUTO
Static Function BscDados()
	IF !EMPTY(cProd) .AND. cProd != cProd2
		AtualizaLista() // pesquisa sql e retorna array com dados
		oDados:Refresh()
		oProd:Refresh()
		cProd2 := cProd
	ENDIF
Return .T.


//FUNCAO RESPONSAVEL POR EXECUTAR A PESQUISA NO BANCO DE DADOS
//DE ACORDO COM AS INFORMAÇÕES PASSADAS PELO USUARIO
Static Function AtualizaLista(_cPesq,_nTip)
	Local i 	:= 0
	//Local _lIpi := .F.
	_aDados   := {}
	_nqtd++
	_nLinha := 0


	IF !EMPTY(_cPesq)
		cProd := PADR(_cPesq,250)
		_cPesq := ""
	ENDIF

	//REALIZA A PESQUISA CASO O USUARIO TENHA PREENCHIDO ALGUMA INFOMRACAO
	IF !EMPTY(cProd)
		cQry := " SELECT B1_COD AS CODIGO,B1_DESC AS DESCRICAO, B1_IPI AS IPI, B1_UM AS UNIDADE, B1_SEGUM UNIDADE2, BM_DESC AS GRUPO "
		cQry += " FROM "+RetSqlName("SB1")+" B1,  "
		cQry += " "+RetSqlName("SBM")+" BM  "
		cQry += " WHERE B1.D_E_L_E_T_<>'*' AND BM.D_E_L_E_T_<>'*' AND B1_MSBLQL <> '1'  "
		cQry += " AND B1_GRUPO=BM_GRUPO  "
		if FUNNAME() == "LOJA701"
			cQry += " AND B1_TIPO ='ME' "
		endif
		cQry += "  AND ( "
		nProd := VAL(cProd)
		cProd2 := cValToChar(nProd)

		IF (nProd == 0 .OR. len(cProd2) !=  LEN(ALLTRIM(cProd)))
			cQry += " CONCAT(B1_COD,B1_DESC) LIKE '%"+STRTRAN(ALLTRIM(cProd)," ","%")+"%' "
		ELSE
			cQry += " B1_COD = '"+ALLTRIM(cProd)+"' "
		ENDIF
		cQry += " ) "
		cQry += " ORDER BY B1_DESC "

		dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry), "_TMP", .t.)

		Do While _TMP->(!EoF())
			_nLinha++
			aEstoque := {}

			cQry2 := " SELECT B2_FILIAL , B2_QATU , (B2_QEMP+B2_RESERVA) AS B2_RESERVA   "
			cQry2 += " FROM "+RetSqlName("SB2")+" B2  "
			cQry2 += " WHERE B2.D_E_L_E_T_<>'*' AND B2_QATU>0 AND B2_COD = '"+_TMP->CODIGO+"' "
			cQry2 += " ORDER BY B2_FILIAL "
			dbUseArea(.t., "TOPCONN", TcGenQry(,,cQry2), "_TMP2", .t.)

			Do While _TMP2->(!EoF())

				IF _TMP2->B2_FILIAL == "0101"
					aadd(aEstoque,{"0101",_TMP2->B2_QATU,_TMP2->B2_RESERVA})
				ELSEIF _TMP2->B2_FILIAL == "0102"
					aadd(aEstoque,{"0102",_TMP2->B2_QATU,_TMP2->B2_RESERVA})
				ELSEIF _TMP2->B2_FILIAL == "0103"
					aadd(aEstoque,{"0103",_TMP2->B2_QATU,_TMP2->B2_RESERVA})
				ELSEIF _TMP2->B2_FILIAL == "0104"
					aadd(aEstoque,{"0104",_TMP2->B2_QATU,_TMP2->B2_RESERVA})
				ENDIF

				_TMP2->( dbSkip() )

			EndDo
			_TMP2->(DbCloseArea())

			//VERIFICA SE EXISTE ESTOQUE NA FILIAL LOGADA PELO USUARIO
			_nEstoque := 0
			_nReserva := 0
			_bEstFil  := .F.
			_nResFil  := 0
      		_nEstFil  := 0
			For i := 1 to len(aEstoque)
				
				IF aEstoque[i,1] == XFILIAL("SL1")
					_nResFil := aEstoque[i,3]
      				_nEstFil  := aEstoque[i,2]
					if 	(aEstoque[i,2] - aEstoque[i,3]) > 0
					_bEstFil := .T.
					endif
				ENDIF

				_nEstoque += aEstoque[i,2] - aEstoque[i,3]
				_nReserva += aEstoque[i,3]
			Next

			//CASO NAO TENHA ESTOQUE, ADICIONA A LEGENDA VERMELHA
			IF _nEstoque <= 0 .and. _nReserva <= 0
				_ret := 1
			ENDIF
			//CASO TENHA ESTOQUE APENAS EM OUTRA FILIAL, ADICIONA A LEGENDA AZUL
			IF _nEstoque > 0 .or. _nReserva > 0
				_ret := 2
			ENDIF
			//CASO TENHA ESTOQUE NA FILIAL LOGADA, ADICIONA A LEGENDA VERDE
			IF _bEstFil
				_ret := 3
			ENDIF
					

			//IF cNivel > 0
				aadd(_aDados,{_ret,;										// 1
				ALLTRIM(_TMP->CODIGO),;										// 2
				ALLTRIM(_TMP->DESCRICAO),;									// 3
				ALLTRIM(_TMP->UNIDADE),;									// 4
				ALLTRIM(_TMP->UNIDADE2),;									// 5
				ALLTRIM(_TMP->GRUPO)})										// 6
			//ENDIF

			_TMP->( dbSkip() )

		EndDo
		_TMP->(DbCloseArea())

	ENDIF


		IF _nLinha == 0
			aadd(_aDados,{1,"","","","",""}) // 6 POSIÇÕES
		ENDIF
		aadd(_aDados2,{1,0,0,0,"","","",""})

		IF _nqtd > 1
			oDados:nAt := 1
			oDados2:nAt := 1

			UpdLBG() // FUNCAO RESPONSAVEL POR ATUALIZAR A GRID 1 E 2
			ExibeFoto(_aDados[oDados:nAt,2])
		ENDIF


Return _aDados


//LEGENDA DA GRID 1
Static Function Legenda()
	Local aCores     := {}
	aAdd(aCores,{"BR_VERMELHO"	,"Sem estoque"})
	aAdd(aCores,{"BR_AZUL"		,"Em estoque em outra filial "})
	aAdd(aCores,{"BR_VERDE"	,"Em estoque na sua filial"})
	BrwLegenda("Legenda","Legenda",aCores)
Return


//FUNCAO RESPONSAVEL POR ORDENAR A GRID 1 DE ACORDO COM O CLICK DO USUARIO NO HEADER
Static Function MudaOrd(nCol)
	aSort(_aDados,,,{|X,Y| x[nCol] < y[nCol]})
	ExibeFoto(_aDados[oDados:nAt,2])
return




// FUNCAO RESPONSAVEL POR CRIAR A GRID 
Static Function getLBG()
	AAdd(_aHeader," ")			 // 1
	AAdd(_aHeader,"Código")		 // 2
	AAdd(_aHeader,"Descrição")	 // 3
	AAdd(_aHeader,"Un") 		 // 4
	AAdd(_aHeader,"2º Un")	 	 // 5
	AAdd(_aHeader,"Grupo")	 	 // 6


	@ 0,0 ListBox oDados Fields ;
		HEADER _aHeader[1],_aHeader[2],_aHeader[3],_aHeader[4],_aHeader[5],_aHeader[6];
		Size 0,0 Of oLayout1 Pixel;
		ColSizes 6,40,400,30,30,100  // 6 posições
	oDados:oFont := oFont
	oDados:bChange   := {|| ExibeFoto(_aDados[oDados:nAt,2]) }
	oDados:bGotFocus := {|| ExibeFoto(_aDados[oDados:nAt,2]) }
	oDados:bLDBLCLICK := {||  cProduto := _aDados[oDados:nAt,2],_lOk := .t. ,oProd:end()  }
	oDados:bRClicked := {|| Legenda()  }

	oDados:bHeaderClick := {|oObj,nCol| MudaOrd(nCol),oPROD:Refresh() }

Return

/*/ posições do array

	Legenda			 // 1
	Código			 // 2
	Descrição		 // 3
	Unidade			 // 4
	2 Unidade		 // 5
	Grupo			 // 6
/*/


/*
		LEGENDA      01
		ESTOQUE      02
		RESERVADO    03
		DISPONIVEL   04
		NOME EMPRESA 05
		LOCALIZACAO  06
		NOME LOCAL   07
*/

// FUNCAO RESPONSAVEL POR CRIAR A GRID 2 

Static Function getLBG2()
	AAdd(_aHead2," ")			// 1
	AAdd(_aHead2,"Estoque")		// 2
	AAdd(_aHead2,"Reserva")		// 3
	AAdd(_aHead2,"Disponivel")	// 4
	AAdd(_aHead2,"Nome Empresa")// 5
	AAdd(_aHead2,"Localizacao")	// 6
	AAdd(_aHead2,"Armazem")     // 7
	AAdd(_aHead2,"Filial")      // 8

	@ 0,0 ListBox oDados2 Fields ;
		HEADER _aHead2[1],_aHead2[2],_aHead2[3],_aHead2[4],_aHead2[5],_aHead2[6],_aHead2[7],_aHead2[8];
		Size 0,0 Of oLayout1 Pixel;
		ColSizes 10,30,35,40,70,45,10,10
	oDados2:oFont := oFont
	oDados2:bLDBLCLICK := {||  VisReser(_aDados[oDados:nAt,2],_aDados2[oDados2:nAt,7],_aDados2[oDados2:nAt,8])  }

Return


/*
		LEGENDA      01
		ESTOQUE      02
		RESERVADO    03
		DISPONIVEL   04
		Cod Barra    05
		NOME EMPRESA 06
		Localização  07

*/

// FUNCAO RESPONSAVEL POR ATUALIZAR A GRID 1 E 2 

Static Function UpdLBG()

	oDados:SetArray(_aDados)
	oDados:bLine := {|| {iif(_aDados[oDados:nAt,1]=2,oAzul,iif(_aDados[oDados:nAt,1]=1,oVermelho,oVerde)),;
		_aDados[oDados:nAt,2],;
		_aDados[oDados:nAt,3],;
		_aDados[oDados:nAt,4],;
		_aDados[oDados:nAt,5],;
		_aDados[oDados:nAt,6]}}
		

	oDados2:SetArray(_aDados2)
	oDados2:bLine := {|| {iif(_aDados2[oDados2:nAt,1]=2,oAzul,iif(_aDados2[oDados2:nAt,1]=1,oVermelho,oVerde)),;
		_aDados2[oDados2:nAt,2],;
		_aDados2[oDados2:nAt,3],;
		_aDados2[oDados2:nAt,4],;
		_aDados2[oDados2:nAt,5],;
		_aDados2[oDados2:nAt,6],;
		_aDados2[oDados2:nAt,7],;
		_aDados2[oDados2:nAt,8]}}

	oDados:Refresh()
	oDados2:Refresh()
	oProd:Refresh()

Return

static function visFoto()
	DEFINE DIALOG oDlgImg TITLE "Imagem" FROM aSize[7],0 To aSize[6],aSize[5] PIXEL

	// Usando o New
	oTBitmap1 := TBmpRep():New(0,0,aSize[6],aSize[5],"",.T.,oDlgImg)

	oBitMap:lAutoSize := .f.
	oBitMap:lstretch :=.t.

	oTBitmap1:LoadBmp(_cNomFot)

	ACTIVATE DIALOG oDlgImg CENTERED
Return


Static Function QtdPrd(cProduto)
	cQtd := "1       "
	DBSELECTAREA("SB1")
	DBSETORDER(1)
	IF SB1->(DbSeek(xFilial("SB1")+cProduto))
		@ 200,1 to 250,210 dialog Ofovb TITLE oemtoansi("Informe a quantidade")
		iw_say(30,10,"Qtd:")
		@ 010,010 Get cQtd PICTURE "@!" SIZE 50,50
		@ 010,080 BMPBUTTON TYPE 01 ACTION close(Ofovb)
		ACTIVATE DIALOG Ofovb CENTERED
	ENDIF

Return val(cQtd)


Static Function VisReser(_cProd,_cArm,_cFil)
	Local _aArea := Getarea()
	Private _oDlg
	Private _aFuncs := {}

	cQuery := " SELECT C0_NUM,C0_OBS,C0_QTDORIG,C0_FILIAL,C0_SOLICIT,CONVERT(VARCHAR(10),cast(C0_EMISSAO as date),103) AS EMISSAO, "
	cQuery += " (SELECT TOP 1 L1_HORA FROM "+RETSQLNAME("SL1")+" (NOLOCK) WHERE D_E_L_E_T_ = ' ' AND L1_NUM = SUBSTRING(C0_OBS,8,6) AND L1_FILIAL = SUBSTRING(C0_OBS,22,2)) AS HORA,' ' FILDES "
	cQuery += " FROM "+RETSQLNAME("SC0")+" (NOLOCK) WHERE D_E_L_E_T_ = ' ' AND C0_FILIAL = '"+XFILIAL("SC0")+"' "
	cQuery += " AND C0_PRODUTO = '"+_cProd+"' "
	cQuery += " AND C0_LOCAL = '"+_cArm+"' "

	DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "RESER", .T., .F. )

	DO WHILE !RESER->(Eof())
		aadd(_aFuncs,{ALLTRIM(RESER->C0_NUM),ALLTRIM(RESER->C0_SOLICIT),;
			ALLTRIM(RESER->C0_OBS)+IIF(!EMPTY(RESER->FILDES)," P/ "+FWFilName ( "01" , RESER->FILDES ),""),;
			RESER->C0_QTDORIG,ALLTRIM(RESER->EMISSAO),ALLTRIM(RESER->HORA)})

		RESER->(DbSkip())
	ENDDO

	RESER->(DbCloseArea())


	IF LEN(_aFuncs) > 0

		DEFINE MSDIALOG _oDlg TITLE "Reservas do produto "+_cProd FROM C(269),C(191) TO C(515),C(725) PIXEL STYLE  DS_MODALFRAME OF oMainWnd

		@ C(007),C(008) ListBox oFuncs Fields HEADER "Cod. Reserva","Usuario","Orç/Nfe/Transf","Qtd.","Emissao","Hora";
			Size C(254),C(100) Of _oDlg Pixel ColSizes 50,40,80,30,30,30
		oFuncs:SetArray(_aFuncs)

		oFuncs:bLine := {|| {;
			_aFuncs[oFuncs:nAt,01],;
			_aFuncs[oFuncs:nAt,02],;
			_aFuncs[oFuncs:nAt,03],;
			_aFuncs[oFuncs:nAt,04],;
			_aFuncs[oFuncs:nAt,05],;
			_aFuncs[oFuncs:nAt,06] }}

		ACTIVATE MSDIALOG _oDlg CENTERED

	ELSE
		MsgInfo("Não existem reservas para este produto na filial e armazem selecionados")
	ENDIF

	RESTAREA(_AAREA)
Return



//	Executa Funções do Botão selecionar.
Static Function funcao1()
	cProduto := _aDados[oDados:nAt,2]
	_lOk := .t.
	oProd:end()

return


// Executa Funções do Botão Consultar Ultimas vendas.
Static Function funcao2()
	cProduto := _aDados[oDados:nAt,2]

	// SE NÃO FOR VAZIO EXECUTA.
	iF !EMPTY(cProduto)

		// POSICIONA NO PRODUTO NA SB1
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3("B1_COD")[1]))

		// CHAMA ROTINA DE HISTORICO DE PREÇOS.
		U_HISTVENDA()

	ENDIF

return

//	Executa Funções do Botão Historico de Preços.
Static Function funcao3()
	cProduto := _aDados[oDados:nAt,2]

	// SE NÃO FOR VAZIO EXECUTA.
	iF !EMPTY(cProduto)

		// POSICIONA NO PRODUTO NA SB1
		DBSELECTAREA("SB1")
		DBSETORDER(1)
		DBSEEK(XFILIAL("SB1")+PADR(cProduto,TamSX3("B1_COD")[1]))

		// CHAMA ROTINA DE HISTORICO DE PREÇOS.
		U_HISTPRECO()

	ENDIF


return

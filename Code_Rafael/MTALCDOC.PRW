#Include 'Protheus.ch'    // Inclui defini��es e fun��es padr�o do Protheus

/*/{Protheus.doc} MTALCDOC
A fun��o MTALCDOC ajusta ou insere registros na tabela SCR para atender a regras personalizadas de controle de al�adas, 
garantindo que n�veis superiores no fluxo de aprova��o sejam liberados somente ap�s o "visto" de n�veis intermedi�rios.
@type user function
@author Rafael Cruz TOTVS SP 
@since 10/12/2024
@version 1.0
@param cDoc, Character, N�mero do documento a ser aprovado.
@param cTp, Character, Tipo do documento.
@param nTotDoc, Numeric, Valor total do documento.
@param cGrpApv, Character, Grupo de aprovadores.
@param nMoeda, Numeric, C�digo da moeda do documento.
@param dEmiss, Date, Data de emiss�o do documento.
@return Nil, Nil, A fun��o n�o retorna valores diretos; atualiza registros na tabela SCR.
@example
// Exemplo de chamada
MTALCDOC()
@see https://tdn.totvs.com/display/public/PROT/MTALCDOC
*/


User Function MTALCDOC()
    // Declara��o das vari�veis locais para armazenar os par�metros recebidos
    Local cDoc       := PARAMIXB[1][1]   // N�mero do documento
    Local cTp        := PARAMIXB[1][2]   // Tipo do documento
    Local nTotDoc    := PARAMIXB[1][3]   // Valor total do documento
    Local cGrpApv    := PARAMIXB[1][6]   // Grupo de aprovadores
    Local nMoeda     := PARAMIXB[1][8]   // Moeda do documento
    Local dEmiss     := PARAMIXB[1][10]  // Data de emiss�o do documento
    Local cNvl       := "00"             // N�vel inicial de aprova��o
    Local nLenSCR    := 0                // Controle do tamanho do campo CR_NIVEL
    Local UltNvlApr  := ""               // Vari�vel para armazenar o �ltimo n�vel aprovado

    // Obt�m o tamanho do campo CR_NIVEL na tabela SCR
    nLenSCR := TamSX3("CR_NIVEL")[1]

    // Seleciona a tabela SCR e posiciona no �ndice 2
    DbSelectArea("SCR")
    SCR->(DbSetOrder(2))

    // Busca registros relacionados ao documento no n�vel inicial (00)
    If SCR->(DbSeek(xFilial("SCR")+cTp+cDoc+Padr(cNvl, nLenSCR)))
        // Itera sobre os registros encontrados
        While !Eof() .And. xFilial("SCR")+cTp+cDoc+cNvl == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)
            // Verifica se o grupo de aprovadores � o mesmo do par�metro recebido
            If Alltrim(SCR->CR_GRUPO) == cGrpApv
                UltNvlApr := SCR->CR_NIVEL  // Atualiza o �ltimo n�vel aprovado
            Endif
            SCR->(dbSkip())  // Move para o pr�ximo registro
        EndDo
    Endif

    // Seleciona a tabela SAL para verificar os aprovadores do grupo
    dbselectarea("SAL")
    SAL->(dbsetorder(2))
    SAL->(dbseek(xFilial("SAL")+cGrpApv, .F.))

    // Verifica se existem aprovadores para o grupo
    if !empty(SAL->AL_COD)
        // Itera sobre os aprovadores que pertencem ao grupo
        while SAL->AL_COD == cGrpApv .And. SAL->AL_NIVEL < UltNvlApr
            // Verifica se o aprovador tem permiss�o de aprova��o
            if ALLTRIM(UPPER(SAL->AL_LIBAPR)) == 'A'
                // Bloqueia o registro na tabela SCR para inser��o/atualiza��o
                if RecLock("SCR", .T.)
                    // Preenche os campos da tabela SCR com os dados do aprovador
                    SCR->CR_FILIAL  := cFilAnt   // Filial
                    SCR->CR_NUM     := cDoc      // Documento
                    SCR->CR_TIPO    := cTp       // Tipo do documento
                    SCR->CR_USER    := SAL->AL_USER   // Usu�rio do aprovador
                    SCR->CR_APROV   := SAL->AL_APROV  // C�digo do aprovador
                    SCR->CR_GRUPO   := SAL->AL_COD    // Grupo do aprovador
                    SCR->CR_NIVEL   := SAL->AL_NIVEL  // N�vel do aprovador
                    SCR->CR_STATUS  := "02"           // Status (pendente de aprova��o)
                    SCR->CR_TOTAL   := nTotDoc        // Valor total do documento
                    SCR->CR_EMISSAO := dEmiss         // Data de emiss�o do documento
                    SCR->CR_MOEDA   := nMoeda         // Moeda do documento
                    MsUnLock()  // Desbloqueia o registro ap�s a atualiza��o
                endif
            endif
            SAL->(dbskip())  // Move para o pr�ximo aprovador
        enddo
    EndIf

Return

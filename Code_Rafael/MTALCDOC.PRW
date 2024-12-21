#Include 'Protheus.ch'    // Inclui definições e funções padrão do Protheus

/*/{Protheus.doc} MTALCDOC
A função MTALCDOC ajusta ou insere registros na tabela SCR para atender a regras personalizadas de controle de alçadas, 
garantindo que níveis superiores no fluxo de aprovação sejam liberados somente após o "visto" de níveis intermediários.
@type user function
@author Rafael Cruz TOTVS SP 
@since 10/12/2024
@version 1.0
@param cDoc, Character, Número do documento a ser aprovado.
@param cTp, Character, Tipo do documento.
@param nTotDoc, Numeric, Valor total do documento.
@param cGrpApv, Character, Grupo de aprovadores.
@param nMoeda, Numeric, Código da moeda do documento.
@param dEmiss, Date, Data de emissão do documento.
@return Nil, Nil, A função não retorna valores diretos; atualiza registros na tabela SCR.
@example
// Exemplo de chamada
MTALCDOC()
@see https://tdn.totvs.com/display/public/PROT/MTALCDOC
*/


User Function MTALCDOC()
    // Declaração das variáveis locais para armazenar os parâmetros recebidos
    Local cDoc       := PARAMIXB[1][1]   // Número do documento
    Local cTp        := PARAMIXB[1][2]   // Tipo do documento
    Local nTotDoc    := PARAMIXB[1][3]   // Valor total do documento
    Local cGrpApv    := PARAMIXB[1][6]   // Grupo de aprovadores
    Local nMoeda     := PARAMIXB[1][8]   // Moeda do documento
    Local dEmiss     := PARAMIXB[1][10]  // Data de emissão do documento
    Local cNvl       := "00"             // Nível inicial de aprovação
    Local nLenSCR    := 0                // Controle do tamanho do campo CR_NIVEL
    Local UltNvlApr  := ""               // Variável para armazenar o último nível aprovado

    // Obtém o tamanho do campo CR_NIVEL na tabela SCR
    nLenSCR := TamSX3("CR_NIVEL")[1]

    // Seleciona a tabela SCR e posiciona no índice 2
    DbSelectArea("SCR")
    SCR->(DbSetOrder(2))

    // Busca registros relacionados ao documento no nível inicial (00)
    If SCR->(DbSeek(xFilial("SCR")+cTp+cDoc+Padr(cNvl, nLenSCR)))
        // Itera sobre os registros encontrados
        While !Eof() .And. xFilial("SCR")+cTp+cDoc+cNvl == SCR->(CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL)
            // Verifica se o grupo de aprovadores é o mesmo do parâmetro recebido
            If Alltrim(SCR->CR_GRUPO) == cGrpApv
                UltNvlApr := SCR->CR_NIVEL  // Atualiza o último nível aprovado
            Endif
            SCR->(dbSkip())  // Move para o próximo registro
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
            // Verifica se o aprovador tem permissão de aprovação
            if ALLTRIM(UPPER(SAL->AL_LIBAPR)) == 'A'
                // Bloqueia o registro na tabela SCR para inserção/atualização
                if RecLock("SCR", .T.)
                    // Preenche os campos da tabela SCR com os dados do aprovador
                    SCR->CR_FILIAL  := cFilAnt   // Filial
                    SCR->CR_NUM     := cDoc      // Documento
                    SCR->CR_TIPO    := cTp       // Tipo do documento
                    SCR->CR_USER    := SAL->AL_USER   // Usuário do aprovador
                    SCR->CR_APROV   := SAL->AL_APROV  // Código do aprovador
                    SCR->CR_GRUPO   := SAL->AL_COD    // Grupo do aprovador
                    SCR->CR_NIVEL   := SAL->AL_NIVEL  // Nível do aprovador
                    SCR->CR_STATUS  := "02"           // Status (pendente de aprovação)
                    SCR->CR_TOTAL   := nTotDoc        // Valor total do documento
                    SCR->CR_EMISSAO := dEmiss         // Data de emissão do documento
                    SCR->CR_MOEDA   := nMoeda         // Moeda do documento
                    MsUnLock()  // Desbloqueia o registro após a atualização
                endif
            endif
            SAL->(dbskip())  // Move para o próximo aprovador
        enddo
    EndIf

Return

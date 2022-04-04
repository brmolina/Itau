/***********************************************************************
* @Fábrica         :  
* @CreatedOn       : 25/02/2022 
* @Author          : Bruno Rodriguez Molina
* @Description     : Define prazos e status das arvores Classificatória e Decisória
* @LastUpdateBy    : Bruno Rodriguez Molina
************************************************************************/

public with sharing class EX3_DefineResponsavelEtapa {


    public static void definirResponsavelDistribuicao(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName) {

        if(distribuicao.EX3_Responsavel_Distribuicao__c == null && responsavelName != null)
            distribuicao.EX3_Responsavel_Distribuicao__c = responsavelName;

    }

    public static void definirUltimaModificacaoDistribuicao(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();

        if(EX3_AlteraEtapasPath.validarAlteracaoDistribuicao(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Distribuicao_F__c = userName;
        }
    }

    public static void definirResponsavelClassificatoria(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName) {

        if(distribuicao.EX3_Responsavel_Classificatoria__c == null && responsavelName != null)
        distribuicao.EX3_Responsavel_Classificatoria__c = responsavelName;
        
    }

    public static void definirUltimaModificacaoClassificatoria(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();

        if(EX3_AlteraEtapasPath.validarAlteracaoArvoreClassificatoria(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Classificatoria_F__c = userName;
        }
    }

    public static void definirResponsavelInclusaoEmPauta(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName) {

        if(distribuicao.EX3_Responsavel_Inclusao__c == null && responsavelName != null)
        distribuicao.EX3_Responsavel_Inclusao__c = responsavelName;

    }

    public static void definirUltimaModificacaoInclusaoEmPauta(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();

        if(EX3_AlteraEtapasPath.validarAlteracaoInclusaoPauta(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Inclusao_F__c = userName;
        }
    }

    public static void definirResponsavelDecisoria(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName) {

        if(distribuicao.EX3_Responsavel_Decisoria__c == null && responsavelName != null)
        distribuicao.EX3_Responsavel_Decisoria__c = responsavelName;
    }

    public static void definirUltimaModificacaoDecisoria(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();

        if(EX3_AlteraEtapasPath.validarAlteracaoArvoreDecisoria(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Decisoria_F__c = userName;
        }
    }
    //TODO - definir responsável pela alocação de pauta seguindo uma lógica de acordo com o resultado da arvore decisória
    public static void definirResponsavelAlocacaoDePauta(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName, Boolean transbordar) {

        if(transbordar){
            distribuicao.EX3_UF_OAB__c = '';
            distribuicao.EX3_Advogado__c = null;
            distribuicao.EX3_Responsavel_Alocacao__c = responsavelName;
        }

        else if(distribuicao.EX3_Responsavel_Decisoria__c == 'Advogados Internos' && distribuicao.EX3_Decisoria_Niveis_Atuacao__c.contains('Priorização de Acordo')){
            distribuicao.EX3_Responsavel_Alocacao__c = 'Analistas de Precificação';
            
        } else if(distribuicao.EX3_Responsavel_Decisoria__c != 'Advogados Internos' && distribuicao.EX3_Decisoria_Atuacao__c.contains('Advogado Interno')){
            distribuicao.EX3_Responsavel_Alocacao__c = 'Advogados Internos';
            
        } else if(distribuicao.EX3_Responsavel_Alocacao__c == null && responsavelName != null) {
        distribuicao.EX3_Responsavel_Alocacao__c = responsavelName;
        }
    }

    public static void definirUltimaModificacaoAlocacaoDePauta(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();

        if(EX3_AlteraEtapasPath.validarAlteracaoAlocacaoDePauta(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Alocacao_F__c = userName;
        }
    }
    //TODO - definir o mesmo responsável da etapa alocação de pauta
    public static void definirResponsavelReportarStatusAtuacao(EX3_DistribuicaoRecurso__c distribuicao) {
        
        if(distribuicao.EX3_Responsavel_Reportar_Status__c == null && distribuicao.EX3_Responsavel_Alocacao__c != null)
        distribuicao.EX3_Responsavel_Reportar_Status__c = distribuicao.EX3_Responsavel_Alocacao__c;
    }
    
    public static void definirUltimaModificacaoReportarStatusAtuacao(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();
        
        if(EX3_AlteraEtapasPath.validarAlteracaoReportarStatusAtuacaoNoTRT(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Rep_Status_F__c = userName;
        }
    }
    
    public static void definirResponsavelReportarResultado(EX3_DistribuicaoRecurso__c distribuicao, String responsavelName) {
        
        if(distribuicao.EX3_Responsavel_Reportar_Resultado__c == null && responsavelName != null)
        distribuicao.EX3_Responsavel_Reportar_Resultado__c = responsavelName;
    }

    public static void definirUltimaModificacaoReportarResultadoPorObjeto(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        String userName = UserInfo.getName();
        
        if(EX3_AlteraEtapasPath.validarAlteracaoReportarResultadoPorObjeto(distribuicao, distribuicaoOld)){
            distribuicao.EX3_Ultima_Modificacao_Rep_Resultado_F__c = userName;
        }
    }
}
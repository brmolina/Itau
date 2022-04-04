/***********************************************************************
* @Fábrica         : NTT Data   
* @CreatedOn       : 04/02/2022 
* @Author          : William Waskievicz Strasser   
* @Description     : Altera automaticamente as etapas do path
* @LastUpdateBy    : Bruno Rodriguez Molina  
************************************************************************/

public with sharing class EX3_AlteraEtapasPath {

    public static void execute() {
        
        Boolean parteRecorrenteNull = false;
        
        Map<Id, EX3_DistribuicaoRecurso__c> distribuicaoNewMap = (Map<Id, EX3_DistribuicaoRecurso__c>) Trigger.newMap;
        Map<Id, EX3_DistribuicaoRecurso__c> distribuicaoOldMap = (Map<Id, EX3_DistribuicaoRecurso__c>) Trigger.oldMap;
        
        List<Id> idsList = new List<Id>();
        for(EX3_DistribuicaoRecurso__c distribuicao : distribuicaoNewMap.values()){
            idsList.add(distribuicao.OwnerId);
        }
        Map<Id, Group> responsavelNameMap = new Map<Id, Group>([SELECT Id, Name FROM Group WHERE Id IN :idsList]);
        
        List<EX3_DefinicaoEstrategia__c> definicaoList = [SELECT Id, EX3_Parte_Recorrente__c 
        FROM EX3_DefinicaoEstrategia__c 
        WHERE EX3_DistribuicaoRecurso__c IN : distribuicaoNewMap.keySet()];
        
        if(!definicaoList.isEmpty()){
            for(EX3_DefinicaoEstrategia__c definicao : definicaoList){
                if(definicao.EX3_Parte_Recorrente__c == null){
                    parteRecorrenteNull = true;
                }
            }
        }
        
        for(EX3_DistribuicaoRecurso__c distribuicao : distribuicaoNewMap.values()){

            Boolean transbordar = false;
            String responsavelName = '';

            if(!responsavelNameMap.isEmpty()){
                responsavelName = responsavelNameMap.get(distribuicao.OwnerId).Name;
            }

            EX3_DefineResponsavelEtapa.definirResponsavelDistribuicao(distribuicao, responsavelName);
            
            EX3_DistribuicaoRecurso__c distribuicaoOld = distribuicaoOldMap.get(distribuicao.Id);
            
            if(distribuicaoOld.EX3_Etapa__c != null && distribuicao.EX3_Etapa__c != null){    
                if(validarAlteracaoCampos(distribuicao, distribuicaoOld)){
                    if(validarCamposDistribuicao(distribuicao, parteRecorrenteNull)){

                        EX3_DefineResponsavelEtapa.definirUltimaModificacaoDistribuicao(distribuicao, distribuicaoOld);
                        EX3_DefineResponsavelEtapa.definirResponsavelClassificatoria(distribuicao, responsavelName);
                        distribuicao.EX3_Etapa__c = '4';

                        if(validarCamposArvoreClassificatoria(distribuicao)){

                            EX3_DefineResponsavelEtapa.definirUltimaModificacaoClassificatoria(distribuicao, distribuicaoOld);
                            EX3_DefineResponsavelEtapa.definirResponsavelInclusaoEmPauta(distribuicao, responsavelName);
                            distribuicao.EX3_Etapa__c = '5';
                            
                            if(validarCamposInclusaoPauta(distribuicao)){

                                EX3_DefineResponsavelEtapa.definirUltimaModificacaoInclusaoEmPauta(distribuicao, distribuicaoOld);
                                EX3_DefineResponsavelEtapa.definirResponsavelDecisoria(distribuicao, responsavelName);
                                distribuicao.EX3_Etapa__c = '6';
                                
                                if(validarCamposArvoreDecisoria(distribuicao)){

                                    EX3_DefineResponsavelEtapa.definirResponsavelAlocacaoDePauta(distribuicao, responsavelName, transbordar);
                                    EX3_DefineResponsavelEtapa.definirUltimaModificacaoDecisoria(distribuicao, distribuicaoOld);
                                    distribuicao.EX3_Etapa__c = '7';    
                                }
                                if(validarCamposAlocacaoDePauta(distribuicao, distribuicaoOld)){

                                    if(distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c == true && (distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c != distribuicaoOld.EX3_Transbordar_Atuacao_Para_o_Credencia__c)){
                                        transbordar = true;
                                        EX3_DefineResponsavelEtapa.definirResponsavelAlocacaoDePauta(distribuicao, responsavelName, transbordar);
                                        EX3_DefineResponsavelEtapa.definirUltimaModificacaoAlocacaoDePauta(distribuicao, distribuicaoOld);
                                        continue;
                                    }

                                    EX3_DefineResponsavelEtapa.definirUltimaModificacaoAlocacaoDePauta(distribuicao, distribuicaoOld);
                                    EX3_DefineResponsavelEtapa.definirResponsavelReportarStatusAtuacao(distribuicao);
                                    distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = false;
                                    if(validarCamposAlocacaoDePautaNaoPreenchidos(distribuicao, distribuicaoOld)){
                                        continue;
                                    }
                                    distribuicao.EX3_Etapa__c = '8';    
                                }
                                if(validarCamposAlocacaoDePautaNaoPreenchidos(distribuicao, distribuicaoOld)){
                                    continue;
                                }
                                if(validarCamposReportarStatusAtuacaoNoTRT(distribuicao)){

                                    EX3_DefineResponsavelEtapa.definirUltimaModificacaoReportarStatusAtuacao(distribuicao, distribuicaoOld);
                                    EX3_DefineResponsavelEtapa.definirResponsavelReportarResultado(distribuicao, responsavelName);
                                    distribuicao.EX3_Etapa__c = '9';    
                                }
                                if(validarCamposReportarResultadoPorObjeto(distribuicao)){

                                    EX3_DefineResponsavelEtapa.definirUltimaModificacaoReportarResultadoPorObjeto(distribuicao, distribuicaoOld);
                                    //distribuicao.EX3_Data_de_Conclusao_Reportar_Resultado__c = (distribuicao.EX3_Data_de_Conclusao_Reportar_Resultado__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Reportar_Resultado__c;

                                    EX3_DefineResponsavelEtapa.definirResponsavelReportarResultado(distribuicao, responsavelName);
                                    distribuicao.EX3_Etapa__c = '9';    
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    static Boolean validarCamposDistribuicao(EX3_DistribuicaoRecurso__c distribuicao, Boolean parteRecorrenteNull){
        if(distribuicao.EX3_Data_da_Publicao__c != null 
        && distribuicao.EX3_Turma__c != null 
        && distribuicao.EX3_TRT__c != null
        && !parteRecorrenteNull){
            return true;
        }else{
            return false;
        }
    }

    static Boolean validarCamposArvoreClassificatoria(EX3_DistribuicaoRecurso__c distribuicao){
        if(	distribuicao.EX3_Classificatoria_Improcedencia__c != null
        && distribuicao.EX3_Classificatoria_Superior_299K__c != null
        && distribuicao.EX3_Classificatoria_Superior_1MM__c != null
        && distribuicao.EX3_Classificatoria_Temas_Prioritarios__c != null
        && distribuicao.EX3_Classificatoria_Estrageria_Defesa__c != null){
            return true;       
        }else{
            return false;
        }
    }
    
    static Boolean validarCamposInclusaoPauta(EX3_DistribuicaoRecurso__c distribuicao){
        if(distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c != null
        && distribuicao.EX3_Data_da_Pauta__c != null
        && distribuicao.EX3_Pauta_Tipo_de_Julgamento__c != null
        && distribuicao.EX3_Pauta_Relator__c != null
        && distribuicao.EX3_Pauta_Revisor__c != null){
            return true;
        }else{
            return false;
        }
    }
    
    static Boolean validarCamposArvoreDecisoria(EX3_DistribuicaoRecurso__c distribuicao){
        if(distribuicao.EX3_Decisoria_Improcedencia__c != null
        && distribuicao.EX3_Decisoria_Superior_299K__c != null
        && distribuicao.EX3_Decisoria_Superior_1MM__c != null
        && distribuicao.EX3_Decisoria_Temas_Prioritarios__c != null
        && distribuicao.EX3_Decisoria_Estrageria_Defesa__c != null
        && distribuicao.EX3_discordancia__c != null){
            return true;       
        }else{
            return false;
        }
    }

    static Boolean validarCamposAlocacaoDePauta(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if((distribuicao.EX3_UF_OAB__c != null
        && distribuicao.EX3_OAB__c != null
        && distribuicao.EX3_Advogado__c != null)
        || distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c != distribuicaoOld.EX3_Transbordar_Atuacao_Para_o_Credencia__c){
            return true;       
        }else{
            return false;
        }
    }
    static Boolean validarCamposAlocacaoDePautaNaoPreenchidos(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_UF_OAB__c == null
        && distribuicao.EX3_OAB__c == null
        && distribuicao.EX3_Advogado__c == null){
            return true;       
        }else{
            return false;
        }
    }
    static Boolean validarCamposReportarStatusAtuacaoNoTRT(EX3_DistribuicaoRecurso__c distribuicao){
        if(distribuicao.EX3_Decisoria_Niveis_Atuacao__c.contains('Memoriais e Sustentação Oral')){
            if(distribuicao.EX3_Memoriais_Foram_Entregues__c != null){
                if(distribuicao.EX3_Sustentacao_Foi_Realizada__c == 'Não'){
                    if(distribuicao.EX3_Memoriais_Foram_Entregues__c != null 
                        && (distribuicao.EX3_Memoriais_Entregues__c != null 
                        || distribuicao.EX3_Memoriais_Nao_Entregues__c !=null)
                        && distribuicao.EX3_Sustentacao_Nao_Realizada__c != null){
                            return true;       
                    }
                }
                if(distribuicao.EX3_Sustentacao_Foi_Realizada__c == 'Sim'){
                    if(distribuicao.EX3_Memoriais_Foram_Entregues__c != null 
                        && (distribuicao.EX3_Memoriais_Entregues__c != null 
                        || distribuicao.EX3_Memoriais_Nao_Entregues__c !=null)){
                            return true;
                    }
                }
            } 
        }
        else if(distribuicao.EX3_Decisoria_Niveis_Atuacao__c.contains('Memoriais')){
            if(distribuicao.EX3_Memoriais_Foram_Entregues__c != null 
            && (distribuicao.EX3_Memoriais_Entregues__c != null 
            || distribuicao.EX3_Memoriais_Nao_Entregues__c !=null)){
                return true;
            }
        }
        else {
            return false;
        }
        return false;
    }
    
    static Boolean validarCamposReportarResultadoPorObjeto(EX3_DistribuicaoRecurso__c distribuicao){
        if(distribuicao.EX3_Conclusao_da_Pasta__c != null){
            return true;
        }
        else {
            return false;
        }
    }

    static Boolean validarAlteracaoCampos(EX3_DistribuicaoRecurso__c distribuicao,EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(validarAlteracaoDistribuicao(distribuicao, distribuicaoOld)
        || validarAlteracaoArvoreClassificatoria(distribuicao, distribuicaoOld)
        || validarAlteracaoInclusaoPauta(distribuicao, distribuicaoOld)
        || validarAlteracaoArvoreDecisoria(distribuicao, distribuicaoOld)
        || validarAlteracaoAlocacaoDePauta(distribuicao, distribuicaoOld)
        || validarAlteracaoReportarStatusAtuacaoNoTRT(distribuicao, distribuicaoOld)
        || validarAlteracaoReportarResultadoPorObjeto(distribuicao, distribuicaoOld)){
            return true;
        }else{
            return false;
        }
    }

    public static Boolean validarAlteracaoDistribuicao(EX3_DistribuicaoRecurso__c distribuicao,EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_Data_da_Publicao__c != distribuicaoOld.EX3_Data_da_Publicao__c 
        || distribuicao.EX3_Turma__c != distribuicaoOld.EX3_Turma__c 
        || distribuicao.EX3_TRT__c != distribuicaoOld.EX3_TRT__c
        || distribuicao.EX3_Distribuicao_Conclusao_Analise__c != distribuicaoOld.EX3_Distribuicao_Conclusao_Analise__c){
            return true;
        }else{
            return false;
        }
    }

    public static Boolean validarAlteracaoArvoreClassificatoria(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(	distribuicao.EX3_Classificatoria_Improcedencia__c != distribuicaoOld.EX3_Classificatoria_Improcedencia__c
        || distribuicao.EX3_Classificatoria_Superior_299K__c != distribuicaoOld.EX3_Classificatoria_Superior_299K__c
        || distribuicao.EX3_Classificatoria_Superior_1MM__c != distribuicaoOld.EX3_Classificatoria_Superior_1MM__c
        || distribuicao.EX3_Classificatoria_Temas_Prioritarios__c != distribuicaoOld.EX3_Classificatoria_Temas_Prioritarios__c
        || distribuicao.EX3_Classificatoria_Estrageria_Defesa__c != distribuicaoOld.EX3_Classificatoria_Estrageria_Defesa__c){
            return true;       
        }else{
            return false;
        }
    }

    public static Boolean validarAlteracaoInclusaoPauta(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c != distribuicaoOld.EX3_Inclusao_Pauta_Data_Publicacao__c
        || distribuicao.EX3_Data_da_Pauta__c != distribuicaoOld.EX3_Data_da_Pauta__c
        || distribuicao.EX3_Pauta_Tipo_de_Julgamento__c != distribuicaoOld.EX3_Pauta_Tipo_de_Julgamento__c
        || distribuicao.EX3_Pauta_Relator__c != distribuicaoOld.EX3_Pauta_Relator__c
        || distribuicao.EX3_Votante__c != distribuicaoOld.EX3_Votante__c
        || distribuicao.EX3_Link_da_sala__c != distribuicaoOld.EX3_Link_da_sala__c
        || distribuicao.EX3_Pauta_Revisor__c != distribuicaoOld.EX3_Pauta_Revisor__c){
            return true;
        }else{
            return false;
        }
    }

    public static Boolean validarAlteracaoArvoreDecisoria(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_Decisoria_Improcedencia__c != distribuicaoOld.EX3_Decisoria_Improcedencia__c
        || distribuicao.EX3_Decisoria_Superior_299K__c != distribuicaoOld.EX3_Decisoria_Superior_299K__c
        || distribuicao.EX3_Decisoria_Superior_1MM__c != distribuicaoOld.EX3_Decisoria_Superior_1MM__c
        || distribuicao.EX3_Decisoria_Temas_Prioritarios__c != distribuicaoOld.EX3_Decisoria_Temas_Prioritarios__c
        || distribuicao.EX3_Decisoria_Estrageria_Defesa__c != distribuicaoOld.EX3_Decisoria_Estrageria_Defesa__c
        || distribuicao.EX3_discordancia__c != distribuicaoOld.EX3_discordancia__c){
            return true;       
        }else{
            return false;
        }
    }
    public static Boolean validarAlteracaoAlocacaoDePauta(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_UF_OAB__c != distribuicaoOld.EX3_UF_OAB__c
            || distribuicao.EX3_OAB__c != distribuicaoOld.EX3_OAB__c
            || distribuicao.EX3_Advogado__c != distribuicaoOld.EX3_Advogado__c
            || distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c != distribuicaoOld.EX3_Transbordar_Atuacao_Para_o_Credencia__c){
                return true;       
            }else{
                return false;
            }
    }
    public static Boolean validarAlteracaoReportarStatusAtuacaoNoTRT(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
        if(distribuicao.EX3_Memoriais_Foram_Entregues__c != distribuicaoOld.EX3_Memoriais_Foram_Entregues__c
            || distribuicao.EX3_Memoriais_Entregues__c != distribuicaoOld.EX3_Memoriais_Entregues__c
            || distribuicao.EX3_Memoriais_Nao_Entregues__c != distribuicaoOld.EX3_Memoriais_Nao_Entregues__c
            || distribuicao.EX3_Sustentacao_Foi_Realizada__c != distribuicaoOld.EX3_Sustentacao_Foi_Realizada__c
            || distribuicao.EX3_Sustentacao_Nao_Realizada__c != distribuicaoOld.EX3_Sustentacao_Nao_Realizada__c){
                return true;       
            }else{
                return false;
            }
    }

    public static Boolean validarAlteracaoReportarResultadoPorObjeto(EX3_DistribuicaoRecurso__c distribuicao, EX3_DistribuicaoRecurso__c distribuicaoOld){
         if(distribuicao.EX3_Conclusao_da_Pasta__c != distribuicaoOld.EX3_Conclusao_da_Pasta__c){
                return true;       
            }else{
                return false;
            }
    }
}
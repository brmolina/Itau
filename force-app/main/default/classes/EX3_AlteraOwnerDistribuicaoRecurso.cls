/*********************************************************************************
 *                                    Itaú - 2021
 *
 * Descrição: Classe responsavel por fazer a alteraçãodo proprietario da distribuição 
 * Classe: EX3_AlteraOwnerDistribuicaoRecurso
 * Autor: Yasmin Rafaela Ricardo Candido
 *
 ********************************************************************************/
public with sharing class EX3_AlteraOwnerDistribuicaoRecurso {
    public static void execute(){
        List<EX3_DistribuicaoRecurso__c> newList = (List<EX3_DistribuicaoRecurso__c>) Trigger.new;
        Id recordTypeId = Schema.SObjectType.EX3_DistribuicaoRecurso__c.getRecordTypeInfosByDeveloperName().get('EX3_Trabalhista').getRecordTypeId();
        Map<Id,EX3_DistribuicaoRecurso__c> mapCasoDistribuicao = new Map<Id,EX3_DistribuicaoRecurso__c>();
        for(EX3_DistribuicaoRecurso__c distribuicao : newList){
            if(distribuicao.RecordTypeId == recordTypeId){
                mapCasoDistribuicao.put(distribuicao.EX3_Caso__c,distribuicao); 
            }
        }
        Id rtEscritorio = Schema.SObjectType.EX3_Advogado__c.getRecordTypeInfosByDeveloperName().get('EX3_Escritorio_credenciado').getRecordTypeId();
        List<EX3_Advogado__c> escritorioCredenciado = [select id, name,EX3_CPF_CNPJ_das_empresas__c,EX3_Caso__c from EX3_Advogado__c where RecordTypeId = :rtEscritorio and EX3_Caso__c  in :mapCasoDistribuicao.keySet()];
        
        Map<Id,string> mapCnpjs = new Map<Id,string>();
        for(EX3_Advogado__c advogado : escritorioCredenciado){
            mapCnpjs.put(advogado.EX3_Caso__c, advogado.EX3_CPF_CNPJ_das_empresas__c);
        }
        List<EX3_Escritorio_Credenciado__mdt> cnpjMetadata = [SELECT id, EX3_Id_Fila__c, EX3_CNPJ__c FROM EX3_Escritorio_Credenciado__mdt where EX3_CNPJ__c in :mapCnpjs.values()];
        for(EX3_Escritorio_Credenciado__mdt proprietario : cnpjMetadata){
            for(id idCaso : mapCnpjs.KeySet()){
                string cnpj = mapCnpjs.get(idCaso);
                if(cnpj == proprietario.EX3_CNPJ__c){
                 	EX3_DistribuicaoRecurso__c distribuicao = mapCasoDistribuicao.get(idCaso);
                    distribuicao.OwnerId = proprietario.EX3_Id_Fila__c;
                }            
            } 
        }
    }
}
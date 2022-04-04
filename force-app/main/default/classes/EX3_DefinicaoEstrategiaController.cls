/*********************************************************************************
 *                                    Itaú - 2021
 *
 * Descrição: Classe de Controller do Componete EX3_DefinicaoEstrategia 
 * Classe: EX3_DefinicaoEstrategiaController
 * Autor: Tiago Alves Fereira
 *
 ********************************************************************************/
public class EX3_DefinicaoEstrategiaController {

    @AuraEnabled
    public static List<EX3_DefinicaoEstrategia__c> getDefinicoes(String idDistribuicao){
        return [SELECT Id, Name, EX3_Nome_do_Pedido__c, EX3_Estrategia__c, EX3_Resultado_1_Instancia__c, EX3_Resultado_2_Instancia__c, EX3_Conclusao__c, toLabel(EX3_Resultado_1_Instancia__c) resultado, toLabel(EX3_Resultado_2_Instancia__c) resultado2Instancia, EX3_Parte_Recorrente__c, 
                    toLabel(EX3_Parte_Recorrente__c) ParteTexto, EX3_DistribuicaoRecurso__c
                    FROM EX3_DefinicaoEstrategia__c WHERE EX3_DistribuicaoRecurso__c =:idDistribuicao];
    }

    @AuraEnabled        
    public static Map<String,String> getPicklistValues(String objectAPIName, String fieldAPIName){
        Map<String,String> pickListValuesMap = new Map<String,String>();
        Schema.SObjectType convertToObj = Schema.getGlobalDescribe().get(objectAPIName);
        Schema.DescribeSObjectResult descResult = convertToObj.getDescribe();
        Schema.DescribeFieldResult fieldResult = descResult.fields.getMap().get(fieldAPIName).getDescribe();
        Boolean isFieldNotRequired = fieldResult.isNillable();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal : ple){
            if(pickListVal.isActive()){
                pickListValuesMap.put(pickListVal.getLabel(), pickListVal.getValue());
            }
        }
        return pickListValuesMap;
    }

    @AuraEnabled
    public static void updateDefinicoes(List<EX3_DefinicaoEstrategia__c> lstDefinicoes){
        update lstDefinicoes;
        List<EX3_DefinicaoEstrategia__c> lstNotSemRecurso = new List<EX3_DefinicaoEstrategia__c>();
        Map<String, Integer> mapParte = new Map<String, Integer>();
        for(EX3_DefinicaoEstrategia__c definicao : lstDefinicoes){
            if(!mapParte.containsKey(definicao.EX3_Parte_Recorrente__c)){
                mapParte.put(definicao.EX3_Parte_Recorrente__c, 0);
            }
            Integer quantidade = mapParte.get(definicao.EX3_Parte_Recorrente__c);
            quantidade++;
            mapParte.put(definicao.EX3_Parte_Recorrente__c, quantidade);
            if(definicao.EX3_Parte_Recorrente__c != '4'){
                lstNotSemRecurso.add(definicao);
            }
        }
        String conclusao = null;
        if((mapParte.containsKey('1') && mapParte.containsKey('2')) || mapParte.containsKey('3')){
            conclusao = 'Ambos';
        }
        else if(mapParte.containsKey('1') && mapParte.get('1') == lstNotSemRecurso.size()){
            conclusao = 'Banco';
        }
        else if(mapParte.containsKey('2') && mapParte.get('2') == lstNotSemRecurso.size()){
            conclusao = 'Reclamante';
        }
        else if(mapParte.containsKey('4') && mapParte.get('4') == lstDefinicoes.size()){
            conclusao = 'Encaminhar para cockpit execução';
        }
        
        EX3_DistribuicaoRecurso__c distribuicao = new EX3_DistribuicaoRecurso__c(
            Id = lstDefinicoes[0].EX3_DistribuicaoRecurso__c,
            EX3_Distribuicao_Conclusao_Analise__c = conclusao
        );
        update distribuicao;
    }


    @AuraEnabled
    public static void updateResultadoPasta(String Id, String conclusaoPasta){
        if(Id != null && conclusaoPasta != null){
            EX3_DistribuicaoRecurso__c distribuicao = new EX3_DistribuicaoRecurso__c(
                Id = Id,
                EX3_Conclusao_da_Pasta__c = conclusaoPasta
            );
            update distribuicao;
        }
    }
}
@isTest
public with sharing class EX3_DefinePrazoseStatusArvoresTest {
    @testSetup
    static void makeData(){

        Id rtTrabalhista = Schema.SObjectType.EX3_DistribuicaoRecurso__c.getRecordTypeInfosByDeveloperName().get('EX3_Trabalhista').getRecordTypeId();
        Id rtEstrategiaSegundaIntancia = Schema.SObjectType.EX3_DefinicaoEstrategia__c.getRecordTypeInfosByDeveloperName().get('EX3_Estrategia_Segunda_Instancia').getRecordTypeId();
        List<EX3_DefinicaoEstrategia__c> lstDefinicao = new List<EX3_DefinicaoEstrategia__c>();
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = new List<EX3_DistribuicaoRecurso__c>();
        for(Integer i = 0; i < 5; i++){
            lstDistribuicao.add(new EX3_DistribuicaoRecurso__c(EX3_Etapa__c = '3', RecordTypeId = rtTrabalhista));
        }
        insert lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            lstDefinicao.add(new EX3_DefinicaoEstrategia__c(EX3_DistribuicaoRecurso__c = distribuicao.Id, EX3_Parte_Recorrente__c = '2', RecordTypeId = rtEstrategiaSegundaIntancia));
        }
        insert lstDefinicao;
    }

    @isTest
    public static void testaPrazoeStatusClassificatoria() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_TRT__c = '	TRT 1';
            distribuicao.EX3_Data_da_Publicao__c = System.today();
            distribuicao.EX3_Turma__c = '1ª Turma';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Classificatoria_Improcedencia__c = 'Sim';
            distribuicao.EX3_Classificatoria_Superior_299K__c = 'Não';
            distribuicao.EX3_Classificatoria_Superior_1MM__c = 'Não';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
            distribuicao.EX3_Classificatoria_Estrageria_Defesa__c = 'Sim';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Status_Arvore_Classificatoria__c, EX3_Prazo_Arvore_Classificatoria__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Prazo_Arvore_Classificatoria__c, EX3_DefinePrazoseStatusArvores.proximoDiaUtil());
            System.assertEquals(distribuicao.EX3_Status_Arvore_Classificatoria__c, '3');
        }
    }

    @isTest
    public static void testaPrazoeStatusDecisoria() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_TRT__c = '	TRT 1';
            distribuicao.EX3_Data_da_Publicao__c = System.today();
            distribuicao.EX3_Turma__c = '1ª Turma';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Classificatoria_Improcedencia__c = 'Sim';
            distribuicao.EX3_Classificatoria_Superior_299K__c = 'Não';
            distribuicao.EX3_Classificatoria_Superior_1MM__c = 'Não';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
            distribuicao.EX3_Classificatoria_Estrageria_Defesa__c = 'Sim';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = System.today();
            distribuicao.EX3_Data_da_Pauta__c = System.now();
            distribuicao.EX3_Pauta_Tipo_de_Julgamento__c = '1';
            distribuicao.EX3_Pauta_Relator__c = 'Teste';
            distribuicao.EX3_Pauta_Revisor__c = 'Teste';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Decisoria_Improcedencia__c = 'Sim';
            distribuicao.EX3_Decisoria_Superior_299K__c = 'Não';
            distribuicao.EX3_Decisoria_Superior_1MM__c = 'Não';
            distribuicao.EX3_Decisoria_Temas_Prioritarios__c = 'Não';
            distribuicao.EX3_Decisoria_Estrageria_Defesa__c = 'Sim';
            distribuicao.EX3_discordancia__c = '6';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Status_Arvore_Decisoria__c, EX3_Prazo_Arvore_Decisoria__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Prazo_Arvore_Decisoria__c, EX3_DefinePrazoseStatusArvores.proximoDiaUtil());
            System.assertEquals(distribuicao.EX3_Status_Arvore_Decisoria__c, '3');
        }
    }
}
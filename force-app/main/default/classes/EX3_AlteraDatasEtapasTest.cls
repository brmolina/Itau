/***********************************************************************
* @Fábrica         : NTT Data   
* @CreatedOn       : 26/01/2022 
* @Author          : William Waskievicz Strasser   
* @Description     : Classe de teste da EX3_AlteraDatasEtapas
* @LastUpdateBy    : Bruno Rodriguez Molina  
************************************************************************/

@isTest
public with sharing class EX3_AlteraDatasEtapasTest {

    @testSetup
    static void makeData(){

        Id rtTrabalhista = Schema.SObjectType.EX3_DistribuicaoRecurso__c.getRecordTypeInfosByDeveloperName().get('EX3_Trabalhista').getRecordTypeId();

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = new List<EX3_DistribuicaoRecurso__c>();
        for(Integer i = 0; i < 5; i++){
            lstDistribuicao.add(new EX3_DistribuicaoRecurso__c(EX3_Etapa__c = '3', RecordTypeId = rtTrabalhista));
        }
        insert lstDistribuicao;
    }

    @isTest
    public static void testaDistribuicaoePautaEtapaDistribuicao() {

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Inicio_Distribuicao__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Distribuicao__c, System.today());
        }
    }

    @isTest
    public static void testaDistribuicaoePautaEtapaArvoreClassificatoria() {
     
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '4';
        }
        
        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Conclusao_Distribuicao__c, EX3_Data_de_Inicio_Arvore_Classi__c FROM EX3_DistribuicaoRecurso__c LIMIT 1]){
            System.assertEquals(distribuicao.EX3_Data_de_Conclusao_Distribuicao__c, System.today());
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c, System.today());
        }
    }

    @isTest
    public static void testaDistribuicaoePautaEtapaInclusaoEmPauta() {
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id, EX3_Etapa__c, EX3_Classificatoria_Improcedencia__c, EX3_Classificatoria_Superior_1MM__c, EX3_Classificatoria_Superior_299K__c, EX3_Classificatoria_Temas_Prioritarios__c, EX3_Classificatoria_Estrageria_Defesa__c FROM EX3_DistribuicaoRecurso__c];
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '4';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '5';
            distribuicao.EX3_Classificatoria_Estrageria_Defesa__c = 'Não';
            distribuicao.EX3_Classificatoria_Improcedencia__c = 'Não';
            distribuicao.EX3_Classificatoria_Superior_1MM__c = 'Não';
            distribuicao.EX3_Classificatoria_Superior_299K__c = 'Não';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Conclusao_Arvore_Classi__c, EX3_Data_de_Inicio_Inclusao_em_Pauta__c FROM EX3_DistribuicaoRecurso__c LIMIT 1]){
            System.assertEquals(distribuicao.EX3_Data_de_Conclusao_Arvore_Classi__c, System.today());
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Inclusao_em_Pauta__c, System.today());
        }
    }

    @isTest
    public static void testaDistribuicaoePautaEtapaArvoreDecisoria() {
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c];
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '6';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Conclusao_Inclusao_em_Pauta__c, EX3_Data_de_Inicio_Arvore_Decisoria__c FROM EX3_DistribuicaoRecurso__c LIMIT 1]){
            System.assertEquals(distribuicao.EX3_Data_de_Conclusao_Inclusao_em_Pauta__c, System.today());
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Arvore_Decisoria__c, System.today());
        }
    }

    @isTest
    public static void testaDistribuicaoePautaEtapaAlocacaodePauta() {
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c];
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '7';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Conclusao_Arvore_Decisoria__c, EX3_Data_de_Inicio_Alocacao_de_Pauta__c FROM EX3_DistribuicaoRecurso__c LIMIT 1]){
            System.assertEquals(distribuicao.EX3_Data_de_Conclusao_Arvore_Decisoria__c, System.today());
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Alocacao_de_Pauta__c, System.today());
        } 
    }

    @isTest
    public static void testaDatajaExistente() {
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c];
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_de_Conclusao_Distribuicao__c = Date.newInstance(2020, 2, 17);
            distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c = Date.newInstance(2020, 2, 17);
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Etapa__c = '4';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Data_de_Conclusao_Distribuicao__c, EX3_Data_de_Inicio_Arvore_Classi__c FROM EX3_DistribuicaoRecurso__c LIMIT 1]){
            System.assertEquals(distribuicao.EX3_Data_de_Conclusao_Distribuicao__c, Date.newInstance(2020, 2, 17));
            System.assertEquals(distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c, Date.newInstance(2020, 2, 17));
        }
    }
}
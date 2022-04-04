/*********************************************************************************
 *                                    Itaú - 2021
 *
 * Descrição: Classe de teste para a classe EX3_AlteraOwnerDistribuicaoRecurso
 * Classe: EX3_AlteraOwnerDistribuicaoRecursoTest
 * Autor: Yasmin Rafaela Ricardo Candido
 *
 ********************************************************************************/
@isTest
public class EX3_AlteraOwnerDistribuicaoRecursoTest {
    
    @testSetup    
    static void setup(){
        Case lCase = new Case(
            Origin =  '1',
            RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('EX3_Juridico').getRecordTypeId(),
            Status = '3',
            EX3_Macro_carteira__c = '2',
            EX3_Etapa__c = '10',
            EX3_Carteira__c = '15',
            EX3_Funcional_de_envio__c =  'não informado',
            EX3_Data_de_entrada__c = DateTime.now()
        );
        insert lCase;
        
        Account acc = new Account(
            Name='ARNOR SERAFIM JR ADVOGADOS ASSOCIADOS',  
            EX3_CPF_CNPJ__c='04485669000171',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('EX3_Escritorio_credenciado').getRecordTypeId()
        );
        insert acc;
        
        Id rtEscritorio = Schema.SObjectType.EX3_Advogado__c.getRecordTypeInfosByDeveloperName().get('EX3_Escritorio_credenciado').getRecordTypeId();
        EX3_Advogado__c lAdvogadoCredenciado = new EX3_Advogado__c(
            RecordTypeId = rtEscritorio,
            EX3_Caso__c = lCase.Id,
            EX3_Escritorio_credenciado__c = acc.Id,
            EX3_Tipo_de_Advogado__c = '3',
            EX3_Chave_unica_Advogado__c = rtEscritorio + '' + lCase.Id

        );
        insert lAdvogadoCredenciado;
        
    }

    @isTest
    static void alteraOwner_Success(){
        Case lCase = [SELECT Id FROM Case];
        Id rtTrabalhista = Schema.SObjectType.EX3_DistribuicaoRecurso__c.getRecordTypeInfosByDeveloperName().get('EX3_Trabalhista').getRecordTypeId();
        EX3_DistribuicaoRecurso__c distribuicaoRecurso = new EX3_DistribuicaoRecurso__c(
            RecordTypeId = rtTrabalhista,
            EX3_Etapa__c = '3',
            EX3_Caso__c = lCase.Id
        );
        Test.startTest();
        insert distribuicaoRecurso;
        Test.stopTest();
        distribuicaoRecurso = [SELECT Id, Name, OwnerId FROM EX3_DistribuicaoRecurso__c WHERE Id =: distribuicaoRecurso.Id];
        Group fila = [SELECT Id, Name FROM group WHERE DeveloperName = 'EX3_ARNOR_SERAFIM_JR_ADV_ASSOCIADOS' And Type = 'Queue'];
        System.assertEquals(distribuicaoRecurso.OwnerId, fila.Id);
    }
}
@isTest
public with sharing class EX3_AlteraEtapasPathTest {
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
        
        List<Contact> advogados = new List<Contact>();
        Contact advogado = new Contact();
        advogado.LastName = 'Test';
        advogado.EX3_UF_da_OAB_do_adv_parte_contraria__c = 'MG';
        advogado.EX3_OAB__c = '102030';
        
        advogados.add(advogado);
        insert advogados;
    }

    @isTest
    public static void testaDistribuicaoParaClassificatoria() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_TRT__c = '	TRT 1';
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
        }
       List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '4');
        }
    }

    @isTest
    public static void testaClassificatoriaParaInclusaoPauta() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
        }

        update lstDistribuicao;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Classificatoria_Improcedencia__c = 'Sim';
            distribuicao.EX3_Classificatoria_Superior_299K__c = 'Não';
            distribuicao.EX3_Classificatoria_Superior_1MM__c = 'Não';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
            distribuicao.EX3_Classificatoria_Estrageria_Defesa__c = 'Sim';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Estrageria_Defesa__c = 'Sim';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
           
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '5');
        }
    }

    @isTest
    public static void testaParaInclusaoPautaParaDecisoria() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
            distribuicao.EX3_Pauta_Tipo_de_Julgamento__c = '1';
            distribuicao.EX3_Pauta_Relator__c = 'Teste';
            distribuicao.EX3_Pauta_Revisor__c = 'Teste';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Pauta_Revisor__c = 'Teste';
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '6');
        }
    }

    @isTest
    public static void testaDecisoriaParaAlocacaoEmPauta() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '7');
        }
    }
    
    @isTest
    public static void testaAlocacaoEmPautaParaReportarStatus() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        update lstDistribuicao;
        
        List<Contact> advogados = [SELECT Id FROM Contact];
        
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_UF_OAB__c = 'MG';
            distribuicao.EX3_Advogado__c = advogados[0].Id; 
            distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = true;
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '7');
        }
    }
    
    @isTest
    public static void testaAlocacaoEmPautaParaInclusaoDePauta() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        update lstDistribuicao;
        
        List<Contact> advogados = [SELECT Id FROM Contact];
        
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_UF_OAB__c = 'MG';
            distribuicao.EX3_Advogado__c = advogados[0].Id; 
            distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = true;
        }
        
        update lstDistribuicao;
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.BypassValidationRule__c = true;
            distribuicao.EX3_Decisoria_Niveis_Atuacao__c = 'Memoriais e Sustentação Oral';
            distribuicao.EX3_Memoriais_Foram_Entregues__c = 'Não';
            distribuicao.EX3_Memoriais_Nao_Entregues__c = 'Retirado de Pauta';
            distribuicao.EX3_Memoriais_Entregues__c = 'Com Despacho';
            distribuicao.EX3_Sustentacao_Foi_Realizada__c = 'Não';
            distribuicao.EX3_Sustentacao_Nao_Realizada__c = 'Retirado de Pauta';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '5');
        }
    }
    
    @isTest
    public static void testaAlocacaoEmPautaParaSegundaInstanciaConcluida() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        update lstDistribuicao;
        
        List<Contact> advogados = [SELECT Id FROM Contact];
        
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_UF_OAB__c = 'MG';
            distribuicao.EX3_Advogado__c = advogados[0].Id; 
            distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = true;
        }
        
        update lstDistribuicao;
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.BypassValidationRule__c = true;
            distribuicao.EX3_Decisoria_Niveis_Atuacao__c = 'Memoriais e Sustentação Oral';
            distribuicao.EX3_Memoriais_Foram_Entregues__c = 'Não';
            distribuicao.EX3_Memoriais_Nao_Entregues__c = 'Retirado de Pauta';
            distribuicao.EX3_Sustentacao_Foi_Realizada__c = 'Não';
            distribuicao.EX3_Sustentacao_Nao_Realizada__c = 'Acordo Formalizado';
            
            distribuicao.EX3_Conclusao_da_Pasta__c = 'Ganhamos';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '10');
        }
    }
    
    @isTest
    public static void testaReportarStatusParaReportarResultadoPorObjeto() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        update lstDistribuicao;
        
        List<Contact> advogados = [SELECT Id FROM Contact];
        
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_UF_OAB__c = 'MG';
            distribuicao.EX3_Advogado__c = advogados[0].Id; 
            distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = true;
        }
        
        update lstDistribuicao;
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.BypassValidationRule__c = true;
            distribuicao.EX3_Decisoria_Niveis_Atuacao__c = 'Memoriais e Sustentação Oral';
            distribuicao.EX3_Memoriais_Foram_Entregues__c = 'Sim'; 
            distribuicao.EX3_Memoriais_Entregues__c = 'Com Despacho';
            distribuicao.EX3_Sustentacao_Foi_Realizada__c = 'Sim';
            distribuicao.EX3_Sustentacao_Nao_Realizada__c = 'Retirado de Pauta';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '9');
        }
    }
    
    @isTest
    public static void testaReportarResultadoPorObjetoParaSegundaInstanciaConcluida() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
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
            distribuicao.EX3_Inclusao_Pauta_Data_Publicacao__c = proximoDia();
            distribuicao.EX3_Data_da_Pauta__c = proximoDia();
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
        
        update lstDistribuicao;
        
        List<Contact> advogados = [SELECT Id FROM Contact];
        
        
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_UF_OAB__c = 'MG';
            distribuicao.EX3_Advogado__c = advogados[0].Id; 
            distribuicao.EX3_Transbordar_Atuacao_Para_o_Credencia__c = true;
        }
        
        update lstDistribuicao;
        
    /*    for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.BypassValidationRule__c = true;
            distribuicao.EX3_Decisoria_Niveis_Atuacao__c = 'Memoriais e Sustentação Oral';
            distribuicao.EX3_Memoriais_Foram_Entregues__c = 'Sim'; 
            distribuicao.EX3_Memoriais_Entregues__c = 'Com Despacho';
            distribuicao.EX3_Sustentacao_Foi_Realizada__c = 'Sim';
            distribuicao.EX3_Sustentacao_Nao_Realizada__c = 'Retirado de Pauta';
        }
        
        update lstDistribuicao;
     */   
        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Conclusao_da_Pasta__c = 'Ganhamos';
        }
        
        List<EX3_DistribuicaoRecurso__c> lstDistribuicao2 = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao2){
            distribuicao.EX3_Classificatoria_Temas_Prioritarios__c = 'Não';
        }

        Test.startTest();
            update lstDistribuicao;
        	update lstDistribuicao2;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '10');
        }
    }

    @isTest
    public static void testaDistribuicaoDadosImcompletos() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '3');
        }
    }

    @isTest
    public static void testaDistribuicaoComEstrategiaNull() {

        List<EX3_DistribuicaoRecurso__c> lstDistribuicao = [SELECT Id FROM EX3_DistribuicaoRecurso__c];
        List<EX3_DefinicaoEstrategia__c> lstEstrategia = [SELECT Id FROM EX3_DefinicaoEstrategia__c];

        for(EX3_DefinicaoEstrategia__c estrategia : lstEstrategia){
            estrategia.EX3_Parte_Recorrente__c = null;
        }

        update lstEstrategia;

        for(EX3_DistribuicaoRecurso__c distribuicao : lstDistribuicao){
            distribuicao.EX3_Data_da_Publicao__c = proximoDia();
            distribuicao.EX3_Turma__c = '1ª Turma';
            distribuicao.EX3_TRT__c = '	TRT 1';
        }

        Test.startTest();
            update lstDistribuicao;
        Test.stopTest();

        for(EX3_DistribuicaoRecurso__c distribuicao : [SELECT Id, EX3_Etapa__c FROM EX3_DistribuicaoRecurso__c]){
            System.assertEquals(distribuicao.EX3_Etapa__c, '3');
        }
    }

    // Método que retorna um dia da semana que não seja sábado ou domingo
    public static date proximoDia(){ 
        Date myDate = Date.newInstance(1900, 1, 7);
        Date proximoDia = System.today()+1;
        Integer quantidade = mydate.daysBetween(proximoDia);
        Date diaSemana = proximoDia;
        
        if((Math.Mod(quantidade, 7)) == 0){
            diaSemana = proximoDia + 3;
        }else{
	        if((Math.Mod(quantidade, 7) == 6)){
                diaSemana = proximoDia + 3;
              }
        }
        return diaSemana;
    }
}
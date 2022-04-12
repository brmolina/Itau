/***********************************************************************
* @Fábrica         : NTT Data   
* @CreatedOn       : 26/01/2022 
* @Author          : William Waskievicz Strasser   
* @Description     : Altera a data de inicio e fim de cada etapa do path
* @LastUpdateBy    : Bruno Rodriguez Molina  
************************************************************************/

public with sharing class EX3_AlteraDatasEtapas {
    public static void execute() {

        List<EX3_DistribuicaoRecurso__c> distribuicaoList = (List<EX3_DistribuicaoRecurso__c>) Trigger.new;
        Map<Id, EX3_DistribuicaoRecurso__c> distribuicaoOldMap = (Map<Id, EX3_DistribuicaoRecurso__c>) Trigger.oldMap;

        for(EX3_DistribuicaoRecurso__c distribuicao : distribuicaoList){
            EX3_DistribuicaoRecurso__c distribuicaoOld;
            
            if (!Trigger.isInsert){
                distribuicaoOld  = distribuicaoOldMap.get(distribuicao.Id);
            }

            switch on distribuicao.EX3_Etapa__c {
                when '3'{
                    distribuicao.EX3_Data_de_Inicio_Distribuicao__c = (distribuicao.EX3_Data_de_Inicio_Distribuicao__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Distribuicao__c;
                }
                when '4'{
                    distribuicao.EX3_Data_de_Conclusao_Distribuicao__c = (distribuicao.EX3_Data_de_Conclusao_Distribuicao__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Distribuicao__c;
                    distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c = (distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Arvore_Classi__c;
                }
                when '5'{
                    distribuicao.EX3_Data_de_Conclusao_Arvore_Classi__c = (distribuicao.EX3_Data_de_Conclusao_Arvore_Classi__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Arvore_Classi__c;
                    distribuicao.EX3_Data_de_Inicio_Inclusao_em_Pauta__c = (distribuicao.EX3_Data_de_Inicio_Inclusao_em_Pauta__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Inclusao_em_Pauta__c;
                }
                when '6'{
                    distribuicao.EX3_Data_de_Conclusao_Inclusao_em_Pauta__c = (distribuicao.EX3_Data_de_Conclusao_Inclusao_em_Pauta__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Inclusao_em_Pauta__c;
                    distribuicao.EX3_Data_de_Inicio_Arvore_Decisoria__c = (distribuicao.EX3_Data_de_Inicio_Arvore_Decisoria__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Arvore_Decisoria__c;
                }
                when '7'{
                    distribuicao.EX3_Data_de_Conclusao_Arvore_Decisoria__c = (distribuicao.EX3_Data_de_Conclusao_Arvore_Decisoria__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Arvore_Decisoria__c;
                    distribuicao.EX3_Data_de_Inicio_Alocacao_de_Pauta__c = (distribuicao.EX3_Data_de_Inicio_Alocacao_de_Pauta__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Alocacao_de_Pauta__c;
                }
            
                when '8'{
                    distribuicao.EX3_Data_de_Conclusao_Alocacao_Pauta__c = (distribuicao.EX3_Data_de_Conclusao_Alocacao_Pauta__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Alocacao_Pauta__c;
                    distribuicao.EX3_Data_de_Inicio_Reportar_Status__c = (distribuicao.EX3_Data_de_Inicio_Reportar_Status__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Reportar_Status__c;
                }
            
                when '9'{
                    distribuicao.EX3_Data_de_Conclusao_Reportar_Status__c = (distribuicao.EX3_Data_de_Conclusao_Reportar_Status__c == null) ? System.today() : distribuicao.EX3_Data_de_Conclusao_Reportar_Status__c;
                    distribuicao.EX3_Data_de_Inicio_Reportar_Resultado__c = (distribuicao.EX3_Data_de_Inicio_Reportar_Resultado__c == null) ? System.today() : distribuicao.EX3_Data_de_Inicio_Reportar_Resultado__c;

                    /* if (!Trigger.isInsert){
                        if(distribuicao.EX3_Conclusao_da_Pasta__c != null && (distribuicao.EX3_Conclusao_da_Pasta__c != distribuicaoOld.EX3_Conclusao_da_Pasta__c)){
                            distribuicao.EX3_Data_de_Conclusao_Reportar_Resultado__c = (distribuicao.EX3_Conclusao_da_Pasta__c == null) ? null : System.today();
                        }
                    } */
         
                }
                when '10'{
                    distribuicao.EX3_Data_de_Conclusao_Reportar_Resultado__c = (distribuicao.EX3_Conclusao_da_Pasta__c == null || distribuicao.EX3_Conclusao_da_Pasta__c == '') ? null : System.today();
                }
            }
        }
    }
}
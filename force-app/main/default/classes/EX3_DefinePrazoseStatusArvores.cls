/***********************************************************************
* @Fábrica         : NTT Data   
* @CreatedOn       : 24/02/2022 
* @Author          : William Waskievicz Strasser   
* @Description     : Define prazos e status das arvores Classificatória e Decisória
* @LastUpdateBy    : Jean Nunes Dutra
* @UpdateOn        : 07/03/2022
************************************************************************/

public with sharing class EX3_DefinePrazoseStatusArvores {
    private static String CLASS_NAME = 'EX3_DefinePrazoseStatusArvores';

    public static void execute() {

        List<EX3_DistribuicaoRecurso__c> distribuicaoList = (List<EX3_DistribuicaoRecurso__c>) Trigger.new;

        for(EX3_DistribuicaoRecurso__c distribuicao : distribuicaoList){

            Integer apiName = integer.valueof(distribuicao.EX3_Etapa__c);

            if(apiName == 4){
                if(distribuicao.EX3_Prazo_Arvore_Classificatoria__c == null && (distribuicao.EX3_Status_Arvore_Classificatoria__c == '1' || distribuicao.EX3_Status_Arvore_Classificatoria__c == null)){
                    distribuicao.EX3_Prazo_Arvore_Classificatoria__c = proximoDiaUtil();
                    distribuicao.EX3_Status_Arvore_Classificatoria__c = '2';
                }
            }
            if(apiName >= 5){
                if(distribuicao.EX3_Prazo_Arvore_Classificatoria__c != null){
                    distribuicao.EX3_Status_Arvore_Classificatoria__c = '3';
                }
            }
            if(apiName == 6){
                if(distribuicao.EX3_Prazo_Arvore_Decisoria__c == null && (distribuicao.EX3_Status_Arvore_Decisoria__c == '1' || distribuicao.EX3_Status_Arvore_Decisoria__c == null)){
                    distribuicao.EX3_Prazo_Arvore_Decisoria__c = proximoDiaUtil();
                    distribuicao.EX3_Status_Arvore_Decisoria__c = '2';
                }
            }
            if(apiName >= 7){
                if(distribuicao.EX3_Prazo_Arvore_Decisoria__c != null){
                    distribuicao.EX3_Status_Arvore_Decisoria__c = '3';
                }
            }
   
     }
    }

    /*
    @description: Retorna o próximo dia útil de acordo com o Horário comercial da organização "Dias Úteis" ou se este 
    não for encontrado será com base no "Default". 
    @Jira: EAA | Sprint 03 | R1_2022 | CINSCIVADJ-1551
    @CreatedBy : Jean Nunes Dutra
    @return: Date
    */
    public static Date proximoDiaUtil() {
        String METHOD_NAME = 'proximoDiaUtil';

        // variáveis para armazenar IDs dos Horários comerciais encontrados.
        ID horarioComercialDiasUteisID;
        ID horarioComercialDefaultID;

        // Cria a Date e hora do próximo dia a ser consultado (Cáclculo: Hoje + 1 dia).
        Datetime dataAlvo = DateTime.newInstanceGMT((System.today()+1), Time.newInstance(12, 0, 0, 0));
        System.debug(LoggingLevel.INFO, '___[Classe: ' + CLASS_NAME + ' - Método: ' + METHOD_NAME + '()] - dataAlvo: ' + dataAlvo.format('dd/MM/yyyy z'));

        // Obtém Horário comercial da organização "Dias Úteis" e "Default".
        List<BusinessHours> horarioComercial = [SELECT ID
                                                     , Name 
                                                FROM   BusinessHours 
                                                WHERE  Name = 'Dias úteis' 
                                                OR     IsDefault = TRUE];
        System.debug(LoggingLevel.INFO, '___[Classe: ' + CLASS_NAME + ' - Método: ' + METHOD_NAME + '()] - horarioComercial.size(): ' + horarioComercial.size());


        for(BusinessHours hc : horarioComercial) {
            if(hc.name == 'Dias úteis'){
                horarioComercialDiasUteisID = hc.ID;
            }else{
                horarioComercialDefaultID = hc.ID;
            }
            System.debug(LoggingLevel.INFO, '___[Classe: ' + CLASS_NAME + ' - Método: ' + METHOD_NAME + '()] - horarioComercial ID: ' + hc.id + ' | horarioComercial Nome: ' + hc.name);

        }
        
        // Retorna o proximo dia útil de acordo com o Horario comercial "Dias Úteis" e se este não for localizado será utilizado o horário comercial "Default".
            Date proximoDiaUtil = (BusinessHours.nextStartDate((horarioComercialDiasUteisID != NULL ? horarioComercialDiasUteisID : horarioComercialDefaultID), dataAlvo).date());
            System.debug(LoggingLevel.INFO, '___[Classe: ' + CLASS_NAME + ' - Método: ' + METHOD_NAME + '()] - Calendário Selecionado: ' + (horarioComercialDiasUteisID != NULL ? 'Dias Úteis' : 'Default'));
            System.debug(LoggingLevel.INFO, '___[Classe: ' + CLASS_NAME + ' - Método: ' + METHOD_NAME + '()] - proximoDiaUtil: ' + (DateTime.newInstanceGMT((proximoDiaUtil), Time.newInstance(12, 0, 0, 0))).format('dd/MM/yyyy z'));

            return proximoDiaUtil;
    }

}
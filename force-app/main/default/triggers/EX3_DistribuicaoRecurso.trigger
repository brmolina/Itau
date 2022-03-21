trigger EX3_DistribuicaoRecurso on EX3_DistribuicaoRecurso__c (after delete, after insert, after update, before delete, before insert, before update) {
    TriggerFactory.createHandler(EX3_DistribuicaoRecurso__c.sObjectType);
}
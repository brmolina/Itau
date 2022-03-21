public with sharing class EX3_DistribuicaoRecursoTriggerHandler implements ITrigger {
    
    public void bulkBefore() {}
    public void bulkAfter() {}
    public void beforeInsert() {
        EX3_AlteraOwnerDistribuicaoRecurso.execute();
        EX3_AlteraDatasEtapas.execute();
        EX3_AtualizaNumeroCasoDistribuicao.execute();
    }
    public void beforeUpdate() {
        EX3_CalculaArvoreClassificatoria.execute();
        EX3_ReplicaArvoreClassificatoria.execute();
        EX3_CalculaArvoreDecisoria.execute();
        EX3_AlteraEtapasPath.execute();
        EX3_AlteraDatasEtapas.execute();
        EX3_DefinePrazoseStatusArvores.execute();
    }
    public void beforeDelete() {}
    public void afterInsert() {}
    public void afterUpdate() {}
    public void afterDelete() {}
    public void andFinally() {}
}
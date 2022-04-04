/**
* Created by jmariane on 2020-04-28.
*/

public with sharing class EX3_AdvogadoTriggerHandler  implements ITrigger{
    
    public void bulkBefore() {}
    public void bulkAfter() {}

    public void beforeInsert() {
        if(!(UserInfo.getUserId() == Label.EX3_Id_usuario_integracao)){
            EX3_PreencherChaveUnica.preencherChaveUnica(Trigger.new);
        }else{
            EX3_AdvogadoPopulaEscritorio.execute(Trigger.new);
            EX3_AdvogadoPopulaDistribuidor.execute(Trigger.new);
            EX3_PopularRelacionamento.popularRelacionamento(Trigger.new);
        }
    }

    public void beforeUpdate() {
        if(!(UserInfo.getUserId() == Label.EX3_Id_usuario_integracao)){
            EX3_PreencherChaveUnica.preencherChaveUnica(Trigger.new);
        }
    }

    public void beforeDelete() {}

    public void afterInsert() {
        EX3_FluxoAceiteEscritorio.criaPrimeiroAceite(Trigger.new);
    }

    public void afterUpdate() {}
    public void afterDelete() {}
    public void andFinally() {}
}
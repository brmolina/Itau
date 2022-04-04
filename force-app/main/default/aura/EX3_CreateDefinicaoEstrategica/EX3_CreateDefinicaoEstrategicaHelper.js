({
    doInit: function (component, event, helper) {
        /**
         * Verifica Custom Permissions
         */
        component.find('utils').hasCustomPermission('Ex3_Finalizar_Captura_de_Documentos')
            .then(hasPermission => {
                component.set('v.hasPermissionCaptura', hasPermission);
            });
        component.find('utils').hasCustomPermission('EX3_Solicitacoes')
            .then(hasPermission => {
                component.set('v.hasPermissionSolicitacoes', hasPermission);
            });
    },

    createRecord: function (component, event, helper) {
        var recordId = component.get("v.recordId");
        var action = component.get("c.redirectToObject");

        component.set('v.isDisabledJuridico', true);

        action.setParams({
            aRecordId: recordId
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var lReturnValue = response.getReturnValue();

                if (lReturnValue != 'success') {
                    helper.showToast("", lReturnValue, "warning");
                    component.set('v.isDisabledJuridico', false);
                    return;
                }

                helper.showToast("Successo", $A.get("$Label.c.EX3_Definicao_Estrategica"), "success");

                // Dispara evento de marco concluído
                var marcoConcluido = $A.get("e.c:EX3_SlaMilestoneConcluido");
                marcoConcluido.setParams({
                    "slaConcluido": true
                });
                marcoConcluido.fire();

                $A.get('e.force:refreshView').fire();
            }
            else if (state === "INCOMPLETE" || state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        helper.showToast("Erro", errors[0].message, "error");
                    }
                } else {
                    helper.showToast("Erro", $A.get("$Label.c.EX3_Erro_Desconhecido"), "error");
                }

                component.set('v.isDisabledJuridico', false);
            }
        });

        $A.enqueueAction(action);
    },

    acionarTarefas: function (component, event, helper) {
        component.set("v.viewComponent", !component.get("v.viewComponent"));
    },

    showToast: function (title, message, type) {
        var toastEvent = $A.get("e.force:showToast");

        toastEvent.setParams({
            "duration": 3000,
            "title": title,
            "message": message,
            "type": type // THE TOAST TYPE, WHICH CAN BE ERROR, WARNING, SUCCESS, OR INFO
        });

        toastEvent.fire();
    }
});
({
    doInit: function (component, event, helper) {
        helper.doInit(component, event, helper);
    },

    createRecord: function (component, event, helper) {
        helper.createRecord(component, event, helper);
    },

    acionarTarefas: function (component, event, helper) {
        helper.acionarTarefas(component, event, helper);
    },

    recordUpdated: function (component, event, helper) {
        var changeType = event.getParams().changeType;
        if (changeType === "ERROR") {
            /* handle error; do this first! */
        }
        else if (changeType === "LOADED") {
            /* handle record load */
        }
        else if (changeType === "REMOVED") {
            /* handle record removal */
        }
        else if (changeType === "CHANGED") {
            /* handle record change */
        }
    }
})
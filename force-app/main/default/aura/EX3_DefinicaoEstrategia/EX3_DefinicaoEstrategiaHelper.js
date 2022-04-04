({
	getRecords: function(cmp, event) {
		cmp.set("v.spinner", true); 
		var recordId = cmp.get("v.recordId"); 
        var action = cmp.get("c.getDefinicoes");
		action.setParams({'idDistribuicao': recordId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.records", response.getReturnValue());
            }
			cmp.set("v.spinner", false); 
        });   
        
        $A.enqueueAction(action);

	},
	getParteRecorrente: function(cmp, event) {
		cmp.set("v.spinner", true); 
        var action = cmp.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "EX3_DefinicaoEstrategia__c",
            fieldAPIName: "EX3_Parte_Recorrente__c"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var optionsRecorrente = [];
                Object.entries(response.getReturnValue()).forEach(([key, value]) => optionsRecorrente.push({label:key,value:value}));
                cmp.set("v.optionsParteRecorrente", optionsRecorrente);
            }
			cmp.set("v.spinner", false); 
        });
        $A.enqueueAction(action);
    },
	verificarResultadoComParteRecorrenteSelecionada: function (cmp, event) {
		var indexVar = event.getSource().get("v.id");
		var registros = cmp.get('v.records');
		var resultadoPrimeiraInstancia = registros[indexVar].EX3_Resultado_1_Instancia__c;
		var parteRecorrenteSelecionada = registros[indexVar].EX3_Parte_Recorrente__c;
		let message = '';

		if(resultadoPrimeiraInstancia === '3' && (parteRecorrenteSelecionada === '1' || parteRecorrenteSelecionada === '3') ){
			cmp.set('v.comboboxAlerta', indexVar);
			message = 'Tem certeza que deseja prosseguir? Banco recorreu de um processo já ganho.';
			this.disparoAlerta(message);
		}
		else if(resultadoPrimeiraInstancia === '4' && (parteRecorrenteSelecionada === '2' || parteRecorrenteSelecionada === '3') ){
			cmp.set('v.comboboxAlerta', indexVar);
			message = 'Tem certeza que deseja prosseguir? Reclamante recorreu de um processo já ganho.';
			this.disparoAlerta(message);
		} else{
			cmp.set('v.comboboxAlerta', '');
		}
	},

	disparoAlerta: function (message){
		var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
			title: "AVISO",
			mode : 'dismissible',
			duration : 15000,
			type: 'warning',
			message: message,
   			});
    		toastEvent.fire();
	},

	updateDefinicao: function(cmp, event) {
		var records = cmp.get("v.records");
		var salvar = true;
		cmp.set("v.parteRecorrente", true);
		records.forEach(item => {
			if(!item.EX3_Parte_Recorrente__c){
				cmp.set("v.parteRecorrente", false);
				salvar = false;
				return;
			}
		});
		if(salvar){
			cmp.set("v.spinner", true); 
			var action = cmp.get("c.updateDefinicoes");
			action.setParams({ lstDefinicoes: records});
			action.setCallback(this,function(response){
				if(response.getState() === "SUCCESS"){
					cmp.find('forceRecord').reloadRecord(true);
					var toastEvent = $A.get("e.force:showToast");
					toastEvent.setParams({
						"title": "Sucesso!",
						"type" : 'success',
						"mode" : 'dismissible',
						"duration" : 5000,
						"message": "Partes Recorrentes gravadas com sucesso!"
					});
					toastEvent.fire();
				}
				cmp.set("v.spinner", false); 
			});
			$A.enqueueAction(action);
		}
		else{
			var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
				"title": "Verifique os campos",
				"type" : 'error',
				"mode" : 'dismissible',
				"duration" : 5000,
				"message": "Existem campos obrigatórios sem preenchimento"
			});
			toastEvent.fire();
		}
	}

})
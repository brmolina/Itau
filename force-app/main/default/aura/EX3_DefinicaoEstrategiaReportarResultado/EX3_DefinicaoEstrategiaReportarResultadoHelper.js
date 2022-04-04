({
	//obtém a lista de pedidos da pasta para exibição no componente
	getRecords: function(cmp, event) {
		cmp.set("v.spinner", true); 
		var recordId = cmp.get("v.recordId"); 
        var action = cmp.get("c.getDefinicoes");
		action.setParams({'idDistribuicao': recordId});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.records", response.getReturnValue());
				this.calcularConclusaoDaPasta(cmp, event);
            }
			cmp.set("v.spinner", false); 
        });   
        
        $A.enqueueAction(action);
	},

	// obtém a lista de opções com os resultados possíveis para a segunda instância
	getResultadoSegundaInstancia: function(cmp, event) {
		cmp.set("v.spinner", true); 
        var action = cmp.get("c.getPicklistValues");
        action.setParams({
            objectAPIName: "EX3_DefinicaoEstrategia__c",
            fieldAPIName: "EX3_Resultado_2_Instancia__c"
        });
        action.setCallback(this,function(response){
            if(response.getState() === "SUCCESS"){
                var optionsRecorrente = [];
                Object.entries(response.getReturnValue()).forEach(([key, value]) => optionsRecorrente.push({label:key,value:value}));
                cmp.set("v.optionsResultado2Instancia", optionsRecorrente);
            }
			cmp.set("v.spinner", false); 
        });
        $A.enqueueAction(action);
    },

	// Atualiza no banco de dados os resultados de segunda instancia para os pedidos da pasta
	updateDefinicao: function(cmp, event) {
		var records = cmp.get("v.records");
		var salvar  = true;
		cmp.set("v.possuiResultado2Instancia", true);

		// verifica se todos os pedidos estão com resultado da segunda instancia preenchido
		records.forEach(item => {
			if(!item.EX3_Resultado_2_Instancia__c){
				cmp.set("v.possuiResultado2Instancia", false);
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
					this.disparoAlerta('Sucesso!', 'dismissible', 5000, 'success', 'Resultados da 2ª Instância gravados com sucesso!');
				}
				cmp.set("v.spinner", false); 
			});
			$A.enqueueAction(action);

			// Atualiza o componente com os valores que foram salvos no banco de dados
				this.getRecords(cmp, event);			
			
		}else{
			this.disparoAlerta('Verifique os campos', 'dismissible', 5000, 'error', 'Existem campos obrigatórios sem preenchimento');
		}
	},

	// Realiza o calculo da conclusão da pasta com base nos resultados de segunda instancia de cada Pedido 
	calcularConclusaoDaPasta: function(cmp, event){
		
		var records = cmp.get("v.records");
		var conclusaoDaPasta = '';

		// Imprimindo todo o registro para verificar informações
		records.forEach(item => {
			console.log('itemCMP ', item);
		});

		// Variáveis para contar a quantidade de resultados
		var ganhamos = 0;
		var perdemos = 0;
		var naoJulgado = 0;
		var extinto = 0;
		var contador = 0;
		
		for(let i in records){

			// Se um registro estiver sem resultado na segunda instancia conclusão da pasta fica vazia
			if(!records[i].hasOwnProperty('EX3_Resultado_2_Instancia__c')){
				conclusaoDaPasta = '';
				this.updateConclusaoPasta(cmp, conclusaoDaPasta);
			return;

			}else{

				contador++;

				if(records[i].EX3_Resultado_2_Instancia__c == '3' ){
					ganhamos++;
				}
					
				if(records[i].EX3_Resultado_2_Instancia__c == '4' ){
					perdemos++;
				}

				if(records[i].EX3_Resultado_2_Instancia__c == '6' ){
					naoJulgado++;
				}
				
				if(records[i].EX3_Resultado_2_Instancia__c == '7' ){
					extinto++;
				}

			}
		}

		if( records.length == contador){
			if(ganhamos >= 1 && extinto >= 0 && naoJulgado >= 0 && perdemos == 0){
				conclusaoDaPasta = 'Ganhamos';
			}
			
			if(perdemos >= 1 && naoJulgado >= 0 && ganhamos == 0 && extinto == 0){
				conclusaoDaPasta = 'Perdemos';
			}

			if(perdemos >= 1 && naoJulgado >= 0 && (ganhamos >= 1 || extinto >= 1)){
				conclusaoDaPasta = 'Perdemos em parte';
			}

			if(extinto >= 1 && naoJulgado >= 0 && ganhamos == 0 && perdemos == 0){
				conclusaoDaPasta = 'Extinto';
			}
			
			if( naoJulgado >= 1 && ganhamos == 0 && perdemos == 0 && extinto == 0){
				conclusaoDaPasta = 'Não Julgado';
			}
		}
		
		cmp.set("v.conclusaoPasta", conclusaoDaPasta); // atualiza a informação no componente

		this.updateConclusaoPasta(cmp, conclusaoDaPasta); // aciona o método que vai gravar a informação na pasta
	},

	// Médodo que aciona o controller atualizando a conclusão da pasta
	updateConclusaoPasta: function(cmp, conclusaoDaPasta){
		cmp.set("v.spinner", true); 
		var recordId = cmp.get("v.recordId"); 
		var action = cmp.get("c.updateResultadoPasta");
		action.setParams({ 'Id': recordId, 'conclusaoPasta': conclusaoDaPasta });
		action.setCallback(this,function(response){
			if(response.getState() === "SUCCESS"){
				cmp.find('forceRecord').reloadRecord(true);
			}
			cmp.set("v.spinner", false); 
		});
		$A.enqueueAction(action);
	},
	
	// Método generico para disparar alertas de qualquer tipo de acordo com os argumentos
	disparoAlerta: function (title, mode, duration, type, message){
		var toastEvent = $A.get("e.force:showToast");
			toastEvent.setParams({
			title: title,
			mode : mode,
			duration : duration,
			type: type,
			message: message,
   			});
    		toastEvent.fire();
	}
})
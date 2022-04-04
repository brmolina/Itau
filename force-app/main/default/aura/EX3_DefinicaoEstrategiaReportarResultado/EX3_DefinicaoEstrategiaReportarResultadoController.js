({
	init: function(cmp, event, helper) {
		
		helper.getResultadoSegundaInstancia(cmp, event);
		helper.getRecords(cmp, event);
	},
	
	handleSalvar: function(cmp, event, helper) {
		helper.updateDefinicao(cmp, event);
	}

})
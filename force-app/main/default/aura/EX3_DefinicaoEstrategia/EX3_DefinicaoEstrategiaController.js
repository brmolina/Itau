({
	init: function(cmp, event, helper) {
		
		helper.getParteRecorrente(cmp, event);
		helper.getRecords(cmp, event);
		
	},
	handleSalvar: function(cmp, event, helper) {
		helper.updateDefinicao(cmp, event);
	},

	handleVerificaResultadoERecorrente: function (cmp, event, helper) {
		helper.verificarResultadoComParteRecorrenteSelecionada(cmp, event);
	}
})
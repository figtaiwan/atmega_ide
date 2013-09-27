define(['aura'], function(Aura) {
	console.log(Date()+' === loading index.js')
	Aura({debug:{enable:true}})
		.components.addSource('aura', '../node_webkit/auraext')
		.use('../node_webkit/auraext/aura-backbone')
		.use('../node_webkit/auraext/aura-yadb')
		.start({ widgets: 'body' })
		// 啟動 aura_components 目錄中各子目錄的 main.js, 包括:
    	// connect、status、console-out、console-in 對應的 *-widget 子目錄
		.then(function() { 
    		console.log(Date()+' === Aura Started')
    	})
});
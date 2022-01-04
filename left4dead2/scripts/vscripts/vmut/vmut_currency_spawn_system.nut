//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}


::VMutCurrencySpawnSystem.currencyItemTable <- {}
::VMutCurrencySpawnSystem.currencyItemSpawnCount <- 0


 function VMutCurrencySpawnSystem::AddCurrencyItemCandidate(origin) {
	g_MapScript.currencyItemCandidates.append(
		{origin = origin}
	)
}
 
 
 function VMutCurrencySpawnSystem::SpawnAndDistributeCurrencyItems() {
 
	//Determine how many items we will spawn, and the median value of these items
	local itemSpawnCount = RandomInt(g_MapScript.minCurrencySpawns, g_MapScript.maxCurrencySpawns)
	if (itemSpawnCount > g_MapScript.currencyItemCandidates.len()) {itemSpawnCount = g_MapScript.currencyItemCandidates.len()}
		
	//Sample a selection of candidates from the currency item candidate table. These will be used to spawn currency items.
	local validCandidates = ::VMutUtils.ListRandomSample(g_MapScript.currencyItemCandidates, itemSpawnCount)
 
	//Spawn items
	local itemSpawnValue = 200
	foreach (spawnCandidate in validCandidates) {
		::VMutCurrency.CreateCurrencyItem(spawnCandidate.origin, itemSpawnValue)
	}
}


function VMutCurrencySpawnSystem::SpawnCurrencyItemsFromPostMapData(mapname) {

	//Get currency item state table
	if (!(mapname in ::VMutPersistentState.postMapData)) {
		printl(" ** Cannot spawn currency items from post map data. Entry " + mapname + " does not exist")
		return false
	}
	local currencyItemStateTable = ::VMutPersistentState.postMapData[mapname].currencyItemState
	
	//Spawn currency items from state table
	foreach (id, state in currencyItemStateTable) {
		::VMutCurrency.CreateCurrencyItem(::VMutUtils.KVStringToVector(state.origin), state.value)
	}
	
	return true
	
}
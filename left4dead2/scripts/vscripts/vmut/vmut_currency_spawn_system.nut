//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}


::VMutCurrencySpawnSystem.currencyItemTable <- {}
::VMutCurrencySpawnSystem.currencyItemSpawnCount <- 0


::VMutCurrencySpawnSystem.defaultCurrencyItemCandidate <- {
	origin 		= Vector(0,0,0)
	flags		= 0
	tag			= 0
	landmark 	= 0
}


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
		foreach(k, v in ::VMutCurrencySpawnSystem.defaultCurrencyItemCandidate) {
			if (!(k in spawnCandidate))
				spawnCandidate[k] <- v
		}
	
		local currencyItemData = ::VMutCurrency.CreateCurrencyItem(spawnCandidate.origin, itemSpawnValue)
		
		//Assign post-creation data
		currencyItemData.flags 		= spawnCandidate.flags
		currencyItemData.tag		= spawnCandidate.tag
		currencyItemData.landmark 	= spawnCandidate.landmark
	}
}


function VMutCurrencySpawnSystem::SpawnCurrencyItemsFromPostMapData() {

	//No landmarks = no data to spawn from
	if (!("landmarks" in g_MapScript)) {
		printl(" ** Cannot recreate currency items from post-map data because current map has no landmarks")
		return false
	}

	foreach(landmark in g_MapScript.landmarks) {
		if (!(landmark in ::VMutPersistentState.postMapData))
			continue
			
		//Get currency item state table
		local currencyItemStateTable = ::VMutPersistentState.postMapData[landmark].currencyItemState
		
		//Spawn currency items from state table
		foreach (id, state in currencyItemStateTable) {
			local currencyItemData = ::VMutCurrency.CreateCurrencyItem(::VMutUtils.KVStringToVector(state.origin), state.value)
			
			currencyItemData.tag 		= state.tag
			currencyItemData.landmark 	= state.landmark
		}
	}
	
	return true
	
}
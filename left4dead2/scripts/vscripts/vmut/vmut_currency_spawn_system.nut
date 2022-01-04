//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}


::VMutCurrencySpawnSystem.currencyItemTable <- {}
::VMutCurrencySpawnSystem.currencyItemSpawnCount <- 0


 function VMutCurrencySpawnSystem::AddCurrencyItemCandidate(origin) {
	g_MapScript.currencyItemCandidates.append(
		{origin = origin}
	)
}

//@TODO remove entity script and use a similar system to vendors. Have data in a table and functionality in a single module.

 function VMutCurrencySpawnSystem::SpawnCurrencyItem(origin, value) {
	local entGroup = g_ModeScript.VMutCurrencyItem.GetEntityGroup()
	local entScope = null
	
	entGroup.SpawnTables["currency_item"].PostPlaceCB <- function(ent, rarity) {
	
		//Get currency item script scope
		//ent.ValidateScriptScope()
		entScope = ent.GetScriptScope()
		
		//Initialize currency item functionality
		entScope.value = value
		//entScope.entities.currencyItem = ent
		
		/*
		entScope.CollectItem <- function() {
			::VMutCurrency.SurvivorEarnedCurrency(0, entScope.value)
		}
		
		ent.ConnectOutput("OnPressed", "CollectItem")
		*/
	}
	
	//Spawn the item
	local angles = QAngle(0,RandomInt(0,360),0)
	local ent = g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
	
	local id = "currency_item_" + (::VMutCurrencySpawnSystem.currencyItemSpawnCount++) + "_" + UniqueString()
	printl("<> Spawned currency item " + id)
	
	//Add to table
	::VMutCurrencySpawnSystem.currencyItemTable[id] <- { //@TODO This is an incredibly hacky and scuffed fix for saving to post-map data. Will definitely need a fix later
		script = entScope
		origin = origin
		value  = value
	}
	
	//Return a refernce to the item entity
	return entScope
 }
 
 
 function VMutCurrencySpawnSystem::SpawnAndDistributeCurrencyItems() {
 
	//Determine how many items we will spawn, and the median value of these items
	local itemSpawnCount = RandomInt(g_MapScript.minCurrencySpawns, g_MapScript.maxCurrencySpawns)
	if (itemSpawnCount > g_MapScript.currencyItemCandidates.len()) {itemSpawnCount = g_MapScript.currencyItemCandidates.len()}
		
	//local itemSpawnValue = floor(g_MapScript.mapCurrency / itemSpawnCount)
	local itemSpawnValue = 200
	
	//Sample a selection of candidates from the currency item candidate table. These will be used to spawn currency items.
	local validCandidates = ::VMutUtils.ListRandomSample(g_MapScript.currencyItemCandidates, itemSpawnCount)
 
	//Spawn items
	foreach (spawnCandidate in validCandidates) {
		SpawnCurrencyItem(spawnCandidate.origin, itemSpawnValue)
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
		::VMutCurrencySpawnSystem.SpawnCurrencyItem(::VMutUtils.KVStringToVector(state.origin), state.value)
	}
	
	return true
}
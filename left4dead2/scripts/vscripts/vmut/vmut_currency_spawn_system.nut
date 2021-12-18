//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}

 function VMutCurrencySpawnSystem::AddCurrencyItemCandidate(origin) {
	g_MapScript.currencyItemCandidates.append(
		{origin = origin}
	)
}


 function VMutCurrencySpawnSystem::SpawnCurrencyItem(origin, value) {
	
	
	local entGroup = g_ModeScript.VMutCurrencyItem.GetEntityGroup()
	
	entGroup.SpawnTables["currency_item"].PostPlaceCB <- function(ent, rarity) {
	
		//Get currency item script scope
		//ent.ValidateScriptScope()
		local entScope = ent.GetScriptScope()
		
		//Initialize currency item functionality
		entScope.value = value
		
		/*
		entScope.CollectItem <- function() {
			::VMutCurrency.SurvivorEarnedCurrency(0, entScope.value)
		}
		
		ent.ConnectOutput("OnPressed", "CollectItem")
		*/
	}
	
	//Spawn the item
	local angles = QAngle(0,RandomInt(0,360),0)
	local g = g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
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
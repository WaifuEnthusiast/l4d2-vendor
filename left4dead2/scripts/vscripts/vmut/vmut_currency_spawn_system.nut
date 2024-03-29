//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}


const DEFAULT_CURRENCY_ITEM_VALUE = 250


/*
 *	Default spawn candidate data
 */
::VMutCurrencySpawnSystem.defaultCurrencyItemCandidate <- {
	origin 		= Vector(0,0,0)
	flags		= 0
	tag			= ""
	landmark 	= ""
}


/*
 *	Setup spawn system data
 */
::VMutCurrencySpawnSystem.relevantSpawnCandidates 	<- []


/*
 *	Process candidate data and add it to the relevant spawn candidates
 */
function VMutCurrencySpawnSystem::AddCurrencyItemCandidate(candidateData) {
	//Assign default values to candidate
	foreach(k, v in ::VMutCurrencySpawnSystem.defaultCurrencyItemCandidate) {
		if (!(k in candidateData))
			candidateData[k] <- v
	}
		
	::VMutCurrencySpawnSystem.relevantSpawnCandidates.append(candidateData)
}
 
 
/*
 *	Spawns currency items throughout the map
 *	Called at the beginning of the game to properly distribute currency items
 */
function VMutCurrencySpawnSystem::SpawnAndDistributeCurrencyItems() {
 
	//Determine how many items we will spawn, and the median value of these items
	local itemSpawnCount = RandomInt(g_MapScript.minCurrencySpawns, g_MapScript.maxCurrencySpawns)
	if (itemSpawnCount > ::VMutCurrencySpawnSystem.relevantSpawnCandidates.len()) {itemSpawnCount = ::VMutCurrencySpawnSystem.relevantSpawnCandidates.len()}
		
		
	//Sample a selection of candidates from the currency item candidate table. These will be used to spawn currency items.
	local validCandidates = []
	foreach (spawnCandidate in ::VMutCurrencySpawnSystem.relevantSpawnCandidates) {
	
		if (::VMutCurrencySpawnSystem.CandidateIsInNoSpawnZone(spawnCandidate))	//Don't include candidates that are in "no currency zones"
			continue
		if (spawnCandidate.landmark != "" && ::VMutPersistentState.LandmarkExists(spawnCandidate.landmark) && g_MapScript.LandmarkExists(spawnCandidate.landmark))	//Don't include candidates that are included in a persistent landmark
			continue
			
		validCandidates.append(spawnCandidate)
			
	}
	validCandidates = ::VMutUtils.ListRandomSample(validCandidates, itemSpawnCount)
 
 
	//Spawn items
	local itemSpawnValue = DEFAULT_CURRENCY_ITEM_VALUE
	foreach (spawnCandidate in validCandidates) {
	
		//Create item and assign post-creation data
		local angles = QAngle(0, RandomInt(0, 360), 0)
		local currencyItemData = ::VMutCurrency.CreateCurrencyItem(spawnCandidate.origin, angles, itemSpawnValue)
		
		currencyItemData.flags 		= spawnCandidate.flags
		currencyItemData.tag		= spawnCandidate.tag
		currencyItemData.landmark 	= spawnCandidate.landmark
	}
}


/*
 *	Recreate currency items that were saved to persistent state from a previous round
 */
function VMutCurrencySpawnSystem::SpawnCurrencyItemsFromLandmarkData() {

	foreach(landmark, landmarkOrigin in g_MapScript.landmarks) {
		if (!::VMutPersistentState.LandmarkExists(landmark))
			continue
			
		//Get currency item state table
		local currencyItemStateTable = ::VMutPersistentState.landmarkData[landmark].currencyItemState //@TODO turn this into a function?
		
		//Spawn currency items from state table
		foreach (id, state in currencyItemStateTable) {
			local origin = landmarkOrigin + ::VMutUtils.KVStringToVector(state.origin)
			local angles = ::VMutUtils.KVStringToQAngle(state.angles)
			local currencyItemData = ::VMutCurrency.CreateCurrencyItem(origin, angles, state.value)
			
			currencyItemData.tag 		= state.tag
			currencyItemData.landmark 	= state.landmark
		}
	}
	
	return true
	
}


 /*
  *	Test if the specified currency item spawn candidate exists within a protected zone that disallows vendor spawning
  */
function VMutCurrencySpawnSystem::CandidateIsInNoSpawnZone(spawnCandidate) {
	foreach(zone in g_MapScript.protectedZones) {
		if ((zone.flags & ZONE_FLAG_NO_CURRENCY) == 0)
			continue
	
		if (::VMutUtils.PointInBox(spawnCandidate.origin, zone.origin, zone.extent))
			return true
	}
	
	return false
}
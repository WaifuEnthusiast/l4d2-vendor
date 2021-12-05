//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}

 function VMutCurrencySpawnSystem::AddCurrencyPickupCandidate(origin) {
	g_MapScript.pickupCandidates.append(
		{origin = origin}
	)
}


 function VMutCurrencySpawnSystem::SpawnCurrencyPickup(origin, value) {
	
	
	local entGroup = g_ModeScript.VMutCurrencyPickup.GetEntityGroup()
	
	entGroup.SpawnTables["pickup"].PostPlaceCB <- function(entity, rarity) {
	
		//Get currency pickup script scope
		entity.ValidateScriptScope()
		local entScope = entity.GetScriptScope()
		
		//Initialize currency pickup functionality
		entScope.value <- value
		entScope.CollectPickup <- function() {
			::VMutCurrency.SurvivorEarnedCurrency(0, entScope.value)
		}
		
		entity.ConnectOutput("OnPressed", "CollectPickup")
	}
	
	//Spawn the pickup
	local angles = QAngle(0,RandomInt(0,360),0)
	local g = g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
 }
 
 
 function VMutCurrencySpawnSystem::SpawnAndDistributeCurrencyPickups() {
 
	//Determine how many pickups we will spawn, and the median value of these pickups
	local pickupSpawnCount = RandomInt(g_MapScript.minCurrencySpawns, g_MapScript.maxCurrencySpawns)
	if (pickupSpawnCount > g_MapScript.pickupCandidates.len()) {pickupSpawnCount = g_MapScript.pickupCandidates.len()}
		
	local pickupSpawnValue = floor(g_MapScript.mapCurrency / pickupSpawnCount)
	
	//Sample a selection of candidates from the pickup candidate table. These will be used to spawn currency pickups.
	local validCandidates = ::VMutUtils.ListRandomSample(g_MapScript.pickupCandidates, pickupSpawnCount)
 
	//Spawn pickups
	foreach (spawnCandidate in validCandidates) {
		SpawnCurrencyPickup(spawnCandidate.origin, pickupSpawnValue)
	}
}
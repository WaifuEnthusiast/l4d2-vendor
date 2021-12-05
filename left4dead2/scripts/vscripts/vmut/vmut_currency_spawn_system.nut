//Author: WaifuEnthusiast
::VMutCurrencySpawnSystem <- {}

 function VMutCurrencySpawnSystem::AddCurrencyPickupCandidate(origin) {
	g_MapScript.pickupCandidates.append(
		{origin = origin}
	)
}


 function VMutCurrencySpawnSystem::SpawnCurrencyPickup(origin, quantity) {
	local angles = QAngle(0,RandomInt(0,360),0)
	
	local entGroup = g_ModeScript.VMutCurrencyPickup.GetEntityGroup()
	
	/*
	entGroup.SpawnTables["button"].PostPlaceCB <- function(entity, rarity) {
		entity.ValidateScriptScope()
		local entScope = entity.GetScriptScope()
		entScope.Pickup <- function() {
			::VMutCurrency.SurvivorEarnedCurrency(0, 500)
		}
		entity.ConnectOutput("OnPressed", "Pickup")
	}
	*/
	
	local g = g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
 }
 
 
 function VMutCurrencySpawnSystem::SpawnAndDistributeCurrencyPickups() {
	//TEMPORARY SYSTEM
	foreach (spawnCandidate in g_MapScript.pickupCandidates) {
	
		local chance = RandomInt(0, 0)
		if (chance == 0) {
			SpawnCurrencyPickup(spawnCandidate.origin, 200 + RandomInt(0,2) * 200)
		}
	}
}
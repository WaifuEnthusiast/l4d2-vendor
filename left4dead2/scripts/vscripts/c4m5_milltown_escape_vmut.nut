//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

//if ("c4_m1_milltown_a" in ::VMutPersistentState.postRoundData) {
//	LoadPostRoundEntities(::VMutPersistentState.postRoundData["c4_m1_milltown_a"])
//}

parentMap <- "c4m1_milltown_a"

function Precache() {
	printl(" ** Map Precache")
	PrecacheModel("models/props_interiors/table_kitchen.mdl")
}


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Spawn table of money
	local kvs = {
		targetname 			= "money_table"
		origin				= Vector(-6616, 7552, 116)
		model				= "models/props_interiors/table_kitchen.mdl"
	}
	local ent = SpawnEntityFromTable("prop_dynamic", kvs)
	ent.SetAngles(QAngle(0, 30, 0))
	
	::VMutCurrencySpawnSystem.SpawnCurrencyItem(Vector(-6616, 7552, 136), 1000)
}

//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- defaultMinCurrencySpawns
maxCurrencySpawns	<- defaultMaxCurrencySpawns
startingCurrency	<- defaultStartingCurrency


//------------------------------------------------------------------------------------------------------
//PURGE TABLE

purgeTable <- defaultPurgeTable


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

vendorCandidates <- []


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []	//No currency spawns governed by the spawning system

	
//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- []


//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
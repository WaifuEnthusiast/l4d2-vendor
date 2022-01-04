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
	
	//Spawn table
	local kvs = {
		targetname 			= "money_table"
		origin				= Vector(-6616, 7552, 96)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	local ent = SpawnEntityFromTable("prop_dynamic", kvs)
	ent.SetAngles(QAngle(0, 30, 0))
}

//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- 0		
minCurrencySpawns	<- 0
maxCurrencySpawns	<- 0
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
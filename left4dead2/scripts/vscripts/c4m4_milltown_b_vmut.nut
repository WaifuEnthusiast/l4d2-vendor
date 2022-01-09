function Precache() {
	printl(" ** Map Precache")
}

parentMap <- "c4m2_milltown_a"

//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- defaultMinCurrencySpawns
maxCurrencySpawns	<- defaultMaxCurrencySpawns
startingCurrency	<- defaultStartingCurrency

landmarks			= {
	"c4m1_milltown_a"			: Vector(0, 0, 0)
	"c4m1_milltown_a_saferoom" 	: Vector(4032, -1600, 296)
}

//------------------------------------------------------------------------------------------------------
//PURGE TABLE

//purgeTable <- defaultPurgeTable
purgeSystem.SetPurgeTableCallbacks( @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin(), landmark = "c4m1_milltown_a"} ) )


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
function Precache() {
	printl(" ** Map Precache")
}

parentMap <- "c4m2_sugarmill_a"

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
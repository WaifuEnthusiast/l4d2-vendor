//Author: Waifu Enthusiast

::VMutPersistentState <- {}


/*
 *	Landmark data overview:
 *	After every round, a table of landmarks will be created. Vendors and currency items will be saved to their assigned landmark tables.
 *
 *	The contents of each landmarkData entry are as follows:
 *	vendorState			- 	The final state of every vendor assigned to this landmark.
 *	currencyItemState	-	The final state of every currency item assigned to this landmark.
 *
 *	This table is primarily used for preserving vendor state between the map transitions of Hard Rain. All vendors will be as they were when the survivors revisit them on the return trip.
 */
 
::VMutPersistentState.postMapData <- {}	//Index this table with map names


/*
 *	Builds a table containing the post-map data of the current round, then assigns it to the specified mapslot
 */
function VMutPersistentState::BuildPostMapData() {

	//Build a landmark with the same name as the map if it doesn't already exist
	::VMutPersistentState.InitializeLandmarkTable(g_ModeScript.Director.GetMapName())
	
	
	//Build landmark tables from the current map's landmarks if they don't already exist
	if ("landmarks" in g_MapScript) {
		foreach (landmark in g_MapScript.landmarks)
			::VMutPersistentState.InitializeLandmarkTable(landmark)
	}
	
	
	//Loop through vendors and build landmark data
	foreach (id, vendorData in ::VMutVendor.vendorTable) {
		
		if (!::VMutVendor.VendorExists(vendorData))
			continue
			
		//Can't assign to a landmark if the vendor doesn't specify one. Instead, save it to the map landmark.
		if (!vendorData.landmark || vendorData.landmark == "" || !(vendorData.landmark in ::VMutPersistentState.postMapData)) {
			::VMutPersistentState.AssignVendorStateToLandmark(vendorData, g_ModeScript.Director.GetMapName())
			continue
		}
			
		//Assign vendor state to the landmark
		::VMutPersistentState.AssignVendorStateToLandmark(vendorData, vendorData.landmark)
		
	}
	
	
	//Loop through currency items and build landmark data
	foreach (id, currencyItem in ::VMutCurrency.currencyItemTable) {
		
		if (!::VMutCurrency.CurrencyItemExists(currencyItem))
			continue
			
		//Can't assign to a landmark if the vendor doesn't specify one. Instead, save it to the map landmark.
		if (!currencyItem.landmark || currencyItem.landmark == "" || !(currencyItem.landmark in ::VMutPersistentState.postMapData)) {
			::VMutPersistentState.AssignCurrencyItemStateToLandmark(currencyItem, g_ModeScript.Director.GetMapName())
			continue
		}
			
		//Assign vendor state to the landmark
		::VMutPersistentState.AssignCurrencyItemStateToLandmark(currencyItem, currencyItem.landmark)
		
	}
	
}


/*
 *	Initialize a new landmark table
 *	Create the table if it doesn't exist, then initialize it
 */
function VMutPersistentState::InitializeLandmarkTable(landmark) {

	if (!(landmark in ::VMutPersistentState.postMapData)) {
		::VMutPersistentState.postMapData[landmark] <- {
			vendorState 		= {}
			currencyItemState 	= {}
		}
	}
				
	::VMutPersistentState.postMapData[landmark].vendorState.clear()
	::VMutPersistentState.postMapData[landmark].currencyItemState.clear()
	
	return ::VMutPersistentState.postMapData[landmark]
	
}


/*
 *	Builds a table containing vendor state which can easily be saved to a persistent table
 */
function VMutPersistentState::AssignVendorStateToLandmark(vendorData, landmark) {

	printl(vendorData)

	//@TODO I am very unhappy with this. I should be able to just say destTable[id] <- vendorData.state. Then, I should be able to just pass the state table into a function to create a vendor without any conversions.
	local vendorState = {	//Convert vendor state into a format that can easily be saved/restored from saved tables...
		origin 		= vendorData.spawnData.origin.ToKVString()
		angles 		= vendorData.spawnData.angles.ToKVString()
		blacklist 	= vendorData.spawnData.blacklist
		itemID		= vendorData.itemId
		meleeID		= vendorData.meleeId
		timesUsed	= vendorData.timesUsed
		tag			= vendorData.tag
		landmark	= vendorData.landmark
		FLAGS		= vendorData.flags //For whatever reason, "flags" becomes capitalized to "FLAGS" after saving this table. No idea why.
		
	}
	::VMutPersistentState.postMapData[landmark].vendorState[vendorData.id] <- vendorState
	
}


/*
 *	Builds a table containing currency item state which can easily be saved to a persistent table
 */
function VMutPersistentState::AssignCurrencyItemStateToLandmark(data, landmark) {

	local state = {
		origin 		= data.entities.prop.GetOrigin().ToKVString()
		value  		= data.value
		landmark 	= data.landmark
	}
	::VMutPersistentState.postMapData[landmark].currencyItemState[data.id] <- state
	
}


/*
 *	Saves the post-map data table to a persistent table
 */
function VMutPersistentState::SavePostMapData() {

	g_ModeScript.SaveTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** SAVED post map data ")
	foreach(landmark, table in ::VMutPersistentState.postMapData) {
		printl(landmark + " - " + table)
	}
	
}


/*
 *	Copies the contents of the persistent table into the post-map data table
 */
function VMutPersistentState::LoadPostMapData() {
	g_ModeScript.RestoreTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** LOADED post map data ")
	foreach(landmark, table in ::VMutPersistentState.postMapData) {
		printl(landmark + " - " + table)
	}
	
}
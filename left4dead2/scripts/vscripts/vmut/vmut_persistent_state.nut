//Author: Waifu Enthusiast

//	This entire module is very rushed and very hacky.
//	Please bear with me.

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
 
::VMutPersistentState.landmarkData <- {}	//Index this table with map names


/*
 *	Builds a table containing the post-map data of the current round, then assigns it to the specified mapslot
 */
function VMutPersistentState::BuildLandmarkData() {

	//Build landmark tables from the current map script's landmarks if they don't already exist
	if ("landmarks" in g_MapScript) {
		foreach (landmark, landmarkOrigin in g_MapScript.landmarks) {
			::VMutPersistentState.InitializeLandmarkTable(landmark)
			::VMutPersistentState.PopulateLandmarkTable(landmark, landmarkOrigin, ::VMutVendor.vendorTable, ::VMutCurrency.currencyItemTable)
		}
	}
	
}


/*
 *	Initialize a new landmark table
 *	Create the table if it doesn't exist, then initialize it
 */
function VMutPersistentState::InitializeLandmarkTable(landmark) {

	if (!(landmark in ::VMutPersistentState.landmarkData)) {
		::VMutPersistentState.landmarkData[landmark] <- {
			vendorState 		= {}
			currencyItemState 	= {}
		}
	}
				
	::VMutPersistentState.landmarkData[landmark].vendorState.clear()
	::VMutPersistentState.landmarkData[landmark].currencyItemState.clear()
	
	return ::VMutPersistentState.landmarkData[landmark]
	
}


/*
 *	Test if the specified landmark exists in persistent state
 */
function VMutPersistentState::LandmarkExists(landmark) {
	return (landmark in ::VMutPersistentState.landmarkData)
}


/*
 *	Fills a landmark table with vendor and currency item state
 */
function VMutPersistentState::PopulateLandmarkTable(landmark, landmarkOrigin, vendorTable, currencyItemTable) {
	
	//We really don't want to be looping through every single vendor and currency item for each landmark.
	//This will create a stupidly huge number of loops for every new landmark.
	//It would be much better to have a system that simply loops items and vendors once, and then can reference landmakrs somewhere else to get the name and origin...
	
	local landmarkTable = ::VMutPersistentState.landmarkData[landmark]

	//Loop through vendors and build landmark data
	foreach (id, vendorData in ::VMutVendor.vendorTable) {
		if (!::VMutVendor.VendorExists(vendorData))
			continue
		if (!vendorData.landmark)
			continue
		if (vendorData.landmark == "")
			continue
		if (vendorData.landmark != landmark)
			continue

		//Assign vendor state to the landmark
		::VMutPersistentState.AssignVendorStateToLandmark(vendorData, landmark, landmarkOrigin)
	}
	
	//Loop through currency items and build landmark data
	foreach (id, currencyItem in ::VMutCurrency.currencyItemTable) {
		if (!::VMutCurrency.CurrencyItemExists(currencyItem))
			continue
		if (!currencyItem.landmark)
			continue
		if (currencyItem.landmark == "")
			continue
		if (currencyItem.landmark != landmark)
			continue

		//Assign vendor state to the landmark
		::VMutPersistentState.AssignCurrencyItemStateToLandmark(currencyItem, landmark, landmarkOrigin)
	}
}


/*
 *	Builds a table containing vendor state which can easily be saved to a persistent table
 */
function VMutPersistentState::AssignVendorStateToLandmark(vendorData, landmark, landmarkOrigin) {

	local offset = vendorData.spawnData.origin - landmarkOrigin

	//@TODO I am very unhappy with this. I should be able to just say destTable[id] <- vendorData.state. Then, I should be able to just pass the state table into a function to create a vendor without any conversions.
	local vendorState = {	//Convert vendor state into a format that can easily be saved/restored from saved tables...
		origin 		= offset.ToKVString()
		angles 		= vendorData.spawnData.angles.ToKVString()
		blacklist 	= vendorData.spawnData.blacklist
		itemID		= vendorData.itemId
		meleeID		= vendorData.meleeId
		timesUsed	= vendorData.timesUsed
		tag			= vendorData.tag
		landmark	= vendorData.landmark
		FLAGS		= vendorData.flags //For whatever reason, "flags" becomes capitalized to "FLAGS" after saving this table. No idea why.
		
	}
	::VMutPersistentState.landmarkData[landmark].vendorState[vendorData.id] <- vendorState
	
}


/*
 *	Builds a table containing currency item state which can easily be saved to a persistent table
 */
function VMutPersistentState::AssignCurrencyItemStateToLandmark(data, landmark, landmarkOrigin) {

	local offset = data.entities.prop.GetOrigin() - landmarkOrigin
	
	local state = {
		origin 		= offset.ToKVString()
		angles		= data.entities.prop.GetAngles().ToKVString()
		value  		= data.value
		tag			= data.tag
		landmark 	= data.landmark
		flags		= data.flags
	}
	::VMutPersistentState.landmarkData[landmark].currencyItemState[data.id] <- state
	
}


/*
 *	Saves the post-map data table to a persistent table
 */
function VMutPersistentState::SaveLandmarkData() {

	g_ModeScript.SaveTable("landmarkData", ::VMutPersistentState.landmarkData)
	printl(" ** SAVED post map data ")
	foreach(landmark, table in ::VMutPersistentState.landmarkData) {
		printl(landmark + " - " + table)
	}
	
}


/*
 *	Copies the contents of the persistent table into the post-map data table
 */
function VMutPersistentState::LoadLandmarkData() {
	g_ModeScript.RestoreTable("landmarkData", ::VMutPersistentState.landmarkData)
	printl(" ** LOADED post map data ")
	foreach(landmark, table in ::VMutPersistentState.landmarkData) {
		printl(landmark + " - " + table)
	}
	
}
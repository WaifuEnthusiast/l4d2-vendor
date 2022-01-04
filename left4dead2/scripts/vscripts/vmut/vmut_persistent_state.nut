//Author: Waifu Enthusiast

::VMutPersistentState <- {}


/*
 *	Post-round data overview:
 *	After every round, a new table will be created containing post round data and saved to the postRoundData table. The current mapname is used as the key.
 *
 *	The contents of each postRoundData entry are as follows:
 *	vendorState			- 	The final state of every vendor in the map.
 *	currencyItemState	-	The final state of every currency item in the map.
 *
 *	This table is primarily used for preserving vendor state between the map transitions of Hard Rain. All vendors will be as they were when the survivors revisit them on the return trip.
 */
 
::VMutPersistentState.postMapData <- {}	//Index this table with map names


/*
 *	Builds a table containing the post-map data of the current round, then assigns it to the specified mapslot
 */
function VMutPersistentState::BuildPostMapData(mapname) {
	if (!(mapname in ::VMutPersistentState.postMapData)) {
	
		::VMutPersistentState.postMapData[mapname] <- {
			vendorState 		= {}
			currencyItemState 	= {}
		}
		
	}
	
	::VMutPersistentState.postMapData[mapname].vendorState.clear()
	::VMutPersistentState.postMapData[mapname].currencyItemState.clear()

	::VMutPersistentState.BuildPostMapVendorState(::VMutVendor.vendorTable, ::VMutPersistentState.postMapData[mapname].vendorState)
	::VMutPersistentState.BuildPostMapCurrencyItemState(::VMutCurrency.currencyItemTable, ::VMutPersistentState.postMapData[mapname].currencyItemState)
	
	printl( " ** Built post-map data for " + mapname)
}


/*
 *	Builds a table containing state of all vendors on the map
 *
 *	sourceTable - table containing all the vendor data
 *	destTable	- table to copy the vendor state into
 */
function VMutPersistentState::BuildPostMapVendorState(sourceTable, destTable) {
	foreach(id, vendorData in sourceTable) {
		if (!::VMutVendor.VendorExists(vendorData))
			continue
	
		//@TODO I am very unhappy with this. I should be able to just say destTable[id] <- vendorData.state. Then, I should be able to just pass the state table into a function to create a vendor without any conversions.
		local vendorState = {	//Convert vendor state into a format that can easily be saved/restored from saved tables...
			origin 		= vendorData.spawnData.origin.ToKVString()
			angles 		= vendorData.spawnData.angles.ToKVString()
			blacklist 	= vendorData.spawnData.blacklist
			itemID		= vendorData.itemId
			meleeID		= vendorData.meleeId
			timesUsed	= vendorData.timesUsed
			tag			= vendorData.tag
			FLAGS		= vendorData.flags //For whatever reason, "flags" becomes capitalized to "FLAGS" after saving this table. No idea why.
			
		}
		destTable[id] <- vendorState
	}
}


/*
 *	Builds a table containing state of all currency items on the map
 *
 *	sourceTable - table containing all the currency item data
 *	destTable	- table to copy the currency item state into
 */
function VMutPersistentState::BuildPostMapCurrencyItemState(sourceTable, destTable) {
	foreach(id, currencyItemData in sourceTable) {
		if (!::VMutCurrency.CurrencyItemExists(currencyItemData))
			continue
	
		local state = {
			origin = currencyItemData.entities.prop.GetOrigin().ToKVString()
			value  = currencyItemData.value
		}
		destTable[id] <- state
	}
}


/*
 *	Saves the post-map data table to a persistent table
 */
function VMutPersistentState::SavePostMapData() {
	g_ModeScript.SaveTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** SAVED post map data ")
	foreach(mapname, table in ::VMutPersistentState.postMapData) {
		printl(mapname + " - " + table)
	}
}


/*
 *	Copies the contents of the persistent table into the post-map data table
 */
function VMutPersistentState::LoadPostMapData() {
	g_ModeScript.RestoreTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** LOADED post map data ")
	foreach(mapname, table in ::VMutPersistentState.postMapData) {
		printl(mapname + " - " + table)
	}
	
}


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


function VMutPersistentState::BuildPostMapData(mapname) {
	local data = {
		vendorState 		= {}
		currencyItemState 	= {}
	}
	
	::VMutPersistentState.BuildPostMapVendorState(::VMutVendor.vendorTable, data.vendorState)
	::VMutPersistentState.BuildPostMapCurrencyItemState(::VMutCurrencySpawnSystem.currencyItemTable, data.currencyItemState)
	
	::VMutPersistentState.postMapData[mapname] <- data
}


function VMutPersistentState::BuildPostMapVendorState(sourceTable, destTable) {
	foreach(id, vendorData in sourceTable) {
		/*
		local state = {
			origin 		= vendorData.spawnData.origin.ToKVString()
			angles 		= vendorData.spawnData.angles.ToKVString()
			blacklist 	= ::VMutUtils.ListToTable(vendorData.spawnData.blacklist)
			itemId		= vendorData.itemId
			tag			= vendorData.tag
			
		}
		*/
		destTable[id] <- vendorData
	}
}


function VMutPersistentState::BuildPostMapCurrencyItemState(sourceTable, destTable) {
	foreach(id, currencyItem in sourceTable) {
		local state = {
			//origin = currencyItem.origin.currencyItem.GetOrigin()
			origin = currencyItem.origin.ToKVString()
			value  = currencyItem.value
		}
		destTable[id] <- state
	}
}


function VMutPersistentState::SavePostMapData() {
	g_ModeScript.SaveTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** SAVED post map data ")
	foreach(k, v in ::VMutPersistentState.postMapData) {
		printl(k + " - " + v)
	}
}


function VMutPersistentState::LoadPostMapData() {
	g_ModeScript.RestoreTable("postMapData", ::VMutPersistentState.postMapData)
	printl(" ** LOADED post map data ")
	foreach(mapname, table in ::VMutPersistentState.postMapData) {
		printl(mapname + " - " + table)
		foreach (id, vendorData in table.vendorState) {
			printl(id + " - " + vendorData)
			foreach (k, v in vendorData) {
				printl(k + " - " + v)
				printl("VECTOR")
				foreach (s, x in vendorData.spawnData.origin) {
					printl("VECTOR - " + s + " - " + x)
				}
			}
		}
	}
	
}


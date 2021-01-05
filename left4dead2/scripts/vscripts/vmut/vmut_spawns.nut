//Author: Waifu Enthusiast
::VMutSpawns <- {}


/*
 *	Spawns vendors throughout the map
 *	Called at the beginning of the game to properly distribute vendors
 */
function VMutSpawns::SpawnAndDistributeVendors() {

	//Get the current map's mapSpawnData
	local mapSpawnData = ::VMutSpawns.GetMapSpawnData()
	if (!mapSpawnData)
		return false
	
	foreach (spawn in mapSpawnData.spawns) {
	
		try {
			//Decide what item this vendor will sell <-- possibly turn this into its own function
			local itemid = 0
			if ("itemid" in spawn)
				itemid = spawn.itemid
			else {
			
				//Filter out unwanted items according to the spawndata's blacklist
				local blacklist = []
				if ("blacklist" in spawn)
					blacklist = spawn.blacklist
				
				local relevantItems = []
				for (local i = 1; i < ITEM_ID.count; i++) {
					if (blacklist.find(i) == null)
						relevantItems.append(i)
				}
			
				itemid = relevantItems[RandomInt(0, relevantItems.len()-1)]
				
			}
		
			//Spawn the vendor
			local vendorData = ::VMutVendor.CreateVendor(spawn.origin, spawn.angles)
			::VMutVendor.VendorSetItemType(vendorData, itemid)
			
		}
		catch (exception) {
			printl("Failed to spawn vendor - " + exception)
		}
		
	}
	
	return true;
	
}


/*
 *	Get the current map's associated mapSpawnData 
 */
function VMutSpawns::GetMapSpawnData() {

	//Read data from map spawn file into map spawn table
	local mapSpawnData = {}
	local directory = "mapSpawns/" + Director.GetMapName() + "_vendor_spawns"
	IncludeScript(directory, mapSpawnData)

	//No spawns, nothing more can be done
	if (!("spawns" in mapSpawnData)) {
		printl("Failed to load map spawns - no spawns array in " + directory)
		return null
	}
	
	//Fill in any missing data
	if (!("areas" in mapSpawnData)) {
		printl("No areas array in " + directory + " - creating empty area...")
		mapSpawnData.areas <- [{}]
	}
	if (!("options" in mapSpawnData)) {
		printl("No map options in " + directory + " - assigning default options...")
		mapSpawnData.options <- {
			minMedkits 			= 0
			maxMedkits 			= 1
			vendorWitchLimit 	= 1
		}
	}
	
	return mapSpawnData
	
}
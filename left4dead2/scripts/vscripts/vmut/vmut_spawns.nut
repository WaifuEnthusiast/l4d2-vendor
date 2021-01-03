//Author: Waifu Enthusiast
::VMutSpawns <- {}


function VMutSpawns::SpawnAndDistributeVendors() {
	local mapSpawnData = ::VMutSpawns.GetMapSpawnData()
	if (!mapSpawnData)
		return false
	
	foreach (spawn in mapSpawnData.spawns) {
		//try {
			local itemid = 0
		
			if ("itemid" in spawn)
				itemid = spawn.itemid
			else {
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
		
			local vendorData = ::VMutVendor.CreateVendor(spawn.origin, spawn.angles)
			::VMutVendor.VendorSetItemType(vendorData, itemid)
		//}
		//catch (exception) {
		//	printl("Failed to spawn vendor - " + exception)
		//}
	}
	
	return true;
}

function VMutSpawns::GetMapSpawnData() {
	local mapSpawnData = {}
	local directory = "mapSpawns/" + Director.GetMapName() + "_vendor_spawns"
	IncludeScript(directory, mapSpawnData)

	if (!("spawns" in mapSpawnData)) {
		printl("Failed to load map spawns - no spawns array in " + directory)
		return null
	}
	
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
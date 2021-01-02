function SpawnAndDistributeVendors() {
	local mapSpawnData = GetMapSpawnData()
	if (!mapSpawnData)
		return false
	
	foreach (spawn in mapSpawnData.spawns) {
		try {
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
		
			local vendorData = g_ModeScript.CreateVendor(spawn.origin, spawn.angles)
			g_ModeScript.VendorSetItemType(vendorData, itemid)
		}
		catch (exception) {
			printl("Failed to spawn vendor - " + exception)
		}
	}
	
	return true;
}

function GetMapSpawnData() {
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
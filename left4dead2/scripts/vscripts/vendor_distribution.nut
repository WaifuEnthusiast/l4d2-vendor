function SpawnAndDistributeVendors() {
	local mapSpawnData = GetMapSpawnData()
	if (!mapSpawnData)
		return false
	
	foreach (spawn in mapSpawnData.spawns) {
		local vendorData = g_ModeScript.CreateVendor(spawn.origin, spawn.angles)
		g_ModeScript.VendorSetItemType(vendorData, RandomInt(1, ITEM_ID.count-1))
	}
	
	return true;
}

function GetMapSpawnData() {
	local mapSpawnData = {}
	IncludeScript("mapSpawns/" + Director.GetMapName() + "_vendor_spawns", mapSpawnData)

	if (!("spawns" in mapSpawnData))
		return null
	
	return mapSpawnData
}
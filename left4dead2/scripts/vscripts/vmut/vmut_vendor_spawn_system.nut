//Author: Waifu Enthusiast
::VMutVendorSpawnSystem <- {}

const DEFAULT_HOARD_CHANCE = 0.02
const DEFAULT_WITCH_CHANCE = 0.25

const HOARD_ENABLE 	= 0
const HOARD_DISABLE = 1
const HOARD_ALWAYS 	= 2

const WITCH_ENABLE 	= 0
const WITCH_DISABLE = 1
const WITCH_ALWAYS 	= 2

//@TODO Change vmut_spawns to vmut_setup which handles everything from randomly generating vendor distribution, purging entities to spawning currency pickups.
//We could also just delegate all setup data on a per-map basis instead of a global system. So we just put all the spawns data into map scripts for each map.
//
//If we want all the setup data to remain consistent when survivors die and the map restarts (ie: vendors/currency pickups spawn in the same places on restart) then we need to store spawndata in global scope after it's generated. 
//We then use this spawndata to spawn the actual vendors and pickups in map scope when the map starts. This also allows us to have repeating vendors in hard rain's return trip. 
//(although for the best experience we would probably want the vendors and pickups themselves to remain consistent throughout chapter changes. ie: vendors that changed their items or had a price increase will still be that way on the return trip.)
//(this may be difficult to pull off and may need to be done by allowing a lot of functionality to be specified in map scripts. The whole process of spawning vendors from memory should be done in hard rain map scripts?)
//(or maybe delegate this to some kind of landmark system that allows us to preserve vendors between maps on a per-vendor and per-map basis???)

/*
 *	Spawns vendors throughout the map
 *	Called at the beginning of the game to properly distribute vendors
 */
function VMutVendorSpawnSystem::SpawnAndDistributeVendors() {

	//No spawns
	if (!"vendorCandidates" in g_MapScript)
		return false
	
	//Spawns
	foreach (spawnCandidateGroup in g_MapScript.vendorCandidates) {
		::VMutVendorSpawnSystem.SpawnVendorGroup(spawnCandidateGroup)
	}
	
	return true;
	
}


/*
 *	Evaluates the contents of a spawnCandidateGroup.
 *	Determine how each spawnCandidate in the spawnCandidate group should be evaluated, then spawns the vendors.
 */
function VMutVendorSpawnSystem::SpawnVendorGroup(spawnCandidateGroup) {
	
	//Can't do anything if the vendor group doesn't contain any spawn candidates
	if (!"spawnCandidates" in spawnCandidateGroup)
		return false
	if (spawnCandidateGroup.spawnCandidates.len() == 0)
		return 0
		
	//Determine how many spawn candidates to use from this group
	local minSpawns = 0
	local maxSpawns = spawnCandidateGroup.spawnCandidates.len()
	
	if ("min" in spawnCandidateGroup)
		minSpawns = spawnCandidateGroup.min
	if ("max" in spawnCandidateGroup)
		maxSpawns = spawnCandidateGroup.max
		
	local spawnCount = RandomInt(minSpawns, maxSpawns)
		
	//No spawns, do nothing
	if (spawnCount == 0)
		return false

	//Find relevant spawn candidates
	foreach (spawnCandidate in spawnCandidateGroup.spawnCandidates) {
		::VMutVendorSpawnSystem.SpawnVendor(spawnCandidate)
	}
	
}


/*
 *	Evaluates the contents of the specified spawn candidate.
 *	Spawn and create a vendor.
 */
function VMutVendorSpawnSystem::SpawnVendor(spawnCandidate) {
	//Decide what item this vendor will sell <-- possibly turn this into its own function
	local itemid = ITEM_ID.EMPTY
	
	if ("itemid" in spawnCandidate)
		itemid = spawnCandidate.itemid
	else {
	
		//Filter out unwanted items according to the spawndata's blacklist
		local blacklist = []
		if ("blacklist" in spawnCandidate)
			blacklist = spawnCandidate.blacklist
		
		local relevantItems = []
		for (local i = 1 ; i < ITEM_ID.count; i++) { //i initialized to 1 instead of 0 because the first index of the itemdata array is EMPTY
			if (blacklist.find(i) == null)
				relevantItems.append(i)
		}
	
		itemid = relevantItems[RandomInt(0, relevantItems.len()-1)]
		
	}

	printl(" <> Spawning vendor with item id: " + itemid)
	
	//Spawn the vendor
	local vendorData = ::VMutVendor.CreateVendor(spawnCandidate.origin, spawnCandidate.angles)
	
	//Melee hack. This is really dumb. We can fix this by giving every melee weapon a unique ITEM_ID.
	if (itemid == ITEM_ID.MELEE) {
		local meleeId = g_ModeScript.meleeId[RandomInt(0, g_ModeScript.meleeId.len()-1)]
		vendorData.itemParam = meleeId
	}
	
	//Assign item to vendor
	::VMutVendor.VendorSetItemId(vendorData, itemid)
}
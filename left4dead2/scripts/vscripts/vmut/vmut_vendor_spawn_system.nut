//Author: Waifu Enthusiast
::VMutVendorSpawnSystem <- {}

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
		foreach (spawnCandidate in spawnCandidateGroup) {
			try {
				//Decide what item this vendor will sell <-- possibly turn this into its own function
				local itemid = 0
				if ("itemid" in spawnCandidate)
					itemid = spawnCandidate.itemid
				else {
				
					//Filter out unwanted items according to the spawndata's blacklist
					local blacklist = []
					if ("blacklist" in spawnCandidate)
						blacklist = spawnCandidate.blacklist
					
					local relevantItems = []
					for (local i = 1; i < ITEM_ID.count; i++) {
						if (blacklist.find(i) == null)
							relevantItems.append(i)
					}
				
					itemid = relevantItems[RandomInt(0, relevantItems.len()-1)]
					
				}
			
				//Spawn the vendor
				local vendorData = ::VMutVendor.CreateVendor(spawnCandidate.origin, spawnCandidate.angles)
				::VMutVendor.VendorSetItemType(vendorData, itemid)
				
			}
			catch (exception) {
				printl("Failed to spawn vendor - " + exception)
			}
		}
	}
	
	return true;
	
}
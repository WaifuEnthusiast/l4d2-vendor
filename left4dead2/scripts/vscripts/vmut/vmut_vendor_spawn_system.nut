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


/*
 *	Default probabilities. If no probability overrides exist in a spawn candidate, these probabilities will be used instead.
 */
 //In order for these to work elegantly into currently existing systems, we may need to change the itemdata system to use strings instead of an enumeration to index the main itemdata array.
 //Change from list into map and use "item_ak47" instead of ITEM_ID.AK47.
 //This means we can simply and easily use probability keys to access data from the main itemdata map.
 //Otherwise, we'll need some janky system where probability overrides are functions that reassign values in a list
 //Example: override = function(x) {x[ITEM_ID.AK47] = 0; x[ITEM_ID.FIRST_AID_KIT] = 100}
 //The randomized then makes a copy of the default probabilities array and passes it into this function in order to reassign values.
 //Make a new list. Copy default probs into this list every time we decide on an item. Call override function.
 //Another way would be to just assign big override lists to every spawn candidate, and null all the indicies we want to ignore. This will make the spawndata interfaces really bloated and messy though.
//Ideally we would want probabilities for categories then probabilities for individual items within each category
 ::VMutVendorSpawnSystem.defaultProbabilities <- [
	0,	//ITEM_ID.EMPTY,
	10,	//ITEM_ID.SMG,
	10,	//ITEM_ID.SMG_SILENCED,
	10,	//ITEM_ID.SHOTGUN,
	10,	//ITEM_ID.SHOTGUN_CHROME,
	10,	//ITEM_ID.AK47,
	10,	//ITEM_ID.M16,
	10,	//ITEM_ID.DESERT_RIFLE,
	10,	//ITEM_ID.AUTOSHOTGUN,
	10,	//ITEM_ID.SHOTGUN_SPAS,
	10,	//ITEM_ID.HUNTING_RIFLE,
	10,	//ITEM_ID.SNIPER_RIFLE,   
	10,	//ITEM_ID.PISTOL,
	10,	//ITEM_ID.MAGNUM,
	20,	//ITEM_ID.MELEE,  
	10,	//ITEM_ID.MACHINEGUN,
	10,	//ITEM_ID.GRENADE_LAUNCHER,
	10,	//ITEM_ID.CHAINSAW,    
	20,	//ITEM_ID.MOLOTOV,
	20,	//ITEM_ID.PIPEBOMB,
	10,	//ITEM_ID.BILE_JAR,    
	20,	//ITEM_ID.PAIN_PILLS,
	20,	//ITEM_ID.ADRENALINE,
	10,	//ITEM_ID.FIRST_AID_KIT,
	10,	//ITEM_ID.DEFIBRILLATOR,   
	10,	//ITEM_ID.GAS,
	10,	//ITEM_ID.PROPANE,   
	10,	//ITEM_ID.INCENDIARY_UPGRADE,
	10,	//ITEM_ID.EXPLOSIVE_UPGRADE,
	10 	//ITEM_ID.LASERSIGHTS_UPGRADE,
]


/*
 *	Setup spawn system data
 */
::VMutVendorSpawnSystem.relevantSpawnCandidates 	<- []
::VMutVendorSpawnSystem.decidedItems			 	<- []


/*
 *	Spawns vendors throughout the map
 *	Called at the beginning of the game to properly distribute vendors
 */
function VMutVendorSpawnSystem::SpawnAndDistributeVendors() {

	//Clear existsing spawn system data
	::VMutVendorSpawnSystem.relevantSpawnCandidates.clear()
    ::VMutVendorSpawnSystem.decidedItems.clear()
	
	//No spawns
	if (!"vendorCandidates" in g_MapScript)
		return false
	
	//PHASE 1
	//Determine relevant spawn candidates
	foreach (spawnCandidateGroup in g_MapScript.vendorCandidates) {
		::VMutVendorSpawnSystem.AddRelvantSpawnCandidatesFromGroup(spawnCandidateGroup)
	}
	
	//PHASE 2
	//Determine what items each relevant spawn candidate will use
	foreach (spawnCandidate in ::VMutVendorSpawnSystem.relevantSpawnCandidates) {
		local blacklist = []
		if ("blacklist" in spawnCandidate)
			blacklist = spawnCandidate.blacklist
		
		local itemid = ::VMutItemData.RandomizeItem(blacklist)
		::VMutVendorSpawnSystem.decidedItems.append(itemid)
	}
	
	//PHASE 3
	//Determine where mandatory medkits should spawn
	//...
	
	//PHASE 4
	//Spawn the final vendors. No changes after this point.
	for (local i = 0; i < ::VMutVendorSpawnSystem.relevantSpawnCandidates.len(); i++) {
		local spawnCandidate	= ::VMutVendorSpawnSystem.relevantSpawnCandidates[i]
		local itemid			= ::VMutVendorSpawnSystem.decidedItems[i]
		
		::VMutVendorSpawnSystem.SpawnVendorFromSpawnCandidate(spawnCandidate, itemid)
	}
	
	return true
	
}


/*
 *	Evaluates the contents of a spawnCandidateGroup.
 *	Randomizes relevant spawn candidates from the group, then adds them to the main relevant spawn candidates array.
 */
function VMutVendorSpawnSystem::AddRelvantSpawnCandidatesFromGroup(spawnCandidateGroup) {
	
	//Can't do anything if the vendor group doesn't contain any spawn candidates
	if (!"spawnCandidates" in spawnCandidateGroup)
		return false
	if (spawnCandidateGroup.spawnCandidates.len() == 0)
		return false
		
	//Determine how many spawn candidates to use from this group
	local minSpawns = 1
	local maxSpawns = spawnCandidateGroup.spawnCandidates.len()
	
	if ("min" in spawnCandidateGroup)
		minSpawns = spawnCandidateGroup.min
	if ("max" in spawnCandidateGroup)
		maxSpawns = spawnCandidateGroup.max
		
	local spawnCount = RandomInt(minSpawns, maxSpawns)
		
	//No spawns, do nothing
	if (spawnCount == 0)
		return false

	//Get relevant spawn candidates
	local relevantSpawnCandidates = ::VMutUtils.ListRandomSample(spawnCandidateGroup.spawnCandidates, spawnCount)
		
	//Spawn vendors at relevant spawn candidates
	foreach (spawnCandidate in relevantSpawnCandidates) {
		::VMutVendorSpawnSystem.relevantSpawnCandidates.append(spawnCandidate)
	}
	
	return true
}


/*
 *	Evaluates the contents of the specified spawn candidate.
 *	Spawn and create a vendor.
 */
function VMutVendorSpawnSystem::SpawnVendorFromSpawnCandidate(spawnCandidate, itemid) {	
	//Get flags
	local flags = 0
	if ("flags" in spawnCandidate)
		flags = spawnCandidate.flags
	
	//Spawn the vendor
	printl(" <> Spawning vendor with item id: " + itemid)
	local vendorData = ::VMutVendor.CreateVendor(spawnCandidate.origin, spawnCandidate.angles, flags, ("blacklist" in spawnCandidate) ? spawnCandidate.blacklist : null)
	
	//Assign a tag if one was specified in the spawndata
	if ("tag" in spawnCandidate)
		vendorData.tag = spawnCandidate.tag
	
	//Assign item to vendor. This will also automatically call functions to initialize price display and display model.
	::VMutVendor.VendorSetMeleeId(vendorData, g_ModeScript.meleeId[RandomInt(0, g_ModeScript.meleeId.len()-1)])
	::VMutVendor.VendorSetItemId(vendorData, itemid)
	
	//Return a reference to the created vendor
	return vendorData
}


/*
 *	Get a random itemid. Do not select any item ids that are within the specified blacklist.
 */
 function VMutVendorSpawnSystem::SpawnVendorsFromPostMapData(mapname) {
 
	//Get vendor state table
	if (!(mapname in ::VMutPersistentState.postMapData)) {
		printl(" ** Cannot spawn vendors from post map data. Entry " + mapname + " does not exist")
		return false
	}
	local vendorStateTable = ::VMutPersistentState.postMapData[mapname].vendorState
	
	//Iterate table and spawn vendors
	foreach(id, state in vendorStateTable) {
	
		//@TODO Ideally we would want to just be able to assign the state table directly to a vendor at the time of creation
		//So vendorData.state = postMapData.state - or copy members one by one via a foreach loop.
		//This would ensure that a recreated vendor has EXACTLY the same state as it originally had. It also means we don't need to care about setting a whole bunch of specific values at the time of creation.
		//The more complex vendors become, the more complex the saving/loading process becomes. This also will create more work later on, since changing how vendor data works means we need to change saving/loading functions too...
		//If all we do is just reassign state, then there is no need to worry about these functions when changing how vendor data works...
		//Long story short: This is very hacky and stupid and dumb and should be changed but I'm not going to change it because i'm lazy. lol.

		foreach (k, v in state) {
			printl(k + " - " + v)
		}
		
		//I have no idea why. But loading tables seems to change "flags" to "FLAGS"
		local vendorData = ::VMutVendor.CreateVendor(::VMutUtils.KVStringToVector(state.origin), ::VMutUtils.KVStringToQAngle(state.angles), (state.FLAGS | VFLAG_POSTMAP_RECREATION), ::VMutUtils.TableToList(state.blacklist))
		vendorData.tag = state.tag
		vendorData.timesUsed = state.timesUsed
		::VMutVendor.VendorSetMeleeId(vendorData, state.meleeID)
		::VMutVendor.VendorSetItemId(vendorData, state.itemID) //???? WHY DOES IT CHANGE Id to ID??????????????? The table saving/restoring system is completely broken!
		
		printl(" <> Recreating vendor with item id: " + state.itemID)
	}
	
	return true
	
 }
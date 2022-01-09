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
 //The randomizer then makes a copy of the default probabilities array and passes it into this function in order to reassign values.
 //Make a new list. Copy default probs into this list every time we decide on an item. Call override function.
 //Another way would be to just assign big override lists to every spawn candidate, and null all the indicies we want to ignore. This will make the spawndata interfaces really bloated and messy though.
//Ideally we would want probabilities for categories then probabilities for individual items within each category
 ::VMutVendorSpawnSystem.defaultProbabilities <- [
		//item ids						//item keys						//idk which version to use ;;;
	0,	//ITEM_ID.EMPTY,				"empty"
	10,	//ITEM_ID.SMG,					"smg"
	10,	//ITEM_ID.SMG_SILENCED,			"smg_silenced"
	10,	//ITEM_ID.SHOTGUN,              "shotgun"
	10,	//ITEM_ID.SHOTGUN_CHROME,       "shotgun_chrome"
	10,	//ITEM_ID.AK47,                 "ak47"
	10,	//ITEM_ID.M16,                  "m16"
	10,	//ITEM_ID.DESERT_RIFLE,         "desert_rifle"
	10,	//ITEM_ID.AUTOSHOTGUN,          "autoshotgun"
	10,	//ITEM_ID.SHOTGUN_SPAS,         "shotgun_spas"
	10,	//ITEM_ID.HUNTING_RIFLE,        "hunting_rifle"
	10,	//ITEM_ID.SNIPER_RIFLE,         "sniper_rifle"
	10,	//ITEM_ID.PISTOL,               "pistol"
	10,	//ITEM_ID.MAGNUM,               "magnum"
	20,	//ITEM_ID.MELEE,                "melee"
	10,	//ITEM_ID.MACHINEGUN,           "machinegun"
	10,	//ITEM_ID.GRENADE_LAUNCHER,     "grenade_launcher"
	10,	//ITEM_ID.CHAINSAW,             "chainsaw"
	20,	//ITEM_ID.MOLOTOV,              "molotov"
	20,	//ITEM_ID.PIPEBOMB,             "pipebomb"
	10,	//ITEM_ID.BILE_JAR,             "bile_jar"
	20,	//ITEM_ID.PAIN_PILLS,           "pain_pills"
	20,	//ITEM_ID.ADRENALINE,           "adrenaline"
	10,	//ITEM_ID.FIRST_AID_KIT,        "first_aid_kit"
	10,	//ITEM_ID.DEFIBRILLATOR,        "defibrillator"
	10,	//ITEM_ID.GAS,                  "gas"
	10,	//ITEM_ID.PROPANE,              "propane"
	10,	//ITEM_ID.INCENDIARY_UPGRADE,   "incendiary_upgrade"
	10,	//ITEM_ID.EXPLOSIVE_UPGRADE,    "explosive_upgrade"
	10 	//ITEM_ID.LASERSIGHTS_UPGRADE,  "lasersights_upgrade"
]


/*
 *	Default spawn candidate data
 */
 ::VMutVendorSpawnSystem.defaultSpawnCandidate <- {
	orign 		= Vector(0,0,0)
	angles		= QAngle(0,0,0)
	witch		= WITCH_ENABLE
	flags		= 0
	tag			= ""
	landmark	= ""
	blacklist 	= null
 }


/*
 *	Setup spawn system data
 */
::VMutVendorSpawnSystem.relevantSpawnCandidates 	<- []
::VMutVendorSpawnSystem.decidedItems			 	<- []


/*
 *	Process candidate data and add it to the relevant spawn candidates
 */
function VMutVendorSpawnSystem::AddVendorCandidate(candidateData) {
	foreach (k, v in ::VMutVendorSpawnSystem.defaultSpawnCandidate) {
		if (!(k in candidateData))
			candidateData[k] <- v
	}
	::VMutVendorSpawnSystem.relevantSpawnCandidates.append(candidateData)
}


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
		//Assign item id
		local itemid = ::VMutItemData.RandomizeItem(spawnCandidate.blacklist)
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
	
	//Get relevant spawn candidates from this group
	local validCandidates = []
	foreach (spawnCandidate in spawnCandidateGroup.spawnCandidates) {
	
		//@TODO Quick hacky fix. This ideally should not be here.
		//Instead, aim to create a better system that can validate spawncandidates from mapdata have all the defaults assigned before running them through the selection process.
		foreach (k, v in ::VMutVendorSpawnSystem.defaultSpawnCandidate) {
			if (!(k in spawnCandidate))
			spawnCandidate[k] <- v
		}
	
		if (::VMutVendorSpawnSystem.CandidateIsInNoSpawnZone(spawnCandidate)) //Don't include candidates that are in "no vendor zones"
			continue
		if (spawnCandidate.landmark != "" && ::VMutPersistentState.LandmarkExists(spawnCandidate.landmark) && g_MapScript.LandmarkExists(spawnCandidate.landmark))	//Don't include candidates that are included in a persistent landmark
			continue
			
		validCandidates.append(spawnCandidate)
	
	}
	validCandidates = ::VMutUtils.ListRandomSample(validCandidates, spawnCount)
	
	//No spawns, do nothing
	//if (spawnCount == 0)
	//	return false
		
	//Process and append relevant candidates
	foreach (spawnCandidate in validCandidates) {
		::VMutVendorSpawnSystem.AddVendorCandidate(spawnCandidate)
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
	
	//Assign post-creation data
	vendorData.tag 		= spawnCandidate.tag
	vendorData.landmark = spawnCandidate.landmark
	
	//Initialize vendor's item
	::VMutVendor.VendorSetMeleeId(vendorData, g_ModeScript.meleeId[RandomInt(0, g_ModeScript.meleeId.len()-1)])
	::VMutVendor.VendorSetItemId(vendorData, itemid)
	
	//Return a reference to the created vendor
	return vendorData
	
}


/*
 *	Recreate vendors that were saved to persistent state from a previous round
 */
function VMutVendorSpawnSystem::SpawnVendorsFromLandmarkData() {
 
	foreach (landmark, landmarkOrigin in g_MapScript.landmarks) {
		if (!::VMutPersistentState.LandmarkExists(landmark))
			continue
	
		local vendorStateTable = ::VMutPersistentState.landmarkData[landmark].vendorState
		
		//Iterate table and spawn vendors
		foreach(id, state in vendorStateTable) {
		
			//@TODO Ideally we would want to just be able to assign the state table directly to a vendor at the time of creation
			//So vendorData.state = postMapData.state - or copy members one by one via a foreach loop.
			//This would ensure that a recreated vendor has EXACTLY the same state as it originally had. It also means we don't need to care about setting a whole bunch of specific values at the time of creation.
			//The more complex vendors become, the more complex the saving/loading process becomes. This also will create more work later on, since changing how vendor data works means we need to change saving/loading functions too...
			//If all we do is just reassign state, then there is no need to worry about these functions when changing how vendor data works...
			//Long story short: This is very hacky and stupid and dumb and should be changed but I'm not going to change it because i'm lazy. lol.
			
			//I have no idea why. But loading tables seems to change "flags" to "FLAGS"
			local origin = landmarkOrigin + ::VMutUtils.KVStringToVector(state.origin)
			local vendorData = ::VMutVendor.CreateVendor(origin, ::VMutUtils.KVStringToQAngle(state.angles), (state.FLAGS | VFLAG_POSTMAP_RECREATION), ::VMutUtils.TableToList(state.blacklist))
			
			//Assign post-creation data
			vendorData.tag 			= state.tag
			vendorData.landmark		= state.landmark
			vendorData.timesUsed 	= state.timesUsed
			
			//Initialize vendor item
			::VMutVendor.VendorSetMeleeId(vendorData, state.meleeID)
			::VMutVendor.VendorSetItemId(vendorData, state.itemID) //???? WHY DOES IT CHANGE Id to ID??????????????? The table saving/restoring system is completely broken!
			
			printl(" <> Recreating vendor with item id: " + state.itemID)
		}
	}
	
	return true
	
}
 
 
/*
 *	Test if the specified vendor spawn candidate exists within a protected zone that disallows vendor spawning
 */
function VMutVendorSpawnSystem::CandidateIsInNoSpawnZone(spawnCandidate) {
	foreach(zone in g_MapScript.protectedZones) {
		if ((zone.flags & ZONE_FLAG_NO_VENDORS) == 0)
			continue
	
		if (::VMutUtils.PointInBox(spawnCandidate.origin, zone.origin, zone.extent))
			return true
	}
	
	return false
}
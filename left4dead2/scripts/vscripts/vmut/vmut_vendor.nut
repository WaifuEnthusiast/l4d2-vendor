//Author: Waifu Enthusiast
::VMutVendor <- {}


const VENDOR_FINISH_TIME			= 2
const VENDOR_FAIL_DISABLE_TIME		= 1
const PRICE_DISPLAY_TEXTURE_SIZE	= 32
const PRICE_DISPLAY_SCALE			= 0.2 //0.2 is the smallest a sprite can be
const PRICE_DISPLAY_MAX_SPRITES		= 4

const VENDOR_MIN_SAFE_USES			= 4
const VENDOR_MAX_SAFE_USES			= 4
const VENDOR_EXPIRE_CHANCE			= 3

const VENDOR_USE_NULL				= 0
const VENDOR_USE_SUCCESS			= 1
const VENDOR_USE_FAIL				= 2

const VFLAG_START_LOCKED			= 1		//Vendor will spawn locked and unusable until unlocked via a script
const VFLAG_PRESERVE_SPAWNDATA		= 2		//When a vendor changes its item, reuse the spawndata to determine how the randomizer will select the new item
const VFLAG_SAFE					= 4 	//Vendor will never change its item or expire
const VFLAG_FINALE					= 8 	//Vendor is tied to a finale sequence
const VFLAG_POSTMAP_RECREATION		= 16	//Vendor was spawned from a post-map data table
const VFLAG_SAFEROOM				= 32	//Vendor spawned in a saferoom
const VFLAG_IS_MINI					= 64	//Vendor will be spawned as a "mini" variant

const EXPIRE_CHANGE					= 0
const EXPIRE_EXPLODE_SAFE			= 1
const EXPIRE_EXPLODE_EFFECT			= 2


function VMutVendor::Precache() {
	printl(" ** VMUT Vendor Precache")

	PrecacheSound("buttons/button4.wav")
	PrecacheSound("buttons/button11.wav")
	PrecacheSound("buttons/bell1.wav")
}


::VMutVendor.vendorTable <- {}	//Contains the state of all vendors
::VMutVendor.vendorCreationCount <- 0


/*
 *	Returns a list of vendors that have the specified tag
 */
function VMutVendor::FindVendorsByTag(tag) {
	//Null tag returns null
	if (!tag)
		return null
		
	local vendorArray = []
		
	foreach(k, v in ::VMutVendor.vendorTable) {
		if (v.tag == tag)
			vendorArray.append(v)
	}
	
	return vendorArray
}


/*
 *	Create a new vendor.
 */
function VMutVendor::CreateVendor(origin, angles, flags, initialBlacklist = null) {

	//-----------------------------------------------------------------------------
	//DATA

	local id = "vendor_" + (::VMutVendor.vendorCreationCount++) + "_" + UniqueString()
	if (id in ::VMutVendor.vendorTable) {
		printl(" ** Failed to create vendor. Venor with id " + id + " already exists")
		return null
	}
	
	//Create underlying data structure and assign data
	local vendorData = {
		entities = { 	//READONLY 
			root				= null
			deployTarget 		= null
			priceDisplayTarget 	= null
			propMachine 		= null
			propItem 			= null
			usetarget 			= null
		}
		gui = { 		//READONLY 
			priceDisplay		= null
			lockDisplay			= null
		}
		spawnData = { 	//READONLY 
			blacklist			= initialBlacklist	//Kind of scuffed... Maybe a system where the we make a dictionary of spawncandidates with vendors as keys? //We could also make blacklist a part of normal state. This way the blacklist could be changed after the vendor is spawned...
			origin				= origin
			angles				= angles
		}
		id						= id				//Unique identifier used to index the main vendor table
		tag						= ""				//Tagging vendors allows certain vendors to be found and referenced after they are spawned via the vendor spawning system.
		landmark				= ""				//Landmarks are used to recreate vendors from previous maps
		flags					= flags				//Flags that are assigned via spawndata. Has some effects on vendor behaviour. Advised to NOT manually alter this value, instead set it via spawndata.
		itemId					= ITEM_ID.EMPTY	 	//DO NOT manually modify this value. Call VenorSetItemId() instead.
		meleeId					= "fireaxe"			//Used for vendors that sell melee items
		expireType				= EXPIRE_CHANGE		//Set this when initiating the self-destruct sequence from an external call. It will determine what happens after the vendor expires.
		timesUsed				= 0
		priceMultiplier			= 1
		enabled					= true
		locked					= false	
	}
	::VMutVendor.vendorTable[id] <- vendorData
	
	
	//-----------------------------------------------------------------------------
	//SPAWN MAP ENTITIES
	
	//Determine which entity group to use
	local entGroup
	
	if ((flags & VFLAG_IS_MINI) != 0)
		entGroup = ::VMutVendorMiniEnt.GetEntityGroup()
	else
		entGroup = ::VMutVendorEnt.GetEntityGroup()
	
	//Generate callbacks for each entity in the entity group. This will make entities add themselves to the vendor's entity data after spawning.
	entGroup.SpawnTables[ "root" ].PostPlaceCB 					<- function(entity, rarity) {vendorData.entities.root				<- entity}
	entGroup.SpawnTables[ "deploy_target" ].PostPlaceCB 		<- function(entity, rarity) {vendorData.entities.deployTarget		<- entity}
	entGroup.SpawnTables[ "price_display_target" ].PostPlaceCB	<- function(entity, rarity) {vendorData.entities.priceDisplayTarget	<- entity}
	entGroup.SpawnTables[ "prop_item" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propItem 			<- entity}
	entGroup.SpawnTables[ "prop_machine" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propMachine 		<- entity}
	
	
	//Spawn the entity group
	g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
	
	
	//-----------------------------------------------------------------------------
	//INITIALIZE
	
	//Initialize usetarget
	::VMutVendor.VendorCreateAndAttachUseTarget(vendorData)
	
	//Initialize gui
	vendorData.gui.priceDisplay = ::VMutGUI.CreateDigitDisplay(vendorData.entities.priceDisplayTarget)
	vendorData.gui.lockDisplay 	= ::VMutGUI.CreateSprite(vendorData.entities.priceDisplayTarget, 0, -8, "sprites/digits/lock.vmt")
	::VMutGUI.HideSprite(vendorData.gui.lockDisplay)
	
	//Lock vendor if flags say to do so
	if ((flags & VFLAG_START_LOCKED) != 0)
		::VMutVendor.VendorLock(vendorData)
		
	//Set item to initialize displays
	//::VMutVendor.VendorSetMeleeId(vendorData.meleeId)
	//::VMutVendor.VendorSetItemId(vendorData.itemId)
	
	
	//-----------------------------------------------------------------------------
	//REFERENCE

	//Return a reference to the created vendor
	return vendorData
	
}
 

/*
 *	Cleanup a vendor and all of its associated entities.
 */
function VMutVendor::DestroyVendor(vendorData) {

	//Destroy all associated entities
	foreach (ent in vendorData.entities) {
		if (ent)
			ent.Kill()
	}
	
	//Cleanup price display
	::VMutGUI.DestroyDigitDisplay(vendorData.gui.priceDisplay)
	
	//Remove from vendor table
	local id = vendorData.id
	delete ::VMutVendor.vendorTable[id]
	
} 


/*
 *	Creates a usetarget entity, then attaches it to the vendor.
 *	Called on vendor creation to initialize a vendor's functionality.
 * 	Also used when unlocking a vendor. Locking a vendor kills its usetarget, unlocking the vendor recreates the usetarget.
 */
function VMutVendor::VendorCreateAndAttachUseTarget(vendorData) {

	//Don't create duplicate usetargets
	if (vendorData.entities.usetarget) {
		printl(" ** Failed to create and attach usetarget to vendor " + vendorData.id)
		return false
	}

	
	//Create and initialize usetarget entity
	local kvs = {
		model 		= vendorData.entities.propMachine.GetName()
		origin 		= Vector(0,0,0)//vendorData.entities.propMachine.GetOrigin() + Vector( 0, -24, 0 )
		targetname 	= "vendor_" + vendorData.id + "_usetarget"
	}
	local ent = SpawnEntityFromTable("point_script_use_target", kvs)
		
	ent.CanShowBuildPanel(false)
	ent.SetProgressBarText("Using Vendor...")
	ent.SetProgressBarFinishTime(VENDOR_FINISH_TIME)
		
	
	//Grab usetarget script scope
	ent.ValidateScriptScope()
	local usetargetScope = ent.GetScriptScope()
	
	
	//Inject and connect output functions
	usetargetScope.user <- null 
	
	usetargetScope.UseFinish <- function() {
		::VMutVendor.ActivateVendor(vendorData,  ::VMutUtils.EHandleToPlayer(usetargetScope.user))
		usetargetScope.user = null
	}
	usetargetScope.UseStart <- function() {
		usetargetScope.user = usetargetScope.PlayerUsingMe
	}
	usetargetScope.UseStop <- function() {
		usetargetScope.user = null
	}
	
	ent.ConnectOutput("OnUseFinished", 	"UseFinish")
	ent.ConnectOutput("OnUseStarted", 	"UseStart")		
	ent.ConnectOutput("OnUseCancelled", "UseStop")
	
	
	//Assign to vendor's usetarget entity
	vendorData.entities.usetarget = ent
	printl(" ** Created and attached usetarget " + vendorData.id + " - " + ent)
	return true
	
}


/*
 *	Kills a vendor's usetarget entity.
 *	Stops players from interacting with the vendor.
 */
function VMutVendor::VendorKillUseTarget(vendorData) {

	local ent = vendorData.entities.usetarget;
	if (!ent)
		return false
		
	ent.Kill()
	vendorData.entities.usetarget = null
	printl(" ** Killed usetarget " + vendorData.id + " - " + ent)
	
	return true
	
}


/*
 *	Enable a vendor and allow players to interact with it again.
 */
function VMutVendor::VendorEnableUse(vendorData) {

	if (vendorData.enabled)
		return
		
	//Recreate this vendor's usetarget entity so that players can interact with it
	::VMutVendor.VendorCreateAndAttachUseTarget(vendorData)

	vendorData.enabled = true
	printl(" ** Enabled vendor " + vendorData.id)
}


/*
 *	Disable a vendor and prevent players from interacting with it.
 */
function VMutVendor::VendorDisableUse(vendorData) {

	if (!vendorData.enabled)
		return
		
	//Stop players from using this vendor by completely removing its usetarget entity
	::VMutVendor.VendorKillUseTarget(vendorData)

	vendorData.enabled = false
	printl(" ** Disabled vendor " + vendorData.id)
}


/*
 *	Leave lock state
 */
function VMutVendor::VendorUnlock(vendorData) {

	if (!vendorData.locked)
		return
		
	::VMutVendor.VendorEnableUse(vendorData)
	::VMutGUI.HideSprite(vendorData.gui.lockDisplay)
	
	vendorData.locked = false
}


/*
 *	Enter lock state
 */
function VMutVendor::VendorLock(vendorData) {

	if (vendorData.locked)
		return
		
	::VMutVendor.VendorDisableUse(vendorData)
	::VMutGUI.ShowSprite(vendorData.gui.lockDisplay)
	
	vendorData.locked = true
	
}


/*
 *	Begin countdown to self-destruct
 */
function VMutVendor::VendorStartExplodeSequence(vendorData) {

	//Prevent players from interacting with the vendor during the self-destruct sequence
	::VMutVendor.VendorDisableUse(vendorData)
	
	//Countdown functionality
	local countdown = function(params) {
		if (params.flash == true) {
			params.count--
			
			if (params.count < 0) {
				::VMutVendor.VendorExpire(vendorData, vendorData.expireType)
				return
			}
			
			EmitSoundOn("buttons/button11.wav", vendorData.entities.priceDisplayTarget)
			::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=0,b=0})
			::VMutGUI.DigitDisplayUpdateValue(vendorData.gui.priceDisplay, params.count.tostring())
			
			params.flash = false
		}
		else {
			::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=255,b=255})
			
			params.flash = true
		}
		
		//::VMutTimers.AddTimer("vendor_countdown_"+vendorData.id, 0.5, 0, countdown, params)
	}
	
	//Begin countdown
	local params = {flash = true, count = 5}
	::VMutTimers.AddTimer("vendor_countdown_"+vendorData.id, 0.5, params.count*2, countdown, params)
}


/*
 *	Cancel self-destruct sequence
 */
function VMutVendor::VendorCancelExplodeSequence(vendorData) {
	//Cancel countdown
	::VMutTimers.RemoveTimer("vendor_countdown"+vendorData.id)
	
	//Reset gui
	::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=255,b=255})
	::VMutGUI.DigitDisplayUpdateValue(vendorData.gui.priceDisplay, ::VMutItemData.itemDataArray[vendorData.itemId].cost)

	//Let players interact with the vendor
	::VMutVendor.VendorEnableUse(vendorData)
}


/*
 *	Returns true if this vendor is usable
 */ 
function VMutVendor::VendorIsUsable(vendorData) {
	return vendorData.enabled
}
 

/*
 *	Test if a player has enough currency to purchase an item from a vendor
 */
function VMutVendor::VendorPlayerCanAfford(vendorData, player) {
	return (::VMutCurrency.SurvivorGetCurrency(player.GetSurvivorSlot()) >= VendorGetPrice(vendorData))
}


/*
 *	Activate a vendor.
 */
function VMutVendor::ActivateVendor(vendorData, player) {
	
	//Attempt to deploy the vendor's item
	local deployStatus = ::VMutVendor.VendorDeploy(vendorData, player)
	
	// Failed to deploy? Play a sound, flash red and lock the vendor for a moment... 
	if (deployStatus == false) {

		EmitSoundOn("buttons/button11.wav", player)
		QueueSpeak(player, "PlayerNegative", 0.30, "")
		::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=0,b=0})
		::VMutVendor.VendorDisableUse(vendorData)
		::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_DISABLE_TIME, 0, function(params) {
		
			if (::VMutVendor.VendorExists(vendorData)) {
				//Re-enable vendor
				::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=255,b=255})
				::VMutVendor.VendorEnableUse(vendorData)
			}
		
		}, null)
		
		return false
	}	
	
	// Successfully activated the vendor. Play a sound, flash blue and lock the vendor for a moment...
	if (deployStatus == true) {
		
		EmitSoundOn("buttons/button4.wav", player)
		::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=80,g=186,b=255})
		::VMutVendor.VendorDisableUse(vendorData)
		::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_DISABLE_TIME, 0, function(params) {
		
			if (::VMutVendor.VendorExists(vendorData)) {
				//Re-enable vendor
				::VMutGUI.DigitDisplaySetColor(vendorData.gui.priceDisplay, {r=255,g=255,b=255})
				::VMutVendor.VendorEnableUse(vendorData)
				
				//Determine if this vendor should expire
				::VMutVendor.VendorFinish(vendorData)
			}
			
		}, null)
		
		// Finish up. Remove currency from the survivor who activated this vendor
		::VMutCurrency.SurvivorRemoveCurrency(player.GetSurvivorSlot(), VendorGetPrice(vendorData))
		vendorData.timesUsed++
	
		return true
	}
	
	return null
	
}


/*
 *	Post function that is called after activating a vendor. Determine if a vendor should expire or not.
 */
 function VMutVendor::VendorFinish(vendorData) {
 
	//When conditions are met, enter explode sequence
	if (vendorData.timesUsed >= VENDOR_MIN_SAFE_USES && !::VMutVendor.VendorIsSafe(vendorData)) {
		local chance = 0
		if (vendorData.timesUsed < VENDOR_MAX_SAFE_USES)
			chance = RandomInt(0, VENDOR_EXPIRE_CHANCE)
			
		if (chance == 0) {
			//Either change item or die
			local chance = RandomInt(0, 2)
			if (chance <= 1)
				vendorData.expireType = EXPIRE_CHANGE
			else
				vendorData.expireType = EXPIRE_EXPLODE_EFFECT

			::VMutVendor.VendorStartExplodeSequence(vendorData)
		}
	}
	
 }
 

/*
 *	Deploy a vendor's item
 */
function VMutVendor::VendorDeploy(vendorData, player) {

	// Retrieve the item-data associated with this vendor's itemid
	local itemid = vendorData.itemId;
	if (!itemid) {return null}
		
	local itemData = ::VMutItemData.itemDataArray[itemid]
	if (!itemData) {return null}
	
	//Test if the player who activated the vendor has enough currency to afford the vendor's item
	if (!::VMutVendor.VendorPlayerCanAfford(vendorData, player))
		return false
	
	//Attempt to deploy the item. The method and conditions of deployment depend on the itemdata type
	local deployStatus = true
	switch (itemData.type) {
		case ITEMDATA_TYPE_ITEM:
			deployStatus = ::VMutVendor.VendorDeployItem(vendorData, player)
			break;
		
		case ITEMDATA_TYPE_MELEE:
			deployStatus = ::VMutVendor.VendorDeployMelee(vendorData, player)
			break;
			
		case ITEMDATA_TYPE_UPGRADE:
			deployStatus = ::VMutVendor.VendorDeployUpgrade(vendorData, player)
			break;
	}
	
	//Failure to deploy means we return false
	if (deployStatus == false)
		return false
	
	// If the itemdata contains a callback function, then execute it now...
	if ("callback" in itemData) {
		itemData.callback(vendorData, player)
	}
	
	return true
}


/*
 *	Deploy an item and give it to the specified player.
 */
function VMutVendor::VendorDeployItem(vendorData, player) {
	//Give the item
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemId]
	return ::VMutInventory.GiveItem(player, itemData.data)
}


/*
 *	Deploy a melee weapon and give it to the specified player.
 */
function VMutVendor::VendorDeployMelee(vendorData, player) {
	//Give the melee
	return ::VMutInventory.GiveItem(player, vendorData.meleeId)
}


/*
 *	Deploy an upgrade on the specified player. Return false if player has no primary.
 */
function VMutVendor::VendorDeployUpgrade(vendorData, player) {
	//Give the upgrade
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemId]
	return ::VMutInventory.GiveUpgrade(player, itemData.data)
}


/*
 *	Make this vendor expire.
 *	It will either explode or change to a new item
 */
function VMutVendor::VendorExpire(vendorData, expireType) {
	
	switch (expireType) {
	
		case EXPIRE_CHANGE:
			local newItemId = ITEM_ID.EMPTY
		
			if ((vendorData.flags & VFLAG_PRESERVE_SPAWNDATA) != 0) {
				newItemId = ::VMutItemData.RandomizeItem(vendorData.spawnData.blacklist)
			}
			else {
				newItemId = ::VMutItemData.RandomizeItem(null)
			}
			
			::VMutVendor.VendorSetItemId(vendorData, newItemId)
			EmitSoundOn("buttons/bell1.wav", vendorData.entities.priceDisplayTarget)
			
			::VMutVendor.VendorEnableUse(vendorData)
			vendorData.timesUsed = 0
			break
			
			
		case EXPIRE_EXPLODE_SAFE:
			::VMutUtils.Explode(vendorData.entities.propMachine.GetOrigin())
			::VMutVendor.DestroyVendor(vendorData)
		break
		
		
		case EXPIRE_EXPLODE_EFFECT:
			::VMutUtils.Explode(vendorData.entities.propMachine.GetOrigin())
			::VMutVendor.DestroyVendor(vendorData)
			
			//Activate a random expire effect...
			//Spawn some currency, spawn an item, spawn a lit pipebomb, spawn a special infected, etc...
		break
		
	}
	
}


/*
 *	Assign a new item-id to a vendor
 */
function VMutVendor::VendorSetItemId(vendorData, itemId) {
	local itemData = ::VMutItemData.itemDataArray[itemId]
	
	vendorData.itemId = itemId;
		
	::VMutVendor.VendorUpdateDisplay(vendorData)
	::VMutGUI.DigitDisplayUpdateValue(vendorData.gui.priceDisplay, itemData.cost.tostring()) 
	
	printl(" ** Vendor " + vendorData.id + " set item id to " + itemId)
}


/*
 *	Assign a new melee-id to a vendor
 */
function VMutVendor::VendorSetMeleeId(vendorData, meleeId) {
	vendorData.meleeId = meleeId;
	
	if (vendorData.itemId == ITEM_ID.MELEE) {
		::VMutVendor.VendorUpdateDisplay(vendorData)
		::VMutGUI.DigitDisplayUpdateValue(vendorData.gui.priceDisplay, itemData.cost.tostring()) 
	}
	
	printl(" ** Vendor " + vendorData.id + " set melee id to " + meleeId)
}


/*
 *	Update a vendor's display model
 */
function VMutVendor::VendorUpdateDisplay(vendorData) {
	//Get itemData
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemId]
	
	//Melee specific display model
	if (itemData.type == ITEMDATA_TYPE_MELEE) {
		vendorData.entities.propItem.SetModel(g_ModeScript.meleeModelWorld[vendorData.meleeId])
	}
	else {
		if (itemData.display)
			vendorData.entities.propItem.SetModel(itemData.display)
	}
	
}


/*
 *	Get the current cost of activating a vendor
 */
function VMutVendor::VendorGetPrice(vendorData) {
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemId]
	return itemData.cost * vendorData.priceMultiplier
}


/*
 *	Check if a vendor is "safe" (cannot expire or change item)
 */
function VMutVendor::VendorIsSafe(vendorData) {
	if ((vendorData.flags & VFLAG_SAFE) != 0)
		return true
	return false
}


/*
 *	Check if a vendor exists
 */
function VMutVendor::VendorExists(vendorData) {
	return (vendorData.id in ::VMutVendor.vendorTable)
}
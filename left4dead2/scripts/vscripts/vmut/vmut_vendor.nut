//Author: Waifu Enthusiast
::VMutVendor <- {}


const VENDOR_FINISH_TIME			= 2
const VENDOR_FAIL_LOCK_TIME			= 1
const PRICE_DISPLAY_TEXTURE_SIZE	= 32
const PRICE_DISPLAY_SCALE			= 0.2 //0.2 is the smallest a sprite can be
const PRICE_DISPLAY_MAX_SPRITES		= 4

const VENDOR_USE_NULL				= 0
const VENDOR_USE_SUCCESS			= 0
const VENDOR_USE_FAIL				= 0

const VFLAG_START_LOCKED		= 1	//Vendor will spawn locked and unusable until unlocked via a script
const VFLAG_PRESERVE_SPAWNDATA	= 2	//When a vendor changes its item, reuse the spawndata to determine how the randomizer will select the new item
const VFLAG_SAFE				= 4 //Vendor will never change its item or expire


::VMutVendor.digitModels <- [
	"sprites/digits/digit0.vmt",
	"sprites/digits/digit1.vmt",
	"sprites/digits/digit2.vmt",
	"sprites/digits/digit3.vmt",
	"sprites/digits/digit4.vmt",
	"sprites/digits/digit5.vmt",
	"sprites/digits/digit6.vmt",
	"sprites/digits/digit7.vmt",
	"sprites/digits/digit8.vmt",
	"sprites/digits/digit9.vmt"
]


function VMutVendor::Precache() {
	printl(" ** VMUT Vendor Precache")

	PrecacheSound("buttons/button4.wav")
	PrecacheSound("buttons/button11.wav")
	PrecacheSound("buttons/bell1.wav")
	
	foreach (model in ::VMutVendor.digitModels)
		PrecacheModel(model)
}


::VMutVendor.vendorTable <- {}	//Contains the state of all vendors


/*
 *	Create a new vendor.
 */
function VMutVendor::CreateVendor(origin, angles, flags = 0) {

	//Initialize the new vendor's data
	local id = UniqueString()
	local vendorData = {
		entities		= {
			deployTarget 		= null
			priceDisplayTarget 	= null
			propMachine 		= null
			propItem 			= null
			usetarget 			= null
		}
		priceDisplay	= []
		itemId			= ITEM_ID.EMPTY //DO NOT manually modify this value. Call VenorSetItemId() instead.
		itemParam		= null			//Certain itemdata types will need additional data to work properly. That additional data goes here.
		timesUsed		= 0
		priceMultiplier	= 1
		locked			= false
		id				= id			//Unique identifier used to index the main vendor table
		tag				= null			//Tagging vendors allows certain vendors to be found and referenced after they are spawned via the vendor spawning system.
		flags			= flags			//Flags that are assigned via spawndata. Has some effects on vendor behaviour. Advised to NOT manually alter this value, instead set it via spawndata.
	}
	
	
	//Generate callbacks for each entity in the entity group. This will make entities add themselves to the vendor's entity data after spawning.
	local entGroup = ::VMutVendorEnt.GetEntityGroup()
	entGroup.SpawnTables[ "deploy_target" ].PostPlaceCB 		<- function(entity, rarity) {vendorData.entities.deployTarget		<- entity}
	entGroup.SpawnTables[ "price_display_target" ].PostPlaceCB	<- function(entity, rarity) {vendorData.entities.priceDisplayTarget	<- entity}
	entGroup.SpawnTables[ "prop_item" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propItem 			<- entity}
	entGroup.SpawnTables[ "prop_machine" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propMachine 		<- entity}
	
	
	//Spawn the entity group. Initialize vendor's usetarget entity and price-display entities.
	g_ModeScript.SpawnSingleAt(VMutVendorEnt.GetEntityGroup(), origin, angles)
	::VMutVendor.VendorCreateAndAttachUseTarget(vendorData)
	::VMutVendor.VendorPriceDisplayInitializeSprites(vendorData, 4)

	::VMutVendor.vendorTable[id] <- vendorData
	
	
	//Lock vendor if flags say so
	if ((flags & VFLAG_START_LOCKED) != 0)
		::VMutVendor.VendorLock(vendorData)
	
	
	//Return a reference to the created vendor
	return vendorData
	
}


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
 *	Cleanup a vendor and all of its associated entities.
 */
function VMutVendor::DestroyVendor(vendorData) {

	//Destroy all associated entities
	foreach (ent in vendorData.entities) {
		if (ent)
			ent.Kill()
	}
	
	//Cleanup price display
	::VMutVendor.VendorPriceDisplayDestroySprites(vendorData)
	
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
	if (vendorData.entities.usetarget)
		return false

	
	//Create and initialize usetarget entity
	local kvs = {
		model 		= vendorData.entities.propMachine.GetName()
		origin 		= vendorData.entities.propMachine.GetOrigin() + Vector( 0, -24, 0 )
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
		
	return true
	
}


/*
 *	Unlock a vendor and allow players to interact with it again.
 */
function VMutVendor::VendorUnlock(vendorData) {

	if (!vendorData.locked)
		return
		
	//Recreate this vendor's usetarget entity so that players can interact with it
	::VMutVendor.VendorCreateAndAttachUseTarget(vendorData)
	//EntFire( vendorData.entities.usetarget.GetName(), "activate", 0, 0 )
	vendorData.locked = false
	
}


/*
 *	Lock a vendor and prevent players from interacting with it.
 */
function VMutVendor::VendorLock(vendorData) {

	if (vendorData.locked)
		return
		
	//Stop players from using this vendor by completely removing its usetarget entity
	::VMutVendor.VendorKillUseTarget(vendorData)
	//EntFire( vendorData.entities.usetarget.GetName(), "deactivate", 0, 0 )
	vendorData.locked = true
	
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
		::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=0,b=0})
		::VMutVendor.VendorLock(vendorData)
		::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(params) {
		
			if (::VMutVendor.VendorExists(vendorData)) { 
				::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
				::VMutVendor.VendorUnlock(vendorData)
			}
		
		}, null)
		
		return false
	}	
	
	// Successfully activated the vendor. Play a sound, flash blue and lock the vendor for a moment...
	if (deployStatus == true) {
		
		EmitSoundOn("buttons/button4.wav", player)
		::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=80,g=186,b=255})
		::VMutVendor.VendorLock(vendorData)
		::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(params) {
		
			if (::VMutVendor.VendorExists(vendorData)) {
				::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
				::VMutVendor.VendorUnlock(vendorData)
			}
			
		}, null)
		
	}
	
	// Finish up. Remove currency from the survivor who activated this vendor
	::VMutCurrency.SurvivorRemoveCurrency(player.GetSurvivorSlot(), VendorGetPrice(vendorData))
	vendorData.timesUsed++
	return true
	
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
	return ::VMutInventory.GiveItem(player, vendorData.itemParam)
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
 *	Assign a new item-id to a vendor
 */
function VMutVendor::VendorSetItemId(vendorData, id) {
	local itemData = ::VMutItemData.itemDataArray[id]
	
	vendorData.itemId = id;
		
	::VMutVendor.VendorUpdateDisplay(vendorData)
	::VMutVendor.VendorPriceDisplayUpdateValue(vendorData, itemData.cost)
}


/*
 *	Update a vendor's display model
 */
function VMutVendor::VendorUpdateDisplay(vendorData) {
	//Get itemData
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemId]
	
	//Melee specific display model
	if (itemData.type == ITEMDATA_TYPE_MELEE) {
		vendorData.entities.propItem.SetModel(g_ModeScript.meleeModelWorld[vendorData.itemParam])
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
 *	Check if a vendor exists
 */
function VMutVendor::VendorExists(vendorData) {
	return (vendorData.id in ::VMutVendor.vendorTable)
}


//------------------------------------------------------------------------------------------------------
//VENDOR PRICE-DISPLAY FUNCTIONALITY

/*
 *	Creates the sprites that show an item's cost.
 *	count = The maximum number of digits that the display can show.
 */
function VMutVendor::VendorPriceDisplayInitializeSprites(vendorData, count) {

	//Don't create duplicate sprites
	::VMutVendor.VendorPriceDisplayDestroySprites(vendorData)
	
	for (local i = 0; i < count; i++) {
	
		local angle = vendorData.entities.priceDisplayTarget.GetAngles()
		angle = QAngle(-angle.z, angle.y+90, angle.x) //shrug
		local offsetScalar = i * PRICE_DISPLAY_TEXTURE_SIZE * PRICE_DISPLAY_SCALE
		local offsetVector = angle.Left().Scale(offsetScalar)
		
		local kvs = {
			targetname 	= "price_display_digit_" + vendorData.id + "_" + i
			scale		= PRICE_DISPLAY_SCALE
			origin 		= vendorData.entities.priceDisplayTarget.GetOrigin() + offsetVector
			model 		= digitModels[0]
			rendermode	= 1
			spawnflags	= 1
		}
		
		local ent = SpawnEntityFromTable("env_sprite", kvs)
		vendorData.priceDisplay.append(ent)
		
		ent.SetAngles(angle)
		EntFire(ent.GetName(), "ShowSprite")
		
	}
	
}


/*
 *	Update sprites to display a new value
 */
function VMutVendor::VendorPriceDisplayUpdateValue(vendorData, newValue) {
	local digitArray = ::VMutUtils.DigitArrayFromValue(newValue)
	
	for (local i = 0; i < vendorData.priceDisplay.len(); i++) {
		local sprite = vendorData.priceDisplay[i]
	
		if (i >= digitArray.len()) {
			EntFire(sprite.GetName(), "HideSprite")
			continue
		}
		
		EntFire(sprite.GetName(), "ShowSprite")
		local digit = digitArray[i]
		sprite.SetModel(::VMutVendor.digitModels[digit])
	}
}


/*
 *	Cleanup all of the sprites in a vendor's price-display
 */
function VMutVendor::VendorPriceDisplayDestroySprites(vendorData) {
	foreach (sprite in vendorData.priceDisplay) {
		sprite.Kill()
	}
	vendorData.priceDisplay.clear()
}


/*
 *	Set color of all sprites in a vendor's price-display
 */
function VMutVendor::VendorPriceDisplaySetColor(vendorData, color) {
	foreach (sprite in vendorData.priceDisplay) {
		EntFire(sprite.GetName(), "ColorRedValue",		color.r.tostring())
		EntFire(sprite.GetName(), "ColorGreenValue",	color.g.tostring())
		EntFire(sprite.GetName(), "ColorBlueValue", 	color.b.tostring())
	}
}
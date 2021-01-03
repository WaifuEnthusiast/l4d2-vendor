//Author: Waifu Enthusiast
::VMutVendor <- {} //Consider using a class to manage vendor functionality instead. Makes more sense.


//Will possibly turn vendors and vendor price displays into two spearate classes. 
//Vendor instances will each have their own instance of a price display.
//That way, vendors need only manage their price displays through the provided interface, and price displays become even more self-contained with fewer dependencies...


const VENDOR_FINISH_TIME			= 2
const VENDOR_FAIL_LOCK_TIME			= 1
const PRICE_DISPLAY_TEXTURE_SIZE	= 32
const PRICE_DISPLAY_SCALE			= 0.2 //0.2 is the smallest a sprite can be
const PRICE_DISPLAY_MAX_SPRITES		= 4


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
	PrecacheSound("buttons/button4.wav")
	PrecacheSound("buttons/button11.wav")
	PrecacheSound("buttons/bell1.wav")
	
	foreach (model in ::VMutVendor.digitModels)
		PrecacheModel(model)
}


function VMutVendor::CreateVendor(origin, angles) {

	local id = UniqueString()
	local vendorData = {
		entities		= {}
		priceDisplay	= []
		itemType		= ITEM_ID.EMPTY
		timesUsed		= 0
		priceMultiplier	= 1
		id				=  id
	}
		
	local UsetargetCB = function(entity, rarity) {
		entity.CanShowBuildPanel(false)
		entity.SetProgressBarText("Using Vendor...")
		entity.SetProgressBarFinishTime(VENDOR_FINISH_TIME)
		
		entity.ValidateScriptScope()
		local usetargetScope = entity.GetScriptScope()
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
			
		entity.ConnectOutput("OnUseFinished", 	"UseFinish")
		entity.ConnectOutput("OnUseStarted", 	"UseStart")
		entity.ConnectOutput("OnUseCancelled", 	"UseStop")
		
		printl(" ** usetarget callback")
	}
	
	local PriceDisplayCB = function(entity, rarity) {
		::VMutVendor.VendorPriceDisplayInitializeSprites(vendorData, 4)
	}

	local entGroup = ::VMutVendorEnt.GetEntityGroup()
	entGroup.SpawnTables[ "deploy_target" ].PostPlaceCB 		<- function(entity, rarity) {vendorData.entities.deployTarget		<- entity}
	entGroup.SpawnTables[ "price_display_target" ].PostPlaceCB	<- function(entity, rarity) {vendorData.entities.priceDisplayTarget	<- entity; PriceDisplayCB(entity, rarity)}
	entGroup.SpawnTables[ "prop_item" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propItem 			<- entity}
	entGroup.SpawnTables[ "prop_machine" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propMachine 		<- entity}
	entGroup.SpawnTables[ "usetarget" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.usetarget 			<- entity; UsetargetCB(entity, rarity)}
		
	g_ModeScript.SpawnSingleAt(VMutVendorEnt.GetEntityGroup(), origin, angles)
	g_ModeScript.SessionState.vendorTable[id] <- vendorData
	return vendorData
}


function VMutVendor::DestroyVendor(vendorData) {
	//Destroy all associated entities
	foreach (ent in vendorData.entities) {
		ent.Kill()
	}
	
	//Cleanup price display
	::VMutVendor.VendorPriceDisplayDestroySprites(vendorData)
	
	//Remove from vendor table
	local id = vendorData.id
	delete g_ModeScript.SessionState.vendorTable[id]
} 


function VMutVendor::ActivateVendor(vendorData, player) {
	
	printl("Vendor Activated By " + player)
	
	if (::VMutCurrency.SurvivorGetCurrency(player.GetSurvivorSlot()) < VendorGetPrice(vendorData)) {	
		EmitSoundOn("buttons/button11.wav", player)
		QueueSpeak(player, "PlayerNegative", 0.3, "")
		::VMutVendor.VendorLock(vendorData)
		::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=0,b=0})
		
		::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(h) {
		
			if (::VMutVendor.VendorExists(vendorData)) {
				::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
				::VMutVendor.VendorUnlock(vendorData)
			}
		
		}, null)
		
		return false
	}

	local type = vendorData.itemType;
	if (!type) 
		return false
		
	local itemData = ::VMutItemData.itemDataArray[type]
	if (!itemData)
		return false
	
	local ent = null
	if ("classname" in itemData) {
		
		local kvs = {}
		if ("keyvalues" in itemData)
			kvs = clone itemData.keyvalues
			
		kvs.origin 	<- vendorData.entities.deployTarget.GetOrigin()
		kvs.angles 	<- QAngle(0,0,0).ToKVString()
		
		ent = SpawnEntityFromTable(itemData.classname, kvs)
		
	}
		
	if ("func" in itemData) {
		
		local params = null
		if ("params" in itemData)
			params = itemData.params
			
		itemData.func(vendorData, player, params)
	}
	
	EmitSoundOn("buttons/button4.wav", player)
	::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=80,g=186,b=255})
	::VMutVendor.VendorLock(vendorData)
	::VMutTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(h) {
	
		if (::VMutVendor.VendorExists(vendorData)) {
			::VMutVendor.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
			::VMutVendor.VendorUnlock(vendorData)
		}
		
	}, null)
	
	::VMutCurrency.SurvivorRemoveCurrency(player.GetSurvivorSlot(), VendorGetPrice(vendorData))
	vendorData.timesUsed++
	return true
}


function VMutVendor::VendorLock(vendorData) {
	//VendorDestroyUsetarget(vendorData)
}


function VMutVendor::VendorUnlock(vendorData) {
	//VendorCreateAndAttachUseTarget(vendorData)
}


function VMutVendor::VendorSetItemType(vendorData, type) {
	local itemData = ::VMutItemData.itemDataArray[type]
	
	vendorData.itemType = type;
		
	if (itemData.display)
		vendorData.entities.propItem.SetModel(itemData.display)
		
	::VMutVendor.VendorPriceDisplayUpdateValue(vendorData, itemData.cost)
}


function VMutVendor::VendorGetPrice(vendorData) {
	local itemData = ::VMutItemData.itemDataArray[vendorData.itemType]
	return itemData.cost * vendorData.priceMultiplier
}


function VMutVendor::VendorExists(vendorData) {
	return (vendorData.id in SessionState.vendorTable)
}


//------------------------------------------------------------------------------------------------------
//VENDOR PRICE-DISPLAY FUNCTIONALITY

function VMutVendor::VendorPriceDisplayInitializeSprites(vendorData, count) {
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


function VMutVendor::VendorPriceDisplayDestroySprites(vendorData) {
	foreach (sprite in vendorData.priceDisplay) {
		sprite.Kill()
	}
	vendorData.priceDisplay.clear()
}


function VMutVendor::VendorPriceDisplaySetColor(vendorData, color) {
	foreach (sprite in vendorData.priceDisplay) {
		EntFire(sprite.GetName(), "ColorRedValue",		color.r.tostring())
		EntFire(sprite.GetName(), "ColorGreenValue",	color.g.tostring())
		EntFire(sprite.GetName(), "ColorBlueValue", 	color.b.tostring())
	}
}
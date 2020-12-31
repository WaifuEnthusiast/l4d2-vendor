//Vendor mutation
//Author: Waifu Enthusiast

//------------------------------------------------------------------------------------------------------
//DECLARE CONSTANTS

const VENDOR_FINISH_TIME			= 2
const VENDOR_FAIL_LOCK_TIME			= 1
const MONEY_BIG_THRESHOLD 			= 1000
const UPGRADE_INCENDIARY_AMMO 		= 0
const UPGRADE_EXPLOSIVE_AMMO 		= 1
const UPGRADE_LASER_SIGHT 			= 2
const PRICE_DISPLAY_TEXTURE_SIZE	= 32
const PRICE_DISPLAY_SCALE			= 0.2 //0.2 is the smallest a sprite can be
const PRICE_DISPLAY_MAX_SPRITES		= 4

enum ITEM_ID {
	EMPTY

    SMG,
    SMG_SILENCED,
    SHOTGUN,
    SHOTGUN_CHROME,
    
    AK47,
    M16,
    DESERT_RIFLE,
    AUTOSHOTGUN,
    SHOTGUN_SPAS,
    HUNTING_RIFLE,
    SNIPER_RIFLE,
    
    PISTOL,
    MAGNUM,
    
    MACHINEGUN,
    GRENADE_LAUNCHER,
    CHAINSAW,
    
    MOLOTOV,
    PIPEBOMB,
    BILE_JAR,
    
    PAIN_PILLS,
    ADRENALINE,
    FIRST_AID_KIT,
    DEFIBRILLATOR,
    
    FIREAXE,
    KATANA,
    
    GAS,
    PROPANE,
    
    INCENDIARY_UPGRADE,
    EXPLOSIVE_UPGRADE,
    LASERSIGHTS_UPGRADE,
    AMMO_REFILL
}


//------------------------------------------------------------------------------------------------------
//INCLUDE

IncludeScript("entitygroups/vendor_vendor_group")

IncludeScript("vendor_itemdata")
IncludeScript("vendor_timers")

//------------------------------------------------------------------------------------------------------
//MUTATION SETUP

ModeSpawns <-
[
     //["VendorVendor", "vendorspawn_*", "vendor_vendor_group", SPAWN_FLAGS.SPAWN],
]


MutationOptions <- {
	
}


MutationState <- {
	vendorTable = {}
	currency = [0,0,0,0]
}


function OnGameplayStart() {
	printl( " ** On Gameplay Start" )
	
	Precache()
	
	CreateVendor(Entities.FindByName(null, "vendorspawn_001"))
	CreateVendor(Entities.FindByName(null, "vendorspawn_002"))
	CreateVendor(Entities.FindByName(null, "vendorspawn_003"))
	
	VendorSetItemType(SessionState.vendorTable[0], ITEM_ID.FIRST_AID_KIT)
	VendorSetItemType(SessionState.vendorTable[1], ITEM_ID.AUTOSHOTGUN)
	VendorSetItemType(SessionState.vendorTable[2], ITEM_ID.MOLOTOV)
	
	GiveCurrencyToAllSurvivors(10000)
	
	//Depending on performance requirements, we may need to create proper systems to only update the hud when needed...
	//For example, on GiveCurrencyToAllSurvivors() also call HudUpdateCurrency(all) or something...
	//This would also ensure that the hud updates EXACTLY at the right time, and we don't need to wait for l4d2 to call hudupdate()...
	//Adds better responsiveness
	local hudTable = {
		Fields = {
			names = {
				slot = HUD_RIGHT_TOP
				flags = HUD_FLAG_NOBG | HUD_FLAG_TEAM_SURVIVORS | HUD_FLAG_ALIGN_RIGHT 
				datafunc = function() {
					
					local string = ""
					
					for (local i = 0; i < 4; i++) {
						string += g_ModeScript.SurvivorSlotToPlayer(i).GetPlayerName()
						if (i < 3) string += "\n"
					}
					
					return string
					
				}
			}
			currency = {
				slot = HUD_RIGHT_BOT
				flags = HUD_FLAG_NOBG | HUD_FLAG_TEAM_SURVIVORS 
				datafunc = function() {
					
					local string = ""
					
					for (local i = 0; i < 4; i++) {
						string += "$"+g_ModeScript.SurvivorGetCurrency(i)
						if (i < 3) string += "\n"
					}
					
					return string
					
				}
			}
		}
	}
	
	HUDSetLayout(hudTable)
	HUDPlace(HUD_RIGHT_TOP, 0.7, 0.025, 0.2, 0.2)
	HUDPlace(HUD_RIGHT_BOT, 0.9, 0.025, 0.1, 0.2)
}


function OnActivate() {
	printl( " ** On Activate" )
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}


function Precache() {
	PrecacheModel("models/props_collectables/money_wad.mdl")
	
	PrecacheModel("sprites/digits/digit0.vmt")
	PrecacheModel("sprites/digits/digit1.vmt")
	PrecacheModel("sprites/digits/digit2.vmt")
	PrecacheModel("sprites/digits/digit3.vmt")
	PrecacheModel("sprites/digits/digit4.vmt")
	PrecacheModel("sprites/digits/digit5.vmt")
	PrecacheModel("sprites/digits/digit6.vmt")
	PrecacheModel("sprites/digits/digit7.vmt")
	PrecacheModel("sprites/digits/digit8.vmt")
	PrecacheModel("sprites/digits/digit9.vmt")
	
	PrecacheSound("buttons/button4.wav")
	PrecacheSound("buttons/button11.wav")
	PrecacheSound("buttons/bell1.wav")
	
	g_vendorItemData.PrecacheModels()
}


function ThinkFunc() {
	printl("eat")
}


//------------------------------------------------------------------------------------------------------
//VENDOR FUNCTIONALITY

vendorCount <- 0
function CreateVendor(position_ent) {
	local vendorData = {
		entities		= {}
		priceDisplay	= []
		itemType		= ITEM_ID.EMPTY
		timesUsed		= 0
		id				= vendorCount
	}
		
	local UsetargetCB = function(entity, rarity) {
		entity.CanShowBuildPanel(false)
		entity.SetProgressBarText("Using Vendor...")
		entity.SetProgressBarFinishTime(VENDOR_FINISH_TIME)
		
		entity.ValidateScriptScope()
		local usetargetScope = entity.GetScriptScope()
		usetargetScope.user <- null
		
		usetargetScope.UseFinish <- function() {
			g_ModeScript.ActivateVendor(vendorData,  g_ModeScript.EHandleToPlayer(usetargetScope.user))
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
		g_ModeScript.VendorPriceDisplayInitializeSprites(vendorData, 4)
	}

	VendorVendor.GetEntityGroup().SpawnTables[ "root" ].PostPlaceCB 				<- function(entity, rarity) {vendorData.entities.root	 			<- entity}
	VendorVendor.GetEntityGroup().SpawnTables[ "deploy_target" ].PostPlaceCB 		<- function(entity, rarity) {vendorData.entities.deployTarget		<- entity}
	VendorVendor.GetEntityGroup().SpawnTables[ "price_display_target" ].PostPlaceCB	<- function(entity, rarity) {vendorData.entities.priceDisplayTarget	<- entity; PriceDisplayCB(entity, rarity)}
	VendorVendor.GetEntityGroup().SpawnTables[ "prop_item" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.propItem 			<- entity}
	VendorVendor.GetEntityGroup().SpawnTables[ "prop_machine" ].PostPlaceCB 		<- function(entity, rarity) {vendorData.entities.propMachine 		<- entity}
	VendorVendor.GetEntityGroup().SpawnTables[ "usetarget" ].PostPlaceCB 			<- function(entity, rarity) {vendorData.entities.usetarget 			<- entity; UsetargetCB(entity, rarity)}
		
	local origin = position_ent.GetOrigin()
	local angles = QAngle(0,0,0)
	SpawnSingleAt(VendorVendor.GetEntityGroup(), origin, angles)
	
	SessionState.vendorTable[vendorCount++] <- vendorData
}


function DestroyVendor(vendorData) {
	//Destroy all associated entities
	foreach (ent in vendorData.entities) {
		ent.Kill()
	}
	
	//Cleanup price display
	VendorPriceDisplayDestroySprites(vendorData)
	
	//Remove from vendor table
	local id = vendorData.id
	delete SessionState.vendorTable[id]
} 


function ActivateVendor(vendorData, player) {
	
	printl("Vendor Activated By " + player)
	
	if (SurvivorGetCurrency(player.GetSurvivorSlot()) < GetVendorPrice(vendorData)) {	
		EmitSoundOn("buttons/button11.wav", player)
		QueueSpeak(player, "PlayerNegative", 0.3, "")
		VendorLock(vendorData)
		VendorPriceDisplaySetColor(vendorData, {r=255,g=0,b=0})
		
		g_vendorTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(h) {
		
			g_ModeScript.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
			g_ModeScript.VendorUnlock(vendorData)
		
		}, null)
		
		return false
	}

	local type = vendorData.itemType;
	if (!type) 
		return false
		
	local itemData = g_vendorItemData.itemDataArray[type]
	if (!itemData)
		return false
			
	if ("classname" in itemData) {
		
		local kvs = {}
		if ("keyvalues" in itemData)
			kvs = DuplicateTable(itemData)
			
		kvs.origin 	<- vendorData.entities.deployTarget.GetOrigin()
		kvs.angles 	<- QAngle(0,0,0).ToKVString()
		
		local ent = SpawnEntityFromTable(itemData.classname, kvs)
		
	}
		
	if ("func" in itemData) {
		
		local params = null
		if ("params" in itemData)
			params = itemData.params
			
		itemData.func(vendorData, player, params)
	}
	
	EmitSoundOn("buttons/button4.wav", player)
	VendorPriceDisplaySetColor(vendorData, {r=80,g=186,b=255})
	VendorLock(vendorData)
	g_vendorTimers.AddTimer("vendor_used_"+vendorData.id, VENDOR_FAIL_LOCK_TIME, function(h) {
		
		g_ModeScript.VendorPriceDisplaySetColor(vendorData, {r=255,g=255,b=255})
		g_ModeScript.VendorUnlock(vendorData)
		
	}, null)
	
	PlayerRemoveCurrency(player, GetVendorPrice(vendorData))
	vendorData.timesUsed++
	return true
}


function VendorLock(vendorData) {
	//Possibly take advantage of the bug wherein declaring OnUseStart() in the point_use_target stops players from being able to use it.
	//Dunno if relying on a bug for functionality is the best call, but you can't lock point_use_target like you can lock a func_button_timed.
	//Possibly find a way to kill the entity then recreate it later without losing all the data...
	//That's fine, since all the data is stored in the VendorTable anyway... All we lose is the functionality that we set up with a callback function.
	//We could easily reattach the point_use_target to the VendorTable and reinitialize all of its functionality on creation. Allthough, this is a pretty tedious workaround for a basic function...
}


function VendorUnlock(vendorData) {

}


function VendorSetItemType(vendorData, type) {
	local itemData = g_vendorItemData.itemDataArray[type]
	
	vendorData.itemType = type;
		
	if (itemData.display)
		vendorData.entities.propItem.SetModel(itemData.display)
		
	VendorPriceDisplayUpdateValue(vendorData, itemData.cost)
}


function GetVendorPrice(vendorData) {
	local itemData = g_vendorItemData.itemDataArray[vendorData.itemType]
	return itemData.cost
}


//------------------------------------------------------------------------------------------------------
//VENDOR PRICE-DISPLAY FUNCTIONALITY

digitModels <- [
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


function VendorPriceDisplayInitializeSprites(vendorData, count) {
	VendorPriceDisplayDestroySprites(vendorData)
	
	for (local i = 0; i < count; i++) {
	
		local angle = vendorData.entities.priceDisplayTarget.GetAngles() + QAngle(0,90,0)
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


function VendorPriceDisplayUpdateValue(vendorData, newValue) {
	local digitArray = DigitArrayFromValue(newValue)
	
	for (local i = 0; i < vendorData.priceDisplay.len(); i++) {
		local sprite = vendorData.priceDisplay[i]
	
		if (i >= digitArray.len()) {
			EntFire(sprite.GetName(), "HideSprite")
			continue
		}
		
		EntFire(sprite.GetName(), "ShowSprite")
		local digit = digitArray[i]
		sprite.SetModel(digitModels[digit])
	}
}


function VendorPriceDisplayDestroySprites(vendorData) {
	foreach (sprite in vendorData.priceDisplay) {
		sprite.Kill()
	}
	vendorData.priceDisplay.clear()
}


function VendorPriceDisplaySetColor(vendorData, color) {
	foreach (sprite in vendorData.priceDisplay) {
		EntFire(sprite.GetName(), "ColorRedValue",		color.r.tostring())
		EntFire(sprite.GetName(), "ColorGreenValue",	color.g.tostring())
		EntFire(sprite.GetName(), "ColorBlueValue", 	color.b.tostring())
	}
}


//------------------------------------------------------------------------------------------------------
//CURRENCY MANAGEMENT

function GiveCurrencyToAllSurvivors(quantity) {
	foreach (idx, value in SessionState.currency)
		SessionState.currency[idx] += quantity
}


function SurvivorGetCurrency(survivorSlot) {
	//local survivorSlot = player.GetSurvivorSlot()
	return SessionState.currency[survivorSlot]
}


function PlayerRemoveCurrency(player, quantity) {
	local survivorSlot = player.GetSurvivorSlot()
	SessionState.currency[survivorSlot] -= quantity
}


//------------------------------------------------------------------------------------------------------
//UTILITY

function EHandleToPlayer(ehandle) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
		
		if (ehandle == player.GetEntityHandle())
			return player
			
		
	}
}


function SurvivorSlotToPlayer(slot) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
			
		if (!player.IsPlayer())
			continue
			
		if (!player.IsSurvivor())
			continue
			
		if (player.GetSurvivorSlot() == slot)
			return player
		
	}
}


function DigitArrayFromValue(value) {

	//VERY quick and dirty method.
	//A proper approach would not use strings, but probably work upwards through the digits with a modulo operator
	
	if (value < 0)
		return [0]
	
	local digitArray = []
	local str = value.tostring()
	
	for (local i = 0; i < str.len(); i++) {
		local substr = str.slice(i, i+1)
		digitArray.append(substr.tointeger())
	}
	
	return digitArray
}

/*
//PSEUDO CODE FOR POTENTIAL REWORK. no idea how this affects performance...
//FROM LEAST SIGNIFICANT TO MOST SIGNIFICANT DIGIT
if (value < 0)
	return [0]
	
if (value < 10)
	return [value]

power = 1;
prevPower = 1;
remainder = 0;

while (remainder != value) {
	prevPower = power;
	power*=10;

	isolated = value mod power;
	isolated -= remainder;
	remainder += isolated;

	digit = isolated/prevPower;
	digitList.insert(0, digit); //most significant digit is at index 0. Least significant digit is at end of array.
}

return digitList
*/

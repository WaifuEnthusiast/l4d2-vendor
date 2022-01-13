//Vendor Mutation
//Author: Waifu Enthusiast

//@TODO
//See if MapState and MutationState add to the same table
//MapOptions + MutationOptions too

printl(" ** Executing mode script")

//------------------------------------------------------------------------------------------------------
//CONSTANTS

const DEFAULT_STARTING_CURRENCY = 4000

const ZONE_FLAG_NO_VENDORS		= 1	//No vendors will spawn in this zone
const ZONE_FLAG_NO_CURRENCY		= 2	//No currency items will spawn in this zone

//------------------------------------------------------------------------------------------------------
//INCLUDE

//@TODO move VendorEnt out of global scope, and have it ONLY referenced in vmut_vendor.nut. Then, if we want to create a vendor from anywhere in the program, we should use either VendorSpawnSystem.Spawn vendor or Vendor.CreateVendor()
IncludeScript("entitygroups/vmut_vendor_group.nut")
IncludeScript("entitygroups/vmut_vendor_mini_group.nut")
IncludeScript("entitygroups/vmut_currency_item_group.nut")

IncludeScript("vmut/vmut_persistent_state")
IncludeScript("vmut/vmut_itemdata")
IncludeScript("vmut/vmut_inventory")
IncludeScript("vmut/vmut_utils")
IncludeScript("vmut/vmut_timers")
IncludeScript("vmut/vmut_currency")
IncludeScript("vmut/vmut_gui")
IncludeScript("vmut/vmut_vendor")
IncludeScript("vmut/vmut_vendor_spawn_system")
IncludeScript("vmut/vmut_currency_spawn_system")


//------------------------------------------------------------------------------------------------------
//DEFAULT MAP SCRIPT TABLES

g_MapScript.defaultMinMedkitVendors <- 0
g_MapScript.defaultMaxMedkitVendors <- 0
g_MapScript.defaultVendorWitchLimit <- 1
g_MapScript.defaultMapCurrency		<- 6000
g_MapScript.defaultMinCurrencySpawns<- 30
g_MapScript.defaultMaxCurrencySpawns<- 40
g_MapScript.defaultStartingCurrency	<- 4000	//When a map is loaded at the start of a campagin, set currency to this ammount

g_MapScript.defaultVendorCandidates 		<- []
g_MapScript.defaultCurrencyItemCandidates 	<- []
g_MapScript.defaultProtectedZones			<- []

//Assign defaults to map properties here?
//minMedkitVendors <- defaultMinMedkitVendors????

/*
 *	Sets criteria that deems an entity as grounds for purging.
 *	Also defines callback functions that are called when an entity is purged.
 *
 *	Currently can only purge by classname, but additional purging criteria will be added in the future
 *	classname		- purge entities of this classname
 *	callback		- function that is executed when an entity is purged. The purged entity is passed as the argument.
 *	condition 		- a function that returns a boolean. If it returns false, cancel the purge.
 *
 *	Potential future criteria:
 *	targetname		- purge entities with this name
 *	position		- purge entities at this position
 *
 *	This is very similar to the sanitize table that is already present in the l4d2 mutation system.
 *	If there were some way to add callbacks to sanitized entities in the sanitize table then I would just be using that instead.
 *	Alas, I don't know any way to add pre or post functionality to each entity sanitized by the sanitize table. Thus, please welcome the purge table.
 *
 *	edit:	I've made the difficult design decision to allow secondary weapons to spawn normally.
 */
g_MapScript.purgeTable <- [
	{classname = "weapon_spawn", 						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_item_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_ammo_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_first_aid_kit_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_defibrillator_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_pain_pills_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_adrenaline_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_molotov_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_pipe_bomb_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_vomitjar_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_upgradepack_incendiary_spawn",	callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_upgradepack_explosive_spawn",	callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_smg_spawn",                    callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_smg_silenced_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_shotgun_spawn",                callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_shotgun_chrome_spawn",         callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_rifle_spawn",                  callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_ak47_spawn",                   callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_desert_rifle_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_autoshotgun_spawn",            callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_shotgun_spas_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_hunting_rifle_spawn",          callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_sniper_military_spawn",        callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_chainsaw_spawn",               callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_grenade_launcher_spawn",       callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_rifle_m60_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	//{classname = "weapon_melee_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	//{classname = "weapon_pistol_spawn",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	//{classname = "weapon_pistol_magnum_spawn",			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_pistol_gascan_spawn",			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_pistol_propane_spawn",			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_ammo", 						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} )},
	{classname = "weapon_first_aid_kit", 				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_defibrillator", 				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_pain_pills", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_adrenaline",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_molotov",						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_pipe_bomb",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_vomitjar",						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_upgradepack_incendiary",		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_upgradepack_explosive",		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_smg",                    		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_smg_silenced",           		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_shotgun",                		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_shotgun_chrome",         		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_rifle",                  		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_ak47",                   		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_desert_rifle",           		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_autoshotgun",            		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_shotgun_spas",           		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_hunting_rifle",          		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_sniper_military",        		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_chainsaw",               		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_grenade_launcher",       		callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_rifle_m60",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	//{classname = "weapon_melee", 						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	//{classname = "weapon_pistol",						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	//{classname = "weapon_pistol_magnum",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_pistol_gascan",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "weapon_pistol_propane",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) !ent.GetOwnerEntity()},
	{classname = "prop_physics", 						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin()} ),		condition = @(ent) (ent.GetModelName() ==  "models/props_junk/propanecanister001a.mdl" || ent.GetModelName() == "models/props_junk/gascan001a.mdl") }
]


//------------------------------------------------------------------------------------------------------
//MODE SETUP

MutationOptions <- {
	
}


MutationState <- {

}


function OnGameplayStart() {
	printl( " ** On Gameplay Start" )
	
	//if ("MapSetup" in g_MapScript)
	//	g_MapScript.MapSetup()
	
	//Post-map data persistence
	::VMutPersistentState.LoadLandmarkData()
	::VMutPersistentState.SaveLandmarkData()	//Saved tables are cleared after they are restored, thus we need to immediately save them again...
	
	//Map setup: Spawn vendors and currency items
	//@TODO move these to map scripts?
	::VMutVendorSpawnSystem.SpawnVendorsFromLandmarkData()
	::VMutCurrencySpawnSystem.SpawnCurrencyItemsFromLandmarkData()
		
	::VMutVendorSpawnSystem.SpawnAndDistributeVendors()
	::VMutCurrencySpawnSystem.SpawnAndDistributeCurrencyItems()
	
	//Round setup: Setup survivor state
	::VMutCurrency.LoadPersistentCurrency()
	if (!::VMutCurrency.IsInitialized()) {
		if ("startingCurrency" in g_MapScript)
			::VMutCurrency.GiveCurrencyToAllSurvivors(g_MapScript.startingCurrency)
		else
			::VMutCurrency.GiveCurrencyToAllSurvivors(DEFAULT_STARTING_CURRENCY)
		::VMutCurrency.SetInitialized()
	}
	::VMutCurrency.SavePersistentCurrency() //Saved tables are cleared after they are restored, thus we need to immediately save them again...
}


function OnActivate() {
	printl( " ** On Activate" )
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}


function Precache() {
	printl( " ** VMUT Precache" )
	
	PrecacheMeleeModels()
	
	::VMutItemData.Precache()
	::VMutGUI.Precache()
	::VMutVendor.Precache()
	::VMutCurrency.Precache()
}


//------------------------------------------------------------------------------------------------------
//PERSISTENT DATA SAVING

function OnGameEvent_map_transition(params) {

	printl(" ** map transition")
	
	//Save current currency to persistent currency table
	::VMutCurrency.SavePersistentCurrency()
	
	//Save post-map data
	::VMutPersistentState.BuildLandmarkData()
	::VMutPersistentState.SaveLandmarkData()

}


//------------------------------------------------------------------------------------------------------
//HUD SETUP

ModeHUD <- {
	Fields = {
		names = {
			slot = HUD_RIGHT_TOP
			flags = HUD_FLAG_NOBG | HUD_FLAG_TEAM_SURVIVORS | HUD_FLAG_ALIGN_RIGHT 
			datafunc = function() {
	
				local string = ""
			
				for (local i = 0; i < 4; i++) {
					local player = ::VMutUtils.SurvivorSlotToPlayer(i)
					if (player)
						string += player.GetPlayerName()
				
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
					string += "$" + ::VMutCurrency.SurvivorGetCurrency(i)
					if (i < 3) string += "\n"
				}
				
				return string
				
			}
		}
	}
}


function SetupModeHUD() {
	HUDSetLayout(ModeHUD)
	HUDPlace(HUD_RIGHT_TOP, 0.7, 0.025, 0.2, 0.2)
	HUDPlace(HUD_RIGHT_BOT, 0.9, 0.025, 0.1, 0.2)
}

//------------------------------------------------------------------------------------------------------
//MELEE MODELS

meleeId <- [
	"baseball_bat",
	"cricket_bat",	
	"crowbar",	
	"electric_guitar",
	"fireaxe",
	"frying_pan",
	"golfclub",	
	"katana",
	"knife",
	"machete",
	"pitchfork",
	"shovel",
    "tonfa"
]
	
meleeModelWorld <- {
	baseball_bat		= "models/weapons/melee/w_bat.mdl"
	cricket_bat			= "models/weapons/melee/w_cricket_bat.mdl"
	crowbar				= "models/weapons/melee/w_crowbar.mdl"
	electric_guitar		= "models/weapons/melee/w_electric_guitar.mdl"
	fireaxe				= "models/weapons/melee/w_fireaxe.mdl"
	frying_pan			= "models/weapons/melee/w_frying_pan.mdl"
	golfclub			= "models/weapons/melee/w_golfclub.mdl"
	katana				= "models/weapons/melee/w_katana.mdl"
	knife				= "models/w_models/weapons/w_knife_t.mdl"
	machete				= "models/weapons/melee/w_machete.mdl"
	pitchfork			= "models/weapons/melee/w_pitchfork.mdl"
	shovel				= "models/weapons/melee/w_shovel.mdl"
	tonfa				= "models/weapons/melee/w_tonfa.mdl"
}

meleeModelView <- {
	baseball_bat		= "models/weapons/melee/v_bat.mdl"
	cricket_bat			= "models/weapons/melee/v_cricket_bat.mdl"
	crowbar				= "models/weapons/melee/v_crowbar.mdl"
	electric_guitar		= "models/weapons/melee/v_electric_guitar.mdl"
	fireaxe				= "models/weapons/melee/v_fireaxe.mdl"
	frying_pan			= "models/weapons/melee/v_frying_pan.mdl"
	golfclub			= "models/weapons/melee/v_golfclub.mdl"
	katana				= "models/weapons/melee/v_katana.mdl"
	knife				= "models/v_models/weapons/v_knife_t.mdl"
	machete				= "models/weapons/melee/v_machete.mdl"
	pitchfork			= "models/weapons/melee/v_pitchfork.mdl"
	shovel				= "models/weapons/melee/v_shovel.mdl"
	tonfa				= "models/weapons/melee/v_tonfa.mdl"
}

function PrecacheMeleeModels() {
	foreach (meleeName, modelName in meleeModelWorld)
		PrecacheModel(modelName)
	foreach (meleeName, modelName in meleeModelView)
		PrecacheModel(modelName)
}


//------------------------------------------------------------------------------------------------------
//LANDMARKS

g_MapScript.landmarks <- []

function g_MapScript::LandmarkExists(landmark) {
	return (landmark in g_MapScript.landmarks)
}


//------------------------------------------------------------------------------------------------------
//PURGE SYSTEM

g_MapScript.purgeSystem <- {

	/*
	 *	Test if an entity is currently being protected by a protected zone
	 */
	IsInProtectedZone = function(ent, protectedZone) {
		if (::VMutUtils.PointInBox(ent.GetOrigin(), protectedZone.origin, protectedZone.extent)) {
			foreach (protection in protectedZone.protected) {
				if (protection == ent.GetClassname())
					return true
			}
		}
		
		return false
	}

	
	/*
	 *	Assign a new callback function to all purge entries within the purge table
	 */
	SetPurgeTableCallbacks = function(newCallback) {
		foreach (purgeEntry in g_MapScript.purgeTable) {
			purgeEntry.callback = newCallback
		}
	}
	
	
	/*
	 *	Purge all entities that fit the criteria of the current map's purge table
	 */
	Purge = function() {
	
		foreach (purgeEntry in g_MapScript.purgeTable) {
			local ent = null
			
			//Initialize callbacks
			local condition = null
			if ("condition" in purgeEntry) {	//pre-callback
				condition = purgeEntry.condition
			}
			local callback = null
			if ("callback" in purgeEntry) {		//post-callback
				callback = purgeEntry.callback
			}
			
			//Purge by classname
			if ("classname" in purgeEntry) {
				while (ent = Entities.FindByClassname(ent, purgeEntry.classname)) {			
					//Do not purge entities held by a player. (possibly change this to a "condition")
					//if (ent.GetOwnerEntity())
					//	continue
				
					//Test condition
					if (condition && !condition(ent))
						continue
				
					//Do not purge entities that are inside a protected zone
					local isProtected = false
					foreach (protectedZone in g_MapScript.protectedZones) {
						if (IsInProtectedZone(ent, protectedZone)) {
							isProtected = true
						}
					}
				
					if (isProtected) 
						continue
						
					if (callback) {callback(ent)}	//Execute callback
					ent.Kill()						//Then kill

				}
			}
		}
		
	}
	
}

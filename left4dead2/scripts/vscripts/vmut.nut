//Vendor Mutation
//Author: Waifu Enthusiast

//@TODO
//See if MapState and MutationState add to the same table
//MapOptions + MutationOptions too

printl(" ** Executing mode script")


//------------------------------------------------------------------------------------------------------
//INCLUDE

IncludeScript("entitygroups/vmut_vendor_group.nut")
IncludeScript("entitygroups/vmut_currency_pickup_group.nut")

IncludeScript("vmut/vmut_itemdata")
IncludeScript("vmut/vmut_utils")
IncludeScript("vmut/vmut_timers")
IncludeScript("vmut/vmut_currency")
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

/*
 *	Sets criteria that deems an entity as grounds for purging.
 *	Also defines callback functions that are called when an entity is purged.
 *
 *	Currently can only purge by classname, but additional purging criteria will be added in the future
 *	classname		- purge entities of this classname
 *	callback		- function that is executed when an entity is purged. The purged entity is passed as the argument.
 *
 *	Potential future criteria:
 *	targetname		- purge entities with this name
 *	position		- purge entities at this position
 *	condition 		- a function that returns a boolean. If it returns false, cancel the purge.
 *
 *	This is very similar to the sanitize table that is already present in the l4d2 mutation system.
 *	If there were some way to add callbacks to sanitized entities in the sanitize table then I would just be using that instead.
 *	Alas, I don't know any way to add pre or post functionality to each entity sanitized by the sanitize table. Thus, please welcome the purge table.
 */
g_MapScript.defaultPurgeTable <- [
	{classname = "weapon_spawn", 						callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_item_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_ammo_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_melee_spawn", 					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_first_aid_kit_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_defibrillator_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_pain_pills_spawn", 			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_adrenaline_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_molotov_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_pipe_bomb_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_vomitjar_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_vomitjar_spawn",				callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_upgradepack_incendiary_spawn",	callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_upgradepack_explosive_spawn",	callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_smg_spawn",                    callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_smg_silenced_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_shotgun_spawn",                callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_shotgun_chrome_spawn",         callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_rifle_spawn",                  callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_ak47_spawn",                   callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_desert_rifle_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_autoshotgun_spawn",            callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_shotgun_spas_spawn",           callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_hunting_rifle_spawn",          callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_sniper_military_spawn",        callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_chainsaw_spawn",               callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_grenade_launcher_spawn",       callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_m60_spawn",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_pistol_spawn",					callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())},
	{classname = "weapon_pistol_magnum_spawn",			callback = @(ent) ::VMutCurrencySpawnSystem.AddCurrencyPickupCandidate(ent.GetOrigin())}
]

g_MapScript.defaultVendorCandidates <- []
g_MapScript.defaultPickupCandidates <- []
g_MapScript.defaultProtectedZones	<- []

::VMutUtils.PointInBox(Vector(0,0,0), Vector(0,0,0), Vector(0,0,0))

//------------------------------------------------------------------------------------------------------
//MODE SETUP

MutationOptions <- {
	
}


MutationState <- {
	currency = [0,0,0,0]
}


function OnGameplayStart() {
	printl( " ** On Gameplay Start" )

	::VMutVendorSpawnSystem.SpawnAndDistributeVendors()
	::VMutCurrencySpawnSystem.SpawnAndDistributeCurrencyPickups()
	::VMutCurrency.GiveCurrencyToAllSurvivors(4000)

}


function OnActivate() {
	printl( " ** On Activate" )
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}


function Precache() {
	printl( " ** VMUT Precache" )
	
	PrecacheModel("models/props_junk/gnome.mdl")
	
	::VMutItemData.Precache()
	::VMutVendor.Precache()
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
	 *	Purge all entities that fit the criteria of the current map's purge table
	 */
	Purge = function() {
	
		foreach (purgeEntry in g_MapScript.purgeTable) {
			local ent = null
			
			//Initialize callbacks
			local callback = null
			if ("callback" in purgeEntry) {
				callback = purgeEntry.callback
			}
			
			
			//Purge by classname
			if ("classname" in purgeEntry) {
				while (ent = Entities.FindByClassname(ent, purgeEntry.classname)) {
				
					//Do not purge entities that are inside a protected zone
					local isProtected = false
					foreach (protectedZone in g_MapScript.protectedZones) {
						if (IsInProtectedZone(ent, protectedZone)) {
							isProtected = true
						}
					}
				
					if (!isProtected) {
						if (callback) {callback(ent)}	//Execute callback
						ent.Kill()						//Then kill
					}
				}
			}
		}
		
	}
	
}
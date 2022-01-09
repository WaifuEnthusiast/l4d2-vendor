/*
 *	Moved spawn-data into a map script to take advantage of the fact that the l4d2 mutation system will automatically load any script that has the same name as the current map.
 */

printl(" ** Executing map script")

function Precache() {
	printl(" ** Map precache")
}


//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- 0 
mapCurrency			<- 0		
minCurrencySpawns	<- 0
maxCurrencySpawns	<- 0
startingCurrency	<- defaultStartingCurrency


//------------------------------------------------------------------------------------------------------
//PURGE TABLE

//purgeTable <- defaultPurgeTable


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

local primaryWeaponOnlyBlacklist = [
	//ITEM_ID.SMG,
	//ITEM_ID.SMG_SILENCED,
	//ITEM_ID.SHOTGUN,
	//ITEM_ID.SHOTGUN_CHROME,
	//ITEM_ID.AK47,
	//ITEM_ID.M16,
	//ITEM_ID.DESERT_RIFLE,
	//ITEM_ID.AUTOSHOTGUN,
	////ITEM_ID.SHOTGUN_SPAS,
	//ITEM_ID.HUNTING_RIFLE,
	//ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	ITEM_ID.MACHINEGUN,
	ITEM_ID.GRENADE_LAUNCHER,
	ITEM_ID.CHAINSAW,
	ITEM_ID.MOLOTOV,
	ITEM_ID.PIPEBOMB,
	ITEM_ID.BILE_JAR,
	ITEM_ID.PAIN_PILLS,
	ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	ITEM_ID.GAS,
	ITEM_ID.PROPANE,
	ITEM_ID.INCENDIARY_UPGRADE,
	ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

local T2WeaponOnlyBlacklist = [
	ITEM_ID.SMG,
	ITEM_ID.SMG_SILENCED,
	ITEM_ID.SHOTGUN,
	ITEM_ID.SHOTGUN_CHROME,
	//ITEM_ID.AK47,
	//ITEM_ID.M16,
	//ITEM_ID.DESERT_RIFLE,
	//ITEM_ID.AUTOSHOTGUN,
	//ITEM_ID.SHOTGUN_SPAS,
	//ITEM_ID.HUNTING_RIFLE,
	//ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	ITEM_ID.MACHINEGUN,
	ITEM_ID.GRENADE_LAUNCHER,
	ITEM_ID.CHAINSAW,
	ITEM_ID.MOLOTOV,
	ITEM_ID.PIPEBOMB,
	ITEM_ID.BILE_JAR,
	ITEM_ID.PAIN_PILLS,
	ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	ITEM_ID.GAS,
	ITEM_ID.PROPANE,
	ITEM_ID.INCENDIARY_UPGRADE,
	ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

local utilityOnlyBlacklist = [
	ITEM_ID.SMG,
	ITEM_ID.SMG_SILENCED,
	ITEM_ID.SHOTGUN,
	ITEM_ID.SHOTGUN_CHROME,
	ITEM_ID.AK47,
	ITEM_ID.M16,
	ITEM_ID.DESERT_RIFLE,
	ITEM_ID.AUTOSHOTGUN,
	ITEM_ID.SHOTGUN_SPAS,
	ITEM_ID.HUNTING_RIFLE,
	ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	//ITEM_ID.MACHINEGUN,
	//ITEM_ID.GRENADE_LAUNCHER,
	//ITEM_ID.CHAINSAW,
	//ITEM_ID.MOLOTOV,
	//ITEM_ID.PIPEBOMB,
	//ITEM_ID.BILE_JAR,
	//ITEM_ID.PAIN_PILLS,
	//ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	//ITEM_ID.GAS,
	//ITEM_ID.PROPANE,
	//ITEM_ID.INCENDIARY_UPGRADE,
	//ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

//@TODO It would be kind of fun to be able to switch up playstyles on a moment to moment basis. For this to happen we need different weapon vendors to spawn throughout the map.
//This can lead to redundancy and overwhelming the map with weapon vendors however.
//Maybe some kind of system that delegates certain vendors as the "weapon vendors" and spawns utility everywhere else.
//Some kind of system to create an even spread of items and make it so that if you want a certain item then you need to go to a certain vendor.
//Switching up secondary weapons would also be cool.
//Spawn one lasersight and one defib would be epic.
//By spawning essential items like weapons in a variety of locations, it will force players to utilize the entire map. It could become very interesting. Players  may also experience moment-to-moment playstyle changes while running loops around the map.
//Adding some variance on medkits could also prove to be powerful. Maybe 3 or 2 possible places for a medkit vendor to spawn. Should have a massive influence on where survivors decide to defend. Medkit vendors will always expire after 4 uses and force survivors to reposition.
//Multiple "medkit sell"  around the map could also create situations where a player could sell medkits for a very short-term boost in order to escape a bad situation.

vendorCandidates <- [
	//Start safehouse
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(5288, 8800, 5608)
				angles = QAngle(0,0,0)
				witch  = WITCH_DISABLE
				blacklist = [	//T1 weapons only
					ITEM_ID.AK47,
					ITEM_ID.M16,
					ITEM_ID.DESERT_RIFLE,
					ITEM_ID.AUTOSHOTGUN,
					ITEM_ID.SHOTGUN_SPAS,
					ITEM_ID.HUNTING_RIFLE,
					ITEM_ID.SNIPER_RIFLE,  
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					ITEM_ID.MOLOTOV,
					ITEM_ID.PIPEBOMB,
					ITEM_ID.BILE_JAR,
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,
					ITEM_ID.GAS,
					ITEM_ID.PROPANE,
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			}
		]
	},
	
	//Pre-Finale Secondary weapons
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(7320, 8624, 5760)
				angles = QAngle(0,270,0)
				witch  = WITCH_DISABLE
				blacklist = [	//Melee only
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.AK47,
					ITEM_ID.M16,
					ITEM_ID.DESERT_RIFLE,
					ITEM_ID.AUTOSHOTGUN,
					ITEM_ID.SHOTGUN_SPAS,
					ITEM_ID.HUNTING_RIFLE,
					ITEM_ID.SNIPER_RIFLE,  
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					//ITEM_ID.MELEE,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					ITEM_ID.MOLOTOV,
					ITEM_ID.PIPEBOMB,
					ITEM_ID.BILE_JAR,
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,
					ITEM_ID.GAS,
					ITEM_ID.PROPANE,
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			},
			{
				origin = Vector(7320, 8696, 5760)
				angles = QAngle(0,270,0)
				witch  = WITCH_DISABLE
				blacklist = [	//Pistol or magnum only
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.AK47,
					ITEM_ID.M16,
					ITEM_ID.DESERT_RIFLE,
					ITEM_ID.AUTOSHOTGUN,
					ITEM_ID.SHOTGUN_SPAS,
					ITEM_ID.HUNTING_RIFLE,
					ITEM_ID.SNIPER_RIFLE,  
					//ITEM_ID.PISTOL,
					//ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					ITEM_ID.MOLOTOV,
					ITEM_ID.PIPEBOMB,
					ITEM_ID.BILE_JAR,
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,
					ITEM_ID.GAS,
					ITEM_ID.PROPANE,
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			}
		]
	},
	
	//Finale
	{
		min = 22,
		max = 22,
		spawnCandidates = [
			{	//Radio building
				origin = Vector(5616, 8336, 6080)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = [	//First aid kit only
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.AK47,
					ITEM_ID.M16,
					ITEM_ID.DESERT_RIFLE,
					ITEM_ID.AUTOSHOTGUN,
					ITEM_ID.SHOTGUN_SPAS,
					ITEM_ID.HUNTING_RIFLE,
					ITEM_ID.SNIPER_RIFLE,  
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					ITEM_ID.MOLOTOV,
					ITEM_ID.PIPEBOMB,
					ITEM_ID.BILE_JAR,
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					//ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,
					ITEM_ID.GAS,
					ITEM_ID.PROPANE,
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			},
			{
				origin = Vector(5616, 8432, 5920)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_FINALE	//starts unlocked
				tag	   = "finale"
				blacklist = T2WeaponOnlyBlacklist
			},
			{
				origin = Vector(5616, 8496, 5920)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_FINALE	//starts unlocked
				tag	   = "finale"
				blacklist = T2WeaponOnlyBlacklist
			},
			{
				origin = Vector(5616, 8560, 5920)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_FINALE	//starts unlocked
				tag	   = "finale"
				blacklist = T2WeaponOnlyBlacklist
			},
			{
				origin = Vector(5816, 8744, 5920)
				angles = QAngle(0, 180, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(5328, 8224, 5952)
				angles = QAngle(0, 0, -90)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Rightside structure
				origin = Vector(6200, 7664, 6080)
				angles = QAngle(0, 180, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(5960, 7584, 5920)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(6416, 8136, 5920)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Leftside structure
				origin = Vector(5952, 9384, 6080)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(6176, 9040, 5920)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(6664, 8944, 5920)
				angles = QAngle(0, 180, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Helipad
				origin = Vector(7488, 8720, 5920)
				angles = QAngle(0, 315, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(7240, 8816, 5920)
				angles = QAngle(0, 180, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Behind helipad
				origin = Vector(7888, 8288, 5772)
				angles = QAngle(0, 225, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(7712, 8656, 5772)
				angles = QAngle(0, 90, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(7664, 9216, 5772)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Outer rim
				origin = Vector(7192, 7896, 5808)
				angles = QAngle(0, 270, -90)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{
				origin = Vector(6760, 7400, 5644)
				angles = QAngle(0, 180, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Meta box
				origin = Vector(5488, 8128, 5772)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			},
			{	//Back
				origin = Vector(5152, 9008, 5772)
				angles = QAngle(0, 0, 0)
				flags  = VFLAG_START_LOCKED | VFLAG_FINALE
				tag	   = "finale"
				blacklist = utilityOnlyBlacklist
			}
		]
	}

]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []	//No currency spawns governed by the spawning system

	
//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	//Starting safehouse
	{
		origin 		= Vector(5248, 8160, 5536)
		extent 		= Vector(448, 416, 128)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	},
	
	//Radio building rooftop
	{
		origin 		= Vector(5472, 8288, 6048)
		extent 		= Vector(528, 432, 224)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"prop_minigun_l4d1"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()


//------------------------------------------------------------------------------------------------------
//SUPPLY BALLOONS

IncludeScript("vmut/vmut_balloon_manager")

::VMutBalloonManager.spawnPoints = [
	{
		origin = Vector(0,0,0)
		angles = QAngle(0,0,0)
	}
]


//------------------------------------------------------------------------------------------------------
//MAP EVENTS AND SCRIPTED BEHAVIOURS


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Free 1k to buy a T2 weapon...
	::VMutCurrency.CreateCurrencyItem(Vector(5856, 8336, 5956), 1000)	
}


eventFinale <- false
function OnGameEvent_finale_start(params) {
	//Run this event only once
	if (eventFinale == true)
		return
	eventFinale = true
	
	//Debug
	printl(" ** Finale started, unlocking finale vendors...")
		
	//Unlock vendors
	local finaleVendors = ::VMutVendor.FindVendorsByTag("finale")
	foreach (vendorData in finaleVendors) {
		::VMutVendor.VendorUnlock(vendorData)
	}
	
	//Test supply balloon
	//::VMutBalloonManager.SpawnSupplyBalloon(Vector(5744, 8512, 6656), QAngle(0, 0, 0))
}


//Use event stages to spawn balloons
/*
function GetNextStage() {
	WHY DOES IT STOP THE FINALE FROM PROGRESSING WHEN THIS FUNCTION EXISTS???????????????
	REEEEEEEEEEEEEEE SO FRUSTRATING!!!!!!!
}
*/
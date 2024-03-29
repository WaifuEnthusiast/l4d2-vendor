//Author: Waifu Enthusiast

printl(" ** Executing map script")


function Precache() {
	printl(" ** Map Precache")
}


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Spawn table of money in ending saferoom (without the money)
	local kvs = {
		targetname 			= "vmut_money_table"
		origin				= Vector(-1880, -13756, 132)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	local ent = SpawnEntityFromTable("prop_dynamic", kvs)
}


//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- defaultMinCurrencySpawns
maxCurrencySpawns	<- defaultMaxCurrencySpawns
startingCurrency	<- defaultStartingCurrency

landmarks			= {
	"c4m2_sugarmill_a"			: Vector(0, 0, 0)
	"c4m1_milltown_a_saferoom" 	: Vector(3776, -1728, 296)
}

//------------------------------------------------------------------------------------------------------
//PURGE TABLE

//purgeTable <- defaultPurgeTable
purgeSystem.SetPurgeTableCallbacks( @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin(), landmark = "c4m2_sugarmill_a"} ) )


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
	//ITEM_ID.MACHINEGUN,
	//ITEM_ID.GRENADE_LAUNCHER,
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
	ITEM_ID.GRENADE_LAUNCHER,
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

vendorCandidates <- [
	{	//Template
		min = 0,
		max = 0,
		spawnCandidates = [
			{
				origin = Vector(0, 0, 0) 
				angles = QAngle(0, 0, 0)
			}
		]
	},
	
	{	//Mill main entrance
		min = 1,
		max = 1,
		spawnCandidates = [
			//{
			//	origin = Vector(3976, -2704, 98) 
			//	angles = QAngle(0, 270, 0)
			//},
			{
				origin 		= Vector(3744, -3288, 116) 
				angles 		= QAngle(0, 45, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Truck
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(4624, -3872, 96) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Manufacturing area entrance
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(4256, -4552, 100) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(4184, -4552, 100) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			}
		]
	},
	
	{	//Early locker room
		min = 1,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(2600, -3648, 100) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin		= Vector(2928, -3632, 100) 
				angles		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(3056, -3632, 100) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Resupply carriage
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin 		= Vector(1320, -4208, 106) 
				angles 		= QAngle(0, 50, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(1160, -4400, 106) 
				angles 		= QAngle(0, 50, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(1144, -4224, 140) 
				angles 		= QAngle(0, 50, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(1096, -4280, 140) 
				angles 		= QAngle(0, 50, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Alley
		min = 1,
		max = 1,
		spawnCandidates = [
			//{
			//	origin = Vector(1800, -4944, 150) 
			//	angles = QAngle(0, 270, -90)
			//},
			{
				origin 		= Vector(2624, -5064, 102) 
				angles 		= QAngle(0, 300, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			}
		]
	},
	
	{	//Late locker room
		min = 1,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(1524, -6272, 104) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(1456, -6272, 104) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Manufacturing platform
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(816, -5960, 176) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(672, -5960, 176) 
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Control room
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(1532, -5368, 228) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist	= primaryWeaponOnlyBlacklist
			}
		]
	},
	
	{	//Resupply carriage before panic
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin 		= Vector(-616, -7816, 112) 
				angles 		= QAngle(0, 0, -90)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(-1056, -7880, 112) 
				angles 		= QAngle(0, 95, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(-1064, -7800, 112) 
				angles 		= QAngle(0, 95, 0)
				landmark 	= "c4m2_sugarmill_a"
			},
			{
				origin 		= Vector(-1072, -7720, 112) 
				angles 		= QAngle(0, 95, 0)
				landmark 	= "c4m2_sugarmill_a"
			}
		]
	},
	
	{	//Sugar field
		min = 3,
		max = 3,
		spawnCandidates = [
			{
				origin 		= Vector(-1080, -9520, 128) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(-1176, -9520, 128) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(-920, -11072, 120) 
				angles 		= QAngle(0, 135, -90)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= utilityOnlyBlacklist
			}
		]
	},
	
	{	//Gas station
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(-1584, -13312, 132) 
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(-1888, -13432, 132) 
				angles 		= QAngle(0, 90, 0)
				landmark 	= "c4m2_sugarmill_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			}
		]
	},
]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []	//No currency spawns governed by the spawning system

	
//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	{	//Starting saferoom
		origin = Vector(3488, -1976, 112)
		extent = Vector(496, 408, 252)
		flags  = ZONE_FLAG_NO_CURRENCY
		protected = [
			"weapon_ammo_spawn", "weapon_first_aid_kit_spawn"
		]
	},
	{	//Ending saferoom
		origin = Vector(-1920, -13840, 128)
		extent = Vector(256, 256, 136)
		flags  = ZONE_FLAG_NO_CURRENCY
		protected = [
			"weapon_ammo_spawn", "weapon_first_aid_kit_spawn"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
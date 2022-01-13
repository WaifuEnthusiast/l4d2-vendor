//Author: Waifu Enthusiast

printl(" ** Executing map script")


function Precache() {
	printl(" ** Map Precache")
}


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Spawn table of money in ending saferoom
	local kvs = {
		targetname 			= "vmut_money_table"
		origin				= Vector(-3552, 7912, 120)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	local ent = SpawnEntityFromTable("prop_dynamic", kvs)
	
	::VMutCurrency.CreateCurrencyItem(Vector(-3556, 7892, 155), QAngle(0,0,0), 1000).landmark = "c4m1_milltown_a"
	::VMutCurrency.CreateCurrencyItem(Vector(-3556, 7912, 155), QAngle(0,0,0), 1000).landmark = "c4m1_milltown_a"
	::VMutCurrency.CreateCurrencyItem(Vector(-3556, 7932, 155), QAngle(0,0,0), 1000).landmark = "c4m1_milltown_a"
	::VMutCurrency.CreateCurrencyItem(Vector(-3556, 7952, 155), QAngle(0,0,0), 1000).landmark = "c4m1_milltown_a"
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
	"c4m1_milltown_a"			: Vector(0, 0, 0)
	"c4m1_milltown_a_saferoom" 	: Vector(4032, -1600, 296)
}

//------------------------------------------------------------------------------------------------------
//PURGE TABLE

//purgeTable <- defaultPurgeTable
purgeSystem.SetPurgeTableCallbacks( @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin(), landmark = "c4m1_milltown_a"} ) )


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

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
	//ITEM_ID.FIRST_AID_KIT,
	//ITEM_ID.DEFIBRILLATOR,
	//ITEM_ID.GAS,
	ITEM_ID.PROPANE,
	//ITEM_ID.INCENDIARY_UPGRADE,
	//ITEM_ID.EXPLOSIVE_UPGRADE,
	//ITEM_ID.LASERSIGHTS_UPGRADE
]


vendorCandidates <- [
	//Starting vendors
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(-6384, 7720, 96)
				angles 		= QAngle(0,270,0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(-6384, 7640, 96)
				angles 		= QAngle(0,270,0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			}
		]
	}
	
	//Finale vendors
	{
		min = 10,
		max = 10,
		spawnCandidates = [	
			{	//Inside burger tank
				origin 		= Vector(-5828, 7384, 140)
				angles 		= QAngle(0,215,0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE | VFLAG_IS_MINI
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(-5888, 7280, 140)
				angles 		= QAngle(0, 270, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE | VFLAG_IS_MINI
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{	//Near toilet
				origin 		= Vector(-5856, 6968, 98)
				angles 		= QAngle(0, 0, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(-6128, 6688, 98)
				angles 		= QAngle(0, 120, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},	
			{	//Dumpster alley
				origin 		= Vector(-6064, 8032, 98)
				angles 		= QAngle(0, 0, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(-5920, 7880, 130)
				angles 		= QAngle(0, 0, -90)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{	//Rooftop
				origin 		= Vector(-6056, 7736, 290)
				angles 		= QAngle(0, 0, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(-6192, 7736, 290)
				angles 		= QAngle(0, 0, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{	//Resturaunt front
				origin 		= Vector(-5376, 6912, 130)
				angles 		= QAngle(0, 0, -90)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
			{	//Docks
				origin 		= Vector(-6800, 7344, 96)
				angles 		= QAngle(0, 135, 0)
				witch  		= WITCH_DISABLE
				landmark 	= "c4m1_milltown_a"
				flags		= VFLAG_FINALE
				blacklist 	= utilityOnlyBlacklist
			},
		]
	},
	
	//Big house
	{
		min = 5,
		max = 5,
		spawnCandidates = [
			{	//inside
				origin 		= Vector(-608, 5696, 104)
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m1_milltown_a"
			},
			{
				origin 		= Vector(152, 5880, 104)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
			},
			{	//outside
				origin 		= Vector(-64, 5456, 98)
				angles 		= QAngle(0,0,0)
				landmark 	= "c4m1_milltown_a"
			},
			{
				origin 		= Vector(8, 5456, 98)
				angles 		= QAngle(0,0,0)
				landmark 	= "c4m1_milltown_a"
			},
			{	//construction
				origin 		= Vector(-552, 6192, 264)
				angles 		= QAngle(0, 90, 0)
				landmark 	= "c4m1_milltown_a"
			},
			//{
			//	origin 		= Vector(-328, 6294, 298)
			//	angles 		= QAngle(0, 45, -90)
			//	landmark 	= "c4m1_milltown_a"
			//},
		]
	},
	
	//Side house 1
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin 		= Vector(1104, 6472, 120)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			},
			{
				origin 		= Vector(1264, 6336, 120)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			}
		]
	},
	
	//Side house 2
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(1472, 4312, 218)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			}
		]
	},
	
	//Garage sale
	{
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin 		= Vector(1472, 2608, 102)
				angles 		= QAngle(0, 135, 0)
				landmark 	= "c4m1_milltown_a"
			},
			{
				origin 		= Vector(1648, 2496, 96)
				angles 		= QAngle(0, 255, 0)
				landmark 	= "c4m1_milltown_a"
			},
			{
				origin 		= Vector(1752, 2664, 96)
				angles 		= QAngle(0, 180, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(1928, 2776, 96)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(1792, 2960, 128)
				angles 		= QAngle(0, 210, -90)
				landmark 	= "c4m1_milltown_a"
			}
		]
	},
	
	//Side house 3
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(4136, 1608, 184)
				angles 		= QAngle(0, 270, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			}
		]
	},
	
	//Side house 4
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(3776, 888, 102)
				angles 		= QAngle(0, 0, 0)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			}
		]
	},
	
	//Road
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin 		= Vector(3536, -1056, 128)
				angles 		= QAngle(0, 330, -90)
				landmark 	= "c4m1_milltown_a"
				blacklist	= utilityOnlyBlacklist
			}
		]
	},
	
	//Saferoom vendors
	{
		min = 3,
		max = 3,
		spawnCandidates = [
			{
				origin 		= Vector(3776, -1568, 232)
				angles 		= QAngle(0,90,0)
				witch  		= WITCH_DISABLE
				flags  		= VFLAG_SAFEROOM
				landmark 	= "c4m1_milltown_a_saferoom"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(3776, -1512, 232)
				angles 		= QAngle(0,90,0)
				witch  		= WITCH_DISABLE
				flags  		= VFLAG_SAFEROOM
				landmark 	= "c4m1_milltown_a_saferoom"
				blacklist 	= primaryWeaponOnlyBlacklist
			},
			{
				origin 		= Vector(4088, -1568, 104)
				angles 		= QAngle(0,0,0)
				witch  		= WITCH_DISABLE
				flags  		= VFLAG_SAFEROOM
				landmark 	= "c4m1_milltown_a_saferoom"
				blacklist 	= primaryWeaponOnlyBlacklist
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
	{	//Starting saferoom
		origin = Vector(3744, -1864, 104)
		extent = Vector(480, 440, 255)
		flags  = ZONE_FLAG_NO_CURRENCY
		protected = [
			"weapon_ammo_spawn", "weapon_first_aid_kit_spawn"
		]
	},
	{	//Ending saferoom
		origin = Vector(-3680 7744 120)
		extent = Vector(832, 416, 168)
		flags  = ZONE_FLAG_NO_CURRENCY
		protected = [
			"weapon_ammo_spawn", "weapon_first_aid_kit_spawn"
		]
	},
	{	//Burgertank supplies
		origin = Vector(-6048, 7208, 104)
		extent = Vector(288, 244, 80)
		flags  = ZONE_FLAG_NO_CURRENCY
		protected = [
			"weapon_first_aid_kit_spawn"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
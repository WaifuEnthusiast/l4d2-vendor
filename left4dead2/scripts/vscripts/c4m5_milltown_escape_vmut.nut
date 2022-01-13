//Author: Waifu Enthusiast

printl(" ** Executing map script")


function Precache() {
	printl(" ** Map Precache")
	PrecacheModel("models/props_interiors/table_kitchen.mdl")
}


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Spawn docks table
	local kvs = {
		targetname 			= "money_table"
		origin				= Vector(-6616, 7552, 96)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	local ent = SpawnEntityFromTable("prop_dynamic", kvs)
	ent.SetAngles(QAngle(0, 30, 0))
	
	//Spawn saferoom table
	kvs = {
		targetname 			= "vmut_money_table"
		origin				= Vector(-3552, 7912, 120)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	ent = SpawnEntityFromTable("prop_dynamic", kvs)
	
}

//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- 0		
minCurrencySpawns	<- 0
maxCurrencySpawns	<- 0
startingCurrency	<- defaultStartingCurrency

landmarks			= {
	"c4m1_milltown_a"	: Vector(0, 0, 0)
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
	}
]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []	//No currency spawns governed by the spawning system

	
//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	{	//Starting saferoom
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
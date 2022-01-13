//Author: Waifu Enthusiast

printl(" ** Executing map script")


function Precache() {
	printl(" ** Map precache")
}


function OnActivate() {
	printl(" ** Map OnActivate")
}


//@TODO
//add vendors to outside area just before hospital. This is an area where chaos can potentially unfold, so having some vendors near the manhole or in the streets can make things more interesting...


//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- 40
maxCurrencySpawns	<- 50
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

local warehouseBlacklist = [
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
	//ITEM_ID.MOLOTOV,
	//ITEM_ID.PIPEBOMB,
	ITEM_ID.BILE_JAR,
	ITEM_ID.PAIN_PILLS,
	ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	//ITEM_ID.GAS,
	//ITEM_ID.PROPANE,
	//ITEM_ID.INCENDIARY_UPGRADE,
	//ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

vendorCandidates <- [
	//Start safehouse weapon vendor
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(11232, 4744, 16)
				angles = QAngle(0,270,0)
				witch  = WITCH_DISABLE
				blacklist = [	//Only spawns with primary weapons
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
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
		
	//Start alleyways <- lots of vendors to stock up for the panic event
	{
		min = 5,
		max = 7,
		spawnCandidates = [
			{
				origin = Vector(11184, 5344, 16)
				angles = QAngle(0, 0, 0)
			},
			{
				origin = Vector(11120, 5344, 16)
				angles = QAngle(0, 0, 0)
			},
			{
				origin = Vector(12512, 5336, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(12512, 5160, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(12432, 4432, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(12432, 4368, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(12064, 4256, 16)
				angles = QAngle(0, 180, 0)
			}
		]
	},
	
	//Shhhhhh.... secret vendor!
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(12352, 5592, 192)
				angles = QAngle(0, 270, -90)
				witch  = WITCH_DISABLE
			}
		]
	}
	
	//Panic risk vendors <- should have a price mod to make these cheaper
	{
		min = 3,
		max = 3,
		spawnCandidates = [
			{
				origin = Vector(10872, 7192, 296)
				angles = QAngle(0, 0, 0)
			},
			{
				origin = Vector(10752, 7064, 296)
				angles = QAngle(0, 75, 0)
			},
			{	
				origin = Vector(10960, 6856, 160)
				angles = QAngle(0, 270, 0)
				witch  = WITCH_DISABLE
				blacklist = [	//Pipebomb, molotov, bile, pills, adrenaline, machinegun
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
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
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
	}
	
	//Warehouse support
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(11040, 7832, 16)
				angles = QAngle(0, 90, 0)
				blacklist = warehouseBlacklist //gas, propane, molotov, pipebomb, incendiary ammo, explosive ammo
			},
			{
				origin = Vector(11536, 8272, 16)
				angles = QAngle(0, 0, 0)
				blacklist = warehouseBlacklist //gas, propane, molotov, pipebomb, incendiary ammo, explosive ammo
			},
			{
				origin = Vector(12024, 7600, 16)
				angles = QAngle(0, 180, 0)
				blacklist = warehouseBlacklist //gas, propane, molotov, pipebomb, incendiary ammo, explosive ammo
			},
			{
				origin = Vector(12496, 8032, 16)
				angles = QAngle(0, 270, 0)
				blacklist = warehouseBlacklist //gas, propane, molotov, pipebomb, incendiary ammo, explosive ammo
			},
		]
	}
	
	//Post-panic relief
	{
		min = 3,
		max = 4,
		spawnCandidates = [
			{	//upstairs
				origin = Vector(13104, 8112, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(13104, 8048, 16)
				angles = QAngle(0, 270, 0)
			},
			{	//downstairs
				origin = Vector(13384, 7400, -255)
				angles = QAngle(0, 90, 0)
				witch  = WITCH_DISABLE
			},
			{
				origin = Vector(13384, 7464, -255)
				angles = QAngle(0, 90, 0)
				witch  = WITCH_DISABLE
			},
			{	//manhole
				origin = Vector(14128, 8224, -255)
				angles = QAngle(0, 0, 0)
			},
			{
				origin = Vector(14256, 8032, -255)
				angles = QAngle(0, 270, 0)
			}
		]
	}
	
	//Sewer ammo room
	{
		min = 1,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(13544, 10488, -464)
				angles = QAngle(0, 0, 0)
				witch  = WITCH_DISABLE
				blacklist = primaryWeaponOnlyBlacklist
			},
			{
				origin = Vector(13656, 10328, -464)
				angles = QAngle(0, 270, 0)
				witch  = WITCH_DISABLE
				blacklist = primaryWeaponOnlyBlacklist
			},
		]
	},
	
	//Sewers
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(14068, 11432, -352)
				angles = QAngle(0, 180, 0)
				witch  = WITCH_DISABLE
			},
			{
				origin = Vector(14408, 11608, -352)
				angles = QAngle(0, 0, 0)
				witch  = WITCH_DISABLE
			}
		]
	}
	
	//@TODO Hospital entrance (possibly make this grenades + soft healing + special weapons only)
	{
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin = Vector(14312, 11872, 8)
				angles = QAngle(0, 315, 0)
				witch  = WITCH_DISABLE
			},
			{
				origin = Vector(14616, 11576, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(13792, 11528, 8)
				angles = QAngle(0, 75, 0)
			},
			{
				origin = Vector(13200, 12424, 14)
				angles = QAngle(0, 30, 0)
			},
		]
	}

]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []


//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	//Starting safehouse
	{
		origin 		= Vector(10768, 4624, 16)
		extent 		= Vector(336, 248, 128)
		flags		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	},
	
	//Ending safehouse (2 zones because of complex shape)
	{
		origin 		= Vector(12272, 12176, 16)
		extent 		= Vector(168, 272, 128)
		flags		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
	{
		origin 		= Vector(12272, 12448, 16)
		extent 		= Vector(208, 224, 128)
		flags		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
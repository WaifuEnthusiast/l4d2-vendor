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
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- defaultMinCurrencySpawns
maxCurrencySpawns	<- defaultMaxCurrencySpawns
startingCurrency	<- defaultStartingCurrency


//------------------------------------------------------------------------------------------------------
//PURGE TABLE

purgeTable <- defaultPurgeTable


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

vendorCandidates <- [
	//Start safehouse
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(3096, 2800, 16)
				angles = QAngle(0,180,0)
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
			},
			{
				origin = Vector(3080, 3144, 16)
				angles = QAngle(0,90,0)
				witch  = WITCH_DISABLE
				blacklist = [	//Spawn with anything to create an interesting choice
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
		
	//Station lobby
	{
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin = Vector(3408, 3840, -512)
				angles = QAngle(0, 90, 0)
			},
			{
				origin = Vector(3408, 3904, -512)
				angles = QAngle(0, 90, 0)
			},
			{
				origin = Vector(3408, 4320, -512)
				angles = QAngle(0, 90, 0)
			},
			{
				origin = Vector(4264, 4240, -512)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(4264, 4176, -512)
				angles = QAngle(0, 270, 0)
			}
		]
	}
		
		
	//Subway tunnel
	{
		min = 2,
		max = 3,
		spawnCandidates = [
			{
				origin = Vector(3480, 4456, -288)
				angles = QAngle(0,315,0)
			},
			{
				origin = Vector(3480, 3680, -288)
				angles = QAngle(0, 255, 0)
			},
			{
				origin = Vector(4920, 4032, -336)
				angles = QAngle(0, 0, 0)
			}
		]
	}
	
	//Subway end
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(7616, 2860, -336)
				angles = QAngle(0,270,0)
			}
		]
	}
		
	//Basement
	{
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin = Vector(8544, 3344, -144)
				angles = QAngle(0,180,0)
			},
			{
				origin = Vector(8480, 3344, -144)
				angles = QAngle(0,180,0)
			},
			{
				origin = Vector(8560, 3856, -144)
				angles = QAngle(0,270,0)
			},
			{
				origin = Vector(8328, 3656, -120)
				angles = QAngle(0, 210, -90)
				witch  = WITCH_DISABLE
			}
		]
	}
	
	//Panic room utility (would be cool if these vendors only become active during the panic event)
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(7504, 3792, 22)
				angles = QAngle(0,0,0)
				witch  = WITCH_DISABLE
				blacklist = [	//gas, propane, molotov, pipebomb only
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
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,	
					ITEM_ID.BILE_JAR,		
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,	
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			},
			{
				origin = Vector(7624, 3792, 22)
				angles = QAngle(0,0,0)
				witch  = WITCH_DISABLE
				blacklist = [	//gas, propane, molotov, pipebomb only
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
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,	
					ITEM_ID.BILE_JAR,		
					ITEM_ID.PAIN_PILLS,
					ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,	
					ITEM_ID.INCENDIARY_UPGRADE,
					ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			}
		]
	},
	
	//Post-panic interiors
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(7240, 3944, 252)
				angles = QAngle(0, 90, 0)
				witch  = WITCH_DISABLE
			},
			{
				origin = Vector(7616, 4144, 252)
				angles = QAngle(0, 270, 0)
				witch  = WITCH_DISABLE
			}
		]
	}
	
	//Late streets
	{
		min = 0,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(7600, 5624, 16)
				angles = QAngle(0, 0, 0)
			},
			{
				origin = Vector(84722, 4644, 16)
				angles = QAngle(0, 180, 0)
			},
		]
	}
	
	//Car alarm
	{
		min = 3,
		max = 3,
		spawnCandidates = [
			{
				origin = Vector(9840, 4952, 8)
				angles = QAngle(0, 105, 0)
			},
			{
				origin = Vector(10526, 4640, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(10096, 5312, 40)
				angles = QAngle(0, 210, -90)
				witch  = WITCH_DISABLE
			}
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
		origin 		= Vector(2816, 2832, 16)
		extent 		= Vector(224, 480, 128)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	},
	
	//Ending safehouse
	{
		origin 		= Vector(10776, 4608, 16)
		extent 		= Vector(320, 264, 128)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
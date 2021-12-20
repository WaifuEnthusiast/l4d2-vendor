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
	//Rooftop
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(1952, 1244, 432)
				angles = QAngle(0,180,0)
				witch  = WITCH_DISABLE
				blacklist = [	//Only spawns with T1 weapons
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
					//ITEM_ID.SMG,
					//ITEM_ID.SMG_SILENCED,
					//ITEM_ID.SHOTGUN,
					//ITEM_ID.SHOTGUN_CHROME,
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
				origin = Vector(1888, 1244, 432)
				angles = QAngle(0,180,0)
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
	
	//Alley
	{
		min = 4,
		max = 4,
		spawnCandidates = [
			{
				origin = Vector(2436, 1756, 16)
				angles = QAngle(0,0,0)
			},
			{
				origin = Vector(2380, 1756, 16)
				angles = QAngle(0,0,0)
			},
			{
				origin = Vector(2528, 1128, 16)
				angles = QAngle(0,270,0)
			},
			{
				origin = Vector(2528, 1072, 16)
				angles = QAngle(0,270,0)
			}
		]
	},
	
	//Car alarm
	{
		min = 3,
		max = 3,
		spawnCandidates = [
			{
				origin = Vector(2508, 3588, 8)
				angles = QAngle(0,255,0)
			},
			{
				origin = Vector(2783, 4396, 16)
				angles = QAngle(0, 270, 0)
			},
			{
				origin = Vector(2284, 4020, 40)
				angles = QAngle(0, 150, -90)
				witch  = WITCH_DISABLE
			}
		]
	}
	
	//Late interiors
	{
		min = 0,
		max = 0,
		spawnCandidates = []
	}
]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- [
	{origin = Vector(2016, 2984, 50)}
]


//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	//Starting rooftop
	{
		origin 		= Vector(1560, 792, 424)
		extent 		= Vector(752, 656, 592)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	},
	
	//Safehouse
	{
		origin 		= Vector(2816, 2832, -240)
		extent 		= Vector(224, 480, 128)
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
]

//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()
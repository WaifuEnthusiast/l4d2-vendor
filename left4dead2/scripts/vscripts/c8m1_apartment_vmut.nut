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


//------------------------------------------------------------------------------------------------------
//PURGE TABLE

purgeTable <- defaultPurgeTable


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

vendorCandidates <- [
	//Rooftop
	[
		{
			origin = Vector(1952, 1244, 432)
			angles = QAngle(0,180,0)
			blacklist = [
				ITEM_ID.FIRST_AID_KIT,
				ITEM_ID.DEFIBRILLATOR,
			]
		},
		{
			origin = Vector(1888, 1244, 432)
			angles = QAngle(0,180,0)
			blacklist = [
				ITEM_ID.FIRST_AID_KIT,
				ITEM_ID.DEFIBRILLATOR
			]
		}
	],
	
	//Alley
	[
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
	],
	
	//Car alarm
	[
		{
			origin = Vector(2508, 3588, 8)
			angles = QAngle(0,255,0)
		},
		{
			origin = Vector(2284, 4020, 40)
			angles = QAngle(0, 150, -90)
		},
		{
			origin = Vector(2783, 4396, 16)
			angles = QAngle(0, 270, 0)
		}
	]
]


//------------------------------------------------------------------------------------------------------
//CURRENCY PICKUP SPAWN TABLE

pickupCandidates <- [
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
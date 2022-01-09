function Precache() {
	printl(" ** Map Precache")
	PrecacheModel("models/props_interiors/table_kitchen.mdl")
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

purgeSystem.SetPurgeTableCallbacks( @(ent) ::VMutCurrencySpawnSystem.AddCurrencyItemCandidate( {origin = ent.GetOrigin(), landmark = "c4m1_milltown_a"} ) )


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

currencyItemCandidates <- []

	
//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- []


//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()


function OnActivate() {
	printl(" ** Map OnActivate")
	
	
	local kvs = null
	local ent = null
	
	
	//Spawn table of money
	kvs = {
		targetname 			= "money_table"
		origin				= Vector(-6616, 7552, 96)
		model				= "models/props_interiors/table_kitchen.mdl"
		solid				= 6
	}
	ent = SpawnEntityFromTable("prop_dynamic", kvs)
	ent.SetAngles(QAngle(0, 30, 0))
	
	::VMutCurrency.CreateCurrencyItem(Vector(-6616, 7552, 132), 1000)
	//::VMutCurrencySpawnSystem.AddCandidate({
	//	origin 			= Vector(-6616, 7552, 132)
	//	landmark 		= "c4m1_milltown_a"
	//	valueOverride 	= 1000
	//	flags			= CFLAG_MUST_EXIST | CFLAG_NOT_MAP_CANDIDATE
	//})
	
	
	//Spawn hints
	kvs = {
		targetname 			= "vmut_persistent_currency_hint_target"
		origin 				= Vector(-6616, 7552, 132)
	}
	SpawnEntityFromTable("info_target_instructor_hint", kvs)
	kvs = {
		targetname			= "vmut_persistent_currency_hint"
		origin 				= Vector(-6616, 7552, 132)
		hint_target			= "vmut_persistent_currency_hint_target"
		hint_caption 		= "Collected money won't reappear on the return trip"
		hint_static			= 0
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_tip"
		hint_icon_offscreen	= "icon_tip"
		hint_color			= "255 255 255"
		hint_timeout		= 30
	}
	SpawnEntityFromTable("env_instructor_hint", kvs)
	
	kvs = {
		targetname			= "vmut_persistent_state_hint"
		origin 				= Vector(0, 0, 0)
		hint_caption 		= "The same vendors will still be here when you come back"
		hint_static			= 0
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_tip"
		hint_icon_offscreen	= "icon_tip"
		hint_color			= "255 255 255"
		hint_timeout		= 30
	}
	SpawnEntityFromTable("env_instructor_hint", kvs)
	
	/*
	kvs = {
		targetname			= "vmut_return_unlock_hint"
		origin 				= Vector(0, 0, 0)
		hint_caption 		= "Some vendors won't unlock until the return trip"
		hint_static			= 0
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_tip"
		hint_icon_offscreen	= "icon_tip"
		hint_color			= "255 255 255"
		hint_timeout		= 30
	}
	SpawnEntityFromTable("env_instructor_hint", kvs)
	*/
}
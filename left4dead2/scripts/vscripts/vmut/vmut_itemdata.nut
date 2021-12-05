//Author: Waifu Enthusiast
::VMutItemData <- {}

//ALL ITEMDATA IS TEMPORARY
//The actual pricing and balancing of this whole system is going to take a LOT of testing, feedback and adjusting... T^T
//The itemdata system / vendor activation system is probably going to be replaced in the future with a system that is friendlier to precaching, wierd exceptions like melee weapons, custom events, custom upgrades, etc...

//------------------------------------------------------------------------------------------------------
//CONST IDS

const UPGRADE_INCENDIARY_AMMO 		= 0
const UPGRADE_EXPLODING_AMMO 		= 1
const UPGRADE_LASER_SIGHT 			= 2

enum ITEM_ID {
	EMPTY,
	
    SMG,
    SMG_SILENCED,
    SHOTGUN,
    SHOTGUN_CHROME,
    
    AK47,
    M16,
    DESERT_RIFLE,
    AUTOSHOTGUN,
    SHOTGUN_SPAS,
    HUNTING_RIFLE,
    SNIPER_RIFLE,
    
    PISTOL,
    MAGNUM,
    
    MACHINEGUN,
    GRENADE_LAUNCHER,
    CHAINSAW,
    
    MOLOTOV,
    PIPEBOMB,
    BILE_JAR,
    
    PAIN_PILLS,
    ADRENALINE,
    FIRST_AID_KIT,
    DEFIBRILLATOR,
    
    FIREAXE,
    KATANA,
	FRYING_PAN,
    
    GAS,
    PROPANE,
    
    INCENDIARY_UPGRADE,
    EXPLOSIVE_UPGRADE,
    LASERSIGHTS_UPGRADE,
	
	count
}

enum ITEM_CATEGORY {
	EMPTY,
	HEALING,
	HEALING_SOFT,
	HEALING_CRITICAL,
	WEAPON,
	PRIMRAY_WEAPON,
	SECONDARY_WEAPON,
	SPECIAL_WEAPON,
	T1_WEAPON,
	T2_WEAPON,
	GRENADE,
	UPGRADE,
	PROP,
	
	count
}

//@TODO possibly add an item_value/item_rarity hierachy. We can assign items different "value".
//Example: First aid and Bile are more valuable than an SMG. We can put vendors that only spawn with "high value" items in areas with a lot of risk such as the panic runs in dark carnival...
//Possibly sort into 2 or 3 tiers of value. 1 is pistols, melee + chainsaw and t1 weapons. 2 is special weapons (except chainsaw), t2 weapons, grenades (except bile) and soft healing. 3 is bile and critical healing.
//Big maybe. The purpose of this system is to encourage players to take risks in dangerous situations by tempting them with powerful items. We could also create a system that gives vendors a chance to spawn with a discounted price.

//------------------------------------------------------------------------------------------------------
//SETUP

function VMutItemData::Precache() {
	local modelsToPrecache = [
		"models/props/terror/incendiary_ammo.mdl",
		"models/props/terror/exploding_ammo.mdl"
	]
	
	local meleeModels = [
		"models/weapons/melee/w_chainsaw.mdl",
		"models/weapons/melee/w_katana.mdl",
		"models/weapons/melee/w_fireaxe.mdl",
		"models/weapons/melee/w_frying_pan.mdl",
	
		"models/weapons/melee/v_chainsaw.mdl",
		"models/weapons/melee/v_katana.mdl",
		"models/weapons/melee/v_fireaxe.mdl",
		"models/weapons/melee/v_frying_pan.mdl"
	]

	foreach (model in modelsToPrecache)
		PrecacheModel(model)
	foreach (model in meleeModels)
		PrecacheModel(model)
}


//------------------------------------------------------------------------------------------------------
//ITEM DATA

/*
 *	Main itemdata array
 *	Index this array with an ITEM_ID constant to retrieve the associated itemdata
 *	eg: shotgunData = itemDataArray[ITEM_ID.SHOTGUN]
 *
 *	cost		-- How much it costs to buy this item from a vendor
 *	display 	-- The model that appears above a vendor when it is selling this item
 *	classname	-- If specified, spawn an entity of this class when this item is purchased from a vendor
 *	keyvalues	-- If specified, assign these keyvalues to the entity created after purchasing an item from a vendor
 *	func		-- If specified, call this function when this item is purchased from a vendor. func(vendordata, player, params)
 * 	params		-- If specified, pass these params to func when it is executed
 *
 */
::VMutItemData.itemDataArray <- [

	//DEFAULT
	{
		cost		= 0
		display		= null
	}

	//T1 WEAPONS
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_smg_uzi.mdl"
		classname 	= "weapon_smg_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_smg_a.mdl"
		classname 	= "weapon_smg_silenced_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_shotgun.mdl"
		classname 	= "weapon_pumpshotgun_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_pumpshotgun_a.mdl"
		classname 	= "weapon_shotgun_chrome_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	
	//T2 WEAPONS
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_ak47.mdl"
		classname 	= "weapon_rifle_ak47_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_m16a2.mdl"
		classname 	= "weapon_rifle_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_desert_rifle.mdl"
		classname 	= "weapon_rifle_desert_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_autoshot_m4super.mdl"
		classname 	= "weapon_autoshotgun_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_shotgun_spas.mdl"
		classname 	= "weapon_shotgun_spas_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_sniper_mini14.mdl"
		classname 	= "weapon_hunting_rifle_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_sniper_military.mdl"
		classname 	= "weapon_sniper_military_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	
	//PISTOLS
	{
		cost 		= 250 //500 for dual pistols
		display 	= "models/w_models/weapons/w_pistol_a.mdl"
		classname 	= "weapon_pistol_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_desert_eagle.mdl"
		classname 	= "weapon_pistol_magnum_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	
	//SPECIAL WEAPONS
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_m60.mdl"
		classname 	= "weapon_rifle_m60_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_grenade_launcher.mdl"
		classname 	= "weapon_grenade_launcher_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1500
		display 	= "models/weapons/melee/w_chainsaw.mdl"
		classname 	= "weapon_chainsaw_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	
	//GENADES
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_eq_molotov.mdl"
		classname 	= "weapon_molotov"
	},
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_eq_pipebomb.mdl"
		classname 	= "weapon_pipe_bomb"
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_eq_bile_flask.mdl"
		classname 	= "weapon_vomitjar"
	},
	
	//HEALTH
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_eq_painpills.mdl"
		classname 	= "weapon_pain_pills"
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_eq_adrenaline.mdl"
		classname 	= "weapon_adrenaline"
	},
	{
		cost 		= 4000
		display 	= "models/w_models/weapons/w_eq_medkit.mdl"
		classname 	= "weapon_first_aid_kit"
	},
	{
		cost 		= 4000
		display 	= "models/w_models/weapons/w_eq_defibrillator.mdl"
		classname 	= "weapon_defibrillator"
	},
	
	//MELEE
	{
		cost 		= 500
		display 	= "models/weapons/melee/w_fireaxe.mdl"
		classname 	= "weapon_melee_spawn"
		keyvalues	= {
			melee_weapon	= "fireaxe"
			count 			= 1
			spawnflags 		= 1
		}
	},
	{
		cost 		= 500
		display 	= "models/weapons/melee/w_katana.mdl"
		classname 	= "weapon_melee_spawn"
		keyvalues	= {
			melee_weapon	= "katana"
			count 			= 1
			spawnflags 		= 1
		}
	},
	{
		cost 		= 500
		display 	= "models/weapons/melee/w_frying_pan.mdl"
		classname 	= "weapon_melee_spawn"
		keyvalues	= {
			melee_weapon	= "frying_pan"
			count 			= 1
			spawnflags 		= 1
		}
	},
	
	//EXPLOSIVES
	{
		cost 		= 750
		display 	= "models/props_junk/gascan001a.mdl"
		classname 	= "weapon_gascan"
	},
	{
		cost 		= 500
		display 	= "models/props_junk/propanecanister001a.mdl"
		classname 	= "prop_physics"
		keyvalues	= {
			model		= "models/props_junk/propanecanister001a.mdl"
			spawnflags 	= 64 | 2048
		}
	},
	
	//UPGRADES
	{
		cost 		= 500
		display 	= "models/props/terror/incendiary_ammo.mdl"
		func		= function(vendorData, player, params) {player.GiveUpgrade(UPGRADE_INCENDIARY_AMMO)}
	},
	{
		cost 		= 500
		display 	= "models/props/terror/exploding_ammo.mdl"
		func		= function(vendorData, player, params) {player.GiveUpgrade(UPGRADE_EXPLODING_AMMO)}
	},
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_laser_sights.mdl"
		func		= function(vendorData, player, params) {player.GiveUpgrade(UPGRADE_LASER_SIGHT)}
	}
	
]


/*
 *	A shorthand function for retrieving an itemdata table from the itemDataArray
 *	ie: VMutItemData.Get(i) instead of VMutItemData.itemDataArray[i]
 */
function VMutItemData::Get(index) {
	return itemDataArray[index]
}


//------------------------------------------------------------------------------------------------------
//ITEM CATEGORIES

//@TODO Change into some kind of "category tree" system that allows categories to be parented?
//Example:
//Weapon -> PrimaryWeapon -> T2Weapon -> T2Strong (t2 strong is desert rifle, spas and sniper. All other t2 weaps are t2 normal)
//So we only specify items in t2 weak and t2 normal, then all the parent categories just list other categories.
//Or a system where the individual item data entries have a list of categories they belong to?
//The purpose of item categories is to eventually add an easier way to blacklist or whitelist certain item groups on vendors.

::VMutItemData.category <- [
	//EMPTY
	[
		ITEM_ID.EMPTY
	],

	//Healing
	[
		ITEM_ID.FIRST_AID_KIT,
		ITEM_ID.DEFIBRILLATOR,
		ITEM_ID.PAIN_PILLS,
		ITEM_ID.ADRENALINE
	],
	
	//Healing soft
	[
		ITEM_ID.PAIN_PILLS,
		ITEM_ID.ADRENALINE
	],
	
	//Healing critical
	[
		ITEM_ID.FIRST_AID_KIT,
		ITEM_ID.DEFIBRILLATOR
	],
	
	//Weapon
	[
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
		ITEM_ID.MACHINEGUN,
		ITEM_ID.GRENADE_LAUNCHER,
		ITEM_ID.CHAINSAW
	],
	
	//Primary weapon
	[
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
		ITEM_ID.SNIPER_RIFLE
	],
	
	//Secondary weapon
	[
		ITEM_ID.PISTOL,
		ITEM_ID.MAGNUM
	],
	
	//Special weapon
	[
		ITEM_ID.MACHINEGUN,
		ITEM_ID.GRENADE_LAUNCHER,
		ITEM_ID.CHAINSAW
	],
	
	//T1 weapon
	[
		ITEM_ID.SMG,
		ITEM_ID.SMG_SILENCED,
		ITEM_ID.SHOTGUN,
		ITEM_ID.SHOTGUN_CHROME
	],
	
	//T2 weapon
	[
		ITEM_ID.AK47,
		ITEM_ID.M16,
		ITEM_ID.DESERT_RIFLE,
		ITEM_ID.AUTOSHOTGUN,
		ITEM_ID.SHOTGUN_SPAS,
		ITEM_ID.HUNTING_RIFLE,
		ITEM_ID.SNIPER_RIFLE
	],
	
	//Grenade
	[
		ITEM_ID.MOLOTOV,
		ITEM_ID.PIPEBOMB,
		ITEM_ID.BILE_JAR
	],
	
	//Upgrade
	[
		ITEM_ID.INCENDIARY_UPGRADE,
		ITEM_ID.EXPLOSIVE_UPGRADE,
		ITEM_ID.LASERSIGHTS_UPGRADE
	],
	
	//Prop
	[
		ITEM_ID.GAS,
		ITEM_ID.PROPANE
	]
]




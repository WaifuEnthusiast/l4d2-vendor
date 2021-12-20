//Author: Waifu Enthusiast
::VMutItemData <- {}

//ALL ITEMDATA IS TEMPORARY
//The actual pricing and balancing of this whole system is going to take a LOT of testing, feedback and adjusting... T^T
//The itemdata system / vendor activation system is probably going to be replaced in the future with a system that is friendlier to precaching, wierd exceptions like melee weapons, custom events, custom upgrades, etc...


//------------------------------------------------------------------------------------------------------
//CONST ITEM TYPES

const ITEMDATA_TYPE_ITEM 	= 0
const ITEMDATA_TYPE_MELEE	= 1
const ITEMDATA_TYPE_UPGRADE	= 2
const ITEMDATA_TYPE_PROPANE	= 3


//------------------------------------------------------------------------------------------------------
//CONST UPGRADE IDs

const UPGRADE_INCENDIARY_AMMO 		= 0
const UPGRADE_EXPLODING_AMMO 		= 1
const UPGRADE_LASER_SIGHT 			= 2


//------------------------------------------------------------------------------------------------------
//CONST ITEM IDs

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
	MELEE,
    
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
    
    GAS,
    PROPANE,
    
    INCENDIARY_UPGRADE,
    EXPLOSIVE_UPGRADE,
    LASERSIGHTS_UPGRADE,
	
	count
}

enum ITEM_CATEGORY {
	EMPTY,
	ALL,
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
	foreach (itemData in ::VMutItemData.itemDataArray) {
		local display = itemData.display
		if (display)
			PrecacheModel(display)
	}

	/*
	local modelsToPrecache = [
		"models/props/terror/incendiary_ammo.mdl",
		"models/props/terror/exploding_ammo.mdl"
	]
	foreach (model in modelsToPrecache)
		PrecacheModel(model)
	*/
}


//------------------------------------------------------------------------------------------------------
//ITEM DATA

/*
 *	Main itemdata array
 *	Index this array with an ITEM_ID constant to retrieve the associated itemdata
 *	eg: shotgunData = itemDataArray[ITEM_ID.SHOTGUN]
 *
 *	cost		-- How much it costs to buy this item from a vendor
 *	display 	-- The model that appears above a vendor when it is selling this item. Melee vendors do not require a display model.
 *	type		-- The itemdata type. This determines what functions the vendor will call when it is activated.
 *	data		-- Determines what item a vendor will deploy once it is activated. Data format will change depending on the itemdata type.
 * 	callback	-- If specified, this function will be called when a vendor deploys an item with this item ID. Callback(vendorData, player) <- must use this format
 *
 */
::VMutItemData.itemDataArray <- [

	//DEFAULT
	{
		cost		= 0
		display		= null
		data		= null
		type		= null
	}

	//T1 WEAPONS
	{	//smg
		cost 		= 500
		display 	= "models/w_models/weapons/w_smg_uzi.mdl"
		data 		= "weapon_smg"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//silenced smg
		cost 		= 500
		display 	= "models/w_models/weapons/w_smg_a.mdl"
		data 		= "weapon_smg_silenced"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//shotgun
		cost 		= 500
		display 	= "models/w_models/weapons/w_shotgun.mdl"
		data	 	= "weapon_pumpshotgun"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//chrome shotgun
		cost 		= 500
		display 	= "models/w_models/weapons/w_pumpshotgun_a.mdl"
		data	 	= "weapon_shotgun_chrome"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//T2 WEAPONS
	{	//ak47
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_ak47.mdl"
		data	 	= "weapon_rifle_ak47"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//assault rifle
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_m16a2.mdl"
		data	 	= "weapon_rifle"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//combat rifle
		cost 		= 1000
		display 	= "models/w_models/weapons/w_desert_rifle.mdl"
		data	 	= "weapon_rifle_desert"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//auto shotgn
		cost 		= 1000
		display 	= "models/w_models/weapons/w_autoshot_m4super.mdl"
		data	 	= "weapon_autoshotgun"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//combat shotgun
		cost 		= 1000
		display 	= "models/w_models/weapons/w_shotgun_spas.mdl"
		data	 	= "weapon_shotgun_spas"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//hunting rifle
		cost 		= 1000
		display 	= "models/w_models/weapons/w_sniper_mini14.mdl"
		data	 	= "weapon_hunting_rifle"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//sniper
		cost 		= 1000
		display 	= "models/w_models/weapons/w_sniper_military.mdl"
		data	 	= "weapon_sniper_military"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//SECONDARY
	{	//pistol
		cost 		= 250 //500 for dual pistols
		display 	= "models/w_models/weapons/w_pistol_a.mdl"
		data 		= "weapon_pistol"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//deagle
		cost 		= 500
		display 	= "models/w_models/weapons/w_desert_eagle.mdl"
		data 		= "weapon_pistol_magnum"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//melee
		cost 		= 500
		display 	= null
		data		= null
		type		= ITEMDATA_TYPE_MELEE
	},
	
	//SPECIAL WEAPONS
	{
		//machine gun
		cost 		= 1000
		display 	= "models/w_models/weapons/w_m60.mdl"
		data 		= "weapon_rifle_m60"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//grenade launcher
		cost 		= 1000
		display 	= "models/w_models/weapons/w_grenade_launcher.mdl"
		data 		= "weapon_grenade_launcher"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//chainsaw
		cost 		= 1000
		display 	= "models/weapons/melee/w_chainsaw.mdl"
		data	 	= "weapon_chainsaw"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//GENADES
	{	//molotov
		cost 		= 750
		display 	= "models/w_models/weapons/w_eq_molotov.mdl"
		data 		= "weapon_molotov"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//pipebomb
		cost 		= 750
		display 	= "models/w_models/weapons/w_eq_pipebomb.mdl"
		data 		= "weapon_pipe_bomb"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//bile
		cost 		= 1500
		display 	= "models/w_models/weapons/w_eq_bile_flask.mdl"
		data 		= "weapon_vomitjar"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//HEALTH
	{	//pills
		cost 		= 1000
		display 	= "models/w_models/weapons/w_eq_painpills.mdl"
		data 		= "weapon_pain_pills"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//adrenaline
		cost 		= 1000
		display 	= "models/w_models/weapons/w_eq_adrenaline.mdl"
		data 		= "weapon_adrenaline"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//kit
		cost 		= 4000
		display 	= "models/w_models/weapons/w_eq_medkit.mdl"
		data 		= "weapon_first_aid_kit"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//defibrillator
		cost 		= 4000
		display 	= "models/w_models/weapons/w_eq_defibrillator.mdl"
		data 		= "weapon_defibrillator"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//EXPLOSIVES
	{	//gas
		cost 		= 750 //should have same price as molotov
		display 	= "models/props_junk/gascan001a.mdl"
		data 		= "weapon_gascan"
		type 		= ITEMDATA_TYPE_ITEM
	},
	{	//propane
		cost 		= 500
		display 	= "models/props_junk/propanecanister001a.mdl"
		data	 	= "weapon_propanetank"
		type 		= ITEMDATA_TYPE_ITEM
	},
	
	//UPGRADES
	{	//incendiary ammo
		cost 		= 500
		display 	= "models/props/terror/incendiary_ammo.mdl"
		data		= UPGRADE_INCENDIARY_AMMO
		type 		= ITEMDATA_TYPE_UPGRADE
	},
	{	//explosive ammo
		cost 		= 500
		display 	= "models/props/terror/exploding_ammo.mdl"
		data		= UPGRADE_EXPLODING_AMMO
		type 		= ITEMDATA_TYPE_UPGRADE
	},
	{	//lasersight
		cost 		= 500
		display 	= "models/w_models/weapons/w_laser_sights.mdl"
		data		= UPGRADE_LASER_SIGHT
		type 		= ITEMDATA_TYPE_UPGRADE
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

/*
::VMutItemData.category <- [
	//EMPTY
	[
		ITEM_ID.EMPTY
	],
	
	//All
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
		ITEM_ID.CHAINSAW,
		ITEM_ID.MOLOTOV,
		ITEM_ID.PIPEBOMB,
		ITEM_ID.BILE_JAR,
		ITEM_ID.PAIN_PILLS,
		ITEM_ID.ADRENALINE,
		ITEM_ID.FIRST_AID_KIT,
		ITEM_ID.DEFIBRILLATOR,
		ITEM_ID.FIREAXE,
		ITEM_ID.KATANA,
		ITEM_ID.FRYING_PAN,
		ITEM_ID.GAS,
		ITEM_ID.PROPANE,
		ITEM_ID.INCENDIARY_UPGRADE,
		ITEM_ID.EXPLOSIVE_UPGRADE,
		ITEM_ID.LASERSIGHTS_UPGRADE
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
*/




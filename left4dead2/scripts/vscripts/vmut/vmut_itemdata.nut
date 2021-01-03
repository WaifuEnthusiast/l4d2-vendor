//Author: Waifu Enthusiast
::VMutItemData <- {}

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
		cost 		= 700
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
		cost 		= 700
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
		cost 		= 1000
		display 	= "models/w_models/weapons/w_grenade_launcher.mdl"
		classname 	= "weapon_grenade_launcher_spawn"
		keyvalues	= {
			count		= 1
			spawnflags 	= 1
		}
	},
	{
		cost 		= 1000
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
		cost 		= 750
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
		cost 		= 750
		display 	= "models/w_models/weapons/w_eq_adrenaline.mdl"
		classname 	= "weapon_adrenaline"
	},
	{
		cost 		= 4000
		display 	= "models/w_models/weapons/w_eq_medkit.mdl"
		classname 	= "weapon_first_aid_kit"
	},
	{
		cost 		= 3000
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
		cost 		= 700
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


function VMutItemData::Get(index) {
	return itemDataArray[index]
}


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


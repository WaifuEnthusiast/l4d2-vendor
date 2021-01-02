//Vendor mutation itemData
//Author: Waifu Enthusiast

//For now in order to fix weapons spawning with no ammo, I am changing weapons to weapon_spawns...
//I don't really understand the implications of spawning weapon_spawns on the director... Dunno if it's messing with systems that I don't understand
//Ideally, a better solution would be to spawn a regular weapon (without the "_spawn") then set some kind of flag or keyvalue to make it spawn with full ammo...
//There needs to be some kind of function that can adjust a weapon's ammo, because l4d2 calls it when survivors throw their weapons away or die and spawn their weapons.
//Unfortunately, there is no documentation that describes the keyvalues and flags of standard weapon entities, so I don't know what the magic ammo key/flag is.
//Maybe there is some way to see the original .cpp class file that valve uses for the weapon entities that might shed some light on this.
//Anyway, now I need to put keyvalues and flags into every itemDataArray field to make sure it spawns correctly. Yet another reason to scrap this system and create a specific system for spawning weapon specifically.
//I can then expand the systems to manage different cases such as melees, upgradess, etc... 
//This will also allow for a smoother precaching system, because right now I need to hand-write an array of models that need to be precached. Not good.


itemDataArray <- [

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
	},
	{
		cost 		= 800
		display 	= "models/props/terror/ammo_stack.mdl"
		func		= function(vendorData, player, params) {}
	}
	
]

function GetItemData(index) {
	return itemDataArray[index]
}

modelsToPrecache <- [
	"models/weapons/melee/w_chainsaw.mdl",
	"models/props/terror/ammo_stack.mdl",
	"models/props/terror/incendiary_ammo.mdl",
	"models/props/terror/exploding_ammo.mdl",
	"models/props_junk/gnome.mdl",
]

meleeModels <- [
	"models/weapons/melee/v_katana.mdl",
	"models/weapons/melee/w_katana.mdl"
	"models/weapons/melee/v_fireaxe.mdl",
	"models/weapons/melee/w_fireaxe.mdl",
	"models/weapons/melee/v_frying_pan.mdl",
	"models/weapons/melee/w_frying_pan.mdl"
]

function PrecacheModels() {
	foreach (model in modelsToPrecache)
		PrecacheModel(model)
	foreach (model in meleeModels)
		PrecacheModel(model)
}


//Vendor mutation itemData
//Author: Waifu Enthusiast


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
		classname 	= "weapon_smg"
	},
	{
		cost 		= 700
		display 	= "models/w_models/weapons/w_smg_a.mdl"
		classname 	= "weapon_smg_silenced"
	},
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_shotgun.mdl"
		classname 	= "weapon_pumpshotgun"
	},
	{
		cost 		= 700
		display 	= "models/w_models/weapons/w_pumpshotgun.mdl"
		classname 	= "weapon_shotgun_chrome"
	},
	
	//T2 WEAPONS
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_ak47.mdl"
		classname 	= "weapon_rifle_ak47"
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_rifle_m16a2.mdl"
		classname 	= "weapon_rifle"
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_desert_rifle.mdl"
		classname 	= "weapon_rifle_desert"
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_autoshot_m4super.mdl"
		classname 	= "weapon_autoshotgun"
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_shotgun_spas.mdl"
		classname 	= "weapon_shotgun_spas"
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_sniper_mini.mdl"
		classname 	= "weapon_hunting_rifle"
	},
	{
		cost 		= 1500
		display 	= "models/w_models/weapons/w_sniper_military.mdl"
		classname 	= "weapon_sniper_military"
	},
	
	//PISTOLS
	{
		cost 		= 250 //500 for dual pistols
		display 	= "models/w_models/weapons/w_pistol_a.mdl"
		classname 	= "weapon_pistol"
	},
	{
		cost 		= 750
		display 	= "models/w_models/weapons/w_desert_eagle.mdl"
		classname 	= "weapon_pistol_magnum"
	},
	
	//SPECIAL WEAPONS
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_m60.mdl"
		classname 	= "weapon_rifle_m60"
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_grenade_launcher.mdl"
		classname 	= "weapon_grenade_launcher"
	},
	{
		cost 		= 1000
		display 	= "models/w_models/weapons/w_chainsaw.mdl"
		classname 	= "weapon_chainsaw"
	},
	
	//GENADES
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_eq_molotov.mdl"
		classname 	= "weapon_molotov"
	},
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_eq_pipebomb.mdl"
		classname 	= "weapon_pipebomb"
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
	/*
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_fireaxe.mdl"
		classname 	= "weapon_melee"
		keyvalues	= {
			MeleeWeapon	= "fireaxe"
			model		= "models/w_models/weapons/w_fireaxe.mdl"
		}
	},
	{
		cost 		= 500
		display 	= "models/w_models/weapons/w_katana.mdl"
		classname 	= "weapon_melee"
		keyvalues	= {
			MeleeWeapon	= "katana"
			model		= "models/w_models/weapons/w_katana.mdl"
		}
	},
	*/
	
	//EXPLOSIVES
	{
		cost 		= 700
		display 	= "models/props_junk/gascan001a.mdl"
		classname 	= "weapon_gascan"
	},
	{
		cost 		= 500
		display 	= "models/props_junk/propanecanister001a.mdl"
		classname 	= "prop_fuel_barrel"
		keyvalues	= {
			model		= "models/props_junk/propanecanister001a.mdl"
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
	"models/props/terror/ammo_stack.mdl",
	"models/props/terror/incendiary_ammo.mdl",
	"models/props/terror/exploding_ammo.mdl",
	"models/props_junk/gnome.mdl"
	
]

function PrecacheModels() {
	foreach (model in modelsToPrecache)
		PrecacheModel(model)
}


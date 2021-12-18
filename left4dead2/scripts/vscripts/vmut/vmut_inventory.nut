//Author: Waifu Enthusiast
//This entire module is hacky and stupid.
//This is partly due to there being no robust system for checking specific inventory slots.
//May need to make my own inventory system that manually keeps track of player inventories and has some nicer functions for checking slots and dropping items...
//Possibly listens to game events to see when items are picked up or dropped and have some tables that reference every item classname to a slot that it belongs to...
//idk

::VMutInventory <- {}

/*
 *	Give the specified item to the specified player.
 *	Forcefully drop items that already exist in desired item slot.
 */
function VMutInventory::GiveItem(player, classname) {
	//Test for bad player
	if (!::VMutUtils.ValidatePlayer(player))
		return false
	
	//If player already has an item in the desired slot, force drop it.
	local inv = {}
	g_ModeScript.GetInvTable(player, inv)

	foreach (slot, item in inv) {
		if (!item)
			continue
			
		if (classname == item.GetClassname()) {
			player.DropItem(classname)
			break;
		}
	}
	
	//this just drops "a" weapon, but isn't actually the player's weapon... So it just drops a gun that has no ammo...
	//maybe for primary weapons we can remove 1 ammo before giving the new weapon which will force a drop? Extremely hacky but it would work...
	
	//Give the item
	player.GiveItem(classname)
	
	return true
}


/*
 *	Give the specified upgrade to the specified player.
 */
function VMutInventory::GiveUpgrade(player, upgradeId) {
	//Test for bad player
	if (!::VMutUtils.ValidatePlayer(player))
		return false
		
	//Test if player has a valid primary weapon
	local inv = {}
	g_ModeScript.GetInvTable(player, inv)
	if (!("slot0" in inv))
		return false
		
	//Give the upgrade
	player.GiveUpgrade(upgradeId)
	
	return true
}


/*
 *	Give the specified item to the specified player.
 *	Forcefully drop items that already exist in desired item slot.
 */
 /*
function VMutInventory::GivePropane(player) {
	//Test for bad player
	if (!::VMutUtils.ValidatePlayer(player))
		return false

	//Create the propane tank
	local kvs = {
		origin 		= player.GetOrigin()
		model		= "models/props_junk/propanecanister001a.mdl"
	}
	//local ent = g_ModeScript.SpawnEntityFromTable("prop_physics", kvs)
	
	//Make player carry the propane tank
	//PickupObject(player, ent)
	player.GiveItem("weapon_propanetank")
	
	return true
}
*/
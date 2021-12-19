//Author: Waifu Enthusiast
//This entire module is hacky and stupid.
//This is partly due to there being no robust system for checking specific inventory slots.
//May need to make my own inventory system that manually keeps track of player inventories and has some nicer functions for checking slots and dropping items...
//Possibly listens to game events to see when items are picked up or dropped and have some tables that reference every item classname to a slot that it belongs to...
//A self made system could also keep track of if the player is currently dual wielding pistols or not...
//idk
//pooping is more fun than peeing

::VMutInventory <- {}

/*
 *	Give the specified item to the specified player.
 *	Forcefully drop items that already exist in the desired item slot.
 */
function VMutInventory::GiveItem(player, classname) {
	//Test for bad player
	if (!::VMutUtils.ValidatePlayer(player))
		return false
	
	//Get player's inventory before the give
	local preInv = {}
	g_ModeScript.GetInvTable(player, preInv)
	
	//Give the item
	player.GiveItem(classname)
	
	//If the item was a pistol, there is no need to do anything else
	if (classname == "weapon_pistol")
		return true
	
	//Get another copy of the player's inventory for comparison
	local postInv = {}
	g_ModeScript.GetInvTable(player, postInv)

	
	//Loop through inventory to find the entity handle of the item we just gave to the player
	foreach (slot, item in postInv) {
	
		//Validate item
		if (!(slot in preInv))
			continue
		if (!item)
			continue
		if (classname != item.GetClassname())
			continue
		
		//The player's item is unchanged, which means an automatic item drop did not occur
		if (preInv[slot] == postInv[slot]) {
			if (slot == "slot0") {	//Primary weapons need to create a new weapon entity with full ammo
			
				printl(" ** forcing primary weapon drop")
				local kvs = {
					origin 		= player.GetOrigin() + Vector(0, 0, 48)
					angles		= QAngle(0,0,0)
					count		= 1
					spawnflags 	= 1
				}
				local ent = g_ModeScript.SpawnEntityFromTable(classname + "_spawn", kvs)
				if (!ent) {printl(" ** failed to create new weapon entity!")}
				
			}
			else {					//Otherwise, a standard drop and replace is fine
				
				printl(" ** forcing item drop")
				player.DropItem(classname)
				player.GiveItem(classname)
				
			}
		}
	}

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
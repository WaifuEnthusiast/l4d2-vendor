//Author: Waifu Enthusiast
::VMutUtils <- {}


/*
 *	Convert a table into an array
 */
 function VMutUtils::TableToList(table, dest = null) {
	if (!dest)
		dest = []
 
	foreach(k, v in table) {
		dest.append(v)
	}
	
	return dest
 }
 
 
 /*
 *	Convert an array into a table
 */
 function VMutUtils::ListToTable(list, dest = null) {
	if (!dest)
		dest = {}
 
	for (local i = 0; i < list.len(); i++) {
		dest[i.tostring()] <- list[i]
	}
	
	return dest
 }
 
 
/*
 *	Convert a table into a vector
 */
 function VMutUtils::TableToVector(table) {
	return Vector(table.x, table.y, table.z)
 }
 
 
/*
 *	Convert a table into a QAngle
 */
 function VMutUtils::TableToQAngle(table) {
	return QAngle(table.x, table.y, table.z)
 }
 
 
 /*
 *	Convert a vector KV string into a vector instance
 */
 function VMutUtils::KVStringToVector(kvString) {
	local values = split(kvString, " ")
	return Vector(values[0].tofloat(), values[1].tofloat(), values[2].tofloat())
 }
 
 
/*
 *	Convert a QAngle KV string into a QAngle instance
 */
 function VMutUtils::KVStringToQAngle(kvString) {
	local values = split(kvString, " ")
	return QAngle(values[0].tofloat(), values[1].tofloat(), values[2].tofloat())
 }
 
 
/*
 *	Converts an entity handle to a player CEntity handle
 */
function VMutUtils::EHandleToPlayer(ehandle) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
		
		if (ehandle == player.GetEntityHandle())
			return player
			
		
	}
}


/*
 *	Get the player entity associated with a survivor slot
 */
function VMutUtils::SurvivorSlotToPlayer(slot) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
			
		if (!player.IsPlayer())
			continue
			
		if (!player.IsSurvivor())
			continue
			
		if (player.GetSurvivorSlot() == slot)
			return player
		
	}
	
	return null
}


/*
 *	Converts an integer value into an array holding each digit of the original value
 *	Eg: 2560 becomes [2,5,6,0]
 */
function VMutUtils::DigitArrayFromValue(value) {
	//This is really dumb and hacky but it works so meh
	
	if (value < 0)
		return [0]
	
	local digitArray = []
	local str = value.tostring()
	
	for (local i = 0; i < str.len(); i++) {
		local substr = str.slice(i, i+1)
		digitArray.append(substr.tointeger())
	}
	
	return digitArray
}


/*
 *	Returns true if the specified point is within the specified bounds
 */
function VMutUtils::PointInBox(point, origin, extent) {
	
	if (
		point.x > origin.x && point.x < origin.x + extent.x &&
		point.y > origin.y && point.y < origin.y + extent.y &&
		point.z > origin.z && point.z < origin.z + extent.z) {
		return true
	}
	
	return false
	
}


/*
 *	Returns another list containing a random set of entries from the supplied list.
 *	The resulting list will not contain any duplicate entries.
 */
function VMutUtils::ListRandomSample(list, samples) {
	
	//Create a temporary copy of the list that can be modified without altering the original list
	local tempList = list.slice(0, list.len())
	local newList = []
	local size = tempList.len()
	
	for (local i = 0; i < samples; i++) {
		//If the list we are sampling from has run out of values, then stop the function
		if (size <= 0)
			break
	
		//Random sample
		local index = RandomInt(0, size-1)
		newList.append(tempList[index])
		
		//Remove the sampled index to prevent it being sampled multiple times
		tempList.remove(index)
		size-=1
	}
	
	return newList
}


/*
 *	Test if a player reference is indeed referencing a valid player
 */
function VMutUtils::ValidatePlayer(player) {
	if (!player)
		return false
	if (!player.IsPlayer())
		return false
	if (!player.IsSurvivor())
		return false
		
	return true
}


/*
 *	Quickly spawn an explosion
 */
function VMutUtils::Explode(origin) {
	local kvs = {
		origin 		= origin
		spawnflags 	= 1
		targetname	= "vmut_quickexplode_" + UniqueString()
	}
	local ent = g_ModeScript.SpawnEntityFromTable("env_explosion", kvs)
	EntFire(ent.GetName(), "Explode", 0, 0)
}

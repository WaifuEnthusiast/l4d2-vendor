//Author: Waifu Enthusiast
::VMutUtils <- {}


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
 *	Returns true if the specified point is within the specified bounds
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

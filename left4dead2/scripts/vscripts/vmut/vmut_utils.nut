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

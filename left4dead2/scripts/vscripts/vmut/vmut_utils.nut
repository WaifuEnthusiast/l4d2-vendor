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
}


/*
 *	Converts an integer value into an array holding each digit of the original value
 *	Eg: 2560 becomes [2,5,6,0]
 */
function VMutUtils::DigitArrayFromValue(value) {
	
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
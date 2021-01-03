//Author: Waifu Enthusiast
::VMutUtils <- {}


function VMutUtils::EHandleToPlayer(ehandle) {
	local player = null
	while (player = Entities.FindByClassname(player, "player")) {
		
		if (ehandle == player.GetEntityHandle())
			return player
			
		
	}
}


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
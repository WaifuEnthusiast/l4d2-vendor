//Author: WaifuEnthusiast

activeTimers 	<- {}
thinkEnt 		<- null


function Think() {
	local timersToRemove = []

	foreach (id, timer in g_ModeScript.vendorTimers.activeTimers) {
	
		if (Time() - timer.prevTime >= timer.delay) {
			timersToRemove.append(id)
			
			//If the function fails to execute, we still want this timer to be removed and others to be executed
			try {
				timer.func(timer.params)
			}
			catch (exception) 
			{ 
				printl("Failed to execute timer function:")
				printl(exception)
			}
		}
			
	}
	
	foreach (id in timersToRemove) {
		g_ModeScript.vendorTimers.RemoveTimer(id)
	}
}


function AddTimer(id, delay, func, params) {
	if (!id || id == "")
		id = UniqueString()

	if (id in activeTimers)
		return false
		
	local newTimer = {
		prevTime 	= Time()
		delay 		= delay
		func 		= func
		params		= params
	}
	
	activeTimers[id] <- newTimer
	return true
}


function RemoveTimer(id) {
	if (!id || !(id in activeTimers))
		return
		
	delete activeTimers[id]
}


function InitializeThinkEnt() {
	if (!thinkEnt || !thinkEnt.IsValid()) {
	
		thinkEnt = SpawnEntityFromTable("info_target", { targetname = "vendorTimers" });
		if (thinkEnt) {
			thinkEnt.ValidateScriptScope()
			local scope = thinkEnt.GetScriptScope()
			scope.vendorTimersThink <- Think
			AddThinkToEnt(thinkEnt, "vendorTimersThink")
			
			return true
		}
		
	}
	
	return false
}
InitializeThinkEnt()
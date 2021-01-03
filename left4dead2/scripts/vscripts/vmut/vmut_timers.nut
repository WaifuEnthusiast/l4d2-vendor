//Author: WaifuEnthusiast

::VMutTimers <- {}

::VMutTimers.activeTimers 	<- {}
::VMutTimers.thinkEnt 		<- null


function VMutTimers::Think() {
	local timersToRemove = []

	foreach (id, timer in ::VMutTimers.activeTimers) {
	
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
		::VMutTimers.RemoveTimer(id)
	}
}


function VMutTimers::AddTimer(id, delay, func, params) {
	if (!id || id == "")
		id = UniqueString()

	if (id in ::VMutTimers.activeTimers)
		return false
		
	local newTimer = {
		prevTime 	= Time()
		delay 		= delay
		func 		= func
		params		= params
	}
	
	::VMutTimers.activeTimers[id] <- newTimer
	return true
}


function VMutTimers::RemoveTimer(id) {
	if (!id || !(id in ::VMutTimers.activeTimers))
		return
		
	delete ::VMutTimers.activeTimers[id]
}


function VMutTimers::InitializeThinkEnt() {
	if (!::VMutTimers.thinkEnt || !::VMutTimers.thinkEnt.IsValid()) {
	
		local ent = SpawnEntityFromTable("info_target", { targetname = "VMutTimers" });
		if (ent) {
			ent.ValidateScriptScope()
			local scope = ent.GetScriptScope()
			scope.VMutTimersThink <- Think
			AddThinkToEnt(ent, "VMutTimersThink")
			
			::VMutTimers.thinkEnt = ent
			return true
		}
		
	}
	
	return false
}
::VMutTimers.InitializeThinkEnt()
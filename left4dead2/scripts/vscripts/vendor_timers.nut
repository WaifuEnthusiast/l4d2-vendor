//Author: WaifuEnthusiast

::g_vendorTimers <- {}

g_vendorTimers.ActiveTimers <- {}
g_vendorTimers.thinkEnt <- null


g_vendorTimers.Think <- function() {
	local timersToRemove = []

	foreach (id, timer in g_vendorTimers.ActiveTimers) {
	
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
		g_vendorTimers.RemoveTimer(id)
	}
}


g_vendorTimers.AddTimer <- function(id, delay, func, params) {
	if (!id || id == "")
		id = UniqueString()

	if (id in g_vendorTimers.ActiveTimers)
		return false
		
	local newTimer = {
		prevTime 	= Time()
		delay 		= delay
		func 		= func
		params		= params
	}
	
	g_vendorTimers.ActiveTimers[id] <- newTimer
	return true
}


g_vendorTimers.RemoveTimer <- function(id) {
	if (!id || !(id in g_vendorTimers.ActiveTimers))
		return
		
	delete g_vendorTimers.ActiveTimers[id]
}


g_vendorTimers.InitializeThinkEnt <- function() {
	if (!g_vendorTimers.thinkEnt || !g_vendorTimers.thinkEnt.IsValid()) {
	
		g_vendorTimers.thinkEnt = SpawnEntityFromTable("info_target", { targetname = "vendorTimers" });
		if (g_vendorTimers.thinkEnt) {
			g_vendorTimers.thinkEnt.ValidateScriptScope()
			local scope = g_vendorTimers.thinkEnt.GetScriptScope()
			scope.vendorTimersThink <- g_vendorTimers.Think
			AddThinkToEnt(g_vendorTimers.thinkEnt, "vendorTimersThink")
			
			return true
		}
		
	}
	
	return false
}
g_vendorTimers.InitializeThinkEnt()
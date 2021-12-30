//Author: WaifuEnthusiast

::VMutTimers <- {}

::VMutTimers.activeTimers 	<- {}
::VMutTimers.thinkEnt 		<- null
::VMutTimers.timerQueue		<- []


/*
 *	Main point of execution for timers. Never call externally.
 *	This function is assigned to an empty entity's think function, and is executed every 0.1 seconds.
 */
function VMutTimers::Think() {
	local timersToRemove = []

	foreach (id, timer in ::VMutTimers.activeTimers) {
	
		if (Time() - timer.prevTime >= timer.delay) {
			if (timer.repeat == 0) {
				timersToRemove.append(id)
			}
			else {
				timer.repeat--
				timer.prevTime = Time()
			}
			
			//If the function fails to execute, we still want this timer to be removed and others to be executed
			try {
				timer.func(timer.params)
			}
			catch (exception) 
			{ 
				printl("Failed to execute timer function - id: " + id + " - " + exception)
			}
		}
			
	}
	
	foreach (id in timersToRemove) {
		::VMutTimers.RemoveTimer(id)
	}
}


/*
 *	Adds a new timer.
 *	When a timer expires, execute "func" and pass "params" as the function parameter
 */
function VMutTimers::AddTimer(id, delay, repeat, func, params) {

	//Generate unique id if not specified
	if (!id || id == "")
		id = UniqueString()

	//Don't create duplicate timers
	if (id in ::VMutTimers.activeTimers)
		return false
		
	//Create the timer
	local newTimer = {
		prevTime 	= Time()
		delay 		= delay
		repeat		= repeat
		func 		= func
		params		= params
	}
	
	::VMutTimers.activeTimers[id] <- newTimer
	return true
}


/*
 *	Removes a timer
 */
function VMutTimers::RemoveTimer(id) {
	if (!id || !(id in ::VMutTimers.activeTimers))
		return
		
	delete ::VMutTimers.activeTimers[id]
}


/*
 *	Creates an empty entity who's think function will be used to update timers.
 */
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
::VMutTimers.InitializeThinkEnt() //Create the think ent immediately when this file is included
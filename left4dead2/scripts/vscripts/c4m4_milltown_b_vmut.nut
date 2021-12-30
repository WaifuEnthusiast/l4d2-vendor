//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

//if ("c4_m1_milltown_a" in ::VMutPersistentState.postRoundData) {
//	LoadPostRoundEntities(::VMutPersistentState.postRoundData["c4_m1_milltown_a"])
//}

purgeSystem.Purge()

function OnActivate() {
	printl(" ** Map OnActivate")
	
	local kvs = null
	
	kvs = {
		targetname			= "vmut_persistent_currency_hint"
		origin 				= Vector(0, 0, 0)
		hint_caption 		= "Collected money won't reappear on the return trip"
		hint_static			= 0
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_info"
		hint_icon_offscreen	= "icon_info"
		hint_color			= "255 255 255"
		hint_timeout		= 30
	}
	SpawnEntityFromTable("env_instructor_hint", kvs)
	
	kvs = {
		targetname			= "vmut_persistent_state_hint"
		origin 				= Vector(0, 0, 0)
		hint_caption 		= "The same vendors will still be here when you come back"
		hint_static			= 0
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_info"
		hint_icon_offscreen	= "icon_info"
		hint_color			= "255 255 255"
		hint_timeout		= 30
	}
	SpawnEntityFromTable("env_instructor_hint", kvs)
}
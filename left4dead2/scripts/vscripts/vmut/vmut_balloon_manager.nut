//Author: Waifu Enthusiast

const SUPPLY_UNPACK_TIME = 5

::VMutBalloonManager <- {}


/*
 *	Include the balloon entity group within the balloon manager scope so that it can only be accessed via the correct spawning functions
 */
IncludeScript("entitygroups/vmut_supply_balloon_group.nut")


/*
 *	A list containing spawn points for use by the spawning system.
 *
 *	origin - origin of the spawn point
 *	angles - facing direction of the spawn point
 */
::VMutBalloonManager.spawnPoints <- []


/*
 *	Spawn a supply balloon
 */
function VMutBalloonManager::SpawnSupplyBalloon(origin, angles) {

	//Get entity group
	local entGroup = g_ModeScript.VmutSupplyBalloon.GetEntityGroup()
	
	//Create reference to supply crate prop entity
	local supplyCrate = null
	entGroup.SpawnTables[ "supply_crate" ].PostPlaceCB <- function(entity, rarity) {supplyCrate = entity}
	
	//Spawn the entity group
	g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
	
	/*
	//Create and initialize usetarget entity
	local kvs = {
		model 		= supplyCrate.GetName()
		origin 		= Vector(0,0,0)
		targetname 	= UniqueString()
	}
	local ent = SpawnEntityFromTable("point_script_use_target", kvs)
		
	ent.CanShowBuildPanel(true)
	ent.SetProgressBarText("Unpacking...")
	ent.SetProgressBarFinishTime(SUPPLY_UNPACK_TIME)
	*/
}


/*
 *	Spawning system for supply balloons. Creates a new balloon at a random spawn point.
 */
function VMutBalloonManager::SpawnSupplyBalloonAtRandomSpawn() {

}
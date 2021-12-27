value <- 2000

function OnPostSpawn() {
	self.SetProgressBarText("Unpacking Supply...")
	self.SetProgressBarFinishTime(SUPPLY_UNPACK_TIME)
	self.SetProgressBarCurrentProgress(0.0)
}


function OnUseFinished() {
	local survivor 	= null
	local player 	= ::VMutUtils.EHandleToPlayer(PlayerUsingMe)
	
	if (::VMutUtils.ValidatePlayer(player))
		survivor = player.GetSurvivorSlot()
	
	::VMutCurrency.SurvivorEarnedCurrency(0, value, CURRENCY_SOURCE_SUPPLY_CRATE)
}
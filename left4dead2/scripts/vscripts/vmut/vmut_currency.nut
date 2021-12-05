//Author: Waifu Enthusiast
::VMutCurrency <- {}

//@TODO preserve currency between map transitions. When a chapter is restarted, reset currency to whatever it was when the chapter was first started.

/*
 *	Currency is assigned on a "by survivor" basis.
 *	This is so that a survivor's currency is maintained even if players leave, or new players join.
 */
 
 
function VMutCurrency::GiveCurrencyToAllSurvivors(quantity) {
	foreach (idx, value in SessionState.currency)
		g_ModeScript.SessionState.currency[idx] += quantity
}

function VMutCurrency::SurvivorEarnedCurrency(survivorSlot, quantity) {
	::VMutCurrency.GiveCurrencyToAllSurvivors(quantity)
	//Play sound and send message to all survivors
	//no survivor slot means no specific survivor mentioned in message
	//source indicates the method by which the currency was earned
	local player 		= ::VMutUtils.SurvivorSlotToPlayer(survivorSlot)
	local playerName 	= "Survivor"
	
	if (player)
		playerName = player.GetPlayerName()
	
	g_ModeScript.Say(null, playerName + " found $" + quantity, false)
}

function VMutCurrency::SurvivorGetCurrency(survivorSlot) {
	return g_ModeScript.SessionState.currency[survivorSlot]
}


function VMutCurrency::SurvivorRemoveCurrency(survivorSlot, quantity) {
	g_ModeScript.SessionState.currency[survivorSlot] -= quantity
}


function VMutCurrency::SavePersistentCurrency() {

}


function VMutCurrency::LoadPersistentCurrency() {

}
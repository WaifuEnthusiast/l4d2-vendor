//Author: Waifu Enthusiast
::VMutCurrency <- {}


/*
 *	Currency is assigned on a "by survivor" basis.
 *	This is so that a survivor's currency is maintained even if players leave, or new players join.
 */
 
 
function VMutCurrency::GiveCurrencyToAllSurvivors(quantity) {
	foreach (idx, value in SessionState.currency)
		g_ModeScript.SessionState.currency[idx] += quantity
}


function VMutCurrency::SurvivorGetCurrency(survivorSlot) {
	return g_ModeScript.SessionState.currency[survivorSlot]
}


function VMutCurrency::SurvivorRemoveCurrency(survivorSlot, quantity) {
	g_ModeScript.SessionState.currency[survivorSlot] -= quantity
}
//Author: Waifu Enthusiast
::VMutCurrency <- {}


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
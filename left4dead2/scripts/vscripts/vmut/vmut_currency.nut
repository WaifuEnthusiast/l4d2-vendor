//Author: Waifu Enthusiast
::VMutCurrency <- {}

const CURRENCY_SOURCE_FOUND 		= 0
const CURRENCY_SOURCE_SUPPLY_CRATE	= 1
const CURRENCY_SOURCE_MAP_COMPLETE  = 2
const CURRENCY_SOURCE_SI_KILLED		= 3

/*
 *	Currency is assigned on a "by survivor" basis.
 *	This is so that a survivor's currency is maintained even if players leave, or new players join.
 */
 
 
 /*
  *	This is INCREDIBLY SCUFFED !!!
  *
  *	The original plan was to either use a table with player entities as keys or to save currency values to player script scope as part of their "survivor state".
  *	Both solutions allow us to save and restore a very intuitive table between map transitions.
  *	Alas, problems. 
  * Firstly, I ran into a problem where player entities sometimes don't exist until after all of the round beginning events and hooks are all called, which makes it very hard to synchronize the tables with survivor states.
  *	Secondly, when saving tables between map transitions, all the keys MUST be strings. Entity handles can not be used as keys and preserved between transitions.
  *	I could use a simple array that is indexed with survivor slots, however, for whatever reason, arrays are converted into tables between map transitions, and cannot be indexed with integers. Pain.
  *	So here is the solution. An incredibly scuffed survivor-slot-to-mapped-value thingamajig. Death.
  */
 
::VMutCurrency.keyList <- [		
	"0", 
	"1", 
	"2", 
	"3"
]
::VMutCurrency.roundCurrency <- {
	"0"	: 0,
	"1"	: 0,
	"2"	: 0,
	"3"	: 0,
	"initialized" : 0
}

 
function VMutCurrency::GiveCurrencyToAllSurvivors(quantity) {
	for (local survivorIndex = 0; survivorIndex < 4; survivorIndex++)
		::VMutCurrency.SurvivorGiveCurrency(survivorIndex, quantity)
}


function VMutCurrency::SurvivorEarnedCurrency(survivorSlot, quantity, source = CURRENCY_SOURCE_FOUND) {
	::VMutCurrency.GiveCurrencyToAllSurvivors(quantity)

	local player 		= ::VMutUtils.SurvivorSlotToPlayer(survivorSlot)
	local playerName 	= "Survivor"
	
	if (::VMutUtils.ValidatePlayer(player))
		playerName = player.GetPlayerName()
	
	local notice = ""
	switch (source) {
		case CURRENCY_SOURCE_FOUND:
			notice = playerName + " found $" + quantity
			break
			
		case CURRENCY_SOURCE_SUPPLY_CRATE:
			notice = playerName + " unpacked $" + quantity
			break
			
		default:
			notice = "Survivors earned $" + quantity
	}
	
	g_ModeScript.Say(null, notice, false)
}


function VMutCurrency::SurvivorGetCurrency(survivorSlot) {
	return ::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]]
}


function VMutCurrency::SurvivorGiveCurrency(survivorSlot, quantity) {
	::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]] += quantity
}


function VMutCurrency::SurvivorRemoveCurrency(survivorSlot, quantity) {
	::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]] -= quantity
}


/*
 *	Functions for managing persistent currency between map transitions
 */
function VMutCurrency::SavePersistentCurrency() {
	g_ModeScript.SaveTable("persistentCurrency", ::VMutCurrency.roundCurrency)
	printl(" ** SAVED persistent currency")
	foreach(k, v in ::VMutCurrency.roundCurrency) {
		printl(k + " - " + v)
	}
}


function VMutCurrency::LoadPersistentCurrency() {
	g_ModeScript.RestoreTable("persistentCurrency", ::VMutCurrency.roundCurrency)
	printl(" ** LOADED persistent currency")
	foreach(k, v in ::VMutCurrency.roundCurrency) {
		printl(k + " - " + v)
	}
}


/*
 *	Functions for setting up currency state at start of campagin
 */
function VMutCurrency::IsInitialized() {
	return (::VMutCurrency.roundCurrency["initialized"] == 1)
}


function VMutCurrency::SetInitialized() {
	::VMutCurrency.roundCurrency["initialized"] = 1
}
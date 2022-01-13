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
  * Firstly, I ran into a problem where player entities sometimes don't exist until after all of the round beginning events and hooks have been called, which makes it very hard to synchronize the tables with survivor states.
  *	Secondly, when saving tables between map transitions, all the keys MUST be strings. Entity handles can not be used as keys and can not be preserved between map transitions.
  *	I could use a simple array that is indexed with survivor slots, however, for whatever reason, arrays are converted into tables between map transitions, and cannot be indexed with integers. Pain.
  *	So here is the solution. A horrible survivor-slot-to-mapped-value thingamajig. Death.
  */

  
function VMutCurrency::Precache() {
	PrecacheModel("models/props_collectables/money_wad.mdl")	//small
	PrecacheModel("models/props_waterfront/money_pile.mdl")		//med
	PrecacheModel("models/props_collectables/gold_bar.mdl")		//big
}
  
  
//------------------------------------------------------------------------------------------------------
//CURRENCY RESOURCE
  
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


/*
 *	Get the quanitity of currency held by the specified survivor
 */
 function VMutCurrency::SurvivorGetCurrency(survivorSlot) {
	return ::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]]
}


/*
 *	Increase the specified survivor's held currency by the specified quantity
 */
function VMutCurrency::SurvivorGiveCurrency(survivorSlot, quantity) {
	::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]] += quantity
}


/*
 *	Decrease the specified survivor's held currency by the specified quantity
 */
function VMutCurrency::SurvivorRemoveCurrency(survivorSlot, quantity) {
	::VMutCurrency.roundCurrency[::VMutCurrency.keyList[survivorSlot]] -= quantity
}


/*
 *	Increase the held currency of ALL survivors by the specified quantity
 */
function VMutCurrency::GiveCurrencyToAllSurvivors(quantity) {
	for (local survivorIndex = 0; survivorIndex < 4; survivorIndex++)
		::VMutCurrency.SurvivorGiveCurrency(survivorIndex, quantity)
}


/*
 *	A survivor earns currency through an in-game interaction
 */
function VMutCurrency::SurvivorEarnedCurrency(survivorSlot, quantity, source = CURRENCY_SOURCE_FOUND) {

	::VMutCurrency.GiveCurrencyToAllSurvivors(quantity)

	local player 		= ::VMutUtils.SurvivorSlotToPlayer(survivorSlot)
	local playerName 	= "Survivors"
	
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
			notice = playerName + " earned $" + quantity
	}
	
	g_ModeScript.Say(null, notice, false)
	
}


//------------------------------------------------------------------------------------------------------
//CURRENCY RESOURCE PERSISTENCE

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


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM

::VMutCurrency.currencyItemTable <- {}
::VMutCurrency.currencyItemSpawnCount <- 0

::VMutCurrency.currencyItemModels <- [
	"models/props_collectables/money_wad.mdl",	//small
	"models/props_waterfront/money_pile.mdl",	//med
	"models/props_collectables/gold_bar.mdl"	//big
]

/*
 *	Create a currency item
 */
function VMutCurrency::CreateCurrencyItem(origin, angles, value) {

	//DATA

	local id = "currency_item_" + (::VMutCurrency.currencyItemSpawnCount++) + "_" + UniqueString()
	if (id in ::VMutVendor.vendorTable) {
		printl(" ** Failed to create vendor. Venor with id " + id + " already exists")
		return null
	}

	local currencyItemData = {
		entities = {
			prop	= null
			button	= null
		}
		id			= id
		value		= value
		flags		= 0
		tag			= ""
		landmark	= ""
	}
	::VMutCurrency.currencyItemTable[id] <- currencyItemData
	
	
	//SPAWN ENTITIES
	
	//Generate callbacks for each entity in the entity group. This will make entities add themselves to the currency item's entity data after spawning.
	local entGroup = ::VMutCurrencyItemEnt.GetEntityGroup()
	entGroup.SpawnTables[ "prop" ].PostPlaceCB 		<- function(entity, rarity) {currencyItemData.entities.prop		<- entity}
	entGroup.SpawnTables[ "button" ].PostPlaceCB 	<- function(entity, rarity) {currencyItemData.entities.button	<- entity}
	
	//Spawn the entity group
	g_ModeScript.SpawnSingleAt(entGroup, origin, angles)
	
	//Determine what model the currency item should use
	local model = ::VMutCurrency.currencyItemModels[0]
	if (value >= 1000)
		model = ::VMutCurrency.currencyItemModels[1]
	if (value >= 2000)
		model = ::VMutCurrency.currencyItemModels[2]
	currencyItemData.entities.prop.SetModel(model)
	
	
	//FUNCTIONALITY
	
	//Initialize functionality
	currencyItemData.entities.button.ValidateScriptScope()
	local buttonScope = currencyItemData.entities.button.GetScriptScope()
	
	buttonScope.CollectItem <- function() {
		local player = buttonScope.activator
		if (::VMutUtils.ValidatePlayer(player)) {
			::VMutCurrency.SurvivorEarnedCurrency(player.GetSurvivorSlot(), currencyItemData.value, CURRENCY_SOURCE_FOUND)
			::VMutCurrency.DestroyCurrencyItem(currencyItemData)
		}
	}
	
	currencyItemData.entities.button.ConnectOutput("OnPressed", "CollectItem")
	
	
	//REFERENCE
	
	return currencyItemData
}


/*
 *	Destroy a currency item and cleanup associated entities
 */
function VMutCurrency::DestroyCurrencyItem(currencyItemData) {
	
	//Destroy all associated entities
	foreach (ent in currencyItemData.entities) {
		if (ent)
			ent.Kill()
	}
	
	//Remove from currency item table
	local id = currencyItemData.id
	delete ::VMutCurrency.currencyItemTable[id]
	
}


/*
 *	Returns true if the specified currency item exists
 */
function VMutCurrency::CurrencyItemExists(currencyItemData) {
	return (currencyItemData.id in ::VMutCurrency.currencyItemTable)
}


/*
 *	Find currency items by tag
 */
function VMutCurrency::FindCurrencyItemsByTag(tag) {
	local currencyItemList = []
	
	foreach (id, currencyItem in ::VMutCurrency.currencyItemTable) {
		if (currencyItem.tag == tag)
			currencyItemList.append(currencyItem)
	}
	
	return currencyItemList
}
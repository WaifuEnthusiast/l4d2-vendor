/*
 *	This script creates a table in global scope that is used to store persistent data that is preserved between rounds.
 *	The global table is only created once.
 *
 *	It is used for remembering spawn locations, keeping track of survivor currency between rounds, etc...
 */
 
 if (!"VMUTPersistentState" in getroottable()) {
	printl(" ** First time creation of persistent state table")
 
	::VMUTPersistentState <- {}
 }
 else {
	printl(" ** Reusing already existing persistent state table")
 }
 
 //May not be needed....
 //We could make the currency manager global and have it listen to game events.
 //It has 2 tables, one for current round currency and one for persistent currency.
 //On game events like survivors loosing or map restart, it copies persistent currency into the round currency (reset to how it was before round start)
 //On game event for finishing a chapter, copy round currency into persistent currency.
 //On campagin finished event, reset everything.
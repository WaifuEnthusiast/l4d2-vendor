/*
 *	This script creates a table in global scope that is used to store persistent data that is preserved between rounds.
 *	The global table is only created once.
 *
 *	It is used for remembering spawn locations, keeping track of survivor currency between rounds, etc...
 */
 
 //this system seems to be pooping.
 //it stays in global scope even if we exit to main menu and load the map again...
 //better to find a way to use the saving and restoring systems which were specifically designed to handle the problems that im trying to solve with this script...
 //im am the stupid
 
 if (!("VMutPersistentState" in getroottable())) {
	printl(" ** First time creation of persistent state table")
 
	::VMutPersistentState <- {}
	
	::VMutPersistentState.isFirstMap 			<- true
	
	::VMutPersistentState.persistentCurrency 	<- [0, 0, 0, 0]	//Index this array with survivor slots
	::VMutPersistentState.postRoundData 		<- {}	//Index this table with map names
	
	/*
	 *	Post-round data overview:
	 *	After every round, a new table will be created containing post round data and saved to the postRoundData table. The current mapname is used as the key.
	 *
	 *	The contents of each postRoundData entry are as follows:
	 *	vendorState			- 	The final state of every vendor in the map.
	 *	currencyItemState	-	The final state of every currency item in the map.
	 *
	 *	This table is primarily used for preserving vendor state between the map transitions of Hard Rain. All vendors will be as they were when the survivors revisit them on the return trip.
	 */
 }
 else {
	printl(" ** Reusing already existing persistent state table")
 }

//@TODO May just delete this script and instead use ConnectOutput when the currency pickup entity group is registered.
//Connect the output of the button use to calling a function that earns currency instead of putting that functionality into an entity script.
//However, placing it here does have the advantage of allowing the entity itself to carry some state variables.
//I could also just connect an output to a function that initializes some state variables in script scope when currency pickups are spawned.
//We need to get the script scope anyway to set the quantity on spawn... unless there's an easier way to get a reference to an entity group after it's been spawned...

value <- 250

function CollectPickup() {
	::VMutCurrency.SurvivorEarnedCurrency(activator.GetSurvivorSlot(), value)
}
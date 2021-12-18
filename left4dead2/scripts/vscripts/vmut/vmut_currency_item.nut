//Author: Waifu Enthusiast

printl(" ** Executing currency item script")

value <- 0

function CollectCurrency() {
	::VMutCurrency.SurvivorEarnedCurrency(activator.GetSurvivorSlot(), value)
	Destroy()
}

function Destroy() {
	EntFire( self.GetName(), "kill", 0, 0.1 )
}
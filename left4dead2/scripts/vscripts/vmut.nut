//Vendor Mutation
//Author: Waifu Enthusiast


//------------------------------------------------------------------------------------------------------
//INCLUDE

IncludeScript("entitygroups/vmut_vendor_group.nut")
IncludeScript("vmut/vmut_itemdata")
IncludeScript("vmut/vmut_utils")
IncludeScript("vmut/vmut_timers")
IncludeScript("vmut/vmut_currency")
IncludeScript("vmut/vmut_vendor")
IncludeScript("vmut/vmut_spawns")


//------------------------------------------------------------------------------------------------------
//MUTATION SETUP

ModeHUD <- {
	Fields = {
		names = {
			slot = HUD_RIGHT_TOP
			flags = HUD_FLAG_NOBG | HUD_FLAG_TEAM_SURVIVORS | HUD_FLAG_ALIGN_RIGHT 
			datafunc = function() {
	
				local string = ""
			
				for (local i = 0; i < 4; i++) {
					local player = ::VMutUtils.SurvivorSlotToPlayer(i)
					if (player)
						string += player.GetPlayerName()
				
					if (i < 3) string += "\n"
				}
				
				return string
				
			}
		}
		currency = {
			slot = HUD_RIGHT_BOT
			flags = HUD_FLAG_NOBG | HUD_FLAG_TEAM_SURVIVORS 
			datafunc = function() {
				
				local string = ""
				
				for (local i = 0; i < 4; i++) {
					string += "$" + ::VMutCurrency.SurvivorGetCurrency(i)
					if (i < 3) string += "\n"
				}
				
				return string
				
			}
		}
	}
}


function SetupModeHUD() {
	HUDSetLayout(ModeHUD)
	HUDPlace(HUD_RIGHT_TOP, 0.7, 0.025, 0.2, 0.2)
	HUDPlace(HUD_RIGHT_BOT, 0.9, 0.025, 0.1, 0.2)
}


MutationOptions <- {
	
}


MutationState <- {
	vendorTable = {}
	currency = [0,0,0,0]
}


function OnGameplayStart() {
	printl( " ** On Gameplay Start" )
	
	Precache()
	
	::VMutSpawns.SpawnAndDistributeVendors()
	::VMutCurrency.GiveCurrencyToAllSurvivors(10000)
}


function OnActivate() {
	printl( " ** On Activate" )
}


function OnEntityGroupRegistered( name, group ) {
	printl( " ** Ent Group " + name + " registered ")
}


function Precache() {
	::VMutItemData.Precache()
	::VMutVendor.Precache()
}


function ThinkFunc() {
	printl("eat")
}


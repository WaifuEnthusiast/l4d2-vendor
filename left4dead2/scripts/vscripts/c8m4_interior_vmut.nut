//Author: Waifu Enthusiast

printl(" ** Executing map script")


function Precache() {
	printl(" ** Map precache")
}


function OnActivate() {
	printl(" ** Map OnActivate")
	
	//Create a hint for the elevator panic event
	local kvs = {
		targetname			= "vmut_elevator_panic_hint"
		origin 				= Vector(13440, 15008, 464)
		hint_caption 		= "Locked vendors will open after calling the elevator"
		hint_static			= 1
		hint_auto_start 	= true
		hint_icon_onscreen	= "icon_info"
		hint_icon_offscreen	= "icon_info"
		hint_color			= "255 255 255"
		hint_timeout		= 6
	}
	elevatorPanicHint = SpawnEntityFromTable("env_instructor_hint", kvs)
}


//------------------------------------------------------------------------------------------------------
//MAP OPTIONS

minMedkitVendors 	<- defaultMinMedkitVendors 
maxMedkitVendors 	<- defaultMaxMedkitVendors 
vendorWitchLimit 	<- defaultVendorWitchLimit 
mapCurrency			<- defaultMapCurrency		
minCurrencySpawns	<- 40
maxCurrencySpawns	<- 50
startingCurrency	<- defaultStartingCurrency


//------------------------------------------------------------------------------------------------------
//PURGE TABLE

//purgeTable <- defaultPurgeTable


//------------------------------------------------------------------------------------------------------
//VENDOR SPAWN TABLE

local primaryWeaponOnlyBlacklist = [
	//ITEM_ID.SMG,
	//ITEM_ID.SMG_SILENCED,
	//ITEM_ID.SHOTGUN,
	//ITEM_ID.SHOTGUN_CHROME,
	//ITEM_ID.AK47,
	//ITEM_ID.M16,
	//ITEM_ID.DESERT_RIFLE,
	//ITEM_ID.AUTOSHOTGUN,
	//ITEM_ID.SHOTGUN_SPAS,
	//ITEM_ID.HUNTING_RIFLE,
	//ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	//ITEM_ID.MACHINEGUN,
	//ITEM_ID.GRENADE_LAUNCHER,
	ITEM_ID.CHAINSAW,
	ITEM_ID.MOLOTOV,
	ITEM_ID.PIPEBOMB,
	ITEM_ID.BILE_JAR,
	ITEM_ID.PAIN_PILLS,
	ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	ITEM_ID.GAS,
	ITEM_ID.PROPANE,
	ITEM_ID.INCENDIARY_UPGRADE,
	ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

local t2WeaponOnlyBlacklist = [
	ITEM_ID.SMG,
	ITEM_ID.SMG_SILENCED,
	ITEM_ID.SHOTGUN,
	ITEM_ID.SHOTGUN_CHROME,
	//ITEM_ID.AK47,
	//ITEM_ID.M16,
	//ITEM_ID.DESERT_RIFLE,
	//ITEM_ID.AUTOSHOTGUN,
	//ITEM_ID.SHOTGUN_SPAS,
	//ITEM_ID.HUNTING_RIFLE,
	//ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	ITEM_ID.MACHINEGUN,
	ITEM_ID.GRENADE_LAUNCHER,
	ITEM_ID.CHAINSAW,
	ITEM_ID.MOLOTOV,
	ITEM_ID.PIPEBOMB,
	ITEM_ID.BILE_JAR,
	ITEM_ID.PAIN_PILLS,
	ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	ITEM_ID.GAS,
	ITEM_ID.PROPANE,
	ITEM_ID.INCENDIARY_UPGRADE,
	ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

local utilityOnlyBlacklist = [
	ITEM_ID.SMG,
	ITEM_ID.SMG_SILENCED,
	ITEM_ID.SHOTGUN,
	ITEM_ID.SHOTGUN_CHROME,
	ITEM_ID.AK47,
	ITEM_ID.M16,
	ITEM_ID.DESERT_RIFLE,
	ITEM_ID.AUTOSHOTGUN,
	ITEM_ID.SHOTGUN_SPAS,
	ITEM_ID.HUNTING_RIFLE,
	ITEM_ID.SNIPER_RIFLE,  
	ITEM_ID.PISTOL,
	ITEM_ID.MAGNUM,
	ITEM_ID.MELEE,
	//ITEM_ID.MACHINEGUN,
	//ITEM_ID.GRENADE_LAUNCHER,
	//ITEM_ID.CHAINSAW,
	//ITEM_ID.MOLOTOV,
	//ITEM_ID.PIPEBOMB,
	//ITEM_ID.BILE_JAR,
	//ITEM_ID.PAIN_PILLS,
	//ITEM_ID.ADRENALINE,
	ITEM_ID.FIRST_AID_KIT,
	ITEM_ID.DEFIBRILLATOR,
	//ITEM_ID.GAS,
	//ITEM_ID.PROPANE,
	//ITEM_ID.INCENDIARY_UPGRADE,
	//ITEM_ID.EXPLOSIVE_UPGRADE,
	ITEM_ID.LASERSIGHTS_UPGRADE
]

vendorCandidates <- [
	//Saferoom primary weapons
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(12168, 12560, 16)
				angles = QAngle(0,90,0)
				witch  = WITCH_DISABLE
				blacklist = primaryWeaponOnlyBlacklist
			},
			{
				origin = Vector(12168, 12496, 16)
				angles = QAngle(0,90,0)
				witch  = WITCH_DISABLE
				blacklist = primaryWeaponOnlyBlacklist
			}
		]
	},
	
	//Starting ward <- Inital map phase where players stock up on weapons and utility
	{
		min = 3,
		max = 4,
		spawnCandidates = [
			{
				origin = Vector(12112, 11952, 16)
				angles = QAngle(0,180,0)
			},
			{
				origin = Vector(12296, 11952, 16)
				angles = QAngle(0,180,0)
			},
			{
				origin = Vector(11992, 12832, 16)
				angles = QAngle(0,0,0)
			},
			{
				origin = Vector(12880, 13128, 16)
				angles = QAngle(0,270,0)
			}
		]
	},
	
	//Second floor
	{
		min = 2
		max = 2
		spawnCandidates = [
			{
				origin = Vector(12328, 12336, 152)
				angles = QAngle(0,180,0)
			},
			{
				origin = Vector(12672, 12920, 152)
				angles = QAngle(0,270,0)
			}
		]
	}
	
	//Elevator primary weapon
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(13552, 15072, 424)
				angles = QAngle(0,0,0)
				witch  = WITCH_DISABLE
				blacklist = t2WeaponOnlyBlacklist
				flags = VFLAG_PRESERVE_SPAWNDATA
			},
			{
				origin = Vector(13528, 14970, 446)
				angles = QAngle(0,300,0)
				witch  = WITCH_DISABLE
				blacklist = t2WeaponOnlyBlacklist
				flags = VFLAG_PRESERVE_SPAWNDATA | VFLAG_IS_MINI
			}
		]
	}
	
	
	//Elevator Panic <- vendors are set up here to provide utility at many different locations. This is to tempt players into off-meta defensible locations and to also create strategic options if less than 4 survivors remain or if the panic event falls into chaos... The typical meta positions for this panic event are also reinforced with vendors to keep the average playstyle interesting, however, this also opens up the possibility of a witch spawning in meta locations. This should further accentuate the decision making process when choosing a spot to defend.
	//If I ever implement a locking system, all these vendors should only become active during the panic event... This is to stop players from creating piles of pipebombs and molotovs before the event starts. It also increases the strategic significance of each vendor, as they will determine the options that each location can provide DURING the panic event. Players should evaluate the vendors before settling on a location.
	{
		min = 8,
		max = 12,
		spawnCandidates = [
			{	//close to elevator
				origin = Vector(13696, 14848, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{
				origin = Vector(13728, 14464, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{
				origin = Vector(13688, 14312, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//sideroom
				origin = Vector(13248, 14008, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//surgery room
				origin = Vector(12136, 14440, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{
				origin = Vector(12136, 14808, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//dark room
				origin = Vector(12888, 15328, 424)
				angles = QAngle(0,0,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{
				origin = Vector(12616, 15328, 424)
				angles = QAngle(0,0,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//small dark room
				origin = Vector(12288, 15328, 424)
				angles = QAngle(0,0,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//reception rest room <- possibly turn this into its own group with 0-2 spawns.
				origin = Vector(12312, 14280, 424)
				angles = QAngle(0,0,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{
				origin = Vector(11952, 14112, 424)
				angles = QAngle(0,90,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
			{	//imaging room
				origin = Vector(12800, 14456, 424)
				angles = QAngle(0,270,0)
				blacklist = utilityOnlyBlacklist
				tag	= "elevator_panic"
				flags = VFLAG_START_LOCKED
			},
		]
	},
	
	//Top floor primary weapon
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(13304, 14984, 5536)
				angles = QAngle(0,135,0)
				witch  = WITCH_DISABLE
				blacklist = primaryWeaponOnlyBlacklist
			}
		]
	},
	
	//Top floor tank/witch utility
	{
		min = 1,
		max = 1,
		spawnCandidates = [
			{
				origin = Vector(12496, 13656, 5537)
				angles = QAngle(0,90,0)
				witch  = WITCH_DISABLE
				blacklist = [
					ITEM_ID.SMG,
					ITEM_ID.SMG_SILENCED,
					ITEM_ID.SHOTGUN,
					ITEM_ID.SHOTGUN_CHROME,
					ITEM_ID.AK47,
					ITEM_ID.M16,
					ITEM_ID.DESERT_RIFLE,
					ITEM_ID.AUTOSHOTGUN,
					ITEM_ID.SHOTGUN_SPAS,
					ITEM_ID.HUNTING_RIFLE,
					ITEM_ID.SNIPER_RIFLE,  
					ITEM_ID.PISTOL,
					ITEM_ID.MAGNUM,
					ITEM_ID.MELEE,
					ITEM_ID.MACHINEGUN,
					ITEM_ID.GRENADE_LAUNCHER,
					ITEM_ID.CHAINSAW,
					//ITEM_ID.MOLOTOV,
					ITEM_ID.PIPEBOMB,
					//ITEM_ID.BILE_JAR,
					//ITEM_ID.PAIN_PILLS,
					//ITEM_ID.ADRENALINE,
					ITEM_ID.FIRST_AID_KIT,
					ITEM_ID.DEFIBRILLATOR,
					//ITEM_ID.GAS,
					ITEM_ID.PROPANE,
					//ITEM_ID.INCENDIARY_UPGRADE,
					//ITEM_ID.EXPLOSIVE_UPGRADE,
					ITEM_ID.LASERSIGHTS_UPGRADE
				]
			}
		]
	},
	
	//Top floor supply
	{
		min = 2,
		max = 2,
		spawnCandidates = [
			{
				origin = Vector(14008, 14792, 5537)
				angles = QAngle(0,270,0)
				witch  = WITCH_DISABLE
			},
			{
				origin = Vector(14008, 14728, 5537)
				angles = QAngle(0,270,0)
				witch  = WITCH_DISABLE
			}
		]
	},
	
	//Top floor <- Either a "supply stop" then vendor drought, or sprinkles of vendors throughout. Create either a preparation based experience or an "advance and improvise" based experience (or both) 
	{
		min = 0,
		max = 0,
		spawnCandidates = []
	}
		
]


//------------------------------------------------------------------------------------------------------
//CURRENCY ITEM SPAWN TABLE

currencyItemCandidates <- []


//------------------------------------------------------------------------------------------------------
//ZONE TABLE

protectedZones <- [
	//Starting safehouse (2 zones because of complex shape)
	{
		origin 		= Vector(12272, 12176, 16)
		extent 		= Vector(168, 272, 128)
		flags  		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
	{
		origin 		= Vector(12272, 12448, 16)
		extent 		= Vector(208, 224, 128)
		flags  		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
	
	//Ending Safehouse
	{
		origin 		= Vector(11280, 14784, 5536)
		extent 		= Vector(424, 320, 192)
		flags 		= ZONE_FLAG_NO_CURRENCY
		protected	= [
			"weapon_first_aid_kit_spawn",
			"weapon_ammo_spawn"
		]
	}
	
	//Patient bed near elevator
	{
	
		origin 		= Vector(13488, 14888, 424)
		extent 		= Vector(104, 128, 80)
		flags  		= ZONE_FLAG_NO_CURRENCY
		protected	= []
	}
]


//------------------------------------------------------------------------------------------------------
//INITIALIZE ROUND

purgeSystem.Purge()


//------------------------------------------------------------------------------------------------------
//MAP EVENTS AND SCRIPTED BEHAVIOURS

eventElevatorPanic <- false
elevatorPanicHint <- null

local elevatorButton = Entities.FindByClassnameNearest("func_button", Vector(13491 15102 477.5), 1)
if (elevatorButton && elevatorButton.IsValid()) {

	//Get scope
	elevatorButton.ValidateScriptScope()
	local scope = elevatorButton.GetScriptScope()
	
	//Setup functionality
	scope.VMutUnlockPanicVendors <- function() {
		//Unlock vendors
		local panicVendors = ::VMutVendor.FindVendorsByTag("elevator_panic")
		foreach (vendorData in panicVendors) {
			::VMutVendor.VendorUnlock(vendorData)
		}
		//Set map event
		g_MapScript.eventElevatorPanic = true
	}
	elevatorButton.ConnectOutput("OnPressed", "VMutUnlockPanicVendors")
	
	printl(" ** Initialized elevator event")
}
else {
	printl(" ** Failed to initialize elevator event")
}


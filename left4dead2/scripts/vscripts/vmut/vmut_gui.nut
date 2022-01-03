//Author: Waifu Enthusiast

::VMutGUI <- {}

const DIGIT_DISPLAY_MAX_SPRITES 		= 4
const DIGIT_DISPLAY_TEXTURE_SIZE		= 32
const DIGIT_DISPLAY_SCALE				= 0.2 //0.2 is the smallest a sprite can be


//@TODO May eventually just create a big sprite table that associates ASCII character indices with sprite directories...
::VMutGUI.digitModels <- [
	"sprites/digits/digit0.vmt",
	"sprites/digits/digit1.vmt",
	"sprites/digits/digit2.vmt",
	"sprites/digits/digit3.vmt",
	"sprites/digits/digit4.vmt",
	"sprites/digits/digit5.vmt",
	"sprites/digits/digit6.vmt",
	"sprites/digits/digit7.vmt",
	"sprites/digits/digit8.vmt",
	"sprites/digits/digit9.vmt"
]


function VMutGUI::Precache() {
	//Sprites
	PrecacheModel("sprites/digits/lock.vmt")

	//Digit models
	foreach (model in ::VMutGUI.digitModels)
		PrecacheModel(model)
}


//------------------------------------------------------------------------------------------------------
//VENDOR GUI

/*
 *	Spawn and initialize a sprite entity
 */
function VMutGUI::SpawnSpriteEntity(rootEntity, offset, angles, modelName = "error.mdl") {
		local kvs = {
			targetname 	= "GUI_sprite_" + UniqueString()
			parentname	= rootEntity.GetName()
			scale		= 0.2
			origin 		= rootEntity.GetOrigin() + offset
			model 		= modelName
			rendermode	= 1
			spawnflags	= 1
		}
		
		local ent = SpawnEntityFromTable("env_sprite", kvs)
		
		ent.SetAngles(angles)
		EntFire(ent.GetName(), "ShowSprite")
		
		return ent
}


//------------------------------------------------------------------------------------------------------
//GUI SPRITE FUNCTIONALITY

/*
 *	Create a wrapper table for sprite entities
 */
function VMutGUI::CreateSprite(rootEntity, hoffset, voffset, modelName = "error.mdl") {
	//Create the sprite entity
	local angles = rootEntity.GetAngles()
	angles = QAngle(-angles.z, angles.y+90, angles.x) //shrug
	local offsetVector = angles.Left().Scale(hoffset) + angles.Up().Scale(voffset)
	
	local ent = ::VMutGUI.SpawnSpriteEntity(rootEntity, offsetVector, angles, modelName)
	
	
	//Create the sprite abstraction
	local spriteTable = {
		root 	= rootEntity
		visible	= true
		ent		= ent
	}
	
	
	//Return a reference to the sprite abstraction
	return spriteTable
}


/*
 *	Destroy a sprite wrapper table and its associated sprite entity
 */
function VMutGUI::DestroySprite(spriteTable) {
	if (spriteTable.ent)
		spriteTable.ent.Kill()
}


/*
 *	Show the sprite entity assocaited with the specified sprite wrapper table
 */
function VMutGUI::ShowSprite(spriteTable) {
	if (spriteTable.visible == true)
		return
	spriteTable.visible = true
	
	if (!spriteTable.ent)
		return
	EntFire(spriteTable.ent.GetName(), "ShowSprite")
	
	printl(" <> Showing sprite: " + spriteTable.ent.GetName())
}


/*
 *	Hide the sprite entity assocaited with the specified sprite wrapper table
 */
function VMutGUI::HideSprite(spriteTable) {
	if (spriteTable.visible == false)
		return
	spriteTable.visible = false
	
	if (!spriteTable.ent)
		return
	EntFire(spriteTable.ent.GetName(), "HideSprite")
	
	printl(" <> Hiding sprite: " + spriteTable.ent.GetName())
}


/*
 *	Set the model of the sprite entity assocaited with the specified wrapper table
 */
function VMutGUI::SetSpriteModel(spriteTable, modelName) {
	if (!spriteTable.ent)
		return
		
	spriteTable.ent.SetModel(modelName)
}


//------------------------------------------------------------------------------------------------------
//DIGIT DISPLAY FUNCTIONALITY

/*
 *	Create a digit display table and initialize its associated sprite entities
 */
function VMutGUI::CreateDigitDisplay(rootEntity) {
	local digitDisplayTable = {
		id				= "digit_display_" + UniqueString()
		root			= rootEntity
		sprites			= []
	}
	::VMutGUI.DigitDisplayInitializeSprites(digitDisplayTable, DIGIT_DISPLAY_MAX_SPRITES)
	
	return digitDisplayTable
}


/*
 *	Destroy a digit dispaly table and cleanup any associates sprite entities
 */
function VMutGUI::DestroyDigitDisplay(digitDisplayTable) {
	//Cleanup sprite entities
	::VMutGUI.DigitDisplayDestroySprites(digitDisplayTable)
	
	//Kill the table
	//delete digitDisplayTable
}


/*
 *	Creates the sprites that show an item's cost.
 *	count = The maximum number of digits that the display can show.
 */
function VMutGUI::DigitDisplayInitializeSprites(digitDisplayTable, count) {

	//Don't create duplicate sprites
	::VMutGUI.DigitDisplayDestroySprites(digitDisplayTable)
	
	//Get the root entity which will be used for the transform initialization
	local root = digitDisplayTable.root
	
	//Create and initialize the sprite entities
	for (local i = 0; i < count; i++) {
	
		local angle = root.GetAngles()
		angle = QAngle(-angle.z, angle.y+90, angle.x) //shrug
		local offsetScalar = i * DIGIT_DISPLAY_TEXTURE_SIZE * DIGIT_DISPLAY_SCALE
		local offsetVector = angle.Left().Scale(offsetScalar)
		//local targetname = digitDisplayTable.id + "_sprite_" + i
		
		local ent = ::VMutGUI.SpawnSpriteEntity(digitDisplayTable.root, offsetVector, angle, ::VMutGUI.digitModels[0])
		digitDisplayTable.sprites.append(ent)
	}
	
}


/*
 *	Cleanup all of the sprites in a gui digit-display
 */
function VMutGUI::DigitDisplayDestroySprites(digitDisplayTable) {
	//Destroy sprite entities inside the digit display
	foreach (ent in digitDisplayTable.sprites) {
		ent.Kill()
	}
	digitDisplayTable.sprites.clear()
}


/*
 *	Update sprites to display a new value
 */
function VMutGUI::DigitDisplayUpdateValue(digitDisplayTable, newValueString) {

	//@TODO
	//Shifting focus to string processing. This is to help future-proof the gui module in case of reusing it to display full text.
	//May eventually just create a big sprite table that associates ASCII character indices with sprite directories...
	
	for (local i = 0; i < digitDisplayTable.sprites.len(); i++) {
		local sprite = digitDisplayTable.sprites[i]
	
		//Determine whether this sprite should be visible
		if (i >= newValueString.len()) {
			EntFire(sprite.GetName(), "HideSprite")
			continue
		}
		EntFire(sprite.GetName(), "ShowSprite")
		
		//Determine which digit should be displayed on this sprite
		local digitIndex = 0
		try
			digitIndex = newValueString.slice(i, i+1).tointeger()
		catch (e)
			digitIndex = 0
			
		//Update the sprite to display the correct digit
		sprite.SetModel(::VMutGUI.digitModels[digitIndex])
	}
	
}


/*
 *	Set color of all sprites in a vendor's price-display
 */
function VMutGUI::DigitDisplaySetColor(digitDisplayTable, color) {
	foreach (sprite in digitDisplayTable.sprites) {
		EntFire(sprite.GetName(), "ColorRedValue",		color.r.tostring())
		EntFire(sprite.GetName(), "ColorGreenValue",	color.g.tostring())
		EntFire(sprite.GetName(), "ColorBlueValue", 	color.b.tostring())
	}
}


/*
 * THE BIG CLASS BASED APPROACH THAT I PROBABLY WON'T USE XDDDD
 * 
 *	if gui requirements become more complex, then i may move to a more strictly systemized approach that uses a node structure to organize gui elements on a 3d panel...
 *
class VMutGUI::GUINode {
	children <- null
	rootEntity <- null
	localPos <- Vector(0,0,0)
	
	constructor(root) {
		rootEntity = root
		children = []
		//calculate local pos...
		//bleh
	}
	
	function GetWidth() 	{ return 0 }
	function GetHeight() 	{ return 0 }
	
	function GetLocalPos() {
		return localPos
	}
	function SetLocalPos(newLocalPos) {
		localPos = newLocalPos
		//calculate new world pos from local pos
		//bleh
	}
	
	function SetRoot(root) {
		rootEntity = root
	}
	
	function AddChildNode(node) {
		if (!(node in children)) {
			children.append(node)
			node.SetRoot(rootEntity)
		} else {
			throw "Attempted to add a GUI child node that is already parented to this node!"
		}
	}
	
	function Reposition(localPosition) {
		//blah blah blah
		//Called when moving a gui element to a new local position. Mostly used when adding or deleting child elements that force parent elements to reorganize their layout.
	}
}


class VMutGUI::GUILayout extends VMutGUI::GUINode {
	padding <- 0
	spacing <- 0
	
	constructor(pad, space) {
		base()
		padding = pad
		spacing = space
	}
}


class VMutGUI::GUILayoutRow extends VMutGUI::GUILayout {

	constructor(pad, space) {
		base(pad, space)
	}
	
	//Return the collective width of all children
	function GetWidth() {
		local width = 0
		foreach (node in children) {
			width += node.GetWidth()
		}
		return width + padding*2.0
	}
	
	//Return the height of whichever child node has the largest height
	function GetHeight() {
		local height = 0
		foreach (node in children) {
			if height < node.GetHeight()
				height = node.GetHeight()
		}
		return height + padding*2.0
	}
}


class VMutGUI::GUILayoutColumn extends VMutGUI::GUILayout {

	constructor(pad, space) {
		base(pad, space)
	}
	
	//Return the width of whichever child node has the largest width
	function GetWidth() {
		local width = 0
		foreach (node in children) {
			if width < node.GetWidth()
				width = node.GetWidth()
		}
		return width + padding*2.0
	}

	//Return the collective height of all children
	function GetHeight() {
		local height = 0
		foreach (node in children) {
			height += node.GetHeight()
		}
		return height + padding*2.0
	}
	
}


class VMutGUI::GUIDigitString extends VMutGUI::GUILayoutRow {
	constructor() {
		base(0,0)
	}
	
	
	function UpdateValue(digitString) {
		//destroy sprites and recreate them in layout...
		//...
	}
}


class VMutGUI::GUISprite extends VMutGUI::GUINode {
	constructor() {
		base()
	}
}
*/
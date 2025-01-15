Locales['en'] = {

    ['MENU__PROCESSING'] = 'Proccessing',
    ['MENU__RECIPE__DESC'] = 'Process your drugs with this recipe',

    ['MENU__UNKNOWN__INGREDIANT'] = 'Unknown Ingrediant',
    ['MENU__INGREDIANT__DESC'] = 'You need %g of this ingrediant',

    ['MENU__TABLE__PROCESS'] = 'Process Drugs',
    ['MENU__TABLE__PROCESS__DESC'] = 'Start processing drugs',

    ['MENU__TABLE__REMOVE'] = 'Remove Table',
    ['MENU__TABLE__REMOVE__DESC'] = 'Get this table back',

    ['MENU__ADMIN__TABLE__MAIN'] = 'Table Management',
    
    ['MENU__TABLE__COUNT'] = 'Total Table Count',
    ['MENU__TABLE__COUNT__DESC'] = 'There are currently %g active tables',


    ['MENU__LIST__TABLES'] = 'View tables by Distance',
    ['MENU__LIST__TABLES__DESC'] = 'View detail infomration about each table',

    ['MENU__ADD__BLIPS'] = 'Add Blips to Map',
    ['MENU__ADD__PLANT__BLIPS__DESC'] = 'Show all plant locations on the map',
    ['MENU__ADD_TABLE__BLIPS__DESC'] = 'Show all table locations on the map',

    ['MENU__REMOVE__BLIPS'] = 'Remove Blips from Map',
    ['MENU__REMOVE__PLANT__BLIPS__DESC'] = 'Remove all plant locations from the map',
    ['MENU__REMOVE__TABLE__BLIPS__DESC'] = 'Remove all table locations from the map',

    ['MENU__TABLE__LIST'] = 'All Tables',

    ['MENU__DIST'] = 'Distance: %gm',

    ['MENU__TABLE__ID'] = 'Table: %s',

    ['MENU__OWNER'] = 'Owner',
    ['MENU__OWNER__META'] = 'Click to copy owner identifiere',

    ['MENU__PLANT__LOCATION'] = 'Location',
    ['MENU__LOCATION__DESC'] = 'Street: %s | Coordinates: (%g, %g, %g)',
    ['MENU__LOCATION__META'] = 'Click top copy coords',

    ['MENU__PLANT__TELEPORT'] = 'Teleport to Plant',
    ['MENU__PLANT__TELEPORT__DESC'] = 'Teleport to the plant location',

    ['MENU__TABLE__TELEPORT'] = 'Teleport to Table',
    ['MENU__TABLE__TELEPORT__DESC'] = 'Teleport to the table location',

    ['MENU__ADD__BLIP'] = 'Add to Map',
    ['MENU__ADD__TABLE__BLIP__DESC'] = 'Create a blip for this table',

    ['MENU__TABLE__DESTROY'] = 'Destroy Table',
    ['MENU__TABLE__DESTROY__DESC'] = 'Destroy this table',

    ['NOTIFICATION__IN__VEHICLE'] = 'You can´t do this in a Vehicle',
    ['NOTIFICATION__CANT__PLACE'] = 'You can´t do this here',
    ['NOTIFICATION__TO__NEAR'] = 'You can´t plant this near to another plant',
    ['NOTIFICATION__CANCELED'] = 'Canceled...',
    ['NOTIFICATION__NO__ITEMS'] = 'You have no items to take care of this plant',

    ['NOTIFICATION__NO__AMOUNT'] = 'You need to enter an amount',

    ['NOTIFICATION__MISSING__INGIDIANT'] = 'You don´t have all ingredients',
    ['NOTIFICATION__SKILL__SUCCESS'] = 'You have processed on drug',
    ['NOTIFICATION__SKILL__ERROR'] = 'You pressed the wrong key',
    ['NOTIFICATION__PROCESS__FAIL'] = 'You faild to process the drug',


    ['NOTIFICATION__MAX__PLANTS'] = 'Please take care of your current plants first',
   
    ['NOTIFICATION__NO__PERMISSION'] = 'You do not have permission to do this',
    ['NOTIFICATION__ADMINMENU__USAGE'] = 'Please use: /%s [plants/tables]',

    ['NOTIFICATION__COPY__CLIPBOARD'] = 'Information copied to clipboard: %s',
    
    ['NOTIFICATION__TELEPORTED'] = 'Teleported to entity location',

    ['NOTIFICATION__PLANT__DESTROYED'] = 'Plant got successfuly destroyed',
    ['NOTIFICATION__TABLE__DESTROYED'] = 'Table got successfuly destroyed',

    ['NOTIFICATION__ADD__BLIP'] = 'Added Blip to Map',
    ['NOTIFICATION__REMOVE__BLIP'] = 'Removed Blip from Map',

    ['NOTIFICATION__NEED_LIGHTER'] = 'You need a lighter to destroy the plant',

    ['PROGRESSBAR__PLACE__TABLE'] = 'Placing Table...',
    ['PROGRESSBAR__REMOVE__TABLE'] = 'Removing Table...',
    ['PROGRESSBAR__PROCESS__DRUG'] = 'Processing...',

    ['INTERACTION__PLACING_TABLE__TEXT'] = '[E] - Place Table / [G] - Cancel',
	
    ['INTERACTION__INTERACT_TEXT'] = '[E] - Interact',

    ['INPUT__AMOUNT__HEADER'] = 'Processing',
    ['INPUT__AMOUNT__TEXT'] = 'Amount',
    ['INPUT__AMOUNT__DESCRIPTION'] = 'How many do you want to process?',

    ['TARGET__TABLE__LABEL'] = 'Use Table',

    ['COMMAND__ADMINMENU'] = 'drugadmin',
}

function _U(string)
	if Locales[Config.Language] == nil then
		return "Language not found"
	end
	if Locales[Config.Language][string] == nil then
		return string
	end
	return Locales[Config.Language][string]
end

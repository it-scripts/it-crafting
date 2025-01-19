Locales['en'] = {
    -- Notifications
    ['NOTIFICATION_CANCELED'] = 'Action Canceled',

    -- cl_crafting.lua
    ['NOTIFICATION__TO__CLOSE'] = 'You are to close to a other crafting station',
    ['NOTIFICATION__MAX__TABLES'] = 'First destory a crafting station befor placing this one',

    ['NOTIFICATION__NOT__ALLOWED__ZONE'] = 'You can\'t place this crafting station here',

    ['NOTIFICATION__IN__VEHICLE'] = 'Please leave your vehicle',
    
    ['NOTIFICATION__NO__AMOUNT'] = 'You hva to input a valid amount',
    
    ['NOTIFICATION__MISSING__INGIDIANT'] = 'You are missing some ingrediants to craft this item',
    
    ['NOTIFICATION__TABLE__IN__USE'] = 'This table is allready in use',

    ['NOTIFICATION__SKILL__SUCCESS'] = 'You have successfully crafted an item',
    ['NOTIFICATION__SKILL__ERROR'] = 'You faild crafting an item',

    ['NOTIFICATION__CANT__CARRY'] = 'You can\'t carry this',

    -- cl_target.lua
    ['NOTIFICATION__NOT__ALLOWED'] = 'You are not allowed to use this table',

    -- cl_admin.lua
    ['NOTIFICATION__COPY__CLIPBOARD'] = 'Copied %s to your clipboard',

    -- cl_blips.lua
    ['NOTIFICATION__BLIPS__ADDED'] = 'Added all blips to map',
    ['NOTIFICATION__BLIPS__REMOVED'] = 'Removed all blips from map',
    
    ['NOTIFICATION__BLIP__ADDED'] = 'Blip added',
    ['NOTIFICATION__BLIP__NOT_FOUND'] = 'Blip not found',
    ['NOTIFICATION__BLIP__REMOVED'] = 'Blip removed',
    ['NOTIFICATION__BLIP__EXISTS'] = 'This blip allready exists',

    -- sv_crafting
    ['NOTIFICATION__CRAFT__FAIL'] = 'You failed crafting an item',

    -- Menus
    -- cl_menus.lua
    ['MENU__RECIPE__DESC'] = 'Craft your items with this recipe',
    ['MENU__CRAFTING__TITLE'] = 'Crafting',

    ['MENU__UNKNOWN__INGREDIANT'] = 'Unknown Ingrediant',
    ['MENU__INGREDIANT__DESC'] = 'You need %g of this ingrediant',

    ['MENU__TABLE__CRAFT__TITLE'] = 'Craft items',
    ['MENU__TABLE__CRAFT__DESC'] = 'Start crafting items',

    ['MENU__ADMIN__TABLE__MAIN'] = 'Admin Panel',

    ['MENU__TABLE__COUNT__TITLE'] = 'Total Crafting Stations',
    ['MENU__TABLE__COUNT__DESC'] = 'There are currently %g crafting stations',

    ['MENU__LIST__TABLES__TITLE'] = 'View Tables',
    ['MENU__LIST__TABLES__DESC'] = 'View a list of all tables',

    ['MENU__ADD__BLIPS__TITLE'] = 'Add Blips',
    ['MENU__ADD_TABLE__BLIPS__DESC'] = 'Add all crafting stations to your the map',

    ['MENU__REMOVE__BLIPS__TITLE'] = 'Remove Blips',
    ['MENU__REMOVE__TABLE__BLIPS__DESC'] = 'Remove all crafting stations from your map',

    ['MENU__DIST'] = 'Distance: %gm',

    ['MENU__TABLE__ID'] = 'Table: %s',

    ['MENU__OWNER'] = 'Owner',
    ['MENU__OWNER__META'] = 'Click to copy owner identifiere',

    ['MENU__TABLE__LOCATION'] = 'Location',
    ['MENU__LOCATION__DESC'] = 'Street: %s | Coordinates: (%g, %g, %g)',
    ['MENU__LOCATION__META'] = 'Click top copy coords',

    ['MENU__TABLE__TELEPORT'] = 'Teleport to Table',
    ['MENU__TABLE__TELEPORT__DESC'] = 'Teleport to the table location',

    ['MENU__ADD__BLIP'] = 'Add to Map',
    ['MENU__ADD__TABLE__BLIP__DESC'] = 'Create a blip for this table',

    ['MENU__TABLE__DESTROY'] = 'Destroy Table',
    ['MENU__TABLE__DESTROY__DESC'] = 'Destroy this table',

    -- Target
    -- cl_target.lua
    ['TARGET__TABLE__LABEL'] = 'Start crafting',
    ['TARGET__TABLE__REMOVE'] = 'Remove Crafting Station',

    -- Progressbar
    -- cl_crafting.lua
    ['PROGRESSBAR__PLACE__TABLE'] = 'Placing Crafting Station...',
    ['PROGRESSBAR__CRAFT__ITEM'] = 'Crafting...',
    ['PROGRESSBAR__REMOVE__TABLE'] = 'Removing Crafting Station...',
    -- Input
    -- cl_crafting.lua
    ['INPUT__AMOUNT__HEADER'] = 'Crafting',
    ['INPUT__AMOUNT__TEXT'] = 'Amount',
    ['INPUT__AMOUNT__DESCRIPTION'] = 'How many do you want to craft?',

    -- Alert
    -- cl_admin
    ['ALERT__ADMIN__HEADER'] = 'NO PERMISSION',
    ['ALERT__ADMIN__CONTENT'] = 'Add this your server.cfg file to give permission to this user:  \n add_ace identifier.%s it-crafting allow #%s License  \n And restart your server to apply the changes',
    
    ['ALTER__ADMIN__COPY'] = 'Copy',
    ['ALTER__ADMIN__CANCEL'] = 'Cancel',

    -- Interaction
    -- cl_crafting.lua
    ['INTERACTION__PLACING_TABLE__TEXT'] = "[E] - Place Table | [G] - Cancle",

    -- Command
    -- sv_admin.lua
    ['COMMAND__ADMINMENU'] = 'craft-admin',
    ['COMMAND__ADMINMENU__USAGE'] = 'Open the craftig admin menu'
}
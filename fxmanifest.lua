fx_version 'cerulean'
game 'gta5'

author '@allroundjonu'
description 'Simple Crafting System for FiveM'
version 'v1.0.0'

identifier 'it-crafting'

shared_script {
    '@ox_lib/init.lua'
}

shared_scripts {
    'shared/config.lua',
    'bridge/init.lua',
    'shared/functions.lua',
    'locales/en.lua',
    'locales/*.lua',
    'bridge/**/shared.lua',
    '@es_extended/imports.lua',
}

client_scripts {

    'bridge/**/client.lua',

    -- 'client/cl_notarget.lua',

    'client/cl_menus.lua',
    'client/cl_crafting.lua',
    'client/cl_target.lua',
    'client/cl_blips.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'bridge/**/server.lua',
    'bridge/**/server/*.lua',
    
    'server/classes/*.lua',

    'server/sv_crafting.lua',
    'server/sv_usableitems.lua',
    'server/sv_webhooks.lua',
    'server/sv_setupdatabase.lua'
}

dependencies {
    'ox_lib',
    'oxmysql'
}

lua54 'yes'

fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author '@allroundjonu'
description 'Simple Crafting System for FiveM'
version 'v1.1.0'

identifier 'it-crafting'

shared_script {
    '@ox_lib/init.lua'
}

shared_scripts {
    'shared/config.lua',
    'shared/functions.lua',
    'locales/en.lua',
    'locales/*.lua',
}

client_scripts {
    'client/cl_menus.lua',
    'client/cl_crafting.lua',
    'client/cl_target.lua',
    'client/cl_blips.lua',
    'client/cl_notarget.lua',
    'client/cl_admin.lua',
    'client/cl_ui.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',

    'server/classes/*.lua',

    'server/sv_setupdatabase.lua',
    'server/sv_callbacks.lua',
    'server/sv_crafting.lua',
    'server/sv_usableitems.lua',
    'server/sv_webhooks.lua',
    'server/sv_admin.lua',
    'server/sv_versioncheck.lua',
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/static/font/*.ttf',
    'web/static/css/*.css',
    'web/static/js/messages.js',
    'web/static/js/crafting.js',
    'web/static/js/minigame.js'
}

dependencies {
    '/onesync',
    'ox_lib',
    'oxmysql',
    'it_bridge',
}
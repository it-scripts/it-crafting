Config = Config or {}
Locales = Locales or {}

-- ┌───────────────────────────────────┐
-- │  ____                           _ │
-- │ / ___| ___ _ __   ___ _ __ __ _| |│
-- │| |  _ / _ \ '_ \ / _ \ '__/ _` | |│
-- │| |_| |  __/ | | |  __/ | | (_| | |│
-- │ \____|\___|_| |_|\___|_|  \__,_|_|│
-- └───────────────────────────────────┘

--[[
    Overwelmed by the amount of settings? Don't worry, we got you covered.
    Here is a quick guide to get you started with the configuration of the script.
    https://docs.it-scripts.com/scripts/it-crafting/installation
]]

--[[
    The first thing to do is to set which framework, inventory and target system the server uses
    The system will automatically detect the framework, inventory and target system if you set it to 'autodetect'
    If you are using a custom framework, inventory or target system contact the developer or add support yourself by creating a pull request
    If you need need more information about this configuration, you can read the documentation here: https://docs.it-scripts.com/scripts/it-crafting
]]

Config.Framework = 'autodetect' -- Choose your framework ('qb-core', 'es_extended', 'ND_Core' 'autodetect')
Config.Inventory = 'autodetect' -- Choose your inventory ('ox_inventory', 'qb-inventory', 'es_extended', 'origen_inventory', 'codem-inventory', 'autodetect')
Config.Target = 'autodetect' -- false -- Target system ('qb-target', 'ox_target' or false to disable)

--[[
    Here you can set the language for the script, you can choose between 'en', 'es', 'de'
    If you want to add more languages, you can do this in the server/locales folder. 
    Feel free to share them with us so we can add them to the script for everyone to use.
]]

Config.Language = 'en' -- Choose your language from the locales folder

--[[
    Here you can set some generale settings regarding to the some features of the script.
    You can set the distance for the raycasting, the time a fire will burn and if the script should clear dead plants on start-up.
    You can also set the player plant limit, this is the maximum amount of plants a player can have simultaneously.
]]
Config.rayCastingDistance = 7.0 -- distance in meters
-- TODO: IMPLEMENT THE WEIGHT CHECKS!
Config.UseWeightSystem = false -- Set to true to use the weight system
Config.PlayerTableLimit = 3 -- Maximum amount of tables a player can have
Config.MinDistanceToTable = 3.0 -- Minimum distance to a table to interact with it

-- ┌───────────────────────────┐
-- │ _____                     │
-- │|__  /___  _ __   ___  ___ │
-- │  / // _ \| '_ \ / _ \/ __|│
-- │ / /| (_) | | | |  __/\__ \│
-- │/____\___/|_| |_|\___||___/│
-- └───────────────────────────┘
-- Determite zones to restrict the use of the crafting tables to specific zones or areas.

Config.Zones = {
    ['cratin_zone_one'] = { -- Zone id (Musst be unique)
        points = {
            vec3(2031.0, 4853.0, 43.0),
            vec3(2007.0, 4877.0, 43.0),
            vec3(1981.0, 4903.0, 43.0),
            vec3(2006.0, 4929.0, 43.0),
            vec3(2032.0, 4903.0, 43.0),
            vec3(2057.0, 4878.0, 43.0),
        },
        thickness = 4.0,
        growMultiplier = 2, -- GlobalGrowTime / growMultiplier = Time in minutes for a plant to grow in this zone
        
        blip = {
            display = true, -- Display blip on map
            sprite = 469, -- Select blip from (https://docs.fivem.net/docs/game-references/blips/)
            displayColor = 2, -- Select blip color from (https://docs.fivem.net/docs/game-references/blips/)
            displayText = 'Crafting Zone',
        },
    },
}

-- ┌────────────────────────────────────────────────────────────────────┐
-- │  ____            __ _   _               ____       _       _       │
-- │ / ___|_ __ __ _ / _| |_(_)_ __   __ _  |  _ \ ___ (_)_ __ | |_ ___ │
-- │| |   | '__/ _` | |_| __| | '_ \ / _` | | |_) / _ \| | '_ \| __/ __|│
-- │| |___| | | (_| |  _| |_| | | | | (_| | |  __/ (_) | | | | | |_\__ \│
-- │ \____|_|  \__,_|_|  \__|_|_| |_|\__, | |_|   \___/|_|_| |_|\__|___/│
-- │                                 |___/                              │
-- └────────────────────────────────────────────────────────────────────┘
Config.CraftingPoints = {
    ['crafting_point_one'] = {
        coords = vector4(210.1188, -932.9069, 29.6918, 58.0372),
        zone = vector3(2.0, 1.0, 2.0),
        label = 'Crafting Point', -- Label for the table
        model = 'v_res_tre_table2', -- Exanples: freeze_it-scripts_empty_table, freeze_it-scripts_weed_table, freeze_it-scripts_coke_table, freeze_it-scripts_meth_table
        restricCrafting = {
            ['onlyOnePlayer'] = true,
            ['onlyOwner'] = false,
            ['zones'] = {},
            ['jobs'] = {}
        },
        blip = {
            display = true, -- Display blip on map
            sprite = 469, -- Select blip from (https://docs.fivem.net/docs/game-references/blips/)
            displayColor = 2, -- Select blip color from (https://docs.fivem.net/docs/game-references/blips/)
            displayText = 'Crafting Point',
        },
        recipes = {
            ['point_joint_lemon_haze'] = {
                label = 'Joint lemon haze',
                ingrediants = {
                    ['weed_lemonhaze'] = {amount = 3, remove = true},
                    ['paper'] = {amount = 1, remove = true}
                },
                outputs = {
                    ['joint'] = 2
                },
                processTime = 15,
                failChance = 15,
                showIngrediants = true,
                animation = {
                    dict = 'anim@amb@drug_processors@coke@female_a@idles',
                    anim = 'idle_a',
                },
                particlefx = {
                    dict = 'scr_ar_planes',
                    particle = 'scr_ar_trail_smoke_slow',
                    color = {r = 255, g = 255, b = 153},
                    offset = {x = 0.0, y = -1.5, z = 1.0},
                    scale = 0.5,
                },
                skillCheck = {
                    enabled = true,
                    difficulty = {'easy', 'easy', 'medium', 'easy'},
                    keys = {'w', 'a', 's', 'd'}
                }
            },
        }
    },
}

-- ┌─────────────────────────────────────────────────────────────────────┐
-- │  ____            __ _   _               _____     _     _           │
-- │ / ___|_ __ __ _ / _| |_(_)_ __   __ _  |_   _|_ _| |__ | | ___  ___ │
-- │| |   | '__/ _` | |_| __| | '_ \ / _` |   | |/ _` | '_ \| |/ _ \/ __|│
-- │| |___| | | (_| |  _| |_| | | | | (_| |   | | (_| | |_) | |  __/\__ \│
-- │ \____|_|  \__,_|_|  \__|_|_| |_|\__, |   |_|\__,_|_.__/|_|\___||___/│
-- │                                 |___/                               │
-- └─────────────────────────────────────────────────────────────────────┘
Config.CraftingTables = { -- Create processing table
    ['simple_crafting_table'] = {
        zone = vector3(2.0, 1.0, 2.0),
        label = 'Weed Processing Table', -- Label for the table
        model = 'v_res_tre_table2', -- Exanples: freeze_it-scripts_empty_table, freeze_it-scripts_weed_table, freeze_it-scripts_coke_table, freeze_it-scripts_meth_table
        restricCrafting = {
            ['onlyOnePlayer'] = true, -- Only one player can use the table at a time
            ['onlyOwner'] = false, -- Only the owner of the table can use it
            ['zones'] = {}, -- Zones where the table can be used
            ['jobs'] = {
                ['police'] = {1, 2, 3, 4, 5}, -- Job name and grade
                ['sheriff'] = true -- Job name (all grades)
            }
        },
        blip = {
            display = true, -- Display blip on map
            sprite = 469, -- Select blip from (https://docs.fivem.net/docs/game-references/blips/)
            displayColor = 2, -- Select blip color from (https://docs.fivem.net/docs/game-references/blips/)
            displayText = 'Weed Zone',
        },
        recipes = {
            ['table_joint_lemon_haze'] = {
                label = 'Joint lemon haze',
                processTime = 15,
                failChance = 15,
                showIngrediants = true,
                ingrediants = {
                    ['weed_lemonhaze'] = {amount = 3, remove = true},
                    ['paper'] = {amount = 1, remove = true}
                },
                outputs = {
                    ['joint'] = 2
                },
                animation = {
                    dict = 'anim@amb@drug_processors@coke@female_a@idles',
                    anim = 'idle_a',
                },
                particlefx = { -- Currently in Beta and not fully working
                    dict = 'scr_ar_planes',
                    particle = 'scr_ar_trail_smoke_slow',
                    color = {r = 255, g = 255, b = 153},
                    offset = {x = 0.0, y = -1.5, z = 1.0},
                    scale = 0.5,
                },
                skillCheck = {
                    enabled = true,
                    difficulty = {'easy', 'easy', 'medium', 'easy'},
                    keys = {'w', 'a', 's', 'd'}
                }
            },
        }
    }
}


--[[
    Debug mode, you can see all kinds of prints/logs using debug,
    but it's only for development.
]]
Config.ManualDatabaseSetup = false -- Set to true to disable the automatic database setup and check

Config.EnableVersionCheck = true -- Enable version check
Config.Branch = 'main' -- Set to 'master' to use the master branch, set to 'development' to use the dev branch
Config.Debug = true -- Set to true to enable debug mode
Config.DebugPoly = true -- Set to true to enable debug mode for PolyZone
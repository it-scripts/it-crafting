Locales['de'] = {
    -- Benachrichtigungen
    ['NOTIFICATION_CANCELED'] = 'Aktion abgebrochen',

    -- cl_crafting.lua
    ['NOTIFICATION__TO__CLOSE'] = 'Du bist zu nah an einer anderen Werkbank',
    ['NOTIFICATION__MAX__TABLES'] = 'Zerstöre zuerst eine Werkbank, bevor du diese platzierst',

    ['NOTIFICATION__NOT__ALLOWED__ZONE'] = 'Du kannst diese Werkbank hier nicht platzieren',

    ['NOTIFICATION__IN__VEHICLE'] = 'Bitte verlasse dein Fahrzeug',

    ['NOTIFICATION__NO__AMOUNT'] = 'Du musst eine gültige Menge eingeben',

    ['NOTIFICATION__MISSING__INGIDIANT'] = 'Dir fehlen einige Zutaten, um diesen Gegenstand herzustellen',

    ['NOTIFICATION__TABLE__IN__USE'] = 'Diese Werkbank wird bereits benutzt',

    ['NOTIFICATION__SKILL__SUCCESS'] = 'Du hast erfolgreich einen Gegenstand hergestellt',
    ['NOTIFICATION__SKILL__ERROR'] = 'Du hast es nicht geschafft, einen Gegenstand herzustellen',

    ['NOTIFICATION__CANT__CARRY'] = 'Du kannst das nicht tragen',

    -- cl_target.lua
    ['NOTIFICATION__NOT__ALLOWED'] = 'Du darfst diese Werkbank nicht benutzen',

    -- cl_admin.lua
    ['NOTIFICATION__COPY__CLIPBOARD'] = '%s in die Zwischenablage kopiert',

    -- cl_blips.lua
    ['NOTIFICATION__BLIPS__ADDED'] = 'Alle Blips zur Karte hinzugefügt',
    ['NOTIFICATION__BLIPS__REMOVED'] = 'Alle Blips von der Karte entfernt',

    ['NOTIFICATION__BLIP__ADDED'] = 'Blip hinzugefügt',
    ['NOTIFICATION__BLIP__NOT_FOUND'] = 'Blip nicht gefunden',
    ['NOTIFICATION__BLIP__REMOVED'] = 'Blip entfernt',
    ['NOTIFICATION__BLIP__EXISTS'] = 'Dieser Blip existiert bereits',

    -- sv_crafting
    ['NOTIFICATION__CRAFT__FAIL'] = 'Du hast es nicht geschafft, einen Gegenstand herzustellen',

    -- Menüs
    -- cl_menus.lua
    ['MENU__RECIPE__DESC'] = 'Stelle deine Gegenstände mit diesem Rezept her',
    ['MENU__CRAFTING__TITLE'] = 'Herstellung',

    ['MENU__UNKNOWN__INGREDIANT'] = 'Unbekannte Zutat',
    ['MENU__INGREDIANT__DESC'] = 'Du benötigst %g von dieser Zutat',

    ['MENU__TABLE__CRAFT__TITLE'] = 'Gegenstände herstellen',
    ['MENU__TABLE__CRAFT__DESC'] = 'Beginne mit der Herstellung von Gegenständen',

    ['MENU__ADMIN__TABLE__MAIN'] = 'Admin-Panel',

    ['MENU__TABLE__COUNT__TITLE'] = 'Gesamtzahl der Werkbänke',
    ['MENU__TABLE__COUNT__DESC'] = 'Es gibt derzeit %g Werkbänke',

    ['MENU__LIST__TABLES__TITLE'] = 'Werkbänke anzeigen',
    ['MENU__LIST__TABLES__DESC'] = 'Eine Liste aller Werkbänke anzeigen',

    ['MENU__ADD__BLIPS__TITLE'] = 'Blips hinzufügen',
    ['MENU__ADD_TABLE__BLIPS__DESC'] = 'Füge alle Werkbänke zu deiner Karte hinzu',

    ['MENU__REMOVE__BLIPS__TITLE'] = 'Blips entfernen',
    ['MENU__REMOVE__TABLE__BLIPS__DESC'] = 'Entferne alle Werkbänke von deiner Karte',

    ['MENU__DIST'] = 'Entfernung: %gm',

    ['MENU__TABLE__ID'] = 'Werkbank: %s',

    ['MENU__OWNER'] = 'Besitzer',
    ['MENU__OWNER__META'] = 'Klicken, um die Besitzer-ID zu kopieren',

    ['MENU__TABLE__LOCATION'] = 'Standort',
    ['MENU__LOCATION__DESC'] = 'Straße: %s | Koordinaten: (%g, %g, %g)',
    ['MENU__LOCATION__META'] = 'Klicken, um die Koordinaten zu kopieren',

    ['MENU__TABLE__TELEPORT'] = 'Zu Werkbank teleportieren',
    ['MENU__TABLE__TELEPORT__DESC'] = 'Zum Standort der Werkbank teleportieren',

    ['MENU__ADD__BLIP'] = 'Zur Karte hinzufügen',
    ['MENU__ADD__TABLE__BLIP__DESC'] = 'Einen Blip für diese Werkbank erstellen',

    ['MENU__TABLE__DESTROY'] = 'Werkbank zerstören',
    ['MENU__TABLE__DESTROY__DESC'] = 'Diese Werkbank zerstören',

    -- Target
    -- cl_target.lua
    ['TARGET__TABLE__LABEL'] = 'Herstellung starten',
    ['TARGET__TABLE__REMOVE'] = 'Werkbank entfernen',

    -- Progressbar
    -- cl_crafting.lua
    ['PROGRESSBAR__PLACE__TABLE'] = 'Werkbank wird platziert...',
    ['PROGRESSBAR__CRAFT__ITEM'] = 'Herstellung...',
    ['PROGRESSBAR__REMOVE__TABLE'] = 'Werkbank wird entfernt...',

    -- Input
    -- cl_crafting.lua
    ['INPUT__AMOUNT__HEADER'] = 'Herstellung',
    ['INPUT__AMOUNT__TEXT'] = 'Menge',
    ['INPUT__AMOUNT__DESCRIPTION'] = 'Wie viele möchtest du herstellen?',

    -- Alert
    -- cl_admin
    ['ALERT__ADMIN__HEADER'] = 'KEINE BERECHTIGUNG',
    ['ALERT__ADMIN__CONTENT'] = 'Füge dies deiner server.cfg-Datei hinzu, um diesem Benutzer die Berechtigung zu erteilen:\nadd_ace identifier.%s it-crafting allow #%s Lizenz\nUnd starte deinen Server neu, um die Änderungen zu übernehmen',

    ['ALTER__ADMIN__COPY'] = 'Kopieren',
    ['ALTER__ADMIN__CANCEL'] = 'Abbrechen',

    -- Interaction
    -- cl_crafting.lua
    ['INTERACTION__PLACING_TABLE__TEXT'] = "[E] - Place Table | [G] - Cancle",

    -- Command
    -- sv_admin.lua
    ['COMMAND__ADMINMENU'] = 'craft-admin',
    ['COMMAND__ADMINMENU__USAGE'] = 'Das Crafting-Admin-Menü öffnen'
}
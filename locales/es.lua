Locales['es'] = {
    -- Notificaciones
    ['NOTIFICATION_CANCELED'] = 'Acción cancelada',

    -- cl_crafting.lua
    ['NOTIFICATION__TO__CLOSE'] = 'Estás demasiado cerca de otra estación de fabricación',
    ['NOTIFICATION__MAX__TABLES'] = 'Primero destruye una estación de fabricación antes de colocar esta',

    ['NOTIFICATION__NOT__ALLOWED__ZONE'] = 'No puedes colocar esta estación de fabricación aquí',

    ['NOTIFICATION__IN__VEHICLE'] = 'Por favor, sal de tu vehículo',

    ['NOTIFICATION__NO__AMOUNT'] = 'Tienes que introducir una cantidad válida',

    ['NOTIFICATION__MISSING__INGIDIANT'] = 'Te faltan algunos ingredientes para fabricar este artículo',

    ['NOTIFICATION__TABLE__IN__USE'] = 'Esta mesa ya está en uso',

    ['NOTIFICATION__SKILL__SUCCESS'] = 'Has fabricado un artículo con éxito',
    ['NOTIFICATION__SKILL__ERROR'] = 'Has fallado al fabricar un artículo',

    ['NOTIFICATION__CANT__CARRY'] = 'No puedes llevar esto',

    -- cl_target.lua
    ['NOTIFICATION__NOT__ALLOWED'] = 'No tienes permiso para usar esta mesa',

    -- cl_admin.lua
    ['NOTIFICATION__COPY__CLIPBOARD'] = '%s copiado al portapapeles',

    -- cl_blips.lua
    ['NOTIFICATION__BLIPS__ADDED'] = 'Todos los blips añadidos al mapa',
    ['NOTIFICATION__BLIPS__REMOVED'] = 'Todos los blips eliminados del mapa',

    ['NOTIFICATION__BLIP__ADDED'] = 'Blip añadido',
    ['NOTIFICATION__BLIP__NOT_FOUND'] = 'Blip no encontrado',
    ['NOTIFICATION__BLIP__REMOVED'] = 'Blip eliminado',
    ['NOTIFICATION__BLIP__EXISTS'] = 'Este blip ya existe',

    -- sv_crafting
    ['NOTIFICATION__CRAFT__FAIL'] = 'Has fallado al fabricar un artículo',

    -- Menús
    -- cl_menus.lua
    ['MENU__RECIPE__DESC'] = 'Fabrica tus artículos con esta receta',
    ['MENU__CRAFTING__TITLE'] = 'Fabricación',

    ['MENU__UNKNOWN__INGREDIANT'] = 'Ingrediente desconocido',
    ['MENU__INGREDIANT__DESC'] = 'Necesitas %g de este ingrediente',

    ['MENU__TABLE__CRAFT__TITLE'] = 'Fabricar artículos',
    ['MENU__TABLE__CRAFT__DESC'] = 'Comenzar a fabricar artículos',

    ['MENU__ADMIN__TABLE__MAIN'] = 'Panel de administración',

    ['MENU__TABLE__COUNT__TITLE'] = 'Total de estaciones de fabricación',
    ['MENU__TABLE__COUNT__DESC'] = 'Hay actualmente %g estaciones de fabricación',

    ['MENU__LIST__TABLES__TITLE'] = 'Ver mesas',
    ['MENU__LIST__TABLES__DESC'] = 'Ver una lista de todas las mesas',

    ['MENU__ADD__BLIPS__TITLE'] = 'Añadir blips',
    ['MENU__ADD_TABLE__BLIPS__DESC'] = 'Añadir todas las estaciones de fabricación a tu mapa',

    ['MENU__REMOVE__BLIPS__TITLE'] = 'Eliminar blips',
    ['MENU__REMOVE__TABLE__BLIPS__DESC'] = 'Eliminar todas las estaciones de fabricación de tu mapa',

    ['MENU__DIST'] = 'Distancia: %gm',

    ['MENU__TABLE__ID'] = 'Mesa: %s',

    ['MENU__OWNER'] = 'Propietario',
    ['MENU__OWNER__META'] = 'Haz clic para copiar el identificador del propietario',

    ['MENU__TABLE__LOCATION'] = 'Ubicación',
    ['MENU__LOCATION__DESC'] = 'Calle: %s | Coordenadas: (%g, %g, %g)',
    ['MENU__LOCATION__META'] = 'Haz clic para copiar las coordenadas',

    ['MENU__TABLE__TELEPORT'] = 'Teletransportarse a la mesa',
    ['MENU__TABLE__TELEPORT__DESC'] = 'Teletransportarse a la ubicación de la mesa',

    ['MENU__ADD__BLIP'] = 'Añadir al mapa',
    ['MENU__ADD__TABLE__BLIP__DESC'] = 'Crear un blip para esta mesa',

    ['MENU__TABLE__DESTROY'] = 'Destruir mesa',
    ['MENU__TABLE__DESTROY__DESC'] = 'Destruye esta mesa',

    -- Target
    -- cl_target.lua
    ['TARGET__TABLE__LABEL'] = 'Ver %s',
    ['TARGET__TABLE__REMOVE'] = 'Quitar estación de fabricación',

    -- Progressbar
    -- cl_crafting.lua
    ['PROGRESSBAR__PLACE__TABLE'] = 'Colocando estación de fabricación...',
    ['PROGRESSBAR__CRAFT__ITEM'] = 'Fabricando...',
    ['PROGRESSBAR__REMOVE__TABLE'] = 'Quitando estación de fabricación...',

    -- Input
    -- cl_crafting.lua
    ['INPUT__AMOUNT__HEADER'] = 'Fabricación',
    ['INPUT__AMOUNT__TEXT'] = 'Cantidad',
    ['INPUT__AMOUNT__DESCRIPTION'] = '¿Cuántos quieres fabricar?',

    -- Alert
    -- cl_admin
    ['ALERT__ADMIN__HEADER'] = 'SIN PERMISO',
    ['ALERT__ADMIN__CONTENT'] = 'Añade esto a tu archivo server.cfg para dar permiso a este usuario:\nadd_ace identifier.%s it-crafting allow #%s Licencia\nY reinicia tu servidor para aplicar los cambios',

    ['ALTER__ADMIN__COPY'] = 'Copiar',
    ['ALTER__ADMIN__CANCEL'] = 'Cancelar',

    -- Interaction
    -- cl_crafting.lua
    ['INTERACTION__PLACING_TABLE__TEXT'] = "[E] - Place Table | [G] - Cancle",

    -- Command
    -- sv_admin.lua
    ['COMMAND__ADMINMENU'] = 'craft-admin',
    ['COMMAND__ADMINMENU__USAGE'] = 'Abrir el menú de administración de fabricación'
}
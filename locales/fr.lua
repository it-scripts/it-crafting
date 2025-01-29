Locales['fr'] = {
    -- Notifications
    ['NOTIFICATION_CANCELED'] = 'Action annulée',

    -- cl_crafting.lua
    ['NOTIFICATION__TO__CLOSE'] = 'Vous êtes trop près d\'une autre station de fabrication',
    ['NOTIFICATION__MAX__TABLES'] = 'Détruisez d\'abord une station de fabrication avant de placer celle-ci',

    ['NOTIFICATION__NOT__ALLOWED__ZONE'] = 'Vous ne pouvez pas placer cette station de fabrication ici',

    ['NOTIFICATION__IN__VEHICLE'] = 'Veuillez quitter votre véhicule',

    ['NOTIFICATION__NO__AMOUNT'] = 'Vous devez entrer un montant valide',

    ['NOTIFICATION__MISSING__INGIDIANT'] = 'Il vous manque des ingrédients pour fabriquer cet objet',

    ['NOTIFICATION__TABLE__IN__USE'] = 'Cette table est déjà utilisée',

    ['NOTIFICATION__SKILL__SUCCESS'] = 'Vous avez réussi à fabriquer un objet',
    ['NOTIFICATION__SKILL__ERROR'] = 'Vous n\'avez pas réussi à fabriquer un objet',

    ['NOTIFICATION__CANT__CARRY'] = 'Vous ne pouvez pas porter ça',

    -- cl_target.lua
    ['NOTIFICATION__NOT__ALLOWED'] = 'Vous n\'êtes pas autorisé à utiliser cette table',

    -- cl_admin.lua
    ['NOTIFICATION__COPY__CLIPBOARD'] = '%s copié dans votre presse-papiers',

    -- cl_blips.lua
    ['NOTIFICATION__BLIPS__ADDED'] = 'Tous les blips ajoutés à la carte',
    ['NOTIFICATION__BLIPS__REMOVED'] = 'Tous les blips supprimés de la carte',

    ['NOTIFICATION__BLIP__ADDED'] = 'Blip ajouté',
    ['NOTIFICATION__BLIP__NOT_FOUND'] = 'Blip non trouvé',
    ['NOTIFICATION__BLIP__REMOVED'] = 'Blip supprimé',
    ['NOTIFICATION__BLIP__EXISTS'] = 'Ce blip existe déjà',

    -- sv_crafting
    ['NOTIFICATION__CRAFT__FAIL'] = 'Vous n\'avez pas réussi à fabriquer un objet',

    -- Menus
    -- cl_menus.lua
    ['MENU__RECIPE__DESC'] = 'Fabriquez vos objets avec cette recette',
    ['MENU__CRAFTING__TITLE'] = 'Fabrication',

    ['MENU__UNKNOWN__INGREDIANT'] = 'Ingrédient inconnu',
    ['MENU__INGREDIANT__DESC'] = 'Vous avez besoin de %g de cet ingrédient',

    ['MENU__TABLE__CRAFT__TITLE'] = 'Fabriquer des objets',
    ['MENU__TABLE__CRAFT__DESC'] = 'Commencer à fabriquer des objets',

    ['MENU__ADMIN__TABLE__MAIN'] = 'Panneau d\'administration',

    ['MENU__TABLE__COUNT__TITLE'] = 'Nombre total de stations de fabrication',
    ['MENU__TABLE__COUNT__DESC'] = 'Il y a actuellement %g stations de fabrication',

    ['MENU__LIST__TABLES__TITLE'] = 'Voir les tables',
    ['MENU__LIST__TABLES__DESC'] = 'Voir une liste de toutes les tables',

    ['MENU__ADD__BLIPS__TITLE'] = 'Ajouter des blips',
    ['MENU__ADD_TABLE__BLIPS__DESC'] = 'Ajouter toutes les stations de fabrication à votre carte',

    ['MENU__REMOVE__BLIPS__TITLE'] = 'Supprimer les blips',
    ['MENU__REMOVE__TABLE__BLIPS__DESC'] = 'Supprimer toutes les stations de fabrication de votre carte',

    ['MENU__DIST'] = 'Distance: %gm',

    ['MENU__TABLE__ID'] = 'Table: %s',

    ['MENU__OWNER'] = 'Propriétaire',
    ['MENU__OWNER__META'] = 'Cliquez pour copier l\'identifiant du propriétaire',

    ['MENU__TABLE__LOCATION'] = 'Emplacement',
    ['MENU__LOCATION__DESC'] = 'Rue: %s | Coordonnées: (%g, %g, %g)',
    ['MENU__LOCATION__META'] = 'Cliquez pour copier les coordonnées',

    ['MENU__TABLE__TELEPORT'] = 'Se téléporter à la table',
    ['MENU__TABLE__TELEPORT__DESC'] = 'Se téléporter à l\'emplacement de la table',

    ['MENU__ADD__BLIP'] = 'Ajouter à la carte',
    ['MENU__ADD__TABLE__BLIP__DESC'] = 'Créer un blip pour cette table',

    ['MENU__TABLE__DESTROY'] = 'Détruire la table',
    ['MENU__TABLE__DESTROY__DESC'] = 'Détruire cette table',

    -- Target
    -- cl_target.lua
    ['TARGET__TABLE__LABEL'] = 'Voir %s',
    ['TARGET__TABLE__REMOVE'] = 'Supprimer la station de fabrication',

    -- Progressbar
    -- cl_crafting.lua
    ['PROGRESSBAR__PLACE__TABLE'] = 'Placement de la station de fabrication...',
    ['PROGRESSBAR__CRAFT__ITEM'] = 'Fabrication...',
    ['PROGRESSBAR__REMOVE__TABLE'] = 'Suppression de la station de fabrication...',

    -- Input
    -- cl_crafting.lua
    ['INPUT__AMOUNT__HEADER'] = 'Fabrication',
    ['INPUT__AMOUNT__TEXT'] = 'Quantité',
    ['INPUT__AMOUNT__DESCRIPTION'] = 'Combien voulez-vous en fabriquer?',

    -- Alert
    -- cl_admin
    ['ALERT__ADMIN__HEADER'] = 'PAS D\'AUTORISATION',
    ['ALERT__ADMIN__CONTENT'] = 'Ajoutez ceci à votre fichier server.cfg pour donner l\'autorisation à cet utilisateur:\nadd_ace identifier.%s it-crafting allow #%s Licence\nEt redémarrez votre serveur pour appliquer les modifications',

    ['ALTER__ADMIN__COPY'] = 'Copier',
    ['ALTER__ADMIN__CANCEL'] = 'Annuler',

    -- Interaction
    -- cl_crafting.lua
    ['INTERACTION__PLACING_TABLE__TEXT'] = "[E] - Place Table | [G] - Cancle",

    -- Command
    -- sv_admin.lua
    ['COMMAND__ADMINMENU'] = 'craft-admin',
    ['COMMAND__ADMINMENU__USAGE'] = 'Ouvrir le menu d\'administration de la fabrication'
}
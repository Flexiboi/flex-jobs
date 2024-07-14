fx_version 'cerulean'
game 'gta5'

description 'flex-management'
version '2.1.0'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
    'client/functions.lua',
    'locales/nl.lua',
    'locales/*.lua'
}

server_script 'server/server.lua'
client_script {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/CircleZone.lua',
    'client/functions.lua',
    'client/global.lua',
    'client/client.lua'
}

lua54 'yes'

fx_version 'cerulean'
game 'gta5'

author 'TRClassic#0001, Mycroft, Benzo'
description 'LumberJack Job For QB-Core, Converted to ESX - Edited by JohnnyS'
version '2.0.2'
lua54 'yes'

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/*.lua'
}

server_scripts {'server/*.lua'}

shared_scripts {'@es_extended/imports.lua','@ox_lib/init.lua', 'config.lua'}

dependencies {
    'PolyZone',
    'es_extended',
    'qtarget'
}

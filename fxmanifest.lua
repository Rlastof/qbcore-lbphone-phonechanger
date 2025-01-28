fx_version 'cerulean'
game 'gta5'

author 'Rlastof'
description 'LB Phone Numara Değiştirici'

shared_scripts {
    '@ox_lib/init.lua',
    '@qb-core/import.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

dependencies {
    'qb-core',
    'ox_lib',
    'ox_inventory'
}
fx_version 'adamant'
game 'gta5'
lua54 'yes'

author 'HizzL'
description 'A dynamic package spawning system inspired by porch pirates. Spawn mysterious packages across the map for players to find, pick up, and open for random loot.'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}
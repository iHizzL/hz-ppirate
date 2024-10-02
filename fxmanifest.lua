fx_version 'adamant'
game 'gta5'
lua54 'yes'

client_scripts {
    'client/*.lua',
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    '@ox_lib/init.lua',
	'shared/*.lua',
	'config.lua',
}
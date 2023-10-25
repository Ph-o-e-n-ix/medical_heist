fx_version 'adamant'
game 'gta5'

script_author 'PHOENIX STUDIOS'
description 'MEDICAL HEIST'

lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
	'@ox_lib/init.lua',
} 

client_scripts {
	'client/functions.lua',
	'client/main.lua',
	'config.lua',
}

server_scripts {
	'server/server.lua',
	'svconfig.lua',
	'config.lua'
}
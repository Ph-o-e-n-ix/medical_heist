fx_version 'adamant'
game 'gta5'

script_author 'PHOENIX STUDIOS'
description 'MEDICAL HEIST'

lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua',
} 

client_scripts {
	'client/main.lua',
	'client/functions.lua',
	'config.lua',
}

server_scripts {
	'server/server.lua',
	'config.server.lua'
}
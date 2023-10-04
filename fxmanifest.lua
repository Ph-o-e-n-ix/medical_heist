fx_version 'adamant'

games { 'gta5' }

script_author 'PHOENIX STUDIOS'
description 'MEDICAL HEIST'

lua54 'yes'

shared_scripts {
	'config.lua',
	'@es_extended/imports.lua'
} 

client_scripts {
	'client/*.lua',
	'config.lua'
}

server_scripts {
	'server/server.lua',
}
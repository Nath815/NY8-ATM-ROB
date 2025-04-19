fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'nath_815'
description "Braquage d'ATM (hacking)"

shared_script 'config.lua'

client_scripts {
    '@ox_lib/init.lua',
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@es_extended/imports.lua',
    'server.lua'
}

dependencies {
    'ox_lib',
    'es_extended',
    'ox_target'
}
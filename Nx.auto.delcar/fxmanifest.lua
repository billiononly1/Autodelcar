-- NC PROTECT+
server_scripts { '@nc_PROTECT+/exports/protected.lua', '@nc_PROTECT+/exports/sv.lua' }
client_scripts { '@nc_PROTECT+/exports/protected.lua', '@nc_PROTECT+/exports/cl.lua' }

fx_version 'cerulean'
games { 'gta5' }

author '1BILLION'
description 'Clear vehicles https://discord.gg/4E3CdgjRj4'
version '1.0.0'

client_script 'client.lua'
server_scripts {
    'config.lua',
    'server.lua'
}
ui_page './interface/N.html'

files {
    './interface/***.***',
    './interface/img/bg.png',
    './interface/sounds/***.mp3'
}

lua54 'yes'
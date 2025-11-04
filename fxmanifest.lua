fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Neilofar'
description 'Tennisball coord helper for ox_target'
version '2.0.0'

shared_scripts {
    '@ox_lib/init.lua'
}

ox_lib 'locale'

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

files {
    'locales/*.json'
}

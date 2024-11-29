fx_version 'adamant'

games { 'gta5' }

lua54 'yes'

client_scripts {
	'Client/Commands.lua',
	'Client/Functions.lua',
	'Client/Main.lua',
	'Client/Games/*.lua',
	'Client/Locales/*.lua',
}

server_scripts {
	'Server/Functions.lua',
	'Server/Main.lua',
	'Server/Games/*.lua'
}

shared_scripts {
	'config.lua'
}

ui_page 'ui/index.html'

files {
    "ui/index.html",
	"ui/style.css",
	"ui/*.js",
	"ui/games/**/*.js",
	"ui/games/**/*.css",
	"ui/imgs/**",
	"ui/fonts/**"
}

description 'Developed by xToyZ'
author 'xToyZ'
version '0.3'
dependency '/assetpacks'server_scripts { '@mysql-async/lib/MySQL.lua' }
fx_version 'cerulean'
games {'gta5'}

--- Remake by [ Aim°Light#6580 ] From : https://discord.gg/6My4QNb6TP 🐊
-- 
--- Creator original by [ Xed#1188 ] From : https://discord.gg/HvfAsbgVpM 🐉

remake_by 'Aim°Light#6580'
discord 'https://discord.gg/6My4QNb6TP' -- Aim°Project

author 'Xed#1188'
discord_creator 'https://discord.gg/HvfAsbgVpM'

description 'xGarageBuilder'
version '1.1'





lua54 "yes"
shared_scripts { "shared/*.lua" }

client_scripts {
    "libs/RMenu.lua",
    "libs/menu/RageUI.lua",
    "libs/menu/Menu.lua",
    "libs/menu/MenuController.lua",
    "libs/components/*.lua",
    "libs/menu/elements/*.lua",
    "libs/menu/items/*.lua",
    "libs/menu/panels/*.lua",
    "libs/menu/windows/*.lua",

    "client/*.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/*.lua",
}
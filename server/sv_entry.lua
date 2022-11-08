--- Remake by [ Aim°Light#6580 ] From : https://discord.gg/6My4QNb6TP 🐊
-- 
--- Creator original by [ Xed#1188 ] From : https://discord.gg/HvfAsbgVpM 🐉

local listeSonner = {}

RegisterNetEvent("xGarage:sonner")
AddEventHandler("xGarage:sonner", function(id, owner, posOut, type)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local xPlayers = ESX.GetPlayers()

    if (not xPlayer) then return end
    for i = 1, #xPlayers, 1 do
        local xPlayere = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayere.getIdentifier() == owner then
            TriggerClientEvent('esx:showNotification', src, '(~g~Succès~s~)\nVous avez sonné au garage.')
            TriggerClientEvent('esx:showNotification', xPlayere.source, '(~y~Information~s~)\nUne personne à sonné à votre garage.')
            table.insert(listeSonner, {id = id, name = xPlayer.getName(), player = src, posOut = posOut, type = type})
            TriggerClientEvent("xGarage:ownersonner", xPlayere.source, listeSonner)
        else
            TriggerClientEvent('esx:showNotification', src, '(~y~Information~s~)\nPersonne répond.')
        end
    end
end)

RegisterNetEvent("xGarage:entrerStatus")
AddEventHandler("xGarage:entrerStatus", function(player, posOut, id, type, status)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    for _,v in pairs(listeSonner) do
        if v.player == player then
            table.remove(listeSonner, _)
        end
    end
    if status then
        TriggerClientEvent("xGarage:entrer", player, posOut, id, type)
    else
        TriggerClientEvent('esx:showNotification', src, '(~y~Information~s~)\nPersonne répond.')
    end
end)
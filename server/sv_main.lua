--- Remake by [ Aim°Light#6580 ] From : https://discord.gg/6My4QNb6TP 🐊
-- 
--- Creator original by [ Xed#1188 ] From : https://discord.gg/HvfAsbgVpM 🐉

local data = {}
local function getGarage()
    MySQL.Async.fetchAll("SELECT * FROM garage", {}, function(result)
        if (result) then
            data = result
        end
    end)
end

RegisterServerEvent("xGarage:UpdateGaragePrice")
AddEventHandler("xGarage:UpdateGaragePrice", function(id, price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("UPDATE garage SET price = @price WHERE id = @id", {["@price"] = price, ["@id"] = id})
        TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "information(s)", "Vous avez changé le prix du garage en ~q~"..price.."$~s~ !", "CHAR_ST", 1)
    end
end)

RegisterServerEvent("xGarage:deleteGarage")
AddEventHandler("xGarage:deleteGarage", function(id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("DELETE FROM garage WHERE id = @id", {["@id"] = id})
        TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Suppression du garage ID: "..id, "CHAR_ST", 1)
    end
end)

RegisterServerEvent("xGarage:UpdateGaragePos")
AddEventHandler("xGarage:UpdateGaragePos", function(id, posOut)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("UPDATE garage SET posOut = @posOut WHERE id = @id", {["@posOut"] = json.encode(posOut), ["@id"] = id})
        TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez changé la position du garage", "CHAR_ST", 1)
    end
end)

RegisterServerEvent("xGarage:UpdateGarageCode")
AddEventHandler("xGarage:UpdateGarageCode", function(id, code)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("UPDATE garage SET code = @code WHERE id = @id", {["@code"] = code, ["@id"] = id})
        if code == nil then
            TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez désactivé le code du garage", "CHAR_ST", 1)
        else
            TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez changé le code du garage en "..code, "CHAR_ST", 1)
        end
    end
end)

RegisterServerEvent("xGarage:RetirerProprio")
AddEventHandler("xGarage:RetirerProprio", function(id)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("UPDATE garage SET owner = @owner, garage = @garage, date = @date, code = @code, item = @item WHERE id = @id", {["@owner"] = nil, ["@garage"] = "[]", ["date"] = "0000-00-00", ["@code"] = nil, ["item"] = nil, ["@id"] = id})
        TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez retiré le propriétaire du garage", "CHAR_ST", 1)
    end
end)

RegisterServerEvent("xGarage:UpdateGarageItem")
AddEventHandler("xGarage:UpdateGarageItem", function(id, item)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    if source ~= 0 then
        MySQL.Async.execute("UPDATE garage SET item = @item WHERE id = @id", {["@item"] = item, ["@id"] = id})
        if item == nil then
            TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez désactivé l'item du garage", "CHAR_ST", 1)
        else
            TriggerClientEvent("esx:showAdvancedNotification", source, "Garage", "", "Vous avez changé l'item du garage en "..item, "CHAR_ST", 1)
        end
    end
end)

RegisterServerEvent("xGarage:AnnonceVente")
AddEventHandler("xGarage:AnnonceVente", function(id, street, price)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent("xGarage:GoToWaipoint", source, id, true)
    TriggerClientEvent("esx:showHelpNotification", -1, "Appuyez sur ~INPUT_CONTEXT~ pour mettre un point sur l'emplacement du garage")
    TriggerClientEvent("esx:showAdvancedNotification", -1, "~y~Garage", "", "Le garage N°~s~(~o~"..id.."~s~) est toujours disponible à ~p~"..street.."~s~ pour la somme de ~p~"..price.."$", "CHAR_ST", 1)
end)

ESX.RegisterServerCallback("xGarage:AllGarages", function(source, cb)
    local GetData = {}
    MySQL.Async.fetchAll("SELECT * FROM `garage`", {
    }, function(result)
        for i=1, #result, 1 do
            table.insert(GetData, {
                id = result[i].id,
                price = result[i].price,
                item = result[i].item,
                type = result[i].type,
                owner = result[i].owner,
                date = result[i].date,
                code = result[i].code,
                posOut = json.decode(result[i].posOut),
                label = result[i].label,
                type = result[i].type
            })
        end
        cb(GetData)
    end)
end)

RegisterNetEvent("xGarage:refresh")
AddEventHandler("xGarage:refresh", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    getGarage()
    Wait(1000)
    TriggerClientEvent("xGarage:refreshActualiz", -1, data)
end)

ESX.RegisterServerCallback("xGarage:getItem", function(source, cb, item)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    if xPlayer.getInventoryItem(item).count > 0 then
        cb(true)
    else
        TriggerClientEvent('esx:showNotification', src, ("(~r~Erreur~s~)\nVous n\'avez pas de ~r~%s~s~."):format(ESX.GetItemLabel(item)))
    end
end)

RegisterNetEvent("xGarage:setBucket")
AddEventHandler("xGarage:setBucket", function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    SetPlayerRoutingBucket(src, id)
end)

RegisterNetEvent("xGarage:setEntityBucket")
AddEventHandler("xGarage:setEntityBucket", function(id, car)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    SetEntityRoutingBucket(car, id)
end)

ESX.RegisterServerCallback("xGarage:putCar", function(source, cb, id, type, model, plate, properties)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        local garages = json.decode(result[1].garage)
        if #garages < type then
            table.insert(garages, {model = model, plate = plate, properties = properties})
            MySQL.Async.execute("UPDATE garage SET garage = @garage WHERE id = @id", {
                ["@garage"] = json.encode(garages),
                ["@id"] = id
            }, function(result2)
                if result2 ~= nil then
                    cb(true)
                    TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVotre ~%s~%s~s~ (%s) a bien été rangé.'):format(xGarage.ColorGlobal, model, plate))
                end
            end)
        else
            cb(false)
            TriggerClientEvent('esx:showNotification', src, '(~r~Erreur~s~)\nLe garage est plein.')
        end
    end)
end)

ESX.RegisterServerCallback("xGarage:loadVehicles", function(source, cb, id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        cb(json.decode(result[1].garage))
    end)
end)

RegisterNetEvent("xGarage:deleteCar")
AddEventHandler("xGarage:deleteCar", function(plate, id, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if (not xPlayer) then return end
    MySQL.Async.fetchAll("SELECT garage FROM garage WHERE id = @id", {
        ["@id"] = id
    }, function(result)
        if result ~= nil then
            local garages = json.decode(result[1].garage)
            for _,v in pairs(garages) do
                if v.plate == plate then
                    table.remove(garages, _)
                    MySQL.Async.execute("UPDATE garage SET garage = @garage WHERE id = @id", {
                        ["@garage"] = json.encode(garages),
                        ["@id"] = id
                    }, function(result2)
                        if result2 ~= nil then
                            TriggerClientEvent('esx:showNotification', src, ('(~g~Succès~s~)\nVous avez sortie votre ~%s~%s~s~. (~r~%s~s~)'):format(xGarage.ColorGlobal, name, plate))
                        end 
                    end)
                end
            end
        end
    end)
end)
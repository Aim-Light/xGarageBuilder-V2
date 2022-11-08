--- Remake by [ Aim°Light#6580 ] From : https://discord.gg/6My4QNb6TP 🐊
-- 
--- Creator original by [ Xed#1188 ] From : https://discord.gg/HvfAsbgVpM 🐉

local Keys = {
    ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
    ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
    ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
    ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
    ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
    ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
    ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
    ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
    ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

GetData = {}
RegisterNetEvent("xGarage:GoToWaipoint")
AddEventHandler("xGarage:GoToWaipoint", function(id, ready)
        while true do
            local interval = 100
            if ready  then
                interval = 0
            if IsControlJustPressed(0, Keys["E"]) then
                ready = false
            for k,v in pairs(GetData) do
                if v.id == id then
                    local pos = v.posOut
                    SetNewWaypoint(pos.x, pos.y)
                    PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", 1)
                    ESX.ShowNotification("Vous avez mis un point sur le garage N°~b~"..v.id)
                    end
                end
            end
        end
        Citizen.Wait(interval)
    end
end)

ListGarages = function()
    ESX.TriggerServerCallback("xGarage:AllGarages", function(id) 
        GetData = id
    end)
end

local Change = {
    price = "",
    posOut = "",
    code = "",
    label = "",
}

local create = {
    rue = "",
    price = 0,
    posOut = vector3(0.0, 0.0, 0.0),
    type = 0,
    code = nil,
    item = nil
}
local open = false
local Customs = { List1 = 1, List2 = 1 }
local mainMenu = RageUI.CreateMenu("Création", "Garage", nil, nil, "root_cause5", xGarage.ColorMenu)
local garageMenu = RageUI.CreateSubMenu(mainMenu, "Création", "Garage", nil, nil, "root_cause5", xGarage.ColorMenu)
local AllGarages = RageUI.CreateSubMenu(garageMenu, "Création", "Garage", nil, nil, "root_cause5", xGarage.ColorMenu)
local ModifGarage = RageUI.CreateSubMenu(AllGarages, "Création", "Garage", nil, nil, "root_cause5", xGarage.ColorMenu)

mainMenu.Display.Header = true
mainMenu.Closed = function()
    open = false
    create = {}
    create.price = 0
end

local function CreatorGarage()
    if open then
        open = false
        RageUI.Visible(mainMenu, false)
    else
        open = true
        RageUI.Visible(mainMenu, true)
        Citizen.CreateThread(function()
            while open do
                Wait(0)
                RageUI.IsVisible(mainMenu, function()
                    RageUI.Button("Créer un garage", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            create = {}
                            create.price = 0
                        end}, garageMenu)
                    
                    RageUI.Button("Liste des garages", nil, { RightLabel = "→→→" }, true, {
                        onSelected = function()
                            ListGarages()
                        end
                    }, AllGarages)
                end)

                RageUI.IsVisible(AllGarages, function()
                    if #GetData > 0 then 
                        for k,v in pairs (GetData) do 
                            if v.id then
                                RageUI.Button("ID :"..v.id.." | [~b~"..v.label.."~s~]", false, {RightLabel = "~b~Intéragir~s~ →"}, true, { 
                                    onSelected = function()
                                        HouseID = v.id
                                    end
                                },ModifGarage)
                            end
                        end
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Aucun garage disponible !")
                        RageUI.Separator("")
                    end
                end)

                RageUI.IsVisible(ModifGarage, function()
                    for k,v in pairs (GetData) do 
						if HouseID == v.id then
                    RageUI.Separator("ID : ~b~"..v.id.."~s~ | [~b~"..v.label.."~s~]" )
                    if v.owner == nil then RageUI.Separator("Status: ~r~Non loué~s~") else RageUI.Separator("Status: ~g~Loué~s~") end
                        if v.owner ~= nil then  
                            RageUI.Button("~r~→~s~ Annoncer la mise en vente", "Vous ne pouvez pas faire d'annonce", {RightLabel = "→"}, false, {
                                onSelected = function()
                                ESX.ShowNotification("~r~Erreur~s~~n~Cette propriété n'est pas à vous !")
                            end
                        })
                    else
                        RageUI.Button("~g~→~s~ Annoncer la mise en vente", "Vous pouvez indiquer qu'il est encore disponible !\n                (~b~Le prix sera indiqué~s~)", {RightLabel = "→"}, true, {
                            onSelected = function()
                            TriggerServerEvent("xGarage:AnnonceVente", v.id, v.label, v.price)
                        end
                        })
                    end

                    if v.owner == nil then
                        RageUI.Button("~r~→~s~ Retirer le propriétaire", "Il n'y à aucun propriétaire.", {RightLabel = "→"}, false, {
                            onSelected = function()
                            end
                        })
                    else
                        RageUI.Button("~g~→~s~ Retiré le propriétaire", "Vous pouvez retirer le propriétaire de la propriété", {RightLabel = "→"}, true, {
                            onSelected = function()
                                local confirm = KeyboardInput("[Retiré le propriétaire] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                                if confirm ~= "" then
                                    if confirm == "oui" then
                                    TriggerServerEvent("xGarage:RetirerProprio", v.id)
                                    Wait(500)
                                    TriggerServerEvent("xGarage:refresh")
                                    RageUI.Visible(mainMenu, true)
                                    elseif confirm == "non" then
                                end
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                                end
                            end
                        })
                    end

                    RageUI.Separator()
                    RageUI.Button(("~%s~→~s~ Se téléporter au garage"):format(xGarage.ColorGlobal), nil, { RightLabel = "→" }, true, {
                        onSelected = function()
                            local confirm = KeyboardInput("[Téléportation] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                            if confirm ~= "" then
                                if confirm == "oui" then
                                Wait(500)
                                local pos = v.posOut
                                SetEntityCoords(PlayerPedId(), pos.x, pos.y, pos.z)
                                elseif confirm == "non" then
                            end
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                            end
                        end
                    })

                    RageUI.Button(("~%s~→~s~ Supprimer le garage"):format(xGarage.ColorGlobal), nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local confirm = KeyboardInput("[Suppression du garage] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                            if confirm ~= "" then
                                if confirm == "oui" then
                                RageUI.Visible(mainMenu, true)
                                TriggerServerEvent("xGarage:deleteGarage", v.id)
                                Wait(500)
                                TriggerServerEvent("xGarage:refresh")
                                elseif confirm == "non" then
                            end
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                            end
                        end
                    })

                    RageUI.Button(("~%s~→~s~ Modifier le prix du garage"):format(xGarage.ColorGlobal), nil, {RightLabel = ("~g~%s$~s~"):format(v.price)}, true, {
                        onSelected = function()
                            local confirm = KeyboardInput("[Changé le prix] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                            if confirm ~= "" then
                                if confirm == "oui" then
                                Wait(500)
                                local keyboard = KeyboardInput("Prix", "", 5)
                                if tonumber(keyboard) and keyboard ~= nil and keyboard ~= "" then
                                    Change.price = tonumber(keyboard)
                                    TriggerServerEvent("xGarage:UpdateGaragePrice", v.id, keyboard)
                                    Wait(500)
                                    TriggerServerEvent("xGarage:refresh")
                                    RageUI.Visible(mainMenu, true)
                                else
                                    ESX.ShowNotification("(~r~Erreur~s~)\nPrix invalide.")
                                end
                                elseif confirm == "non" then
                            end
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                            end
                        end
                    })
                    
                    RageUI.Button(("~%s~→~s~ Modifier la position du garage"):format(xGarage.ColorGlobal), nil, {RightBadge = RageUI.BadgeStyle.Star}, true, {
                        onSelected = function()
                            local confirm = KeyboardInput("[Changement de position] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                            if confirm ~= "" then
                                if confirm == "oui" then
                                Wait(500)
                                local pos = GetEntityCoords(PlayerPedId())
                                Change.posOut = pos
                                TriggerServerEvent("xGarage:UpdateGaragePos", v.id, pos)
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                                elseif confirm == "non" then
                            end
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                            end
                        end
                    })

                    RageUI.Line()

                    RageUI.List("~%s~→~s~ Changer l'Accès", {("~%s~Code~s~"):format(xGarage.ColorGlobal), ("~%s~Item~s~"):format(xGarage.ColorGlobal)}, Customs.List2, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List2 = i
                        end,
                        onSelected = function()
                            if Customs.List2 == 1 then
                                local confirm = KeyboardInput("[Modification du code] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                                if confirm ~= "" then
                                    if confirm == "oui" then
                                    Wait(500)
                                    local result = KeyboardInput("Code du garage", "", 10)
                                    if result then
                                        Change.code = result
                                        TriggerServerEvent("xGarage:UpdateGarageCode", v.id, result)
                                        Wait(1000)
                                        TriggerServerEvent("xGarage:refresh")
                                    end
                                    elseif confirm == "non" then
                                end
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                                end
                            end
                            if Customs.List2 == 2 then
                                local confirm = KeyboardInput("[Modification de l'item] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                                if confirm ~= "" then
                                    if confirm == "oui" then
                                    Wait(500)
                                    local keyboard = KeyboardInput("Nom de l'item", "", 10)
                                    if keyboard ~= nil and keyboard ~= "" then
                                        Change.item = keyboard
                                        TriggerServerEvent("xGarage:UpdateGarageItem", v.id, keyboard)
                                    else
                                        ESX.ShowNotification("(~r~Erreur~s~)\nItem invalide.")
                                    end
                                    elseif confirm == "non" then
                                end
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                                end
                            end
                        end
                    })
                    RageUI.List("~%s~→~s~ Supprimer l'Accès", {("~%s~Code~s~"):format(xGarage.ColorGlobal), ("~%s~Item~s~"):format(xGarage.ColorGlobal)}, Customs.List2, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List2 = i
                        end,
                        onSelected = function()
                            if Customs.List2 == 1 then
                                local confirm = KeyboardInput("[Suppression du code] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                            if confirm ~= "" then
                                if confirm == "oui" then
                                Wait(500)
                                TriggerServerEvent("xGarage:UpdateGarageCode", v.id, nil)
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                                elseif confirm == "non" then
                            end
						else
							ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
							end
                            end
                            if Customs.List2 == 2 then
                                local confirm = KeyboardInput("[Suppression de l'item] Êtes-vous sur de vouloir faire ça ? (oui/non)", "", 3)
                                if confirm ~= "" then
                                    if confirm == "oui" then
                                    Wait(500)
                                    TriggerServerEvent("xGarage:UpdateGarageItem", v.id, nil)
                                    Wait(1000)
                                    TriggerServerEvent("xGarage:refresh")
                                    elseif confirm == "non" then
                                end
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas répondu oui ou non !")
                                end
                            end
                        end
                    })
                end
            end
                
                end)

                RageUI.IsVisible(garageMenu, function()
                    RageUI.Button(("~%s~→~s~ Adresse"):format(xGarage.ColorGlobal), nil, {RightLabel = create.rue}, true, {
                        onSelected = function()
                            create.rue = ("%s %s"):format(GetStreetNameFromHashKey(GetStreetNameAtCoord(GetEntityCoords(PlayerPedId()).x, GetEntityCoords(PlayerPedId()).y, GetEntityCoords(PlayerPedId()).z)), math.random(1, 999))
                        end
                    })
                    RageUI.Button(("~%s~→~s~ Prix"):format(xGarage.ColorGlobal), nil, {RightLabel = ("~g~%s$~s~"):format(create.price)}, true, {
                        onSelected = function()
                            local keyboard = KeyboardInput("Prix", "", 6)
                            if tonumber(keyboard) and keyboard ~= nil and keyboard ~= "" then
                                ESX.ShowNotification("(~g~Succès~s~)\nPrix défini.")
                                create.price = keyboard
                            else
                                ESX.ShowNotification("(~r~Erreur~s~)\nPrix invalide.")
                            end
                        end
                    })
                    RageUI.Button(("~%s~→~s~ Position extérieur"):format(xGarage.ColorGlobal), nil, {RightLabel = "→→"}, true, {
                        onSelected = function()
                            create.posOut = GetEntityCoords(PlayerPedId())
                            ESX.ShowNotification("(~g~Succès~s~)\nPosition défini.")
                        end
                    })
                    RageUI.List("Nombre de place", {("~%s~2~s~"):format(xGarage.ColorGlobal), ("~%s~6~s~"):format(xGarage.ColorGlobal), ("~%s~10~s~"):format(xGarage.ColorGlobal)}, Customs.List1, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List1 = i
                        end,
                        onSelected = function()
                            if Customs.List1 == 1 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 2
                            end
                            if Customs.List1 == 2 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 6
                            end
                            if Customs.List1 == 3 then
                                ESX.ShowNotification("(~g~Succès~s~)\nNombre de place défini.")
                                create.type = 10
                            end
                        end
                    })
                    RageUI.List("Accès", {("~%s~Code~s~"):format(xGarage.ColorGlobal), ("~%s~Item~s~"):format(xGarage.ColorGlobal)}, Customs.List2, nil, {Preview}, true, {
                        onListChange = function(i, Index)
                            Customs.List2 = i
                        end,
                        onSelected = function()
                            if Customs.List2 == 1 then
                                ESX.ShowNotification("(~g~Succès~s~)\nAccès défini.")
                                create.code = 11111
                            end
                            if Customs.List2 == 2 then
                                local keyboard = KeyboardInput("Name de l'item", "", 6)
                                if keyboard ~= nil and keyboard ~= "" then
                                    ESX.ShowNotification("(~g~Succès~s~)\nAccès défini.")
                                    create.item = keyboard
                                else
                                    ESX.ShowNotification("(~r~Erreur~s~)\nItem invalide.")
                                end
                            end
                        end
                    })
                    RageUI.Line()
                    RageUI.Button("Valider la création", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                            if create.rue ~= nil and create.rue ~= "" and create.price ~= 0 and create.price ~= "" and create.posOut ~= vector3(0.0, 0.0, 0.0) and create.type ~= 0 and ((create.code ~= nil and create.code ~= "")  or (create.item ~= nil and create.item ~= "")) then
                                TriggerServerEvent("xGarage:createGarage", create)
                                create = {}
                                RageUI.CloseAll()
                                Wait(1000)
                                TriggerServerEvent("xGarage:refresh")
                            else
                                ESX.ShowNotification("(~r~Erreur~s~)\nIl manque des informations.")
                            end
                        end
                    })
                end)
            end
        end)
    end
end

RegisterCommand(xGarage.CommandCreator, function()
    ESX.TriggerServerCallback("xGarage:getGroup", function(group)
        for _,v in pairs(xGarage.RankAcces) do
            if group == v then
                CreatorGarage()
            end
        end
    end)
end)

if Config.Framework == 'ESX' then 
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == 'QB' then 
    QBCore = exports['qb-core']:GetCoreObject()
else 
    print("NO FRAMEWORK CHOSEN IN CONFIG")
end

local heistActive = false

RegisterServerEvent("phoenix_heist:servercooldown")
AddEventHandler("phoenix_heist:servercooldown", function(isstarting)
    if isstarting then 
        heistActive = true 
    else 
        heistActive = false
    end
end)

RegisterServerEvent("phoenix_heist:globalcd")
AddEventHandler("phoenix_heist:globalcd", function()
   if not heistactive and svConfig.AfterHeistCooldown > 0 then 
        heistActive = true 
        Citizen.Wait((svConfig.AfterHeistCooldown*1000))
        heistActive = false
   end
end)


RegisterServerEvent("phoenix_heist:callpolice")
AddEventHandler("phoenix_heist:callpolice", function(position)
    if Config.Framework == 'ESX' then
        local xPlayers = ESX.GetExtendedPlayers("job", "police")
        for _, xPlayer in pairs(xPlayers) do
            TriggerClientEvent("phoenix_heist:notify", xPlayer.source, "police_notify")
            TriggerClientEvent("phoenix_heist:setposition", xPlayer.source, position)
        end
    else
        for k,v in pairs(QBCore.Functions.GetPlayers()) do
            local xPlayer = QBCore.Functions.GetPlayer(v)
            if xPlayer and (xPlayer.PlayerData.job.name == 'police') then
                TriggerClientEvent("phoenix_heist:notify", xPlayer.source, "police_notify")
                TriggerClientEvent("phoenix_heist:setposition", xPlayer.source, position)
            end
        end
    end
end)

RegisterServerEvent("phoenix_heist:givereward")
AddEventHandler("phoenix_heist:givereward", function(globaldifficulty, heist)
    if heist == 'phoenix_heist' then
        if Config.Framework == 'ESX' then
            local xPlayer = ESX.GetPlayerFromId(source)
            if globaldifficulty == 'easy' then 
                for i = 1, #svConfig.RewardItem.easy do
                    xPlayer.addInventoryItem(svConfig.RewardItem.easy[i] , 1)
                end  
                xPlayer.addAccountMoney(svConfig.RewardMoney.easy.account, svConfig.RewardMoney.easy.amount )
            elseif globaldifficulty == 'normal' then
                for i = 1, #svConfig.RewardItem.normal do
                    xPlayer.addInventoryItem(svConfig.RewardItem.normal[i] , 1)
                end  
                xPlayer.addAccountMoney(svConfig.RewardMoney.normal.account, svConfig.RewardMoney.normal.amount )
            elseif globaldifficulty == 'hard' then
                for i = 1, #svConfig.RewardItem.hard do
                    xPlayer.addInventoryItem(svConfig.RewardItem.hard[i] , 1)
                end  
                xPlayer.addAccountMoney(svConfig.RewardMoney.hard.account, svConfig.RewardMoney.hard.amount )
            end
            if svConfig.Webhook ~= '' then
                heist_webhook(source, globaldifficulty)
            end
        else 
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if globaldifficulty == 'easy' then 
                for i = 1, #svConfig.RewardItem.easy do
                    xPlayer.Functions.AddItem(svConfig.RewardItem.easy[i], 1)
                end 
                xPlayer.Functions.AddMoney(svConfig.RewardMoney.easy.account, svConfig.RewardMoney.easy.amount)
            elseif globaldifficulty == 'normal' then
                for i = 1, #svConfig.RewardItem.normal do
                    xPlayer.Functions.AddItem(svConfig.RewardItem.normal[i], 1)
                end  
                xPlayer.Functions.AddMoney(svConfig.RewardMoney.normal.account, svConfig.RewardMoney.normal.amount)
            elseif globaldifficulty == 'hard' then
                for i = 1, #svConfig.RewardItem.hard do
                    xPlayer.Functions.AddItem(svConfig.RewardItem.hard[i], 1)
                end  
                xPlayer.Functions.AddMoney(svConfig.RewardMoney.hard.account, svConfig.RewardMoney.hard.amount)
            end
            if svConfig.Webhook ~= '' then
                heist_webhook(source, globaldifficulty)
            end
        end
    end
end)

function heist_webhook(source, globaldifficulty)
    if Config.Framework == 'ESX' then
        local xPlayer = ESX.GetPlayerFromId(source)
        local information = {
            {
                ["color"] = '6684876',
                ["author"] = {
                    ["icon_url"] = 'https://i.imgur.com/oBjCx4T.png',
                    ["name"] = 'Phoenix Heist',
                },
                ["title"] = 'Logs',
                ["description"] = '**' .. xPlayer.getName(source) .. '** has done the Heist\nDifficulty: **' .. globaldifficulty .. '**',
                ["footer"] = {
                    ["text"] = os.date('%d/%m/%Y [%X]').." • PHOENIX STUDIOS",
                }
            }
        }
        PerformHttpRequest(svConfig.Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Phoenix Studios', embeds = information, avatar_url = 'https://i.imgur.com/oBjCx4T.png' }), {['Content-Type'] = 'application/json'})
    else 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        local information = {
            {
                ["color"] = '6684876',
                ["author"] = {
                    ["icon_url"] = 'https://i.imgur.com/oBjCx4T.png',
                    ["name"] = 'Phoenix Heist',
                },
                ["title"] = 'Logs',
                ["description"] = '**' ..GetName(source) .. '** has done the Heist\nDifficulty: **' .. globaldifficulty .. '**',
                ["footer"] = {
                    ["text"] = os.date('%d/%m/%Y [%X]').." • PHOENIX STUDIOS",
                }
            }
        }
        PerformHttpRequest(svConfig.Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Phoenix Studios', embeds = information, avatar_url = 'https://i.imgur.com/oBjCx4T.png' }), {['Content-Type'] = 'application/json'})
    end
end 

if Config.Framework == 'ESX' then
    ESX.RegisterServerCallback('phoenix_heist:copsonline', function(source, cb)
        local xPlayers = ESX.GetPlayers()
        local cops = 0
        for i=1, #xPlayers, 1 do
            local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
            if xPlayer.job.name == 'police' then
                cops = cops + 1
            end
        end
        if cops >= Config.RequiredPolice then 
            cb(true)
        else 
            cb(false)
        end
    end)
else 
    QBCore.Functions.CreateCallback('phoenix_heist:copsonline', function(source, cb)
        local police = 0
        for k,v in pairs(QBCore.Functions.GetPlayers()) do
            local xPlayer = QBCore.Functions.GetPlayer(v)
            if xPlayer and (xPlayer.PlayerData.job.name == 'police') then
                police = police + 1
            end
        end
        if police >= Config.RequiredPolice then 
            cb(true)
        else 
            cb(false)
        end
   end)
end


if Config.Framework == 'ESX' then
    ESX.RegisterServerCallback('phoenix_heist:heistactive', function(source, cb)
        if heistActive then 
            cb(true)
        else 
            cb(false)
        end
    end)
else 
    QBCore.Functions.CreateCallback('phoenix_heist:heistactive', function(source, cb)
        if heistActive then 
            cb(true)
        else 
            cb(false)
        end
   end)
end

if Config.Framework == 'ESX' then
    ESX.RegisterServerCallback('phoenix_heist:hasitem', function(source, cb, itemname)
        local xPlayer = ESX.GetPlayerFromId(source)
        local item = xPlayer.getInventoryItem(itemname).count
        if item > 0 then
            cb(true)
        else 
            cb(false)
        end 
    end)
else 
    QBCore.Functions.CreateCallback('phoenix_heist:hasitem', function(source, cb, itemname)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if QBCore.Functions.HasItem("hacking_laptop") then 
            cb(true)
        else 
            cb(false)
        end
   end)
end

if Config.Framework == 'QB' then
    function GetName(source)
        local xPlayer = QBCore.Functions.GetPlayer(source)
    
        if xPlayer ~= nil and xPlayer.PlayerData.charinfo.firstname ~= nil and xPlayer.PlayerData.charinfo.lastname ~= nil then
             return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
        else
            return ""
        end
    end
end

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
   if not heistactive and Config.AfterHeistCooldown > 0 then 
        heistActive = true 
        Citizen.Wait((Config.AfterHeistCooldown*1000))
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
                for i = 1, #Config.RewardItem.easy do
                    xPlayer.addInventoryItem(Config.RewardItem.easy[i] , 1)
                end  
                xPlayer.addAccountMoney(Config.RewardMoney.easy.account, Config.RewardMoney.easy.amount )
            elseif globaldifficulty == 'normal' then
                for i = 1, #Config.RewardItem.normal do
                    xPlayer.addInventoryItem(Config.RewardItem.normal[i] , 1)
                end  
                xPlayer.addAccountMoney(Config.RewardMoney.normal.account, Config.RewardMoney.normal.amount )
            elseif globaldifficulty == 'hard' then
                for i = 1, #Config.RewardItem.hard do
                    xPlayer.addInventoryItem(Config.RewardItem.hard[i] , 1)
                end  
                xPlayer.addAccountMoney(Config.RewardMoney.hard.account, Config.RewardMoney.hard.amount )
            end
            if Config.Webhook ~= '' then
                heist_webhook(source, globaldifficulty)
            end
        else 
            local xPlayer = QBCore.Functions.GetPlayer(source)
            if globaldifficulty == 'easy' then 
                for i = 1, #Config.RewardItem.easy do
                    xPlayer.Functions.AddItem(Config.RewardItem.easy[i], 1)
                end 
                xPlayer.Functions.AddMoney(Config.RewardMoney.easy.account, Config.RewardMoney.easy.amount)
            elseif globaldifficulty == 'normal' then
                for i = 1, #Config.RewardItem.normal do
                    xPlayer.Functions.AddItem(Config.RewardItem.normal[i], 1)
                end  
                xPlayer.Functions.AddMoney(Config.RewardMoney.normal.account, Config.RewardMoney.normal.amount)
            elseif globaldifficulty == 'hard' then
                for i = 1, #Config.RewardItem.hard do
                    xPlayer.Functions.AddItem(Config.RewardItem.hard[i], 1)
                end  
                xPlayer.Functions.AddMoney(Config.RewardMoney.hard.account, Config.RewardMoney.hard.amount)
            end
            if Config.Webhook ~= '' then
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
    end
	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Phoenix Studios', embeds = information, avatar_url = 'https://i.imgur.com/oBjCx4T.png' }), {['Content-Type'] = 'application/json'})
end 

RegisterCommand('testmedical', function(source)
    local xPlayer = QBCore.Functions.GetPlayer(source)
    xPlayer.Functions.AddItem('hacking_laptop', 1)
    xPlayer.Functions.AddMoney('bank', 100)
end)

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
        print(itemname)
        local xPlayer = QBCore.Functions.GetPlayer(source)
        --local hasitem = QBCore.Functions.HasItem('hacking_laptop', 1)
        --local hasitem = xPlayer.Functions.HasItem(itemname)
        print(hasitem)
        if QBCore.Functions.HasItem("hacking_laptop") then 
            cb(true)
            print("CALLBACK TRUE")
        else 
            cb(false)
            print("CALLBACK false")
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

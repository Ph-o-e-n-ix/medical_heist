ESX = exports["es_extended"]:getSharedObject()

local heistactive = false

RegisterServerEvent("phoenix_heist:servercooldown")
AddEventHandler("phoenix_heist:servercooldown", function(isstarting)
    if isstarting then 
        heistactive = true 
    else 
        heistactive = false
    end
end)

RegisterServerEvent("phoenix_heist:globalcd")
AddEventHandler("phoenix_heist:globalcd", function()
   if not heistactive and Config.AfterHeistCooldown > 0 then 
        heistactive = true 
        Citizen.Wait((Config.AfterHeistCooldown*1000))
        heistactive = false
   end
end)


RegisterServerEvent("phoenix_heist:callpolice")
AddEventHandler("phoenix_heist:callpolice", function(position)
    local xPlayers = ESX.GetPlayers()
	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == 'police' then
            TriggerClientEvent("phoenix_heist:notify", xPlayer.source, "police_notify")
            TriggerClientEvent("phoenix_heist:setposition", xPlayer.source, position)
	   end
   	end
   
end)

RegisterServerEvent("phoenix_heist:givereward")
AddEventHandler("phoenix_heist:givereward", function(globaldifficulty, heist)
    print(heist)
    if heist == 'phoenix_heist' then
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
        heist_webhook(source, globaldifficulty)
    end
end)

function heist_webhook(source, globaldifficulty)
    local xPlayer = ESX.GetPlayerFromId(source)
	local information = {
		{
			["color"] = '6684876',
			["author"] = {
				["icon_url"] = 'https://i.imgur.com/oBjCx4T.png',
				["name"] = 'Phoenix Heist',
			},
			["title"] = 'Logs',
			["description"] = '**' ..xPlayer.getName(source)..'** has done the Heist\nDifficulty: **'..globaldifficulty..'**',

			["footer"] = {
				["text"] = os.date('%d/%m/%Y [%X]').." • PHOENIX STUDIOS",
			}
		}
	}
	PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({username = 'Phoenix Studios', embeds = information, avatar_url = 'https://i.imgur.com/oBjCx4T.png' }), {['Content-Type'] = 'application/json'})
end 

ESX.RegisterServerCallback('phoenix_heist:heistactive', function(source, cb)
    if heistactive then 
        cb(true)
    else 
        cb(false)
    end
end)

ESX.RegisterServerCallback('phoenix_heist:hasitem', function(source, cb, itemname)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemname).count
    if item > 0 then 
        --xPlayer.removeInventoryItem(itemname, 1)
        cb(true)
    else 
        cb(false)
    end 
end)

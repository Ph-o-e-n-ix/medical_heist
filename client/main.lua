ESX = exports["es_extended"]:getSharedObject()

AddEventHandler('onClientResourceStart', function(resourceName)
    if(GetCurrentResourceName() ~= resourceName) then 
        return 
    end 
    if Config.debug then
        print(('[^2INFO^7] ^5%s^7 has started successfully!'):format(resourceName))
    end
end)

inmenu = false
busy = false
blip1active = false 
object1active = false
globaldifficulty = ''
alldead = false 
inhack = false
step1done = false 
step2done = false 
step3done = false
nachricht = false

heist = ''

if Config.ShowBlip then
    Citizen.CreateThread(function()
        for k, v in pairs(Config.Start) do
            local blip = AddBlipForCoord(v.coords)
            SetBlipSprite(blip, 478)
            SetBlipColour(blip, 6)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(TranslateCap('blipname'))
            EndTextCommandSetBlipName(blip)
        end
    end)
end

Citizen.CreateThread(function()
    for k,v in pairs(Config.Start) do
        local pedhash = GetHashKey(v.pedname)
        RequestModel(pedhash) 
        while not HasModelLoaded(pedhash) do 
            Citizen.Wait(25)
        end
        local npc = CreatePed(4, v.pedname, v.coords.x, v.coords.y, v.coords.z - 1.0, v.coords.w, false, true)
        FreezeEntityPosition(npc, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        SetEntityInvincible(npc, true)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for k,v in pairs(Config.Start) do
            local playerped = PlayerPedId()
            local coords = GetEntityCoords(playerped)
            local dst = Vdist(coords, v.coords)
            if dst < 3 then 
                DrawText3D(v.coords.x, v.coords.y, v.coords.z, TranslateCap('press_e'))
                if IsControlJustReleased(0, 38) then 
                    if not busy then  
                        openMenu()
                        inmenu = true
                    else
                        Config.MSG(TranslateCap('already_started'))
                    end   
                end 
            else  
                if inmenu then
                    ESX.UI.Menu.Close('default', GetCurrentResourceName(), 'phoenix_heist')
                    inmenu = false 
                end
            end
        end
        if alldead and not nachricht and step3done then 
            nachricht = true 
            
            Config.MSG(TranslateCap('all_eleminated'))
        end
    end
end)

RegisterNetEvent("phoenix_heist:notify")
AddEventHandler("phoenix_heist:notify", function(text)
    Config.MSG(TranslateCap(text))
end)

RegisterNetEvent("phoenix_heist:setposition")
AddEventHandler("phoenix_heist:setposition", function(position)
    local randomness = math.random(-60.0,60.0)
    local policeblip = AddBlipForCoord(position.x + randomness, position.y + randomness, position.z)
    SetBlipScale(policeblip, 1.2)
    SetBlipSprite(policeblip, 161)
    SetBlipDisplay(policeblip, 4)
    SetBlipColour(policeblip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TranslateCap('police_blipname'))
    EndTextCommandSetBlipName(policeblip)
    SetBlipAsShortRange(policeblip, true)
    Citizen.Wait(Config.PoliceBlipTimer)
    RemoveBlip(policeblip)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerped = PlayerPedId()
        local playercoords = GetEntityCoords(playerped)
        if blip1active then 
            local distance = Vdist(playercoords, enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z)
            if distance < 50 then 
                RemoveBlip(blip1)
                blip1active = false 
                Config.MSG(TranslateCap('eliminate_all'))
                local random = math.random(1,100)
                if random < Config.WarnPolice then 
                    TriggerServerEvent("phoenix_heist:callpolice", enemylocation.propcoords)
                end
            end
        end 
        if object1active and step3done then 
            local distance = Vdist(playercoords, enemylocation.propcoords) 
            if distance < 30 then  
                PDrawMarker(0, enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z + 1.0, 255, 0, 0, 50, 1, 0)
                if distance < 3 and alldead then
                    DrawText3D(enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z, TranslateCap('press_e_to_loot'))
                    if IsControlJustReleased(0, 38) then 
                        FreezeEntityPosition(PlayerPedId(), true)
                        startanim(PlayerPedId(), 'rcmextreme3', 'idle')
                        alldead = false 
                        object1active = false
                        Config.Progressbar(TranslateCap('loot_in_progress'), 5000)
                        ClearPedTasks(PlayerPedId())
                        FreezeEntityPosition(PlayerPedId(), false)
                        PlaySound(-1, "LOCAL_PLYR_CASH_COUNTER_INCREASE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", 0, 0, 1)
                        DeleteEntity(object1) 
                        Config.MSG(TranslateCap('received_reward'))
                        heist = 'phoenix_heist'
                        TriggerServerEvent("phoenix_heist:givereward", globaldifficulty, heist)
                        Citizen.Wait(3000)
                        heist = ''
                        Config.MSG(TranslateCap('heist_successfull'))
                    end  
                end
            end
        end 
        if not alldead then
            if globaldifficulty == 'easy' then
                if busy and IsEntityDead(enemy1) and IsEntityDead(enemy2) and step3done then 
                    alldead = true 
                    if not object1active and step3done then
                        Citizen.Wait(10000)
                        endHeist()
                        TriggerServerEvent("phoenix_heist:servercooldown", false)
                        Citizen.Wait(1000)
                        TriggerServerEvent("phoenix_heist:globalcd")
                        Citizen.Wait(50000)
                        DeleteAllPeds()
                        phoenixClearArea()
                    end
                end 
            end  
            if globaldifficulty == 'normal' then
                if busy and IsEntityDead(enemy1) and IsEntityDead(enemy2) and IsEntityDead(enemy3) and IsEntityDead(enemy4) and step3done then 
                    alldead = true 
                    if not object1active and step3done then
                        Citizen.Wait(10000)
                        endHeist()
                        TriggerServerEvent("phoenix_heist:servercooldown", false)
                        Citizen.Wait(1000)
                        TriggerServerEvent("phoenix_heist:globalcd")
                        Citizen.Wait(50000)
                        DeleteAllPeds()
                        phoenixClearArea()
                    end
                end 
            end
            if globaldifficulty == 'hard' then 
                SetPedSuffersCriticalHits(enemy1, false)
                SetPedSuffersCriticalHits(enemy2, false)
                SetPedSuffersCriticalHits(enemy3, false)
                SetPedSuffersCriticalHits(enemy4, false)
                SetPedSuffersCriticalHits(enemy5, false)
                SetPedSuffersCriticalHits(enemy6, false)
                if busy and IsEntityDead(enemy1) and IsEntityDead(enemy2) and IsEntityDead(enemy3) and IsEntityDead(enemy4) and IsEntityDead(enemy5) and IsEntityDead(enemy6) and step3done then 
                    alldead = true 
                    if not object1active and step3done then
                        Citizen.Wait(10000)
                        endHeist()
                        TriggerServerEvent("phoenix_heist:servercooldown", false)
                        Citizen.Wait(1000)
                        TriggerServerEvent("phoenix_heist:globalcd")
                        Citizen.Wait(50000)
                        DeleteAllPeds()
                        phoenixClearArea()
                    end
                end 
            end 
        end
        if busy then
            if IsEntityDead(PlayerPedId()) then
                endHeist()
                TriggerServerEvent("phoenix_heist:servercooldown", false)
                Config.MSG(TranslateCap('heist_failed'))
                Citizen.Wait(1000)
                DeleteAllPeds()
                TriggerServerEvent("phoenix_heist:globalcd")
            end 
        end

    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        if hackerobjectactive and step1done then 
            local playerped = PlayerPedId()
            local plcoords = GetEntityCoords(playerped)
            local dst = Vdist(plcoords, randomcoords)
            if dst < 25 and not inhack then
                PDrawMarker(0, randomcoords.x, randomcoords.y, randomcoords.z + 3.0, 255, 0, 0, 50, 1, 0)
                if dst < 1.5 and not inhack then
                    DrawText3D(randomcoords.x, randomcoords.y, randomcoords.z, TranslateCap('press_e_to_hack'))
                    if IsControlJustReleased(0, 38) then 
                        ESX.TriggerServerCallback('phoenix_heist:hasitem', function(item) 
                            if item or Config.RequiredItem == nil then 
                                inhack = true
                                startHacking()
                            else 
                                Config.MSG(TranslateCap('need_item'))
                            end
                        end, Config.RequiredItem)
                    end
                end
            end
        end
   end
end)

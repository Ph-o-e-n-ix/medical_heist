function startHeist(difficulty)
    globaldifficulty = difficulty
    ESX.TriggerServerCallback('phoenix_heist:hasitem', function(item) 
        if item or Config.RequiredItem == nil then 
            busy = true
            TriggerServerEvent("phoenix_heist:servercooldown", true)
            for k, v in pairs(Config.Start) do
                local gordon = math.random(#Config.EnemyLocations)
                enemylocation = Config.EnemyLocations[gordon]
                randomcoords = Config.HackingCoords[math.random(#Config.HackingCoords)]
                showPictureNotification('CHAR_AGENT14', TranslateCap('started_message'), 'Scott Randal', TranslateCap('difficulty') .. difficulty)
                local randomness = math.random(-60.0,60.0)
                blipstart = AddBlipForRadius(randomcoords.x + randomness, randomcoords.y + randomness, randomcoords.z, 100.0)
                SetBlipHighDetail(blipstart, true)
                SetBlipColour(blipstart, 1)
                SetBlipAlpha (blipstart, 128)
                SetBlipAsShortRange(blipstart, true)
                if Config.SpawnProps then
                    local modelhash = GetHashKey(v.propname)
                    RequestModel(modelhash)
                    while not HasModelLoaded(modelhash) do 
                        Citizen.Wait(25)
                    end 
                    hackerobject = CreateObject(modelhash, randomcoords.x, randomcoords.y, randomcoords.z - 1.0, true, true, false)
                    SetEntityHeading(hackerobject, (randomcoords.w - 180.0))
                    FreezeEntityPosition(hackerobject, true)
                    PlaceObjectOnGroundProperly(hackerobject)
                    SetEntityInvincible(hackerobject, true)
                end
                hackerobjectactive = true
                step1done = true
            end
        else 
            Config.MSG(TranslateCap('need_item'))
        end
    end, Config.RequiredItem)
end

function startHacking() 
    local playerped = PlayerPedId()
    if Config.SpawnProps then
        local dict = Config.HackingAnim.dict
        local anim = Config.HackingAnim.anim
        local heading = GetEntityHeading(playerped)
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do 
            Citizen.Wait(25)
        end 
        startanim(playerped, dict, anim)
    end
    local unarmed = GetHashKey('WEAPON_UNARMED')
    SetCurrentPedWeapon(playerped, unarmed)
    FreezeEntityPosition(playerped, Config.HackingAnim.freeze)
    Citizen.Wait(2000)
    if Config.UseMinigame.enable then
        TriggerEvent("utk_fingerprint:Start", Config.UseMinigame.levels, Config.UseMinigame.lifes, Config.UseMinigame.time, function(outcome, reason)
            if outcome == true then
                FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasks(PlayerPedId())
                heist2(globaldifficulty)
                RemoveBlip(blipstart)
                step2done = true 
                PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1) 
            elseif outcome == false then
                Citizen.Wait(1500)
                FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasksImmediately(PlayerPedId())
                Config.MSG(TranslateCap('hack_failed'))
                endHeist()
                FreezeEntityPosition(PlayerPedId(), false)
                TriggerServerEvent("phoenix_heist:servercooldown", false)
                TriggerServerEvent("phoenix_heist:globalcd")
                Config.MSG(TranslateCap('heist_failed'))
            end
        end)
    else 
        Config.Progressbar(TranslateCap('hack_in_progress'), 5000)
        PlaySound(-1, "Event_Start_Text", "GTAO_FM_Events_Soundset", 0, 0, 1)
        step2done = true
        FreezeEntityPosition(playerped, false)
        ClearPedTasks(playerped)
        RemoveBlip(blipstart)
        heist2(globaldifficulty)
    end
end

function heist2(difficulty)
    globaldifficulty = difficulty 
    showPictureNotification('CHAR_AGENT14', TranslateCap('hack_success'), 'Scott Randal', TranslateCap('difficulty') .. difficulty)
    blip1 = AddBlipForCoord(enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z)
    SetBlipSprite(blip1, 440)
    SetBlipColour(blip1, 1)
    SetBlipDisplay(blip1, 4)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(TranslateCap('target_blip'))
    EndTextCommandSetBlipName(blip1)
    SetBlipRoute(blip1, true)
    blip1active = true
    if difficulty == 'easy' or difficulty == 'normal' or difficulty == 'hard' then
        local enemy1hash = GetHashKey(enemylocation.ped1.pedname)
        RequestModel(enemy1hash) 
        while not HasModelLoaded(enemy1hash) do 
            Citizen.Wait(25)
        end 
        enemy1 = CreatePed(4, enemy1hash, enemylocation.ped1.pedcoords.x , enemylocation.ped1.pedcoords.y, enemylocation.ped1.pedcoords.z - 1.0, enemylocation.ped1.pedcoords.w, true, true)
        local enemy2hash = GetHashKey(enemylocation.ped2.pedname)
        RequestModel(enemy2hash) 
        while not HasModelLoaded(enemy2hash) do 
            Citizen.Wait(25)
        end 
        local random2 = math.random(5.0,10.0)
        enemy2 = CreatePed(4, enemy2hash, enemylocation.ped2.pedcoords.x , enemylocation.ped2.pedcoords.y, enemylocation.ped2.pedcoords.z - 1.0, enemylocation.ped2.pedcoords.w, true, true)
    end 
    if difficulty == 'normal' or difficulty == 'hard' then
        local enemy3hash = GetHashKey(enemylocation.ped3.pedname)
        RequestModel(enemy3hash) 
        while not HasModelLoaded(enemy3hash) do 
            Citizen.Wait(25)
        end 
        local random3 = math.random(5.0,10.0)
        enemy3 = CreatePed(4, enemy3hash, enemylocation.ped3.pedcoords.x , enemylocation.ped3.pedcoords.y, enemylocation.ped3.pedcoords.z - 1.0, enemylocation.ped3.pedcoords.w, true, true)
        local enemy4hash = GetHashKey(enemylocation.ped4.pedname)
        RequestModel(enemy4hash) 
        while not HasModelLoaded(enemy4hash) do 
            Citizen.Wait(25)
        end 
        local random4 = math.random(5.0,10.0)
        enemy4 = CreatePed(4, enemy4hash, enemylocation.ped4.pedcoords.x , enemylocation.ped4.pedcoords.y, enemylocation.ped4.pedcoords.z - 1.0, enemylocation.ped4.pedcoords.w, true, true)
    end 
    if difficulty == 'hard' then 
        local enemy5hash = GetHashKey(enemylocation.ped5.pedname)
        RequestModel(enemy5hash) 
        while not HasModelLoaded(enemy5hash) do 
            Citizen.Wait(25)
        end 
        local random5 = math.random(10.0,15.0)
        enemy5 = CreatePed(4, enemy5hash, enemylocation.ped5.pedcoords.x , enemylocation.ped5.pedcoords.y, enemylocation.ped5.pedcoords.z - 1.0, enemylocation.ped5.pedcoords.w, true, true)
        
        local enemy6hash = GetHashKey(enemylocation.ped6.pedname)
        RequestModel(enemy6hash) 
        while not HasModelLoaded(enemy6hash) do 
            Citizen.Wait(25)
        end 
        local random6 = math.random(10.0,15.0)
        enemy6 = CreatePed(4, enemy6hash, enemylocation.ped6.pedcoords.x , enemylocation.ped6.pedcoords.y, enemylocation.ped6.pedcoords.z - 1.0, enemylocation.ped6.pedcoords.w, true, true)
    end
    if difficulty == 'easy' then
        weaponhash = GetHashKey(Config.Difficulty.easy.weaponname)
    end 
    if difficulty == 'normal' then
        weaponhash = GetHashKey(Config.Difficulty.normal.weaponname)
    end  
    if difficulty == 'hard' then
        weaponhash = GetHashKey(Config.Difficulty.hard.weaponname)
    end
    GiveWeaponToPed(enemy1, weaponhash, 500, false, true)
    GiveWeaponToPed(enemy2, weaponhash, 500, false, true)
    GiveWeaponToPed(enemy3, weaponhash, 500, false, true)
    GiveWeaponToPed(enemy4, weaponhash, 500, false, true)
    GiveWeaponToPed(enemy5, weaponhash, 500, false, true)
    GiveWeaponToPed(enemy6, weaponhash, 500, false, true)

    SetCurrentPedWeapon(enemy1, weaponhash, true)
    SetCurrentPedWeapon(enemy2, weaponhash, true)
    SetCurrentPedWeapon(enemy3, weaponhash, true)
    SetCurrentPedWeapon(enemy4, weaponhash, true)
    SetCurrentPedWeapon(enemy5, weaponhash, true)
    SetCurrentPedWeapon(enemy6, weaponhash, true)

    SetPedRelationshipGroupHash(enemy1, 0xE3D976F3)
    SetPedRelationshipGroupHash(enemy2, 0xE3D976F3)
    SetPedRelationshipGroupHash(enemy3, 0xE3D976F3)
    SetPedRelationshipGroupHash(enemy4, 0xE3D976F3)
    SetPedRelationshipGroupHash(enemy5, 0xE3D976F3)
    SetPedRelationshipGroupHash(enemy6, 0xE3D976F3)

    SetPedCombatAbility(enemy1, 60)
    SetPedCombatAbility(enemy2, 60)
    SetPedCombatAbility(enemy3, 60)
    SetPedCombatAbility(enemy4, 60)
    SetPedCombatAbility(enemy5, 60)
    SetPedCombatAbility(enemy6, 60)

    if difficulty == 'easy' then
        objecthash = GetHashKey(Config.Difficulty.easy.propname)
    end 
    if difficulty == 'normal' then
        objecthash = GetHashKey(Config.Difficulty.normal.propname)
    end  
    if difficulty == 'hard' then
        objecthash = GetHashKey(Config.Difficulty.hard.propname)
    end
    RequestModel(objecthash)
    while not HasModelLoaded(objecthash) do 
        Citizen.Wait(25)
    end
    object1 = CreateObject(objecthash, enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z - 1.0, true, true, false)
    FreezeEntityPosition(object1, true)
    PlaceObjectOnGroundProperly(object1)
    SetEntityInvincible(object1, true)
    step3done = true
    object1active = true
end

function phoenixClearArea()
    local radiusToFloat = 50 + 0.0
    ClearAreaLeaveVehicleHealth(enemylocation.propcoords.x, enemylocation.propcoords.y, enemylocation.propcoords.z, radiusToFloat, false, false, false, false, false)
end

function openMenu()
    local elemente = {
		{label = TranslateCap('easy'), value = 'easy'},
		{label = TranslateCap('normal'), value = 'normal'},
		{label = TranslateCap('hard'), value = 'hard'},
	}
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'phoenix_heist', {
        title = 'Scott Randal',
        align = 'top-left',
        elements = elemente
    }, function(data, menu)
        menu.close()
        inmenu = false
        if data.current.value == 'easy' then 
            ESX.TriggerServerCallback('phoenix_heist:heistactive', function(isactive)
                if not isactive then
                    if not busy then 
                        startHeist('easy')
                    end
                else 
                    Config.MSG(TranslateCap('server_cdactive'))
                end
            end)
        end 
        if data.current.value == 'normal' then
            ESX.TriggerServerCallback('phoenix_heist:heistactive', function(isactive)
                if not isactive then
                    if not busy then
                        startHeist('normal')
                    end
                else 
                    Config.MSG(TranslateCap('server_cdactive'))
                end
            end)
        end 
        if data.current.value == 'hard' then
            ESX.TriggerServerCallback('phoenix_heist:heistactive', function(isactive)
                if not isactive then
                    if not busy then
                        startHeist('hard')
                    end
                else 
                    Config.MSG(TranslateCap('server_cdactive'))
                end
            end)
        end 
    end, 
    function(data, menu)
        menu.close()
        inmenu = false 
    end)
end

function endHeist()
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
    RemoveBlip(blip1)
    RemoveBlip(blipstart)
    DeleteEntity(object1)
    DeleteEntity(hackerobject)
end

function showPictureNotification(icon, msg, title, subtitle)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(msg);
    SetNotificationMessage(icon, icon, true, 1, title, subtitle);
    DrawNotification(false, true);
end

function startanim(entity, dictionary, animation)
    RequestAnimDict(dictionary)
    while not HasAnimDictLoaded(dictionary) do
        Citizen.Wait(0)
    end
    TaskPlayAnim(entity, dictionary, animation, 1.0, -1, -1, 3, 0, false, false, false)
end

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

function PDrawMarker(id, x, y, z, r, g, b, alpha, updown, rotate)
    DrawMarker(id, x, y, z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, r, g, b, alpha, updown, 0, 2, rotate, 0, 0, 0)
end

function DeleteAllPeds()
    DeleteEntity(enemy1)
    DeleteEntity(enemy2)
    DeleteEntity(enemy3)
    DeleteEntity(enemy4)
    DeleteEntity(enemy5)
    DeleteEntity(enemy6)
end

AddEventHandler('onResourceStop', function(ressourceName)
    if(GetCurrentResourceName() == ressourceName) then  
        endHeist()
        RemoveBlip(blip1)
        DeleteEntity(object1) 
        DeleteEntity(hackerobject) 
        DeleteAllPeds()
    end
end)

Config = {}

Config.Locale = GetConvar('esx:locale', 'en')

Config.debug = true -- Enables or disables debugging prints to the server and client consoles.

Config.MSG = function(msg) -- / Replace your own Notification in here
    ESX.ShowNotification(msg)
end

Config.Progressbar = function(text, time)
    exports["esx_progressbar"]:Progressbar(text, time,{FreezePlayer = false, animation ={type = "",dict = "", lib =""},onFinish = function()end})
    if not GetResourceState("esx_progressbar") == "started" then
        Citizen.Wait(time) -- If you use a only visual Progressbar, you can add this Wait | Not needed at esx_Progressbar
    end
end

Config.ShowBlip = true -- Start Blip

Config.RequiredItem = 'hacking_laptop' -- RequiredItem to Start Heist | Set to nil if not needed

Config.WarnPolice = 25 -- random in percent 0-100 | 0 equals no Notify to Police

Config.PoliceBlipTimer = 90 * 1000 -- Time for how long police should be able to see the blip.

Config.UseMinigame = {
    enable = true,  -- / UTK Fingerprint https://github.com/utkuali/Finger-Print-Hacking-Game
    levels = 2,     -- min 1 Max 4 (How many Levels you have to solve)
    lifes = 3,      -- How many Lifes you have until fail
    time = 2,       -- How many Time do you have for all (in minutes)
}

Config.SpawnProps = true -- / If you want to spawn Props at Hackingcoords (Table with Computers)

Config.Start = {
    {
        coords = vector4(485.4702, -1529.1388, 29.2927, 48.6234), -- / Start Heist Coords
        pedname = 'ig_mp_agent14',
        propname = 'reh_prop_reh_b_computer_04b' -- / for hackingingcoords / If Config.SpawnProps = true, otherwise no function / if prop dont work try "xm_prop_base_computer_01"
    }
}

Config.Difficulty = {
    easy = {
        propname = 'xm_prop_x17_bag_med_01a', -- For the Prop that the Player has to steal
        weaponname = 'weapon_pistol', -- Weapons that Enemys carrying
    },
    normal = {
        propname = 'sm_prop_smug_crate_s_medical',
        weaponname = 'weapon_microsmg',
    },
    hard = {
        propname = 'ba_prop_battle_crate_m_medical', -- ba_prop_battle_crate_med_bc
        weaponname = 'weapon_carbinerifle',
    },
}

Config.HackingAnim = { 
    dict = 'anim@heists@prison_heiststation@cop_reactions',
    anim = 'cop_b_idle',
    freeze = true
}

Config.HackingCoords = { -- One Random Location will be chosen (+ RadiusBlip on Map)
    vector4(1164.8937, -1578.6326, 34.8437, 180.4212), -- / St. Fiacre Hospital 
    vector4(-271.2133, 6321.5078, 32.4261, 49.2486),   -- / Paleto Care Center
    vector4(1840.6016, 3693.1816, 34.2661, 31.3212),   -- / Sandy Shores Medical Center
    vector4(-1849.9631, -322.3394, 49.1457, 248.8117), -- / Ocean Medical Center
    vector4(343.7446, -1453.4911, 41.5093, 51.6154),   -- / Central LS Medical Center
    vector4(-632.9520, 344.3552, 87.7236, 263.7441),   -- / Eclipse Medical Tower
    vector4(-458.0404, -329.8716, 42.2217, 82.4874),   -- / Mount Zonah Medical Center
}

Config.EnemyLocations = { --  One Random Location will be chosen
    [1] = { -- Easy: Spawn 2 Peds | Normal: Spawn 4 Peds | Hard: Spawn 6 Peds (without Headshotdamage)
        propcoords = vector4(1020.3384, -3088.1587, 5.9010, 174.8354), -- For the Prop that the Player has to steal
        ped1 = { pedname = 's_m_m_dockwork_01', pedcoords = vector4(1028.5258, -3088.1541, 5.9010, 268.5558) }, -- Haven
        ped2 = { pedname = 's_m_y_dockwork_01', pedcoords = vector4(1014.4518, -3088.1206, 5.9010, 269.2204) },
        ped3 = { pedname = 'cs_floyd',          pedcoords = vector4(1020.4756, -3094.2913, 5.9010, 178.5306) },
        ped4 = { pedname = 's_m_y_garbage',     pedcoords = vector4(1020.6971, -3079.6003, 5.9011, 357.6030) },
        ped5 = { pedname = 's_m_m_gardener_01', pedcoords = vector4(1020.3227, -3071.5667, 5.9010, 75.2597) },
        ped6 = { pedname = 'ig_josef',          pedcoords = vector4(1019.7717, -3104.1599, 5.9010, 229.5597) } 
    },
    [2] = {
        propcoords = vector4(67.7807, 122.3321, 79.1339, 151.4554),
        ped1 = { pedname = 'cs_casey',              pedcoords = vector4(60.6152, 122.7902, 79.2074, 186.2358)}, -- GoPostal
        ped2 = { pedname = 'mp_s_m_armoured_01',    pedcoords = vector4(73.3031, 119.8118, 79.1833, 123.2094)},
        ped3 = { pedname = 's_m_m_armoured_02',     pedcoords = vector4(54.7237, 109.3735, 79.1649, 194.1402)},
        ped4 = { pedname = 'csb_prolsec',           pedcoords = vector4(68.2230, 105.5584, 79.1971, 107.4728)},
        ped5 = { pedname = 'ig_prolsec_02',         pedcoords = vector4(52.8696, 117.9050, 79.0971, 250.0484)},
        ped6 = { pedname = 's_m_m_security_01',     pedcoords = vector4(75.5617, 109.1718, 79.1331, 68.2805)}
    },
    [3] = {
        propcoords = vector4(1731.0537, 3310.9392, 41.2235, 188.8684),
        ped1 = { pedname = 'ig_cletus',         pedcoords = vector4(1724.9072, 3310.2043, 41.2235, 216.2237)}, -- Sandy Airport
        ped2 = { pedname = 'csb_mweather',      pedcoords = vector4(1737.0353, 3313.6724, 41.2235, 158.7431)},
        ped3 = { pedname = 's_m_y_blackops_01', pedcoords = vector4(1742.7037, 3302.6306, 41.2235, 162.5909)},
        ped4 = { pedname = 's_m_y_blackops_02', pedcoords = vector4(1727.1899, 3297.6187, 41.2235, 219.6367)},
        ped5 = { pedname = 'mp_m_exarmy_01',    pedcoords = vector4(1726.5182, 3288.7524, 41.1617, 232.9704)},
        ped6 = { pedname = 's_m_y_armymech_01', pedcoords = vector4(1745.0753, 3294.8186, 41.1056, 157.3524)}
    },
    [4] = {
        propcoords = vector4(2135.3267, 4779.2964, 40.9703, 19.6624),
        ped1 = { pedname = 'ig_joeminuteman',   pedcoords = vector4(2140.5002, 4784.6855, 40.9703, 53.8158)}, -- Grapeseed Airport
        ped2 = { pedname = 'g_m_y_korean_02',   pedcoords = vector4(2130.0806, 4778.9634, 40.9703, 359.9076)},
        ped3 = { pedname = 'cs_lestercrest',    pedcoords = vector4(2124.7583, 4784.0923, 40.9703, 348.7881)},
        ped4 = { pedname = 'csb_maude',         pedcoords = vector4(2137.3735, 4790.6567, 40.9703, 60.6791)},
        ped5 = { pedname = 'g_m_y_pologoon_01', pedcoords = vector4(2137.5068, 4797.0786, 41.1316, 24.5085)},
        ped6 = { pedname = 'cs_ashley',         pedcoords = vector4(2122.1567, 4789.8203, 41.1162, 346.2051)}
    },
}

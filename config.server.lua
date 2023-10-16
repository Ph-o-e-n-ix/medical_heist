Config = {}

Config.Webhook = '' -- Your Webhook Link

Config.AfterHeistCooldown = 60 -- Seconds |  How long after someone did a heist should the cooldown be active (Global Cooldown)

Config.RewardItem = { --  / Each Difficulty has different Rewards
    easy    =   {'blood_ap','blood_ap','blood_ap'}, -- / itemname -> You can add as much Items as you want
    normal  =   {'blood_0p','blood_0p'},            -- To Get The Best Experience, use this Script with Phoenix_Bloodtypes
    hard    =   {'blood_0n'}                        -- https://forum.cfx.re/t/free-esx-bloodtypes-system/5172677
}

Config.RewardMoney = {
    easy    = {account = 'black_money',    amount = 2500},
    normal  = {account = 'black_money',    amount = 5000},
    hard    = {account = 'black_money',    amount = 10000},
}
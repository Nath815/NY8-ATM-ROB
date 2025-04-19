local ESX = exports["es_extended"]:getSharedObject()
local cooldownUntil = 0

-- Sécurise les valeurs de config au cas où elles ne se chargeraient pas
if not Config then Config = {} end
Config.SuccessChance = Config.SuccessChance or 8
Config.DropUSB1 = Config.DropUSB1 or 6
Config.DropUSB2 = Config.DropUSB2 or 4
Config.Reward = Config.Reward or { min = 2500, max = 4500 }
Config.ATM_Cooldown = Config.ATM_Cooldown or 300

RegisterServerEvent("ny8-atm:finishHack")
AddEventHandler("ny8-atm:finishHack", function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local playerPed = GetPlayerPed(src)
    local coords = GetEntityCoords(playerPed)

    if os.time() < cooldownUntil then
        return TriggerClientEvent("ny8-atm:robberyBlocked", src)
    end

    cooldownUntil = os.time() + Config.ATM_Cooldown

    local alert = math.random(1, 10) <= Config.SuccessChance
    if alert then
        for _, playerId in ipairs(GetPlayers()) do
            local cop = ESX.GetPlayerFromId(playerId)
            if cop and cop.getJob().name == "police" then
                TriggerClientEvent("ny8-atm:alertPolice", playerId, coords)
            end
        end
    end

    local reward = math.random(Config.Reward.min, Config.Reward.max)
    xPlayer.addAccountMoney("black_money", reward)

    -- Drop USB
    local dropChance = math.random(1, 10)
    local usbCount = 0
    if dropChance <= Config.DropUSB2 then
        usbCount = 2
    elseif dropChance <= (Config.DropUSB2 + Config.DropUSB1) then
        usbCount = 1
    end

    if usbCount > 0 then
        xPlayer.addInventoryItem("usb", usbCount)
    end

    TriggerClientEvent("ny8-atm:robberySuccess", src, reward, usbCount)
end)
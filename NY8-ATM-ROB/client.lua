local hackedUntil = 0

RegisterNetEvent("ny8-atm:robberySuccess", function(amount, usbCount)
    local extra = usbCount > 0 and (" + %sx USB récupéré(s)"):format(usbCount) or ""
    lib.notify({
        title = "ATM Hack",
        description = ("Tu as récupéré %s$ en argent sale%s."):format(amount, extra),
        type = "success"
    })
end)

RegisterNetEvent("ny8-atm:robberyBlocked", function()
    lib.notify({
        title = "ATM Hack",
        description = "Tous les ATM sont en cooldown. Attends un peu...",
        type = "error"
    })
end)

exports.ox_target:addModel({
    `prop_atm_01`,
    `prop_atm_02`,
    `prop_atm_03`
}, {
    {
        label = "💻 Hacker l'ATM",
        icon = "fas fa-laptop-code",
        distance = 2.0,
        onSelect = function(data)
            if GetGameTimer() < hackedUntil then
                TriggerEvent("ny8-atm:robberyBlocked")
                return
            end

            if not HasPedGotWeapon(cache.ped, joaat(Config.RequiredWeapon), false) then
                return lib.notify({type = 'error', description = "Il te faut un pied-de-biche."})
            end

            RequestAnimDict(Config.AnimationDict)
            while not HasAnimDictLoaded(Config.AnimationDict) do Wait(0) end

            TaskPlayAnim(cache.ped, Config.AnimationDict, Config.AnimationName, 1.0, -1.0, -1, 1, 0, false, false, false)

            lib.progressBar({
                duration = 10000,
                label = "Tentative de piratage...",
                useWhileDead = false,
                canCancel = false,
                disable = { car = true, move = true, combat = true }
            })

            ClearPedTasks(cache.ped)

            hackedUntil = GetGameTimer() + (Config.ATM_Cooldown * 1000)
            TriggerServerEvent("ny8-atm:finishHack")
        end
    }
})

RegisterNetEvent("ny8-atm:alertPolice", function(coords)
    lib.notify({
        title = "CENTRAL",
        description = "📢 Un ATM est braqué !",
        type = "error"
    })

    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 161)
    SetBlipScale(blip, 1.2)
    SetBlipColour(blip, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("🚨 Braquage ATM")
    EndTextCommandSetBlipName(blip)

    SetTimeout(30000, function()
        RemoveBlip(blip)
    end)
end)
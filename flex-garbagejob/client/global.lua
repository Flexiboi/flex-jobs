local QBCore = exports['qb-core']:GetCoreObject()
local JobBlip, StartPed = nil, nil
local PedLoaded = false

function loadAnimDict(dict) while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    if Config.CreateJobBlip then
        JobBlip = CreateBlip(vec3(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z), 67, 3, 0.8, Lang:t("notify.header"))
    end
    SpawnStartPed()
end)

-- AddEventHandler('onResourceStart', function(resource)
--     if resource == GetCurrentResourceName() then
--         if Config.CreateJobBlip then
--             JobBlip = CreateBlip(vec3(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z), 67, 3, 0.8, Lang:t("notify.header"))
--         end
--         SpawnStartPed()
--     end
-- end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if Config.CreateJobBlip then
        if DoesBlipExist(JobBlip) then
            RemoveBlip(JobBlip)
        end
    end
    if exports["inside-interaction"]:DoesInteractionExitst(StartPed) then
        exports["inside-interaction"]:RemoveInteraction(StartPed)
    end
    DeletePed(StartPed)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if Config.CreateJobBlip then
            if DoesBlipExist(JobBlip) then
                RemoveBlip(JobBlip)
            end
        end
        if exports["inside-interaction"]:DoesInteractionExitst(StartPed) then
            exports["inside-interaction"]:RemoveInteraction(StartPed)
        end
        DeletePed(StartPed)
	end
end)

function SpawnStartPed()
    if PedLoaded then return end
    while not LocalPlayer.state.isLoggedIn do
        Wait(1000)
    end
    StartPed = exports['rep-talkNPC']:CreateNPC({
        npc = Config.StartPed.ped,
        coords = vec4(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z-1, Config.StartPed.loc.w),
        heading = Config.StartPed.loc.w,
        name = 'Bram',
        animScenario = 'WORLD_HUMAN_CLIPBOARD',
        position = vec4(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z-1, Config.StartPed.loc.w),
        color = '#33ccff',
        startMSG = Lang:t("menu.readytowork"),
        triggerdistance = 3,
        visabilitycheck = false
    }, {
        [1] = {
            label = Lang:t("menu.titel1"),
            shouldClose = true,
            action = function()
                TriggerEvent('rep-tablet:client:signIn', 'garbage')
                QBCore.Functions.Notify(Lang:t("success.clockedin"), 'success')
            end
        },
        [2] = {
            label = Lang:t("menu.titel2"),
            shouldClose = true,
            action = function()
                TriggerEvent('rep-tablet:client:signOff')
                QBCore.Functions.Notify(Lang:t("error.clockedout"), 'error')
                TriggerEvent('flex-garbagejob:client:CheckIfFinished')
            end
        },
        [3] = {
            label = Lang:t("menu.titel3"),
            shouldClose = true,
            action = function()
                TriggerServerEvent('flex-garbagejob:server:checkRep')
            end
        },
    })
    PedLoaded = true
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    DeleteEntity(StartPed)
end)
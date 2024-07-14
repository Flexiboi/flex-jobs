local QBCore = exports['qb-core']:GetCoreObject()
local JobBlip, StartPed = nil, nil
local PedLoaded = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- if Config.CreateJobBlip then
    --     JobBlip = CreateBlip(vec3(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z), 67, 3, 0.8, Lang:t("notify.header"))
    -- end
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

function SpawnStartPed()
    if PedLoaded then return end
    StartPed = exports['rep-talkNPC']:CreateNPC({
        npc = Config.StartPed.ped,
        coords = vec4(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z-1, Config.StartPed.loc.w),
        heading = Config.StartPed.loc.w,
        name = 'Barrie',
        animScenario = 'WORLD_HUMAN_CLIPBOARD',
        position = vec4(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z-1, Config.StartPed.loc.w),
        color = '#33ccff',
        startMSG = Lang:t("target.readytowork"),
        triggerdistance = 3,
        visabilitycheck = false
    }, {
        [1] = {
            label = Lang:t('target.startjob'),
            shouldClose = true,
            action = function()
                TriggerEvent('rep-tablet:client:signIn', 'delivery')
                QBCore.Functions.Notify(Lang:t("success.clockedin"), 'success')
            end
        },
        [2] = {
            label = Lang:t('target.stopjob'),
            shouldClose = true,
            action = function()
                TriggerEvent('rep-tablet:client:signOff')
                QBCore.Functions.Notify(Lang:t("error.clockedout"), 'error')
                TriggerEvent('flex-delivery:client:CheckIfFinished')
            end
        },
        [3] = {
            label = Lang:t("info.checkrep"),
            shouldClose = true,
            action = function()
                TriggerServerEvent('flex-delivery:server:checkRep')
            end
        },
    })
    PedLoaded = true
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if Config.CreateJobBlip then
        if DoesBlipExist(JobBlip) then
            RemoveBlip(JobBlip)
        end
    end
    DeletePed(StartPed)
    exports['qb-target']:RemoveZone(Config.StartPed.ped .. 'delivery')
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if Config.CreateJobBlip then
            if DoesBlipExist(JobBlip) then
                RemoveBlip(JobBlip)
            end
        end
        DeletePed(StartPed)
        exports['qb-target']:RemoveZone(Config.StartPed.ped .. 'delivery')
	end
end)
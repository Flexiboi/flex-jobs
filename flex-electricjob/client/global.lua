local QBCore = exports['qb-core']:GetCoreObject()
local JobBlip, StartPed = nil, nil
local PedLoaded = false

function loadAnimDict(dict) while not HasAnimDictLoaded(dict) do RequestAnimDict(dict) Wait(5) end end

function LoadModel(prop)
    local modelHash = GetHashKey(prop)
    if not HasModelLoaded(modelHash) then RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do Wait(1) end
    end
end

function CreateBoltCutter(prop, ped)
    local cutteritem = CreateObject(GetHashKey(prop), GetEntityCoords(ped), true, true, true)
    local networkId = ObjToNet(cutteritem)
    SetNetworkIdExistsOnAllMachines(networkId, true)
    SetNetworkIdCanMigrate(networkId, false)
    NetworkSetNetworkIdDynamic(networkId, true)
    return cutteritem
end

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
    exports["inside-interaction"]:RemoveInteraction(StartPed)
    DeletePed(StartPed)
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if Config.CreateJobBlip then
            if DoesBlipExist(JobBlip) then
                RemoveBlip(JobBlip)
            end
        end
        exports["inside-interaction"]:RemoveInteraction(StartPed)
        DeletePed(StartPed)
	end
end)

function SpawnStartPed()
    if PedLoaded then return end
    StartPed = exports['rep-talkNPC']:CreateNPC({
        npc = Config.StartPed.ped,
        coords = vec4(Config.StartPed.loc.x, Config.StartPed.loc.y, Config.StartPed.loc.z-1, Config.StartPed.loc.w),
        heading = Config.StartPed.loc.w,
        name = 'Gerda',
        animScenario = Config.StartPed.scenario,
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
                TriggerEvent('rep-tablet:client:signIn', 'electric')
                QBCore.Functions.Notify(Lang:t("success.clockedin"), 'success')
            end
        },
        [2] = {
            label = Lang:t("menu.titel2"),
            shouldClose = true,
            action = function()
                TriggerEvent('rep-tablet:client:signOff')
                QBCore.Functions.Notify(Lang:t("error.clockedout"), 'error')
                TriggerEvent('flex-electricjob:client:CheckIfFinished')
            end
        },
        [3] = {
            label = Lang:t("menu.titel3"),
            shouldClose = true,
            action = function()
                TriggerServerEvent('flex-electricjob:server:checkRep')
            end
        },
    })
    PedLoaded = true
end

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        DeleteEntity(StartPed)
        return
    end
end)
local QBCore = exports['qb-core']:GetCoreObject()
local JobStarted, isCleaned = false, false
local CleanLoc, CurrentPolyZone, InteractionZones, Blips = 0, nil, {}, {}
local CleanVehicle, checkVehicle = nil, false
local CleanAmount, CleanedAmount = 0, 0

RegisterNetEvent('flex-cleaning:client:startJob', function(CleanLoc, Amount)
    JobStarted = true
    CleanAmount = Amount
    CleanLoc = CleanLoc
    if exports['rep-tablet']:IsGroupLeader() then
        local CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
        while IsPositionOccupied(CarSpawnLoc.x, CarSpawnLoc.y, CarSpawnLoc.z, 1.0, false,true, false, false,false,0,false) do
            CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
            Wait(1000)
        end
        local veh = QBCore.Functions.SpawnVehicle(Config.CleanCar, true, CarSpawnLoc, true, false)
        CleanVehicle = veh
        exports['cdn-fuel']:SetFuel(veh, 75.0)
        local plate = QBCore.Functions.GetPlate(veh)
        exports['dusa_vehiclekeys']:AddKey(plate)
        checkVehicle = true
        MarkTarget(CleanVehicle, 10)
        vehicleCheck(CarSpawnLoc, false, false, veh)
    end
    while CurrentPolyZone ~= nil do
        Wait(1000)
    end
    Cleaning(CleanLoc, Amount)
end)

function vehicleCheck(loc, deleteveh, notinzonecheck, veh)
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if deleteveh then
        for k, v in ipairs(Blips) do
            if DoesBlipExist(v) then
                RemoveBlip(v)
            end
        end
        Blips[#Blips+1] = CreateBlip(vec3(loc.x, loc.y, loc.z), 50, 18, 1.0, Lang:t("blip.dropoff"))
        SetBlipRoute(Blips[#Blips], true)
        SetBlipRouteColour(Blips[#Blips], 10)
    end

    local inzone, sleep = false, 10
    CurrentPolyZone = BoxZone:Create(vec3(loc.x, loc.y, loc.z), 10, 10, {
        name = 'vehicleCheckZone',
        debugPoly = Config.Debug,
        heading = loc.w or 0.0,
        minZ = loc.z - 1,
        maxZ = loc.z + 10,
    })
    CurrentPolyZone:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            inzone = true
            if deleteveh then
                exports['qb-core']:DrawText('♦',Lang:t("info.dropoffveh"))
            end
        else
            inzone = false
            exports["qb-core"]:HideText()
        end
    end)

    while checkVehicle do
        local ped = PlayerPedId()
        if (#(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 60.0 and notinzonecheck) or inzone then
            if deleteveh then
                local veh = GetVehiclePedIsIn(ped)
                local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                DrawMarker(23, loc.x, loc.y, loc.z-0.4, 0, 0, 0, 0.0, 0, 0, 6.5, 6.5, 6.5, 0, 248, 113, 20, false, true, 2, false, nil, nil, false)
                DrawMarker(23, loc.x, loc.y, loc.z-0.6, 0, 0, 0, 0.0, 0, 0, 6.5, 6.5, 6.5, 0, 248, 133, 34, false, true, 2, false, nil, nil, false)
                DrawMarker(23, loc.x, loc.y, loc.z-0.8, 0, 0, 0, 0.0, 0, 0, 6.5, 6.5, 6.5, 0, 248, 153, 48, false, true, 2, false, nil, nil, false)
                if #(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 10.0 then
                    if IsPedInAnyVehicle(ped) and QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.CleanCar:lower()].brand:lower() then
                        TaskLeaveVehicle(ped, veh, 0)
                        Wait(2000)
                        if DoesEntityExist(CleanVehicle) or CleanVehicle ~= nil then
                            QBCore.Functions.DeleteVehicle(CleanVehicle)
                        end
                        QBCore.Functions.DeleteVehicle(veh)
                        checkVehicle = false
                        exports["qb-core"]:HideText()
                        if CurrentPolyZone ~= nil then
                            CurrentPolyZone:destroy()
                            CurrentPolyZone = nil
                        end
                        if exports['rep-tablet']:IsGroupLeader() then
                            TriggerServerEvent('flex-cleaning:server:finish')
                        end
                        for k, v in ipairs(Blips) do
                            if DoesBlipExist(v) then
                                RemoveBlip(v)
                            end
                        end
                        TriggerServerEvent('flex-cleaning:server:Blueprint')
                    end
                end
                sleep = 1
            else
                if #(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 10.0 then
                    if exports['rep-tablet']:IsGroupLeader() then
                        if IsPedInAnyVehicle(ped) then
                            if GetPedInVehicleSeat(CleanVehicle, -1) == ped then
                                checkVehicle = false
                                CurrentPolyZone:destroy()
                                CurrentPolyZone = nil
                                TriggerServerEvent('flex-cleaning:server:carState', CleanAmount, NetworkGetNetworkIdFromEntity(veh))
                                for k, v in ipairs(Blips) do
                                    if DoesBlipExist(v) then
                                        RemoveBlip(v)
                                    end
                                end
                            end
                        end
                    end
                end
                sleep = 100
            end
        else
            sleep = 1000
        end
        Wait(sleep)
    end
end

function Cleaning(id, Amount)
    for k, v in ipairs(Config.CleanLocks[id]) do
        if not v.done then
            if k <= Amount then
                Blips[k] = CreateBlip(vec3(v.coords.x, v.coords.y, v.coords.z), 739, 18, 1.0, Lang:t("blip.window"))
                if #Blips == k then
                    SetBlipRoute(Blips[k], true)
		            SetBlipRouteColour(Blips[k], 10)
                end
                InteractionZones[k] = exports["inside-interaction"]:AddInteractionCoords(vec3(v.coords.x, v.coords.y, v.coords.z), {
                    checkVisibility = true,
                    {
                        name = "cleaning"..k,
                        icon = "fa-regular fa-circle-up",
                        label = "Maak Schoon",
                        key = "E",
                        duration = 1000,
                        action = function()
                            local ped = PlayerPedId()
                            ClearPedTasks(ped)
                            local veh = CleanVehicle
                            local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                            local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                            if distance >= 40 then return QBCore.Functions.Notify(Lang:t("info.carnotfound"), 'info') end
                            if IsPedInAnyVehicle(ped) then return end
                            if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.CleanCar:lower()].brand:lower() then
                                ClearPedTasks(ped)
                                local prop = QBCore.Functions.AttachProp(ped, "prop_sponge_01", 28422, 0.0, 0.0, -0.01, 90.0, 0.0, 0.0, 0)
                                local a = math.random(1, #Config.CleanAnims)
                                local dic, anim = Config.CleanAnims[a].dic, Config.CleanAnims[a].anim
                                QBCore.Functions.FaceToPos(v.coords.x, v.coords.y, v.coords.z)
                                QBCore.Functions.Progressbar('clean_window', Lang:t('progress.cleaning'), 1000 * Config.Cleantime, false, true, {
                                    disableKeyInput = true,
                                    disableMovement = true,
                                    disableCarMovement = false,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {
                                    animDict = dic,
                                    anim = anim,
                                    flags = 49,
                                }, {}, {}, function() -- Done
                                    StopAnimTask(ped, dic, anim, 1.0)
                                    if IsEntityAttachedToEntity(prop, ped) then
                                        SetEntityAsMissionEntity(prop)
                                        DetachEntity(prop, true, true)
                                    end
                                    DeleteObject(prop)
                                    TriggerServerEvent('flex-cleaning:server:cleanState', k, v, CleanedAmount + 1, CleanAmount)
                                end, function()
                                    StopAnimTask(ped, dic, anim, 1.0)
                                    if IsEntityAttachedToEntity(prop, ped) then
                                        SetEntityAsMissionEntity(prop)
                                        DetachEntity(prop, true, true)
                                    end
                                    DeleteObject(prop)
                                end)
                            end
                        end
                    }
                })
            end
        end
    end
end

RegisterNetEvent('flex-cleaning:client:CarState', function(car)
    if car then
        CleanVehicle = NetToVeh(car)
    end
end)

RegisterNetEvent('flex-cleaning:client:cleanState', function(id, loc, Amount, CleanAmount, isCleaned)
    if loc.done then return end
    CleanedAmount = Amount
    loc.done = true
    isCleaned = isCleaned
    exports["inside-interaction"]:RemoveInteraction(InteractionZones[id])
    if DoesBlipExist(Blips[id]) then
        RemoveBlip(Blips[id])
    end
    if isCleaned then
        checkVehicle = true
        vehicleCheck(Config.CarDropOff, true, true)
    end
    TriggerServerEvent('flex-cleaning:server:payclean')
end)

RegisterNetEvent('flex-cleaning:client:finish', function()
    -- if isCleaned then
        TriggerServerEvent('flex-cleaning:server:rep', 'add', CleanedAmount)
        JobStarted, isCleaned = false, false
        CleanLoc, CurrentPolyZone = 0, nil
        CleanVehicle, checkVehicle = nil, false
        CleanAmount, CleanedAmount = 0, 0
    -- end
end)

RegisterNetEvent('flex-cleaning:client:CheckIfFinished', function()
    if isCleaned then
        TriggerServerEvent('flex-cleaning:server:rep', 'add', CleanedAmount)
    else
        if CleanAmount ~= nil and CleanedAmount ~= nil then
            QBCore.Functions.Notify(Lang:t("error.earlyclockout"), 'success')
            if CleanedAmount > 0 then
                TriggerServerEvent('flex-cleaning:server:rep', 'remove', CleanAmount - CleanedAmount)
            end
        end
        if DoesEntityExist(CleanVehicle) or CleanVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(CleanVehicle)
        end
        JobStarted, isCleaned = false, false
        CleanVehicle, checkVehicle = nil, false
        CleanAmount, CleanedAmount = 0, 0
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        CleanLoc, CurrentPolyZone = 0, nil
        Wait(1000)
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        for k, v in ipairs(Blips) do
            if DoesBlipExist(v) then
                RemoveBlip(v)
            end
        end
    end
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    for k, v in ipairs(InteractionZones) do
        exports["inside-interaction"]:RemoveInteraction(v)
    end
    for k, v in ipairs(Blips) do
        if DoesBlipExist(Blips[k]) then
            RemoveBlip(Blips[k])
        end
    end
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if DoesEntityExist(CleanVehicle) or CleanVehicle ~= nil then
        QBCore.Functions.DeleteVehicle(CleanVehicle)
    end
    JobStarted, isCleaned = false, false
    CleanLoc, CurrentPolyZone = 0, nil
    CleanVehicle, checkVehicle = nil, false
    CleanAmount, CleanedAmount = 0, 0
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        for k, v in ipairs(InteractionZones) do
            exports["inside-interaction"]:RemoveInteraction(v)
        end
        for k, v in ipairs(Blips) do
            if DoesBlipExist(Blips[k]) then
                RemoveBlip(Blips[k])
            end
        end
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if DoesEntityExist(CleanVehicle) or CleanVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(CleanVehicle)
        end
        JobStarted, isCleaned = false, false
        CleanLoc, CurrentPolyZone = 0, nil
        CleanVehicle, checkVehicle = nil, false
        CleanAmount, CleanedAmount = 0, 0
	end
end)
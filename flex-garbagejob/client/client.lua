local QBCore = exports['qb-core']:GetCoreObject()
local JobStarted, isGarbaged = false, false
local GarbageLoc, CurrentPolyZone, CurrentBlip = 0, nil, nil
local GarbageVehicle, checkVehicle = nil, false
local GarbageAmount, GarbagedAmount, GarbageBins = 0, 0, {}
local CurrentCar = nil

RegisterNetEvent('flex-garbagejob:client:startJob', function(GarbageLoc, Amount)
    ResetAllLocals()
    JobStarted = true
    GarbageAmount = Amount
    GarbageLoc = GarbageLoc
    if exports['rep-tablet']:IsGroupLeader() then
        local CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
        while IsPositionOccupied(CarSpawnLoc.x, CarSpawnLoc.y, CarSpawnLoc.z, 1.0, false,true, false, false,false,0,false) do
            CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
            Wait(1000)
        end
        local veh = QBCore.Functions.SpawnVehicle(Config.GarbageTruck, true, CarSpawnLoc, true, false)
        GarbageVehicle = veh
        exports['cdn-fuel']:SetFuel(GarbageVehicle, 75.0)
        local plate = QBCore.Functions.GetPlate(veh)
        exports['dusa_vehiclekeys']:AddKey(plate)
        checkVehicle = true
        MarkTarget(GarbageVehicle, 10)
        vehicleCheck(CarSpawnLoc, false, veh)
    end
    while CurrentPolyZone ~= nil do
        Wait(1000)
    end
    garbagezone(GarbageLoc)
end)

function vehicleCheck(loc, deleteveh, veh)
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
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
                    if IsPedInAnyVehicle(ped) and QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.GarbageTruck:lower()].brand:lower() then
                        TaskLeaveVehicle(ped, veh, 0)
                        Wait(2000)
                        if DoesEntityExist(GarbageVehicle) or GarbageVehicle ~= nil then
                            QBCore.Functions.DeleteVehicle(GarbageVehicle)
                        end
                        QBCore.Functions.DeleteVehicle(veh)
                        checkVehicle = false
                        exports["qb-core"]:HideText()
                        if CurrentPolyZone ~= nil then
                            CurrentPolyZone:destroy()
                        end
                        CurrentPolyZone = nil
                        -- if exports['rep-tablet']:IsGroupLeader() then
                            TriggerServerEvent('flex-garbagejob:server:finish')
                        -- end
                        TriggerServerEvent('flex-garbagejob:server:BLueprint')
                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end
                    end
                end
                sleep = 1
            else
                if #(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 10.0 then
                    if exports['rep-tablet']:IsGroupLeader() then
                        if IsPedInAnyVehicle(ped) then
                            if GetPedInVehicleSeat(GarbageVehicle, -1) == ped then
                                checkVehicle = false
                                CurrentPolyZone:destroy()
                                CurrentPolyZone = nil
                                TriggerServerEvent('flex-garbagejob:server:carState', GarbageAmount, NetworkGetNetworkIdFromEntity(veh))
                            end
                        end
                    end
                    if DoesBlipExist(CurrentBlip) then
                        RemoveBlip(CurrentBlip)
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

function garbagezone(id)
    local loc = Config.GarbageLocs[id]

    CurrentBlip = AddBlipForRadius(loc.coords.x, loc.coords.y, loc.coords.z, loc.radius)
    SetBlipSprite(CurrentBlip,1)
    SetBlipColour(CurrentBlip,69)
    SetBlipAlpha(CurrentBlip,75)
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, 69)

    local inzone, foundvalidtrash = false, false
    CurrentPolyZone = CircleZone:Create(vector3(loc.coords.x, loc.coords.y, loc.coords.z), loc.radius/5, {name = 'GarbageZone', useZ = true, debugPoly = Config.Debug,})
    CurrentPolyZone:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            inzone = true
            exports['qb-target']:AddTargetModel(Config.Garbagebins, {
                options = {
                    {
                        num = 1,
                        type = "server",
                        event = "flex-garbagejob:server:GarbageState",
                        icon = "fa-solid fa-trash-arrow-up",
                        label = Lang:t("target.grabgarbage"),
                        action = function(entity)
                            NetworkRequestControlOfEntity(entity)
                            NetworkRegisterEntityAsNetworked(entity)
                            local ped = PlayerPedId()
                            local veh = GarbageVehicle
                            local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                            local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                            if distance >= 25 then return QBCore.Functions.Notify(Lang:t("info.carnotfound"), 'info') end
                            if IsPedInAnyVehicle(ped) then return end
                            if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.GarbageTruck:lower()].brand:lower() then
                                foundtrashbin = false
                                if #GarbageBins > 0 then
                                    for k, v in ipairs(GarbageBins) do
                                        if v ~= NetworkGetNetworkIdFromEntity(entity) then
                                            foundtrashbin = true
                                        else
                                            foundtrashbin = false
                                            return QBCore.Functions.Notify(Lang:t("error.garbagebinempty"), 'error')
                                        end
                                        if k == #GarbageBins then
                                            if foundtrashbin then
                                                GarbageBins[#GarbageBins +1] = NetworkGetNetworkIdFromEntity(entity)
                                                TriggerServerEvent('flex-garbagejob:server:TakeBag')
                                                TriggerServerEvent('flex-garbagejob:server:GarbageState', GarbageBins, loc, GarbagedAmount + 1, GarbageAmount)
                                            else
                                                QBCore.Functions.Notify(Lang:t("error.garbagebinempty"), 'error')
                                            end
                                        end
                                    end
                                else
                                    GarbageBins[#GarbageBins +1] = NetworkGetNetworkIdFromEntity(entity)
                                    TriggerServerEvent('flex-garbagejob:server:TakeBag')
                                    TriggerServerEvent('flex-garbagejob:server:GarbageState', GarbageBins, loc, GarbagedAmount + 1, GarbageAmount)
                                end
                            end
                        end,
                        canInteract = function()
                            if not QBCore.Functions.HasItem(Config.Garbagebag, 1) and inzone then
                                return true
                            end
                        end
                    },
                },
                distance = 2.0
            })
        else
            inzone = false
            exports['qb-target']:RemoveTargetModel(Config.Garbagebins, Lang:t("target.grabgarbage"))
        end
    end)
end

RegisterNetEvent('flex-garbagejob:client:CarState', function(car)
    if car then
        GarbageVehicle = NetToVeh(car)
    end
end)

RegisterNetEvent('flex-garbagejob:client:GarbageState', function(bins, loc, Amount, GarbageAmount, isGarbaged)
    if loc.done then return end
    GarbagedAmount = Amount
    loc.done = true
    isGarbaged = isGarbaged
    GarbageBins = bins
    TriggerServerEvent('flex-garbagejob:server:Pay')
    if isGarbaged then
        exports['qb-target']:RemoveTargetModel(Config.Garbagebins, Lang:t("target.grabgarbage"))
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end

        CurrentBlip = CreateBlip(vec3(Config.CarDropOff.x, Config.CarDropOff.y, Config.CarDropOff.z), 50, 3, 0.8, Lang:t("blip.dropoff"))
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 9)

        checkVehicle = true
        vehicleCheck(Config.CarDropOff, true)
    end
end)

RegisterNetEvent('flex-garbagejob:client:finish', function()
    TriggerServerEvent('flex-garbagejob:server:rep', 'add', GarbagedAmount)
    ResetAllLocals()
    exports['qb-target']:RemoveTargetModel(Config.Garbagebins, Lang:t("target.grabgarbage"))
end)

RegisterNetEvent('flex-garbagejob:client:CheckIfFinished', function()
    if not isGarbaged then
        TriggerServerEvent('flex-garbagejob:server:rep', 'add', GarbagedAmount)
        if GarbageAmount ~= nil and GarbagedAmount ~= nil then
            if GarbageAmount == GarbagedAmount then return end
            QBCore.Functions.Notify(Lang:t("error.earlyclockout"), 'success')
            if GarbagedAmount > 0 then
                TriggerServerEvent('flex-garbagejob:server:rep', 'remove', GarbageAmount - GarbagedAmount)
            end
        end
        if DoesEntityExist(GarbageVehicle) or GarbageVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(GarbageVehicle)
        end
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        Wait(1000)
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end
        ResetAllLocals()
    end
end)


RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if DoesEntityExist(GarbageVehicle) or GarbageVehicle ~= nil then
        QBCore.Functions.DeleteVehicle(GarbageVehicle)
    end
    ResetAllLocals()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if DoesEntityExist(GarbageVehicle) or GarbageVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(GarbageVehicle)
        end
        ResetAllLocals()
	end
end)

function ResetAllLocals()
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end
    JobStarted, isGarbaged = false, false
    GarbageLoc, CurrentPolyZone, CurrentBlip = 0, nil, nil
    GarbageVehicle, checkVehicle = nil, false
    GarbageAmount, GarbagedAmount, GarbageBins = 0, 0, {}
end
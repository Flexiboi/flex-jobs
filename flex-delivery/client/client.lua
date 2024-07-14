local QBCore = exports['qb-core']:GetCoreObject()

local JobStarted = false
local PickUpState, DeliverStrate, FinishState = false, false, false
local CurrentPolyZone, CurrentInteractZone CurrentBlip, DeliverVehicle, CurrentObj, CurrentPed = nil, nil, nil, nil, nil, nil
local PickedUpAmount, DeliverAmount, DeliveredAmount = 0, 0, 0
local checkVehicle = false
local packages = {}

RegisterNetEvent('flex-delivery:client:startJob', function(PickupLock, DeliverLock, Amount)
    JobStarted = true
    DeliverAmount = Amount
    if exports['rep-tablet']:IsGroupLeader() then
        local CarSpawnLoc = Config.StartLocs[math.random(1, #Config.StartLocs)]
        while IsPositionOccupied(CarSpawnLoc.x, CarSpawnLoc.y, CarSpawnLoc.z, 1.0, false,true, false, false,false,0,false) do
            CarSpawnLoc = Config.StartLocs[math.random(1, #Config.StartLocs)]
            Wait(1000)
        end
        local veh = QBCore.Functions.SpawnVehicle(Config.DeliverCar, true, CarSpawnLoc, true, false)
        DeliverVehicle = veh
        local plate = QBCore.Functions.GetPlate(veh)
        exports['cdn-fuel']:SetFuel(veh, 75.0)
        exports['dusa_vehiclekeys']:AddKey(plate)
        checkVehicle = true
        MarkTarget(veh, 10)
        vehicleCheck(CarSpawnLoc, false, false, veh)
    end
    while CurrentPolyZone ~= nil do
        Wait(1000)
    end
    Pickup(PickupLock)
    Deliver(DeliverLock, PickupLock)
end)

function vehicleCheck(loc, deleteveh, notinzonecheck, veh)
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if CurrentInteractZone ~= nil then
        exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
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
                    if IsPedInAnyVehicle(ped) and QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.DeliverCar:lower()].brand:lower() then
                        TaskLeaveVehicle(ped, veh, 0)
                        Wait(2000)
                        if DoesEntityExist(DeliverVehicle) or DeliverVehicle ~= nil then
                            QBCore.Functions.DeleteVehicle(DeliverVehicle)
                        end
                        QBCore.Functions.DeleteVehicle(veh)
                        checkVehicle = false
                        TriggerServerEvent('flex-delivery:server:Update', {'getout', 0, DeliverAmount})
                        TriggerServerEvent('flex-delivery:server:State', 'finish', true)
                        exports["qb-core"]:HideText()
                        -- if exports['rep-tablet']:IsGroupLeader() then
                            TriggerServerEvent('flex-delivery:server:Finish')
                        -- end
                        TriggerServerEvent('flex-delivery:server:BLueprint')
                    end
                end
                sleep = 1
            else
                if #(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 10.0 then
                    if exports['rep-tablet']:IsGroupLeader() then
                        if IsPedInAnyVehicle(ped) then
                            if GetPedInVehicleSeat(DeliverVehicle, -1) == ped then
                                SetVehicleMod(GetVehiclePedIsIn(ped, false), 14, 27)
                                checkVehicle = false
                                TriggerServerEvent('flex-delivery:server:Update', {'getin', 0, DeliverAmount, NetworkGetNetworkIdFromEntity(veh)})
                                if CurrentPolyZone ~= nil then
                                    CurrentPolyZone:destroy()
                                end
                                if CurrentInteractZone ~= nil then
                                    if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
                                        exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
                                    end
                                end
                                CurrentPolyZone, CurrentInteractZone = nil, nil
                                exports["qb-core"]:HideText()
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

function DropOffmarker(coords, marker)
end

function Pickup(PickupLock)
    PickUpState = true

    CurrentBlip = CreateBlip(vec3(PickupLock.x, PickupLock.y, PickupLock.z), 50, 3, 0.8, Lang:t("pickup.blip"))
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, 9)

    local prop = Config.Pallets[math.random(1, #Config.Pallets)]
    local obj = GetClosestObjectOfType(PickupLock.x, PickupLock.y, PickupLock.z, 5.0, GetHashKey(prop), false, true ,true)
    if exports['rep-tablet']:IsGroupLeader() then
        while #(GetEntityCoords(obj) - vec3(PickupLock.x, PickupLock.y, PickupLock.z)) < 5.0 or obj ~= 0 do
            PickupLock = Config.PickupLocks[math.random(1, #Config.PickupLocks)]
            obj = GetClosestObjectOfType(PickupLock.x, PickupLock.y, PickupLock.z, 5.0, GetHashKey(prop), false, true ,true)
            Wait(1000)
        end
        if #(GetEntityCoords(obj) - vec3(PickupLock.x, PickupLock.y, PickupLock.z)) > 5.0 or obj == 0 then
            CurrentObj = CreateObject(prop, PickupLock.x, PickupLock.y, PickupLock.z-1, true, false, true, false, false)
            NetworkRequestControlOfEntity(CurrentObj)
            local timeWaited = 0
            while not NetworkHasControlOfEntity(CurrentObj) and timeWaited <= 500 do
                Wait(1)
                timeWaited = timeWaited + 1
            end
            SetEntityAsMissionEntity(CurrentObj, true, true)
            SetEntityCollision(CurrentObj, true)
            PlaceObjectOnGroundProperly(CurrentObj)
            SetEntityHeading(CurrentObj, PickupLock.w)
        end
    end

    CurrentInteractZone = exports["inside-interaction"]:AddInteractionCoords(vec3(PickupLock.x, PickupLock.y, PickupLock.z), {
        checkVisibility = false,
        distance = 8.0,
        {
            name = "deliveryinteract",
            icon = "fa-regular fa-circle-up",
            label = Lang:t("pickup.info.takebox"),
            key = "E",
            duration = 1000,
            action = function()
                local ped = PlayerPedId()
                local veh = DeliverVehicle
                local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                if distance >= 25 then return QBCore.Functions.Notify(Lang:t("info.carnotfound"), 'info') end
                if IsPedInAnyVehicle(ped) then return end
                if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.DeliverCar:lower()].brand:lower() then
                    if not QBCore.Functions.HasItem(Config.BoxItem, 1) then
                        TriggerServerEvent('flex-delivery:server:Update',{'pickup', PickedUpAmount, DeliverAmount})
                    end
                end
            end
        }
    })
end

function Deliver(DeliverLock, PickupLock)
    while PickUpState do
        Wait(1000)
    end

    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end

    CurrentBlip = CreateBlip(vec3(DeliverLock.x, DeliverLock.y, DeliverLock.z), 781, 3, 0.8, Lang:t("dropoff.blip"))
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, 9)

    if DoesEntityExist(CurrentObj) then
        DeleteEntity(CurrentObj)
    end
    Wait(100)
    if PickupLock ~= nil then
        local obj = GetClosestObjectOfType(PickupLock.x, PickupLock.y, PickupLock.z, 5.0, GetHashKey(Config.EmptyPallet), false, true ,true)
        if #(GetEntityCoords(obj) - vec3(PickupLock.x, PickupLock.y, PickupLock.z)) > 5.0 or obj == 0 then
            CurrentObj = CreateObject(Config.EmptyPallet, PickupLock.x, PickupLock.y, PickupLock.z-1, true, false, true, false, false)
            NetworkRequestControlOfEntity(CurrentObj)
            local timeWaited = 0
            while not NetworkHasControlOfEntity(CurrentObj) and timeWaited <= 500 do
                Wait(1)
                timeWaited = timeWaited + 1
            end
            SetEntityAsMissionEntity(CurrentObj, true, true)
            SetEntityCollision(CurrentObj, true)
            PlaceObjectOnGroundProperly(CurrentObj)
            SetEntityHeading(CurrentObj, PickupLock.w)
        end
    end

    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if CurrentInteractZone ~= nil then
        if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
            exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
        end
    end

    DeliverStrate = true

    if exports['rep-tablet']:IsGroupLeader() then
        CurrentPed = CreatePedAtCoords(Config.Peds.models[math.random(1, #Config.Peds.models)], DeliverLock, Config.Peds.scenarios[math.random(1, #Config.Peds.scenarios)])
    end

    CurrentInteractZone = exports["inside-interaction"]:AddInteractionCoords(vec3(DeliverLock.x, DeliverLock.y, DeliverLock.z), {
        checkVisibility = true,
        distance = 8.0,
        {
            name = "deliveryinteract",
            icon = "fa-regular fa-circle-up",
            label = Lang:t("dropoff.info.deliverbox"),
            key = "E",
            duration = 1000,
            action = function()
                local ped = PlayerPedId()
                local veh = DeliverVehicle
                local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                if distance >= 25 then return QBCore.Functions.Notify(Lang:t("info.carnotfound"), 'info') end
                if IsPedInAnyVehicle(ped) then return end
                if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.DeliverCar:lower()].brand:lower() then
                    if QBCore.Functions.HasItem(Config.BoxItem, 1) then
                        TriggerServerEvent('flex-delivery:server:Update', {'deliver', DeliveredAmount, DeliverAmount, DeliverLock})
                    end
                end
            end
        }
    })
end

RegisterNetEvent('flex-delivery:client:CarState', function(car)
    print(car)
    if car then
        DeliverVehicle = NetToVeh(car)
    end
end)

RegisterNetEvent('flex-delivery:client:Update', function(updateType, Amount, DelivAmount, dropOffloc)
    if exports['rep-tablet']:IsGroupLeader() then
        if CurrentPed ~= nil then
            if DoesEntityExist(CurrentPed) then
                DeleteEntity(CurrentPed)
            end
        end
    end
    if updateType == 'deliver' and DeliverStrate then
        DeliveredAmount = Amount
        if Amount >= DeliverAmount then
            if DoesBlipExist(CurrentBlip) then
                RemoveBlip(CurrentBlip)
            end
            if CurrentPolyZone ~= nil then
                CurrentPolyZone:destroy()
            end
            if CurrentInteractZone ~= nil then
                if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
                    exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
                end
            end
            TriggerServerEvent('flex-delivery:server:State', 'deliver', false)
            checkVehicle = true
            --if exports['rep-tablet']:IsGroupLeader() then
            CurrentBlip = CreateBlip(vec3(Config.CarDropOff.x, Config.CarDropOff.y, Config.CarDropOff.z), 50, 3, 0.8, Lang:t("blip.dropoff"))
            SetBlipRoute(CurrentBlip, true)
            SetBlipRouteColour(CurrentBlip, 9)
            vehicleCheck(Config.CarDropOff, true, true)
            if DoesBlipExist(CurrentBlip) then
                RemoveBlip(CurrentBlip)
            end
            --end
        elseif Amount < DeliverAmount then
            Deliver(dropOffloc)
            TriggerServerEvent('flex-delivery:server:paydelivery')
        end
    elseif updateType == 'pickup' and PickUpState then
        PickedUpAmount = Amount
        if PickedUpAmount == DeliverAmount then
            PickUpState = false
            DeliverStrate =  true
        end
    end
end)

RegisterNetEvent('flex-delivery:client:State', function(state, bool)
    if state == 'pickup' then
        PickUpState = bool
    elseif state == 'deliver' then
        DeliverStrate = bool
    elseif state == 'finish' then
        FinishState = bool
    end
end)

RegisterNetEvent('flex-delivery:client:Finish', function()
    QBCore.Functions.Notify(Lang:t("success.successended"), 'success')
    TriggerServerEvent('flex-delivery:server:Rep', 'add', DeliveredAmount)
    TriggerServerEvent('flex-delivery:server:paydelivery')
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if CurrentInteractZone ~= nil then
        if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
            exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
        end
    end
    JobStarted = false
    PickUpState, DeliverStrate, FinishState = false, false, false
    CurrentPolyZone, CurrentInteractZone,CurrentBlip, DeliverVehicle, CurrentObj = nil, nil, nil, nil, nil
    PickedUpAmount, DeliverAmount, DeliveredAmount = 0, 0, 0
    checkVehicle = false
end)

RegisterNetEvent('flex-delivery:client:CheckIfFinished', function()
    if FinishState then
        TriggerServerEvent('flex-delivery:server:rep', 'add', DeliveredAmount)
    else
        if DeliverAmount ~= DeliveredAmount then
            QBCore.Functions.Notify(Lang:t("error.earlyclockout"), 'success')
            if DeliveredAmount > 0 then
                TriggerServerEvent('flex-delivery:server:rep', 'remove', DeliverAmount - DeliveredAmount)
            end
        end
        if DoesEntityExist(DeliverVehicle) or DeliverVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(DeliverVehicle)
        end
        JobStarted = false
        PickUpState, DeliverStrate, FinishState = false, false, false
        PickedUpAmount, DeliverAmount, DeliveredAmount = 0, 0, 0
        checkVehicle = false
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if CurrentInteractZone ~= nil then
            if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
                exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
            end
        end
        CurrentPolyZone, CurrentInteractZone, CurrentBlip, DeliverVehicle, CurrentObj = nil, nil, nil, nil, nil
        Wait(1000)
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if CurrentInteractZone ~= nil then
            if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
                exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
            end
        end
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end
        if DoesEntityExist(CurrentObj) then
            DeleteEntity(CurrentObj)
        end
    end
end)

RegisterNetEvent('flex-delivery:client:rep', function(addremove)
    TriggerServerEvent('flex-delivery:server:rep', addremove, DeliverAmount - DeliveredAmount)
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if CurrentInteractZone ~= nil then
        if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
            exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
        end
    end
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end
    if DoesEntityExist(DeliverVehicle) or DeliverVehicle ~= nil then
        QBCore.Functions.DeleteVehicle(DeliverVehicle)
    end
    if DoesEntityExist(CurrentObj) then
        DeleteEntity(CurrentObj)
    end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        if CurrentPolyZone ~= nil then
            CurrentPolyZone:destroy()
        end
        if CurrentInteractZone ~= nil then
            if exports["inside-interaction"]:DoesInteractionExitst(CurrentInteractZone) then
                exports["inside-interaction"]:RemoveInteraction(CurrentInteractZone)
            end
        end
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end
        if DoesEntityExist(DeliverVehicle) or DeliverVehicle ~= nil then
            QBCore.Functions.DeleteVehicle(DeliverVehicle)
        end
        if DoesEntityExist(CurrentObj) then
            DeleteEntity(CurrentObj)
        end
	end
end)
local QBCore = exports['qb-core']:GetCoreObject()
local JobStarted, IsElectriced = false, false
local ElectricLoc, CurrentPolyZone, CurrentBlip = 0, nil, nil
local ElectricVehicle, checkVehicle = nil, false
local ElectricAmount, ElectricedAmount, Cabinets = 0, 0, {}
local CurrentCar = nil

RegisterNetEvent('flex-electricjob:client:startJob', function(ElectricLoc, Amount)
    reset()
    JobStarted = true
    ElectricAmount = Amount
    ElectricLoc = ElectricLoc
    if exports['rep-tablet']:IsGroupLeader() then
        local CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
        while IsPositionOccupied(CarSpawnLoc.x, CarSpawnLoc.y, CarSpawnLoc.z, 1.0, false,true, false, false,false,0,false) do
            CarSpawnLoc = Config.CarLocs[math.random(1, #Config.CarLocs)]
            Wait(1000)
        end
        
        local veh = QBCore.Functions.SpawnVehicle(Config.JobVehicle, true, CarSpawnLoc, true, false)
        ElectricVehicle = veh
        exports['cdn-fuel']:SetFuel(veh, 75.0)
        local plate = QBCore.Functions.GetPlate(veh)
        exports['dusa_vehiclekeys']:AddKey(plate)
        checkVehicle = true
        MarkTarget(veh, 10)
        vehicleCheck(CarSpawnLoc, false, false, veh)
    end
    while CurrentPolyZone ~= nil do
        Wait(1000)
    end
    ElectricZone(ElectricLoc)
end)

function vehicleCheck(loc, deleteveh, notinzonecheck, veh)
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
                    if IsPedInAnyVehicle(ped) and QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.JobVehicle:lower()].brand:lower() then
                        TaskLeaveVehicle(ped, veh, 0)
                        Wait(2000)
                        if DoesEntityExist(ElectricVehicle) or ElectricVehicle ~= nil then
                            QBCore.Functions.DeleteVehicle(ElectricVehicle)
                        end
                        QBCore.Functions.DeleteVehicle(veh)
                        checkVehicle = false
                        exports["qb-core"]:HideText()
                        if CurrentPolyZone ~= nil then
                            CurrentPolyZone:destroy()
                            CurrentPolyZone = nil
                        end
                        if exports['rep-tablet']:IsGroupLeader() then
                            TriggerServerEvent('flex-electricjob:server:finish')
                        end
                        TriggerServerEvent('flex-electricjob:server:BLueprint')
                        if DoesBlipExist(CurrentBlip) then
                            RemoveBlip(CurrentBlip)
                        end
                    end
                end
                sleep = 1
            else
                if #(GetEntityCoords(ped) - vec3(loc.x, loc.y, loc.z)) < 10.0 then
                    if IsPedInAnyVehicle(ped) then
                        local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                        local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                        if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.JobVehicle:lower()].brand:lower() then
                            if exports['rep-tablet']:IsGroupLeader() then
                                if GetPedInVehicleSeat(veh, -1) == ped then
                                    checkVehicle = false
                                    CurrentPolyZone:destroy()
                                    CurrentPolyZone = nil
                                    TriggerServerEvent('flex-electricjob:server:carState', ElectricAmount, NetworkGetNetworkIdFromEntity(veh))
                                end
                            end
                        end
                    end
                    Wait(100)
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

function ElectricZone(id)
    local loc = Config.ElectricZones[id]

    CurrentBlip = AddBlipForRadius(loc.coords.x, loc.coords.y, loc.coords.z, loc.radius)
    SetBlipSprite(CurrentBlip,1)
    SetBlipColour(CurrentBlip,69)
    SetBlipAlpha(CurrentBlip,75)
    SetBlipRoute(CurrentBlip, true)
    SetBlipRouteColour(CurrentBlip, 69)

    local inzone, foundvalidcabin = false, false
    CurrentPolyZone = CircleZone:Create(vector3(loc.coords.x, loc.coords.y, loc.coords.z), loc.radius/5, {name = 'ElectricZone', useZ = true, debugPoly = Config.Debug,})
    CurrentPolyZone:onPlayerInOut(function(isPointInside, _, zone)
        if isPointInside then
            inzone = true
            exports['qb-target']:AddTargetModel(Config.Cabinets, {
                options = {
                    {
                        num = 1,
                        type = "server",
                        event = "flex-electricjob:server:ElectricState",
                        icon = "fa-solid fa-bolt",
                        label = Lang:t("target.work"),
                        action = function(entity)
                            NetworkRequestControlOfEntity(entity)
                            NetworkRegisterEntityAsNetworked(entity)
                            local ped = PlayerPedId()
                            local veh = ElectricVehicle
                            local distance = #(GetEntityCoords(veh) - GetEntityCoords(ped))
                            local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(veh))
                            if distance >= 25 then return QBCore.Functions.Notify(Lang:t("info.carnotfound"), 'info') end
                            if IsPedInAnyVehicle(ped) then return end
                            if QBCore.Shared.Vehicles[vehname:lower()].brand:lower() == QBCore.Shared.Vehicles[Config.JobVehicle:lower()].brand:lower() then
                                foundvalidcabin = false
                                if #Cabinets > 0 then
                                    for k, v in ipairs(Cabinets) do
                                        if v ~= NetworkGetNetworkIdFromEntity(entity) then
                                            foundvalidcabin = true
                                        else
                                            foundvalidcabin = false
                                            return QBCore.Functions.Notify(Lang:t("error.cabinalreadyfiued"), 'error')
                                        end
                                        if k == #Cabinets then
                                            if foundvalidcabin then
                                                local ped = PlayerPedId()
                                                local prop = "h4_prop_h4_bolt_cutter_01a"
                                                LoadModel(prop)
                                                local cutteritem = CreateBoltCutter(prop, ped)
                                                -- SetEntityHeading(ped, GetEntityHeading(entity))
                                                local cabinetcoords = GetEntityCoords(entity)
                                                QBCore.Functions.FaceToPos(cabinetcoords.x, cabinetcoords.y, cabinetcoords.z)
                                                AttachEntityToEntity(cutteritem, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.03, 0.0, 0.0, 0.0, -90.0, 0.0, true, true, false, true, 1, true)
                                                QBCore.Functions.Progressbar('repaircabin', Lang:t("progress.repairing"), 6000, false, true, {
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true,
                                                }, {
                                                    animDict = 'anim@scripted@heist@ig4_bolt_cutters@male@',
                                                    anim = 'action_male',
                                                    flags = 16,
                                                }, {}, {}, function()
                                                    Cabinets[#Cabinets +1] = NetworkGetNetworkIdFromEntity(entity)
                                                    TriggerServerEvent('flex-electricjob:server:ElectricState', Cabinets, loc, ElectricedAmount + 1, ElectricAmount)
                                                    DeleteEntity(cutteritem)
                                                end, function()
                                                    QBCore.Functions.Notify(Lang:t("error.canceled"), "error")
                                                    DeleteEntity(cutteritem)
                                                end)
                                            else
                                                QBCore.Functions.Notify(Lang:t("error.cabinalreadyfiued"), 'error')
                                            end
                                        end
                                    end
                                else
                                    local ped = PlayerPedId()
                                    local prop = "h4_prop_h4_bolt_cutter_01a"
                                    LoadModel(prop)
                                    local cutteritem = CreateBoltCutter(prop, ped)
                                    -- SetEntityHeading(ped, GetEntityHeading(entity))
                                    local cabinetcoords = GetEntityCoords(entity)
                                    QBCore.Functions.FaceToPos(cabinetcoords.x, cabinetcoords.y, cabinetcoords.z)
                                    AttachEntityToEntity(cutteritem, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.03, 0.0, 0.0, 0.0, -90.0, 0.0, true, true, false, true, 1, true)
                                    QBCore.Functions.Progressbar('repaircabin', Lang:t("progress.repairing"), 6000, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = 'anim@scripted@heist@ig4_bolt_cutters@male@',
                                        anim = 'action_male',
                                        flags = 16,
                                    }, {}, {}, function()
                                        Cabinets[#Cabinets +1] = NetworkGetNetworkIdFromEntity(entity)
                                        TriggerServerEvent('flex-electricjob:server:ElectricState', Cabinets, loc, ElectricedAmount + 1, ElectricAmount)
                                        DeleteEntity(cutteritem)
                                    end, function()
                                        QBCore.Functions.Notify(Lang:t("error.canceled"), "error")
                                        DeleteEntity(cutteritem)
                                    end)
                                end
                            end
                        end,
                        canInteract = function()
                            if inzone and not IsElectriced then
                                return true
                            end
                        end
                    },
                },
                distance = 2.0
            })
        else
            inzone = false
            exports['qb-target']:RemoveTargetModel(Config.Cabinets, Lang:t("target.work"))
        end
    end)
end

RegisterNetEvent('flex-electricjob:client:ElectricState', function(Cabins, loc, Amount, ElectricAmount, IsElectriced)
    if loc.done then return end
    ElectricedAmount = Amount
    loc.done = true
    IsElectriced = IsElectriced
    Cabinets = Cabins
    Wait(200)
    if IsElectriced then
        exports['qb-target']:RemoveTargetModel(Config.Cabinets, Lang:t("target.work"))
        if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
        end
        checkVehicle = true
        CurrentBlip = CreateBlip(vec3(Config.CarDropOff.x, Config.CarDropOff.y, Config.CarDropOff.z), 50, 3, 0.8, Lang:t("info.dropoffblip"))
        SetBlipRoute(CurrentBlip, true)
        SetBlipRouteColour(CurrentBlip, 9)
        vehicleCheck(Config.CarDropOff, true, true)
    end
    TriggerServerEvent('flex-electricjob:server:payelectric')
end)

RegisterNetEvent('flex-electricjob:client:SetCarState', function(car)
    if car then
        ElectricVehicle = NetToVeh(car)
    end
end)

RegisterNetEvent('flex-electricjob:client:finish', function()
    if not IsElectriced then
        TriggerServerEvent('flex-electricjob:server:rep', 'add', ElectricedAmount)
        reset()
    end
end)

RegisterNetEvent('flex-electricjob:client:CheckIfFinished', function()
    if not IsElectriced then
        if ElectricAmount ~= ElectricedAmount then
            QBCore.Functions.Notify(Lang:t("error.earlyclockout"), 'success')
            if ElectricedAmount > 0 then
                TriggerServerEvent('flex-electricjob:server:rep', 'remove', ElectricAmount - ElectricedAmount)
            end
        end
        reset()
    end
end)

function reset()
    if DoesBlipExist(CurrentBlip) then
        RemoveBlip(CurrentBlip)
    end
    if CurrentPolyZone ~= nil then
        CurrentPolyZone:destroy()
    end
    if DoesEntityExist(ElectricVehicle) or ElectricVehicle ~= nil then
        QBCore.Functions.DeleteVehicle(ElectricVehicle)
    end
    JobStarted, IsElectriced = false, false
    ElectricLoc, CurrentPolyZone = 0, nil
    ElectricVehicle, checkVehicle = nil, false
    ElectricAmount, ElectricedAmount = 0, 0
end

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()
    reset()
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
        reset()
	end
end)
local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-delivery:server:startJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if k == #Config.Rep then
            if rep.delivery < Config.Rep[1].MinRep then
                if rep.delivery <= Config.DontAllowToWorkHereRep then
                    return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                end
            end
        end
    end
    if exports['rep-tablet']:isGroupLeader(src, group) then
        local DeliverAmount = 0
        for k, v in ipairs(Config.Rep) do
            if rep.delivery >= v.MinRep and rep.delivery < v.MaxRep then
                DeliverAmount = math.random(math.floor(v.MaxDelivers/2), v.MaxDelivers)

                local playerPed = GetPlayerPed(src)
                local playerCoords = GetEntityCoords(playerPed)
                local dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                while #(playerCoords - vec3(dropOffloc.x, dropOffloc.y, dropOffloc.z)) < 10.0 do
                    dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                end

                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:startJob', 
                {Config.PickupLocks[math.random(1, #Config.PickupLocks)], dropOffloc, DeliverAmount})
                SetStartJobStatus(group, DeliverAmount)
                return
            elseif rep.delivery > Config.Rep[#Config.Rep].MinRep then
                DeliverAmount = Config.Rep[#Config.Rep].MaxDelivers

                local playerPed = GetPlayerPed(src)
                local playerCoords = GetEntityCoords(playerPed)
                local dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                while #(playerCoords - vec3(dropOffloc.x, dropOffloc.y, dropOffloc.z)) < 10.0 do
                    dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                end

                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:startJob', 
                {Config.PickupLocks[math.random(1, #Config.PickupLocks)], dropOffloc, DeliverAmount})
                SetStartJobStatus(group, DeliverAmount)
                return
            elseif k == #Config.Rep then
                if rep.delivery < Config.Rep[1].MinRep then
                    if rep.delivery <= Config.DontAllowToWorkHereRep then
                        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                    else
                        DeliverAmount = 1

                        local playerPed = GetPlayerPed(src)
                        local playerCoords = GetEntityCoords(playerPed)
                        local dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                        while #(playerCoords - vec3(dropOffloc.x, dropOffloc.y, dropOffloc.z)) < 10.0 do
                            dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
                        end

                        exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:startJob', 
                        {Config.PickupLocks[math.random(1, #Config.PickupLocks)], dropOffloc, DeliverAmount})
                        SetStartJobStatus(group, DeliverAmount)
                        return
                    end
                end
            end
        end
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.startmsg"), "fa-solid fa-truck", '#57d3de', 3000)
    end
end)

function SetStartJobStatus(group, DeliverAmount)
    local stages = {
        [1] = {
            id = 1,
            name = 'Haal je busje op.',
            max = 1,
            count = 0,
            isDone = false,
        },
        [2] = {
            id = 2,
            name = 'Verzamel / haal alle pakjes.',
            max = DeliverAmount,
            count = 0,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever alle pakjes.',
            max = DeliverAmount,
            count = 0,
            isDone = false,
        },
        [4] = {
            id = 1,
            name = 'Lever je busje terug in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    exports['rep-tablet']:setJobStatus(group, stages)
end

RegisterNetEvent('flex-delivery:server:Update', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    if data[1] == 'deliver' then
        --if exports['rep-tablet']:isGroupLeader(src, group) then
            local playerPed = GetPlayerPed(src)
            local playerCoords = GetEntityCoords(playerPed)
            local dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
            -- while #(playerCoords - vec3(dropOffloc.x, dropOffloc.y, dropOffloc.z)) < 10.0 do
            --     dropOffloc = Config.DeliverLocks[math.random(1, #Config.DeliverLocks)]
            --     Wait(100)
            -- end

            Player.Functions.RemoveItem(Config.BoxItem, 1)
            if data[2]+1 >= data[3] then
                exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("dropoff.info.finishdropoff"), "fa-solid fa-truck", '#57d3de', 3000)
                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:Update', 
                {'deliver', data[3], data[3], dropOffloc})
                local stages = {
                    [1] = {
                        id = 1,
                        name = 'Haal je busje op.',
                        max = 1,
                        count = 1,
                        isDone = true,
                    },
                    [2] = {
                        id = 2,
                        name = 'Verzamel / haal alle pakjes.',
                        max = data[3],
                        count = data[3],
                        isDone = true,
                    },
                    [3] = {
                        id = 3,
                        name = 'Lever alle pakjes.',
                        max = data[3],
                        count = data[3],
                        isDone = true,
                    },
                    [4] = {
                        id = 1,
                        name = 'Lever je busje terug in.',
                        max = 1,
                        count = 0,
                        isDone = false,
                    }
                }
                exports['rep-tablet']:setJobStatus(group, stages)
                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:rep',{'add'})
            else
                exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("dropoff.info.nextdropoff"), "fa-solid fa-truck", '#57d3de', 3000)
                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:Update', 
                {'deliver', data[2]+1, data[3], dropOffloc})
                local stages = {
                    [1] = {
                        id = 1,
                        name = 'Haal je busje op.',
                        max = 1,
                        count = 1,
                        isDone = true,
                    },
                    [2] = {
                        id = 2,
                        name = 'Verzamel / haal alle pakjes.',
                        max = data[3],
                        count = data[3],
                        isDone = false,
                    },
                    [3] = {
                        id = 3,
                        name = 'Lever alle pakjes.',
                        max = data[3],
                        count = data[2]+1,
                        isDone = false,
                    },
                    [4] = {
                        id = 1,
                        name = 'Lever je busje terug in.',
                        max = 1,
                        count = 0,
                        isDone = false,
                    }
                }
                exports['rep-tablet']:setJobStatus(group, stages)
                exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:rep',{'add'})
            end
        --end
    elseif data[1] == 'pickup' then
        --if exports['rep-tablet']:isGroupLeader(src, group) then
            exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:Update', 
            {'pickup', data[2]+1})
            Player.Functions.AddItem(Config.BoxItem, 1)
            TriggerClientEvent("inventory:client:ItemBox", src, QBCore.Shared.Items[Config.BoxItem], "add")
            if data[2]+1 == DeliverAmount then
                exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.godeliver"), "fa-solid fa-truck", '#57d3de', 3000)
                local stages = {
                    [1] = {
                        id = 1,
                        name = 'Haal je busje op.',
                        max = 1,
                        count = 1,
                        isDone = true,
                    },
                    [2] = {
                        id = 2,
                        name = 'Verzamel / haal alle pakjes.',
                        max = data[3],
                        count = data[2]+1,
                        isDone = true,
                    },
                    [3] = {
                        id = 3,
                        name = 'Lever alle pakjes.',
                        max = data[3],
                        count = 0,
                        isDone = false,
                    },
                    [4] = {
                        id = 1,
                        name = 'Lever je busje terug in.',
                        max = 1,
                        count = 0,
                        isDone = false,
                    }
                }
                exports['rep-tablet']:setJobStatus(group, stages)
            else
                local stages = {
                    [1] = {
                        id = 1,
                        name = 'Haal je busje op.',
                        max = 1,
                        count = 1,
                        isDone = true,
                    },
                    [2] = {
                        id = 2,
                        name = 'Verzamel / haal alle pakjes.',
                        max = data[3],
                        count = data[2]+1,
                        isDone = false,
                    },
                    [3] = {
                        id = 3,
                        name = 'Lever alle pakjes.',
                        max = data[3],
                        count = 0,
                        isDone = false,
                    },
                    [4] = {
                        id = 1,
                        name = 'Lever je busje terug in.',
                        max = 1,
                        count = 0,
                        isDone = false,
                    }
                }
                exports['rep-tablet']:setJobStatus(group, stages)
            end
        --end
    elseif data[1] == 'getin' then
        local stages = {
            [1] = {
                id = 1,
                name = 'Haal je busje op.',
                max = 1,
                count = 1,
                isDone = true,
            },
            [2] = {
                id = 2,
                name = 'Verzamel / haal alle pakjes.',
                max = DeliverAmount,
                count = 0,
                isDone = false,
            },
            [3] = {
                id = 3,
                name = 'Lever alle pakjes.',
                max = DeliverAmount,
                count = 0,
                isDone = false,
            },
            [4] = {
                id = 1,
                name = 'Lever je busje terug in.',
                max = 1,
                count = 0,
                isDone = false,
            }
        }
        exports['rep-tablet']:setJobStatus(group, stages)
        exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:CarState', {data[4]})
    elseif data[1] == 'getout' then
        local stages = {
            [1] = {
                id = 1,
                name = 'Haal je busje op.',
                max = 1,
                count = 1,
                isDone = true,
            },
            [2] = {
                id = 2,
                name = 'Verzamel / haal alle pakjes.',
                max = DeliverAmount,
                count = DeliverAmount,
                isDone = true,
            },
            [3] = {
                id = 3,
                name = 'Lever alle pakjes.',
                max = DeliverAmount,
                count = DeliverAmount,
                isDone = true,
            },
            [4] = {
                id = 1,
                name = 'Lever je busje terug in.',
                max = 1,
                count = 1,
                isDone = true,
            }
        }
        exports['rep-tablet']:setJobStatus(group, stages)
    elseif data[1] == 'package' then
        TriggerClientEvent('flex-delivery:client:Update', -1, 'package', data[2], data[3])
    end
end)

RegisterNetEvent('flex-delivery:server:State', function(state, bool)
    local src = source
    local group = exports['rep-tablet']:getGroupByMembers(src)
    exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:State', 
    {state, bool})
end)

RegisterNetEvent('flex-delivery:server:Finish', function()
    local src = source
    local group = exports['rep-tablet']:getGroupByMembers(src)
    exports['rep-tablet']:resetJobStatus(group)
    if exports['rep-tablet']:isGroupLeader(src, group) then
        exports['rep-tablet']:GroupEvent(group, 'flex-delivery:client:Finish',{})
    end
end)

RegisterNetEvent('flex-delivery:server:paydelivery', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if rep.delivery >= v.MinRep and rep.delivery < v.MaxRep then
            local amount = v.PayPerDeliver
            Player.Functions.AddMoney('cash', amount, 'Levering')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
            exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
        elseif k == #Config.Rep then
            if rep.delivery > Config.Rep[#Config.Rep].MinRep then
                local amount = v.PayPerDeliver
                Player.Functions.AddMoney('cash', amount, 'Levering')
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
                exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
            end
        end
    end 
end)

RegisterNetEvent('flex-delivery:server:BLueprint', function()
    local src = source
    exports['flex-crafting']:GiveBluePrint(src, Config.BluePrint.items[math.random(1, #Config.BluePrint.items)], Config.BluePrint.chance)
end)

RegisterNetEvent('flex-delivery:server:rep', function(addremove, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    local a = amount or 1
    if addremove == 'add' then
        for k, v in ipairs(Config.Rep) do
            if rep.delivery >= v.MinRep and rep.delivery < v.MaxRep then
                local testrep = v.RepEarning * a
                if testrep == 0 then
                    testrep = v.RepEarning
                end
                exports["cw-rep"]:updateSkill(src, 'delivery', testrep)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                break
            elseif k == #Config.Rep then
                if rep.delivery < Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'delivery', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                elseif rep.delivery > Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'delivery', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                end
            end
        end
    elseif addremove == 'remove' then
        if a > 0 then
            for k, v in ipairs(Config.Rep) do
                if rep.delivery >= v.MinRep and rep.delivery < v.MaxRep then

                    local testrep = v.RepLoss * a
                    if testrep == 0 then
                        testrep = v.RepLoss
                    end
                    exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                    break
                elseif k == #Config.Rep then
                    if rep.delivery < Config.Rep[1].MinRep then
    
                        local testrep = v.RepLoss * a
                        if testrep == 0 then
                            testrep = v.RepLoss
                        end
                        exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                        break
                    elseif rep.delivery > Config.Rep[#Config.Rep].MinRep then
    
                        local testrep = v.RepLoss * a
                        if testrep == 0 then
                            testrep = v.RepLoss
                        end
                        exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                        break
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('flex-delivery:server:checkRep', function()
    local src = source
    local playerSkills = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep', {value = playerSkills.delivery}), 'primary')
end)

QBCore.Commands.Add('deliveryrep', Lang:t('command.help'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = playerSkills.delivery}), 'primary')
end)
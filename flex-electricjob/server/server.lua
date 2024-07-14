local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-electricjob:server:startJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if k == #Config.Rep then
            if rep.electric < Config.Rep[1].MinRep then
                if rep.electric <= Config.DontAllowToWorkHereRep then
                    return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                end
            end
        end
    end
    if exports['rep-tablet']:isGroupLeader(src, group) then
        local ElectricLoc, ElectricAmount = 0, 0
        for k, v in ipairs(Config.Rep) do
            if rep.electric >= v.MinRep and rep.electric < v.MaxRep then
                ElectricLoc = math.random(1, #Config.ElectricZones)
                ElectricAmount = math.random(v.MinCabinets, v.MaxCabinets)
                exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:startJob', 
                {ElectricLoc, ElectricAmount})
                return
            elseif rep.electric > Config.Rep[#Config.Rep].MinRep then
                ElectricLoc = math.random(1, #Config.ElectricZones)
                ElectricAmount = math.random(v.MinCabinets, v.MaxCabinets)

                exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:startJob', 
                {ElectricLoc, ElectricAmount})
                return
            elseif k == #Config.Rep then
                if rep.electric < Config.Rep[1].MinRep then
                    if rep.electric <= Config.DontAllowToWorkHereRep then
                        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                    else
                        ElectricLoc = math.random(1, #Config.ElectricZones)
                        ElectricAmount = 1

                        exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:startJob', 
                        {ElectricLoc, ElectricAmount})
                        return
                    end
                end
            end
        end
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.startmsg"), "fa-solid fa-truck", '#57d3de', 3000)
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
                name = 'Ga de kastjes repareren.',
                max = ElectricAmount,
                count = 0,
                isDone = false,
            },
            [3] = {
                id = 3,
                name = 'Lever je busje in.',
                max = 1,
                count = 0,
                isDone = false,
            }
        }
        exports['rep-tablet']:setJobStatus(group, stages)
    end
end)

RegisterNetEvent('flex-electricjob:server:carState', function(ElectricAmount, car)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
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
            name = 'Ga de kastjes repareren.',
            max = ElectricAmount,
            count = 0,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.pickedupcar"), "fa-solid fa-truck", '#57d3de', 3000)
    exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:SetCarState', {car})
end)

RegisterNetEvent('flex-electricjob:server:ElectricState', function(Cabins, loc, ElectricedAmount, ElectricAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local IsElectriced = false

    local newAmount = ElectricAmount - ElectricedAmount
    if newAmount <= 0 then
        newAmount = 0
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.repairedfinish"), "fa-solid fa-truck", '#57d3de', 3000)
    else
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.repaired", {value = newAmount}), "fa-solid fa-truck", '#57d3de', 3000)
    end
    local stages = {
        [1] = {
            id = 1,
            name = 'Haal je busje op.',
            max = 1,
            count = 0,
            isDone = true,
        },
        [2] = {
            id = 2,
            name = 'Ga de kastjes repareren.',
            max = ElectricAmount,
            count = ElectricedAmount,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    if newAmount == 0 then
        stages[2] = {
            id = 2,
            name = 'Ga de kastjes repareren.',
            max = ElectricAmount,
            count = ElectricAmount,
            isDone = true,
        }
        IsElectriced = true
    end
    
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:ElectricState', 
    {Cabins, loc, ElectricedAmount, ElectricAmount, IsElectriced})
end)

RegisterNetEvent('flex-electricjob:server:finish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    exports['rep-tablet']:resetJobStatus(group)
    exports['rep-tablet']:GroupEvent(group, 'flex-electricjob:client:finish', 
    {})
end)

RegisterNetEvent('flex-electricjob:server:payelectric', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if rep.electric >= v.MinRep and rep.electric < v.MaxRep then
            local amount = v.PayPerCabinet
            Player.Functions.AddMoney('cash', amount, 'Kastje gemaakt')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
            exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
        elseif k == #Config.Rep then
            if rep.electric > Config.Rep[#Config.Rep].MinRep then
                local amount = v.PayPerCabinet
                Player.Functions.AddMoney('cash', amount, 'Kastje gemaakt')
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
                exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
            end
        end
    end 
end)

RegisterNetEvent('flex-electricjob:server:BLueprint', function()
    local src = source
    exports['flex-crafting']:GiveBluePrint(src, Config.BluePrint.items[math.random(1, #Config.BluePrint.items)], Config.BluePrint.chance)
end)

RegisterNetEvent('flex-electricjob:server:rep', function(addremove, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    local a = amount or 1
    if addremove == 'add' then
        for k, v in ipairs(Config.Rep) do
            if rep.electric >= v.MinRep and rep.electric < v.MaxRep then
                local testrep = v.RepEarning * a
                if testrep == 0 then
                    testrep = v.RepEarning
                end
                exports["cw-rep"]:updateSkill(src, 'electric', testrep)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                break
            elseif k == #Config.Rep then
                if rep.electric < Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'electric', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                elseif rep.electric > Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'electric', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                end
            end
        end
    elseif addremove == 'remove' then
        if a > 0 then
            for k, v in ipairs(Config.Rep) do
                if rep.electric >= v.MinRep and rep.electric < v.MaxRep then
                    local testrep = v.RepLoss * a
                    if testrep == 0 then
                        testrep = v.RepLoss
                    end
                    exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                elseif k == #Config.Rep then
                    if rep.electric < Config.Rep[1].MinRep then
                        local testrep = v.RepLoss * a
                        if testrep == 0 then
                            testrep = v.RepLoss
                        end
                        exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                    elseif rep.electric > Config.Rep[#Config.Rep].MinRep then
                        local testrep = v.RepLoss * a
                        if testrep == 0 then
                            testrep = v.RepLoss
                        end
                        exports["cw-rep"]:updateSkill(src, 'delivery', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('flex-electricjob:server:checkRep', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.electric or 0}), 'primary')
end)

QBCore.Commands.Add('electricrep', Lang:t('command.help'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.electric or 0}), 'primary')
end)
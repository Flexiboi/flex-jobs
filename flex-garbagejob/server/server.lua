local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-garbagejob:server:startJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if k == #Config.Rep then
            if rep.garbage < Config.Rep[1].MinRep then
                if rep.garbage <= Config.DontAllowToWorkHereRep then
                    return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                end
            end
        end
    end
    if exports['rep-tablet']:isGroupLeader(src, group) then
        local GarbageLoc, GarbageAmount = 0, 0
        for k, v in ipairs(Config.Rep) do
            if rep.garbage >= v.MinRep and rep.garbage < v.MaxRep then
                GarbageLoc = math.random(1, #Config.GarbageLocs)
                GarbageAmount = math.random(v.MinBags, v.MaxBags)
                exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:startJob', 
                {GarbageLoc, GarbageAmount})
                return
            elseif rep.garbage > Config.Rep[#Config.Rep].MinRep then
                GarbageLoc = math.random(1, #Config.GarbageLocs)
                GarbageAmount = math.random(v.MinBags, v.MaxBags)

                exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:startJob', 
                {GarbageLoc, GarbageAmount})
                return
            elseif k == #Config.Rep then
                if rep.garbage < Config.Rep[1].MinRep then
                    if rep.garbage <= Config.DontAllowToWorkHereRep then
                        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                    else
                        GarbageLoc = math.random(1, #Config.GarbageLocs)
                        GarbageAmount = 1

                        exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:startJob', 
                        {GarbageLoc, GarbageAmount})
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
                name = 'Haal alle vuilzakken op.',
                max = GarbageAmount,
                count = 0,
                isDone = false,
            },
            [3] = {
                id = 3,
                name = 'Lever je busje en vuilniszakken in.',
                max = 1,
                count = 0,
                isDone = false,
            }
        }
        exports['rep-tablet']:setJobStatus(group, stages)
    end
end)

RegisterNetEvent('flex-garbagejob:server:carState', function(GarbageAmount, car)
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
            name = 'Haal alle vuilzakken op.',
            max = GarbageAmount,
            count = 0,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje en vuilniszakken in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.pickedupcar"), "fa-solid fa-truck", '#57d3de', 3000)
    exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:CarState', {car})
end)

RegisterNetEvent('flex-garbagejob:server:GarbageState', function(bins, loc, GarbagedAmount, GarbageAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local isGarbaged = false
    local newAmount = GarbageAmount - GarbagedAmount
    if newAmount <= 0 then
        newAmount = 0
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.cleanfinish"), "fa-solid fa-truck", '#57d3de', 3000)
    else
        exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.cleaned", {value = newAmount}), "fa-solid fa-truck", '#57d3de', 3000)
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
            name = 'Haal alle vuilzakken op.',
            max = GarbageAmount,
            count = GarbagedAmount,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje en vuilniszakken in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    if newAmount == 0 then
        stages[2] = {
            id = 2,
            name = 'Haal alle vuilzakken op.',
            max = GarbageAmount,
            count = GarbageAmount,
            isDone = true,
        }
        isGarbaged = true
    end
    
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:GarbageState', 
    {bins, loc, GarbagedAmount, GarbageAmount, isGarbaged})
end)

RegisterNetEvent('flex-garbagejob:server:finish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    exports['rep-tablet']:resetJobStatus(group)
    if exports['rep-tablet']:isGroupLeader(src, group) then
        exports['rep-tablet']:GroupEvent(group, 'flex-garbagejob:client:finish', 
        {})
    end
end)

RegisterNetEvent('flex-garbagejob:server:Pay', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if rep.garbage >= v.MinRep and rep.garbage < v.MaxRep then
            local amount = v.PayPerBag
            Player.Functions.AddMoney('cash', amount, 'Vuilnis ophalen')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
            exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
        elseif k == #Config.Rep then
            if rep.garbage > Config.Rep[#Config.Rep].MinRep then
                local amount = v.PayPerBag
                Player.Functions.AddMoney('cash', amount, 'Vuilnis ophalen')
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
                exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
            end
        end
    end
end)

RegisterNetEvent('flex-garbagejob:server:BLueprint', function()
    local src = source
    exports['flex-crafting']:GiveBluePrint(src, Config.BluePrint.items[math.random(1, #Config.BluePrint.items)], Config.BluePrint.chance)
end)

RegisterNetEvent('flex-garbagejob:server:TakeBag', function()
    local src = source
    exports['flex-extras']:GiveItem(src, Config.Garbagebag, 1, 1, false, false)
end)

RegisterNetEvent('flex-garbagejob:server:rep', function(addremove, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    local a = amount or 1
    if addremove == 'add' then
        for k, v in ipairs(Config.Rep) do
            if rep.garbage >= v.MinRep and rep.garbage < v.MaxRep then
                local testrep = v.RepEarning * a
                if testrep == 0 then
                    testrep = v.RepEarning
                end
                exports["cw-rep"]:updateSkill(src, 'garbage', testrep)
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                break
            elseif k == #Config.Rep then
                if rep.garbage < Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'garbage', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                elseif rep.garbage > Config.Rep[#Config.Rep].MinRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'garbage', testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = testrep}), 'success')
                    break
                end
            end
        end
    elseif addremove == 'remove' then
        if a > 0 then
            for k, v in ipairs(Config.Rep) do
                if rep.garbage >= v.MinRep and rep < v.MaxRep then
                    local testrep = v.RepEarning * a
                    if testrep == 0 then
                        testrep = v.RepEarning
                    end
                    exports["cw-rep"]:updateSkill(src, 'garbage', -testrep)
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                elseif k == #Config.Rep then
                        if rep.garbage < Config.Rep[1].MinRep then
                            local testrep = v.RepEarning * a
                        if testrep == 0 then
                            testrep = v.RepEarning
                        end
                        exports["cw-rep"]:updateSkill(src, 'garbage', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                    elseif rep.garbage > Config.Rep[#Config.Rep].MinRep then
                        local testrep = v.RepEarning * a
                        if testrep == 0 then
                            testrep = v.RepEarning
                        end
                        exports["cw-rep"]:updateSkill(src, 'garbage', -testrep)
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = testrep}), 'error')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('flex-garbagejob:server:checkRep', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.garbage or 0}), 'primary')
end)

QBCore.Commands.Add('vuilnisrep', Lang:t('command.help'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.garbage or 0}), 'primary')
end)
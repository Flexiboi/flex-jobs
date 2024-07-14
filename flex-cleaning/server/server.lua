local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('flex-cleaning:server:startJob', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if k == #Config.Rep then
            if rep.cleaning < Config.Rep[1].MinRep then
                if rep <= Config.DontAllowToWorkHereRep then
                    return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                end
            end
        end
    end
    if exports['rep-tablet']:isGroupLeader(src, group) then
        local CleanLoc, CleanAmount = 0, 0
        for k, v in ipairs(Config.Rep) do
            if rep.cleaning >= v.MinRep and rep.cleaning < v.MaxRep then
                CleanLoc = math.random(1, #Config.CleanLocks)
                CleanAmount = math.random(math.floor(#Config.CleanLocks[CleanLoc]/2), #Config.CleanLocks[CleanLoc])
                exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:startJob', 
                {CleanLoc, CleanAmount})
                return
            elseif rep.cleaning > Config.Rep[#Config.Rep].MinRep then
                CleanLoc = math.random(1, #Config.CleanLocks)
                CleanAmount = math.random(math.floor(#Config.CleanLocks[CleanLoc]/2), #Config.CleanLocks[CleanLoc])

                exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:startJob', 
                {CleanLoc, CleanAmount})
                return
            elseif k == #Config.Rep then
                if rep.cleaning < Config.Rep[1].MinRep then
                    if rep.cleaning <= Config.DontAllowToWorkHereRep then
                        return TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cantworkhere'), 'error')
                    else
                        CleanLoc = math.random(1, #Config.CleanLocks)
                        CleanAmount = 1

                        exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:startJob', 
                        {CleanLoc, CleanAmount})
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
                name = 'Was alle ramen.',
                max = CleanAmount,
                count = 0,
                isDone = false,
            },
            [3] = {
                id = 3,
                name = 'Lever je busje terug in.',
                max = 1,
                count = 0,
                isDone = false,
            }
        }
        exports['rep-tablet']:setJobStatus(group, stages)
    end
end)

RegisterNetEvent('flex-cleaning:server:carState', function(CleanAmount, car)
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
            name = 'Was alle ramen.',
            max = CleanAmount,
            count = 0,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje terug in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:pNotifyGroup(group, Lang:t("notify.header"), Lang:t("notify.pickedupcar"), "fa-solid fa-truck", '#57d3de', 3000)
    exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:CarState', {car})
end)

RegisterNetEvent('flex-cleaning:server:cleanState', function(id, loc, CleanedAmount, CleanAmount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    local isCleaned = false

    local newAmount = CleanAmount - CleanedAmount
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
            name = 'Was alle ramen.',
            max = CleanAmount,
            count = CleanedAmount,
            isDone = false,
        },
        [3] = {
            id = 3,
            name = 'Lever je busje terug in.',
            max = 1,
            count = 0,
            isDone = false,
        }
    }
    if newAmount == 0 then
        stages[2] = {
            id = 2,
            name = 'Was alle ramen.',
            max = CleanAmount,
            count = CleanAmount,
            isDone = true,
        }
        isCleaned = true
    end
    
    exports['rep-tablet']:setJobStatus(group, stages)
    exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:cleanState', 
    {id, loc, CleanedAmount, CleanAmount, isCleaned})
end)

RegisterNetEvent('flex-cleaning:server:finish', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local group = exports['rep-tablet']:getGroupByMembers(src)
    exports['rep-tablet']:GroupEvent(group, 'flex-cleaning:client:finish', {})
    exports['rep-tablet']:resetJobStatus(group)
end)

RegisterNetEvent('flex-cleaning:server:payclean', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    for k, v in ipairs(Config.Rep) do
        if rep.cleaning >= v.MinRep and rep.cleaning < v.MaxRep then
            local amount = v.PayPerClean
            Player.Functions.AddMoney('cash', amount, 'Schoonmaken')
            TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
            exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
        elseif k == #Config.Rep then
            if rep.cleaning > Config.Rep[#Config.Rep].MinRep then
                local amount = v.PayPerClean
                Player.Functions.AddMoney('cash', amount, 'Schoonmaken')
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.earn',{value = amount}), 'success')
                exports['flex-extras']:GiveItem(src, Config.ItemReward.items[math.random(1, #Config.ItemReward.items)], Config.ItemReward.min, Config.ItemReward.max, false, false)
            end
        end
    end 
end)

RegisterNetEvent('flex-cleaning:server:Blueprint', function()
    local src = source
    exports['flex-crafting']:GiveBluePrint(src, Config.BluePrint.items[math.random(1, #Config.BluePrint.items)], Config.BluePrint.chance)
end)

RegisterNetEvent('flex-cleaning:server:rep', function(addremove, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local a = amount or 1
    local rep = exports["cw-rep"]:fetchSkills(src)
    if addremove == 'add' then
        for k, v in ipairs(Config.Rep) do
            if rep.cleaning >= v.MinRep and rep.cleaning < v.MaxRep then
                exports["cw-rep"]:updateSkill(src, 'cleaning', (v.RepEarning * a))
                TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = (v.RepEarning * a)}), 'success')
                break
            elseif k == #Config.Rep then
                if rep.cleaning < Config.Rep[#Config.Rep].MinRep then
                    exports["cw-rep"]:updateSkill(src, 'cleaning', (v.RepEarning * a))
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = 1}), 'success')
                    break
                elseif rep.cleaning > Config.Rep[#Config.Rep].MinRep then
                    exports["cw-rep"]:updateSkill(src, 'cleaning', (v.RepEarning * a))
                elseif rep.cleaning > Config.Rep[#Config.Rep].MinRep then
                    exports["cw-rep"]:updateSkill(src, 'cleaning', (v.RepEarning * a))
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('success.rep',{value = (v.RepEarning * a)}), 'success')
                    break
                end
            end
        end
    elseif addremove == 'remove' then
        if a > 0 then
            for k, v in ipairs(Config.Rep) do
                if rep.cleaning >= v.MinRep and rep.cleaning < v.MaxRep then
                    exports["cw-rep"]:updateSkill(src, 'cleaning', -(v.RepEarning * a))
                    TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = (v.RepEarning * a)}), 'error')
                    break
                elseif k == #Config.Rep then
                    if rep.cleaning < Config.Rep[1].MinRep then
                        local newrep = exports["cw-rep"]:fetchSkills(src)
                        exports["cw-rep"]:updateSkill(src, 'cleaning', -(v.RepEarning * a))
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = (v.RepEarning * a)}), 'error')
                        break
                    elseif rep.cleaning > Config.Rep[#Config.Rep].MinRep then
                        local newrep = exports["cw-rep"]:fetchSkills(src)
                        exports["cw-rep"]:updateSkill(src, 'cleaning', -(v.RepEarning * a))
                        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.rep',{value = (v.RepEarning * a)}), 'error')
                        break
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('flex-cleaning:server:checkRep', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.cleaning or 0}), 'primary')
end)

QBCore.Commands.Add('schoonmaakrep', Lang:t('command.help'), {}, false, function(source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local rep = exports["cw-rep"]:fetchSkills(src)
    TriggerClientEvent('QBCore:Notify', src, Lang:t('command.rep',{value = rep.cleaning or 0}), 'primary')
end)

QBCore.Commands.Add('herstelrep', 'Herstel je oude reputatie', {}, false, function(source)
    local reps = {
        'cleaning',
        'garbage',
        'delivery',
        'electric',
        'houserobbery',
        'scrap'
    }
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for k, v in ipairs(reps) do
        exports["cw-rep"]:updateSkill(src, v, Player.PlayerData.metadata['jobrep'][v])
        if k == #reps then
            local newrep = Player.PlayerData.metadata['jobrep']
            newrep.cleaning = 0
            newrep.garbage = 0
            newrep.delivery = 0
            newrep.electric = 0
            newrep.houserobbery = 0
            newrep.scrap = 0
            Player.Functions.SetMetaData('jobrep', newrep)
            TriggerClientEvent('QBCore:Notify', src, 'Al je rep weer goed gezet! Bekijk het met /rep', 'primary')
        end
    end
end)
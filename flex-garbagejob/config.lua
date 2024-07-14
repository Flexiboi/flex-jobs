Config = {}

Config.Debug = false

Config.StartPed = {
    loc = vector4(-346.55, -1552.0, 25.63, 159.55),
    ped = 'ig_floyd',
    scenario = 'WORLD_HUMAN_CLIPBOARD',
}
Config.GarbageTruck = 'trash2'
Config.CreateJobBlip = false --Should the job location be on the map?

Config.DontAllowToWorkHereRep = -10000
Config.Rep = {
    [1] = {
        MinBags = 7,
        MaxBags = 10,
        MinRep = 0,
        MaxRep = 1000,
        RepEarning = math.random(2,5),
        RepLoss = 1,
        PayPerBag = 75,
    },
    [2] = {
        MinBags = 8,
        MaxBags = 16,
        MinRep = 1000,
        MaxRep = 2000,
        RepEarning = math.random(2,5),
        RepLoss = 1,
        PayPerBag = 100,
    },
    [3] = {
        MinBags = 12,
        MaxBags = 19,
        MinRep = 2000,
        MaxRep = 3000,
        RepEarning = math.random(2,6),
        RepLoss = math.random(1,2),
        PayPerBag = 150,
    }
}

Config.ItemReward = {
    min = 10,
    max = 15,
    items = {
        'metalscrap',
        'iron',
    }
}

Config.BluePrint = {
    chance = 5,
    items = {
        'repairkit',
        'empty_weed_bag'
    }
}

Config.CarLocs = { -- Vehicle spawn locations (goes to next if car is in position)
    [1] = vector4(-337.62, -1570.65, 25.23, 59.12),
    [2] = vector4(-333.66, -1563.78, 25.23, 61.66),
}

Config.Garbagebins = {
    -1096777189,
    666561306,
    1437508529,
    -1426008804,
    -228596739,
    161465839,
    651101403
    -58485588,
    218085040,
    'prop_dumpster_02b'
}

Config.Garbagebag = 'garbagebag'
Config.GarbageLocs = { -- Location to pick up packages
    [1] = {coords = vector4(-1298.68, -795.2, 17.57, 37.36), radius = 2000.0},
    [2] = {coords = vector4(-1346.54, -735.6, 22.41, 33.72), radius = 2000.0},
    [3] = {coords = vector4(226.57, -1772.15, 28.83, 68.48), radius = 2000.0},
    [4] = {coords = vector4(-3.94, -1479.32, 30.36, 141.0), radius = 2000.0},
    [5] = {coords = vector4(-10.25, -1386.74, 28.98, 134.05), radius = 2000.0},
    [6] = {coords = vector4(158.71, -1299.55, 29.18, 147.47), radius = 2000.0},
    [7] = {coords = vector4(121.48, -1053.6, 29.19, 329.92), radius = 2000.0},
    [8] = {coords = vector4(161.65, -1070.78, 29.19, 277.19), radius = 2000.0},
    [9] = {coords = vector4(373.42, -836.91, 29.29, 250.76), radius = 2000.0},
    [10] = {coords = vector4(340.37, -1091.66, 28.72, 9.66), radius = 2000.0},
    [11] = {coords = vector4(-70.01, -1264.73, 28.38, 259.62), radius = 2000.0},
    [12] = {coords = vector4(-89.57, -1285.43, 28.54, 179.42), radius = 2000.0},
    [13] = {coords = vector4(-177.69, -1294.31, 30.55, 286.32), radius = 2000.0},
}

Config.CarDropOff = vector3(-331.33, -1564.53, 24.71)
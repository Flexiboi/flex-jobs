Config = {}

Config.Debug = false

Config.StartPed = {
    loc = vector4(722.21, -2016.33, 29.29, 265.26),
    ped = 'g_f_y_vagos_01',
    scenario = 'WORLD_HUMAN_CLIPBOARD',
}
Config.JobVehicle = 'boxville'
Config.CreateJobBlip = false --Should the job location be on the map?

Config.DontAllowToWorkHereRep = -10000
Config.Rep = {
    [1] = {
        MinCabinets = 5,
        MaxCabinets = 10,
        MinRep = 0,
        MaxRep = 1000,
        RepEarning = math.random(2,5),
        RepLoss = 1,
        PayPerCabinet = 50,
    },
    [2] = {
        MinCabinets = 8,
        MaxCabinets = 13,
        MinRep = 1000,
        MaxRep = 2000,
        RepEarning = math.random(1,6),
        RepLoss = 1,
        PayPerCabinet = 75,
    },
    [3] = {
        MinCabinets = 8,
        MaxCabinets = 15,
        MinRep = 2000,
        MaxRep = 3000,
        RepEarning = math.random(2,6),
        RepLoss = 1,
        PayPerCabinet = 125,
    }
}

Config.ItemReward = {
    min = 10,
    max = 15,
    items = {
        'copper',
        'rubber'
    }
}

Config.BluePrint = {
    chance = 10,
    items = {
        'bolt_cutter',
        'weapon_wrench',
    }
}

Config.CarLocs = { -- Vehicle spawn locations (goes to next if car is in position)
    [1] = vector4(733.01, -2025.49, 29.29, 265.14),
    [2] = vector4(734.06, -2019.75, 29.28, 266.99),
    [3] = vector4(734.69, -2014.7, 29.28, 262.3),
}

Config.Cabinets = {
    'm23_1_prop_m31_electricbox_01a',
    'm23_1_prop_m31_electricbox_03a',
    'm23_1_prop_m31_electricbox_02a',
    'prop_elecbox_11',
    'prop_elecbox_12',
    'prop_sub_trans_02a',
    'prop_elecbox_02a',
    'prop_elecbox_09',
    'prop_elecbox_04a',
    'prop_elecbox_05a',
    'prop_elecbox_14',
    'prop_elecbox_06a',
    'prop_elecbox_07',
    'prop_elecbox_07a'
}

Config.ElectricZones = { -- Location to pick up packages
    [1] = {coords = vector4(420.15, -1584.96, 29.3, 29.95), radius = 2000.0},
    [2] = {coords = vector4(387.71, -1045.97, 29.26, 358.24), radius = 2000.0},
    [3] = {coords = vector4(131.47, -1071.41, 29.19, 296.89), radius = 2000.0},
    [4] = {coords = vector4(172.58, -820.01, 31.18, 192.86), radius = 2000.0},
    [5] = {coords = vector4(953.61, -1785.7, 31.25, 191.07), radius = 2000.0},
    [6] = {coords = vector4(-107.55, -1515.53, 33.84, 233.58), radius = 2000.0},
    [7] = {coords = vector4(-14.58, -1101.21, 26.67, 1.6), radius = 2000.0},
    [8] = {coords = vector4(-1243.76, -874.84, 12.4, 41.69), radius = 2000.0},
    [9] = {coords = vector4(844.07, -1594.16, 31.81, 105.03), radius = 2000.0},
    [10] = {coords = vector4(354.32, -1922.31, 24.62, 67.86), radius = 2000.0},
}

Config.CarDropOff = vector4(718.76, -2022.77, 29.29, 85.11)
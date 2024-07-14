Config = {}

Config.Debug = false

Config.StartPed = {
    loc = vector4(216.14, -1462.1, 29.19, 46.07),
    ped = 's_m_y_armymech_01',
    scenario = 'WORLD_HUMAN_CLIPBOARD',
}
Config.DeliverCar = 'boxville2'
Config.CreateJobBlip = false --Should the job location be on the map?

Config.DontAllowToWorkHereRep = -10000
Config.Rep = {
    [1] = {
        MinRep = 0,
        MaxRep = 100,
        MaxDelivers = 3,
        RepEarning = math.random(1,5),
        RepLoss = math.random(3,7),
        PayPerDeliver = 50,
    },
    [2] = {
        MinRep = 100,
        MaxRep = 1000,
        MaxDelivers = 9,
        RepEarning = math.random(1,5),
        RepLoss = math.random(3,7),
        PayPerDeliver = 50,
    },
    [3] = {
        MinRep = 1000,
        MaxRep = 2000,
        MaxDelivers = 13,
        RepEarning = math.random(1,5),
        RepLoss = math.random(3,7),
        PayPerDeliver = 75,
    },
    [4] = {
        MinRep = 2000,
        MaxRep = 3000,
        MaxDelivers = 17,
        RepEarning = math.random(1,4),
        RepLoss = math.random(3,7),
        PayPerDeliver = 125,
    }
}

Config.ItemReward = {
    min = 10,
    max = 15,
    items = {
        'aluminum',
        'steel',
    }
}

Config.BluePrint = {
    chance = 25,
    items = {
        'ziptie',
    }
}

Config.StartLocs = { -- Vehicle spawn locations (goes to next if car is in position)
    [1] = vector4(205.16, -1453.51, 29.08, 150.19),
    [2] = vector4(207.19, -1464.84, 29.06, 46.19),
    [3] = vector4(202.73, -1469.53, 29.04, 45.95),
    [4] = vector4(189.41, -1461.22, 29.04, 231.12),
    [5] = vector4(182.9, -1466.64, 29.04, 280.79),
}

Config.EmptyPallet = 'bkr_prop_weed_pallet'
Config.Pallets = {
    'hei_prop_carrier_cargo_04b'
}

Config.BoxItem = 'box'

Config.PickupLocks = { -- Location to pick up packages
    vector4(-698.99, -919.72, 19.01, 90.9),
    vector4(31.5, -1314.56, 29.52, 357.58),
    vector4(-332.7, -1516.51, 27.54, 184.3),
    vector4(109.31, -1089.17, 29.3, 355.28),
    vector4(-416.26, -1677.7, 19.03, 159.78),
    vector4(502.87, -1970.22, 24.84, 298.67),
    vector4(223.58, -920.55, 29.56, 72.61),
}

Config.Peds = {
    models = {
        'a_m_y_bevhills_02',
        'a_f_y_bevhills_03',
        'a_m_y_business_03',
        'u_f_y_comjane',
        's_m_m_lifeinvad_01',
        'ig_mrs_thornhill',
        'a_f_m_salton_01',
        's_f_y_shop_low',
        'a_f_m_soucent_02',
        'a_f_y_tourist_02',
        'u_m_o_taphillbilly',
        'ig_priest',
        's_m_m_marine_02'
    },
    scenarios = {
        'WORLD_HUMAN_MUSCLE_FLEX',
        'WORLD_HUMAN_MUSICIAN',
        'WORLD_HUMAN_COP_IDLES',
        'WORLD_HUMAN_CHEERING',
        'WORLD_HUMAN_AA_COFFEE',
        'WORLD_HUMAN_AA_SMOKE',
        'WORLD_HUMAN_BINOCULARS',
    }
}
Config.DeliverLocks = { -- Location to pick up packages
    vector4(-2074.1, -331.22, 13.32, 46.82),
    vector4(-1430.52, -267.21, 46.26, 155.92),
    vector4(642.42, 263.14, 103.3, 38.03),
    vector4(1161.19, -327.17, 69.21, 178.34),
    vector4(1215.34, -1381.5, 35.36, 225.99),
    vector4(170.01, -1552.65, 29.26, 218.42),
    vector4(-51.51, -1759.05, 29.44, 105.36),
    vector4(-529.09, -1221.35, 18.45, 345.01),
    vector4(288.46, -1264.45, 29.44, 128.69),
    vector4(25.61, -1349.96, 29.33, 204.45),
    vector4(-716.37, -917.2, 19.21, 199.67),
    vector4(1141.85, -978.31, 46.33, 258.53),
    vector4(-51.61, -1758.77, 29.44, 126.94),
    vector4(83.22, -1395.11, 29.39, 321.45),
    vector4(417.83, -805.1, 29.41, 140.9),
    vector4(394.15, -830.73, 29.29, 190.27),
    vector4(410.22, -1022.22, 29.38, 127.58),
    vector4(489.57, -1024.73, 28.14, 313.05),
    vector4(128.04, -1086.19, 29.19, 14.57),
    vector4(137.31, -1086.36, 29.19, 352.1),
    vector4(148.32, -1087.03, 29.19, 343.45),
    vector4(-50.32, -1104.31, 26.44, 161.15),
    vector4(-43.92, -1107.96, 26.44, 111.52),
    vector4(-61.12, -1090.68, 26.58, 114.86),
    vector4(154.17, -1038.17, 29.32, 40.98),
    vector4(317.33, -276.09, 53.92, 2.56),
    vector4(473.65, -986.22, 30.29, 182.48),
    vector4(-661.97613525391, 312.85498046875, 83.087951660156, 163.80419921875),
    vector4(-666.47009277344, 323.11367797852, 83.083610534668, 171.28338623047),
    vector4(-692.10491943359, 323.35339355469, 83.083694458008, 261.69967651367)
}

Config.Packages = {
    'prop_drug_package'
}

Config.CarDropOff = vector3(194.57, -1465.06, 29.14)
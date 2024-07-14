Config = {}

Config.Debug = false

Config.StartPed = {
    loc = vector4(427.88, -1515.49, 29.29, 211.83),
    ped = 's_m_m_janitor',
    scenario = 'WORLD_HUMAN_CLIPBOARD',
}
Config.CleanCar = 'paradise'
Config.CreateJobBlip = false --Should the job location be on the map?

Config.DontAllowToWorkHereRep = -1000
Config.Rep = {
    [1] = {
        MinRep = 0,
        MaxRep = 1000,
        RepEarning = math.random(2,5),
        RepLoss = 1,
        PayPerClean = 75,
    },
    [2] = {
        MinRep = 1000,
        MaxRep = 2000,
        RepEarning = math.random(1,3),
        RepLoss = 1,
        PayPerClean = 145,
    },
    [3] = {
        MinRep = 2000,
        MaxRep = 3000,
        RepEarning = math.random(1,2),
        RepLoss = 1,
        PayPerClean = 185,
    },
}

Config.ItemReward = {
    min = 10,
    max = 15,
    items = {
        'glass',
        'plastic',
    }
}

Config.BluePrint = {
    chance = 5,
    items = {
        'armor',
    }
}

Config.CarLocs = { -- Vehicle spawn locations (goes to next if car is in position)
    [1] = vector4(437.71, -1530.57, 28.75, 125.4),
    [2] = vector4(433.48, -1525.31, 28.77, 123.92)

}

Config.Cleantime = 5 -- seconds
Config.CleanAnims = {
    [1] = {
        dic = 'amb@world_human_maid_clean@',
        anim = 'base',
    }
}
Config.CleanLocks = {
    [1] = {
        [1] = {coords = vector4(474.89, -995.12, 30.25, 358.19), done = false},
        [2] = {coords = vector4(467.9, -995.13, 30.25, 356.45), done = false},
        [3] = {coords = vector4(460.7, -995.12, 30.25, 0.73), done = false},
        [4] = {coords = vector4(454.25, -995.11, 30.25, 0.37), done = false},
        [5] = {coords = vector4(443.84, -995.16, 30.25, 359.63), done = false},
        [6] = {coords = vector4(436.83, -995.12, 30.25, 357.53), done = false},
        [7] = {coords = vector4(433.62, -995.11, 30.25, 3.73), done = false},
    },
    [2] = {
        [1] = {coords = vector4(152.75, -1037.63, 29.34, 159.23), done = false},
        [2] = {coords = vector4(149.31, -1036.42, 29.34, 165.46), done = false},
        [3] = {coords = vector4(317.04, -276.32, 53.92, 159.14), done = false},
        [4] = {coords = vector4(313.53, -275.07, 53.93, 162.85), done = false},
    },
    [3] = {
        [1] = {coords = vector4(-58.44, -1087.22, 26.63, 253.4), done = false},
        [2] = {coords = vector4(-59.39, -1089.89, 26.63, 251.63), done = false},
        [3] = {coords = vector4(-60.91, -1097.29, 26.44, 300.79), done = false},
        [4] = {coords = vector4(-59.91, -1098.91, 26.44, 304.02), done = false},
        [5] = {coords = vector4(-59.01, -1100.56, 26.43, 302.85), done = false},
        [6] = {coords = vector4(-57.44, -1101.72, 26.43, 344.16), done = false},
        [7] = {coords = vector4(-55.96, -1102.23, 26.43, 342.05), done = false},
        [8] = {coords = vector4(-54.42, -1102.8, 26.44, 340.17), done = false},
        [9] = {coords = vector4(-51.28, -1103.99, 26.44, 340.59), done = false},
        [10] = {coords = vector4(-49.68, -1104.51, 26.44, 341.79), done = false},
        [11] = {coords = vector4(-45.55, -1106.02, 26.44, 338.96), done = false},
        [12] = {coords = vector4(-43.9, -1106.62, 26.44, 344.12), done = false},
    },
    [4] = {
        [1] = {coords = vector4(-691.45739746094, 315.60131835938, 83.113647460938, 356.93203735352), done = false},
        [2] = {coords = vector4(-686.87243652344, 315.2024230957, 83.099250793457, 359.20336914062), done = false},
        [3] = {coords = vector4(-680.09881591797, 314.6110534668, 83.084526062012, 347.96585083008), done = false},
        [4] = {coords = vector4(-673.67333984375, 314.0524597168, 83.084526062012, 0.46202358603477), done = false},
        [5] = {coords = vector4(-665.97076416016, 313.37341308594, 83.086563110352, 350.98010253906), done = false},
        [6] = {coords = vector4(-662.15405273438, 313.04040527344, 83.088073730469, 353.98764038086), done = false},
        [7] = {coords = vector4(-668.43463134766, 317.27697753906, 83.083694458008, 265.56976318359), done = false},
        [8] = {coords = vector4(-668.17651367188, 320.32476806641, 83.083694458008, 271.80090332031), done = false},
        [9] = {coords = vector4(-684.39837646484, 318.81433105469, 83.083694458008, 88.428939819336), done = false},
        [10] = {coords = vector4(-684.11169433594, 321.94998168945, 83.083694458008, 91.707725524902), done = false},
    },
    [5] = {
        [1] = {coords = vector4(26.01, -1349.68, 29.33, 7.73), done = false},
        [2] = {coords = vector4(31.66, -1349.66, 29.33, 358.46), done = false},
        [3] = {coords = vector4(29.81, -1341.83, 29.5, 8.94), done = false},
        [4] = {coords = vector4(28.1, -1341.79, 29.5, 353.6), done = false},
        [5] = {coords = vector4(26.39, -1341.77, 29.5, 356.74), done = false},
    },
    [6] = {
        [1] = {coords = vector4(82.66, -1399.34, 29.41, 91.56), done = false},
        [2] = {coords = vector4(82.85, -1391.03, 29.41, 115.95), done = false},
    },
    [7] = {
        [1] = {coords = vector4(152.72, -1037.66, 29.34, 171.36), done = false},
        [2] = {coords = vector4(149.42, -1036.42, 29.34, 156.02), done = false},
    },
    [8] = {
        [1] = {coords = vector4(235.65, -901.45, 29.63, 245.61), done = false},
        [2] = {coords = vector4(242.92, -904.23, 29.62, 247.5), done = false},
        [3] = {coords = vector4(243.54, -902.81, 29.62, 248.49), done = false},
        [4] = {coords = vector4(244.13, -901.09, 29.62, 244.15), done = false},
    },
    [9] = {
        [1] = {coords = vector4(-342.52, -1477.55, 30.75, 109.48), done = false},
        [2] = {coords = vector4(-342.54, -1483.49, 30.72, 81.92), done = false},
        [3] = {coords = vector4(-351.3, -1483.85, 30.79, 99.3), done = false},
        [4] = {coords = vector4(-351.33, -1481.38, 30.79, 94.13), done = false},
    },
    [10] = {
        [1] = {coords = vector4(-50.2, -1759.54, 29.44, 328.36), done = false},
        [2] = {coords = vector4(-53.89, -1756.72, 29.44, 325.93), done = false},
        [3] = {coords = vector4(-56.5, -1750.91, 29.42, 51.52), done = false},
        [4] = {coords = vector4(-54.65, -1748.61, 29.42, 41.94), done = false},
        [5] = {coords = vector4(-52.42, -1747.4, 29.42, 316.65), done = false},
        [6] = {coords = vector4(-50.05, -1749.39, 29.42, 325.08), done = false},
    },
    [11] = {
        [1] = {coords = vector4(-533.95, -1220.12, 18.46, 162.64), done = false},
        [2] = {coords = vector4(-529.11, -1222.47, 18.46, 156.72), done = false},
        [3] = {coords = vector4(-531.23, -1231.13, 18.46, 160.84), done = false},
        [4] = {coords = vector4(-532.31, -1230.73, 18.46, 162.0), done = false},
        [5] = {coords = vector4(-534.44, -1229.64, 18.46, 151.8), done = false},
    },
    [12] = {
        [1] = {coords = vector4(387.7, -833.37, 29.29, 12.71), done = false},
        [2] = {coords = vector4(389.54, -833.37, 29.29, 21.43), done = false},
        [3] = {coords = vector4(394.38, -828.53, 29.29, 89.96), done = false},
        [4] = {coords = vector4(394.42, -826.7, 29.29, 97.38), done = false},
    },
    [13] = {
        [1] = {coords = vector4(-209.39, -1158.6, 23.05, 186.1), done = false},
        [2] = {coords = vector4(-204.41, -1158.62, 23.81, 194.02), done = false},
        [3] = {coords = vector4(-197.2, -1158.61, 23.81, 174.31), done = false},
        [4] = {coords = vector4(-190.83, -1158.62, 23.81, 178.94), done = false},
        [5] = {coords = vector4(-188.31, -1158.65, 23.81, 185.59), done = false},
        [6] = {coords = vector4(-169.43, -1158.62, 23.81, 184.53), done = false},
    },
}

Config.CarDropOff = vector3(423.43, -1533.77, 29.27)